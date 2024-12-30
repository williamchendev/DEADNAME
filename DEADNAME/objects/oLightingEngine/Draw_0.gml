/// @description Draw Event
// You can write your code in this editor

// Reset Light Color Surface
surface_set_target(lights_color_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

// Reset Light Vector Surface (MIGHT NOT NEED THIS ONE, HEY INNO WE FIND OUT THE LIGHT DATA IN ONE PASS ANYWAYS SO REMOVE THIS LATER)
surface_set_target(lights_vector_surface);
draw_clear_alpha(global.lighting_engine_normalmap_default_color, 1);
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

// Enable MRT Deferred Lighting Shader - Draw objects to three different surfaces simultaneously: Diffuse (Object Color), Normals (Object Surface Direction Lighting Vectors), Depth/Specular/Stencil (Object Detail and Effects Map)
shader_set(shd_mrt_deferred_lighting);

surface_set_target_ext(0, diffuse_color_surface);
surface_set_target_ext(1, normalmap_vector_surface);
surface_set_target_ext(2, depth_specular_stencil_surface);

// Iterate through all Objects assigned via Layers to be draw sequentially (from back to front) in a Painter's Sorted List
var temp_layer_index = 0;

repeat(ds_list_size(lighting_engine_layer_object_list))
{
    // Find Lighting Layer Object List
    var temp_layer_object_list = ds_list_find_value(lighting_engine_layer_object_list, temp_layer_index);
    
    // Iterate through Lighting Layer Objects
    var temp_layer_object_index = 0;
    
    repeat(ds_list_size(temp_layer_object_list))
    {
        // Find Lighting Object
        var temp_lit_object = ds_list_find_value(temp_layer_object_list, temp_layer_object_index);
        
        // Check what Lighting Object type to properly draw Lit Object
        switch (temp_lit_object.lit_object_type)
        {
            case LightingEngineLitObjectType.Unit:
            	// Draw Lit Unit
				with(temp_lit_object.lit_object_instance)
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

// Reset MRT Deferred Lighting Shader
shader_reset();

//
surface_reset_target();

//
if (global.debug and global.debug_surface_enabled)
{
	//
	surface_set_target(debug_surface);
	
	//
	with(oPlatform)
	{
		draw_self();
	}
	
	//
	with(oSolid)
	{
		draw_self();
	}
	
	//
	shader_set(shd_point_light);
	
	shader_set_uniform_f(point_light_shader_surface_size_index, GameManager.game_width, GameManager.game_height);
    shader_set_uniform_f(point_light_shader_surface_position_index, render_x, render_y);
    
    texture_set_stage(point_light_shader_normalmap_texture_index, surface_get_texture(normalmap_vector_surface));
	
	//
	lighting_engine_render_point_light(mouse_x, mouse_y, 240, c_red);
	
	//
	shader_reset();
	
	//
	surface_reset_target();
}
