/// @description Draw Event
// You can write your code in this editor

// Reset Light Color Surface
surface_set_target(lights_color_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

// Reset Diffuse Color Surface
surface_set_target(diffuse_color_surface);
draw_clear(c_black);
surface_reset_target();

// Reset Normal Map Vector Surface
surface_set_target(normalmap_vector_surface);
draw_clear_alpha(global.lighting_engine_normalmap_default_color, 1);
surface_reset_target();

// Reset Depth Specular Stencil Surface
surface_set_target(depth_specular_stencil_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

// Enable MRT Deferred Lighting Shader and Surfaces - Draw objects to three different surfaces simultaneously: Diffuse (Object Color), Normals (Object Surface Direction Lighting Vectors), Depth/Specular/Stencil (Object Detail and Effects Map)
shader_set(shd_mrt_deferred_lighting);

surface_set_target_ext(0, diffuse_color_surface);
surface_set_target_ext(1, normalmap_vector_surface);
surface_set_target_ext(2, depth_specular_stencil_surface);

// Iterate through all Objects assigned via Layers to be draw sequentially (from back to front) in a Painter's Sorted List
var temp_layer_index = 0;

repeat (ds_list_size(lighting_engine_layer_object_list))
{
    // Find Lighting Layer Object List
    var temp_layer_object_list = ds_list_find_value(lighting_engine_layer_object_list, temp_layer_index);
    
    // Iterate through Lighting Layer Objects
    var temp_layer_object_index = 0;
    
    repeat (ds_list_size(temp_layer_object_list))
    {
        // Find Lighting Object
        var temp_lit_object = ds_list_find_value(temp_layer_object_list, temp_layer_object_index);
        
        // Check what Lighting Object type to properly draw Lit Object
        switch (temp_lit_object.lit_object_type)
        {
            case LightingEngineLitObjectType.Unit:
            	// Draw Lit Unit
				with (temp_lit_object.lit_object_instance)
				{
					// Draw Secondary Arm rendered behind Unit Body
					limb_secondary_arm.lighting_engine_render_behaviour();
				
					// Draw Unit Body
					lighting_engine_draw_sprite
					(
						sprite_index,
						image_index,
						normalmap_spritepack[image_index].texture,
						specularmap_spritepack[image_index].texture,
						normalmap_spritepack[image_index].uvs,
						specularmap_spritepack[image_index].uvs,
						x,
						y + ground_contact_vertical_offset,
						draw_xscale,
						draw_yscale,
						image_angle + draw_angle_value,
						image_blend,
						image_alpha
					);
					
					// Draw Unit's Weapon (if equipped)
					if (weapon_active)
					{
						weapon_equipped.lighting_engine_render_behaviour();
					}
					
					// Draw Primary Arm rendered in front Unit Body
					limb_primary_arm.lighting_engine_render_behaviour();
				}
                break;
            case LightingEngineLitObjectType.Basic:
            default:
                break;
        }
        
        // Increment Object Index
        temp_layer_object_index++;
    }
    
    // Increment Layer Index
    temp_layer_index++;
}

// Reset MRT Deferred Lighting Shader and Surfaces
shader_reset();
surface_reset_target();

// Render Point Lights with Shadows
with (oLightingEngine_Source_PointLight)
{
	if (point_light_render_enabled)
	{
		//
		gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_one, bm_one);
		
		//
		shader_set(shd_point_light_shadows);
		surface_set_target(LightingEngine.lights_shadow_surface);
		
		//
		draw_clear_alpha(c_black, 0);
		
		//
		shader_set_uniform_f(LightingEngine.point_light_shadow_shader_light_source_radius_index, point_light_vibrant_radius);
		shader_set_uniform_f(LightingEngine.point_light_shadow_shader_light_source_position_index, x, y);
		
		//
		var temp_light_source_contact_solid_index = 0;
		
		repeat (ds_list_size(point_light_collisions_list))
		{
			var temp_light_source_contact_solid = ds_list_find_value(point_light_collisions_list, temp_light_source_contact_solid_index);
			
			if (temp_light_source_contact_solid.shadows_enabled)
			{
				shader_set_uniform_f(LightingEngine.point_light_shadow_shader_collider_center_position_index, temp_light_source_contact_solid.center_xpos, temp_light_source_contact_solid.center_ypos);
				vertex_submit(temp_light_source_contact_solid.shadow_vertex_buffer, pr_trianglelist, -1);
			}
			
			temp_light_source_contact_solid_index++;
		}
		
		//
		shader_reset();
		surface_reset_target();
		
		//
		gpu_set_blendmode(bm_normal);
		
		//
		shader_set(shd_point_light);
		surface_set_target(LightingEngine.lights_color_surface);
		
		//
		shader_set_uniform_f(LightingEngine.point_light_shader_surface_size_index, GameManager.game_width, GameManager.game_height);
		shader_set_uniform_f(LightingEngine.point_light_shader_surface_position_index, LightingEngine.render_x, LightingEngine.render_y);
		
		texture_set_stage(LightingEngine.point_light_shader_normalmap_texture_index, surface_get_texture(LightingEngine.normalmap_vector_surface));
		texture_set_stage(LightingEngine.point_light_shader_shadows_texture_index, surface_get_texture(LightingEngine.lights_shadow_surface));
		
		//
		shader_set_uniform_f(LightingEngine.point_light_shader_radius_index, point_light_falloff_radius);
    	shader_set_uniform_f(LightingEngine.point_light_shader_centerpoint_index, x, y);
    	shader_set_uniform_f(LightingEngine.point_light_shader_light_color_index, color_get_red(point_light_color) / 255, color_get_green(point_light_color) / 255, color_get_blue(point_light_color) / 255);
    	
    	//
		vertex_submit(point_light_vertex_buffer, pr_trianglelist, -1);
		
		//
		shader_reset();
		surface_reset_target();
		gpu_set_blendmode(bm_normal);
	}
}

//
if (global.debug and global.debug_surface_enabled)
{
	//
	surface_set_target(debug_surface);
	
	//
	with (oPlatform)
	{
		draw_self();
	}
	
	//
	with (oSolid)
	{
		draw_self();
	}
	
	//
	surface_reset_target();
}
