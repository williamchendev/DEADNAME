/// @description Draw Event
// You can write your code in this editor

//
surface_set_target(diffuse_color_surface);
draw_clear(c_black);
surface_reset_target();

//
surface_set_target(normalmap_color_surface);
draw_clear_alpha(global.lighting_engine_normalmap_default_color, 1);
surface_reset_target();

//
surface_set_target(depth_specular_stencil_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

//
surface_set_target_ext(0, diffuse_color_surface);
surface_set_target_ext(1, normalmap_color_surface);
surface_set_target_ext(2, depth_specular_stencil_surface);

//
shader_set(shd_mrt_deferred_lighting);

//
var temp_layer_index = 0;

repeat(ds_list_size(lighting_engine_layer_object_list))
{
    // Find Layer Object List
    var temp_layer_object_list = ds_list_find_value(lighting_engine_layer_object_list, temp_layer_index);
    
    // Iterate through Layer Objects
    var temp_layer_object_index = 0;
    
    repeat(ds_list_size(temp_layer_object_list))
    {
        // 
        var temp_lit_object = ds_list_find_value(temp_layer_object_list, temp_layer_object_index);
        
        //
        switch (temp_lit_object.lit_object_type)
        {
            case LightingEngineLitObjectType.Unit:
            	//
				with(temp_lit_object.lit_object_instance)
				{
					//
					limb_secondary_arm.lighting_engine_render_behaviour();
				
					//
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
					
					// 
					if (weapon_active)
					{
						weapon_equipped.lighting_engine_render_behaviour();
					}
					
					// 
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

//
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
	
	//
	lighting_engine_render_point_light(mouse_x, mouse_y, 64, c_white);
	
	//
	shader_reset();
	
	//
	surface_reset_target();
}
