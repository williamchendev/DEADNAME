/// @description Draw Event
// You can write your code in this editor

//
surface_set_target_ext(0, diffuse_color_surface);
surface_set_target_ext(1, normalmap_color_surface);
surface_set_target_ext(2, depth_specular_stencil_surface);
draw_clear(c_black);

//
shader_set(shd_mrt_deferredlighting_render_sprite);

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
        
        show_debug_message("HI");
        //
        switch (temp_lit_object.lit_object_type)
        {
            case LightingEngineLitObjectType.Unit:
                with (temp_lit_object.lit_object_instance)
                {
                	//limb_secondary_arm.render_behaviour();

					//
					lighting_engine_draw_sprite(sprite_index, normalmap_index, normalmap_index, image_index, x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, image_angle + draw_angle_value, image_blend, image_alpha);
					//draw_sprite_ext(sprite_index, image_index, x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, image_angle + draw_angle_value, image_blend, image_alpha);
					
					// 
					//if (weapon_active)
					//{
						//weapon_equipped.render_behaviour();
					//}
					
					// 
					//limb_primary_arm.render_behaviour();
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