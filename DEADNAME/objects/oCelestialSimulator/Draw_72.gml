/// @description Celestial UI Event
// Renders some UI for the Celestial Simulator

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Set Celestial Simulator's UI Surface as Render Target
surface_set_target(LightingEngine.ui_surface);

// Celestial Simulator Observing Celestial Object UI Behaviour
if (instance_exists(camera_observing_instance))
{
	// Set Centered Text Alignment
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	// Establish Default (Transparent) Selected Render Object Alpha
	var temp_render_object_selected_alpha = 0;
	
	// Check if Celestial Simulator should Render the Miniature Version of the Render Object's Sprite
	var temp_render_object_miniature_icon = camera_observing_instance_radius_offset_value > camera_observing_instance_radius_offset_zoom_in_threshold;
	
	// Iterate through Celestial Object's Depth Sorted Celestial Render Objects
	var temp_render_object_index = 0;
	
	repeat (array_length(camera_observing_instance.render_objects_front_layer_index_array))
	{
		// Find Celestial Object's Render Object Index
		var temp_index = camera_observing_instance.render_objects_front_layer_index_array[temp_render_object_index];
		
		// Find Celestial Object's Render Object Depth & Instance from Render Object Index
		var temp_depth = camera_observing_instance.render_objects_front_layer_depth_array[temp_index];
		var temp_instance = camera_observing_instance.render_objects_front_layer_instance_array[temp_index];
		
		// Establish Render Object's Unlit Sprite Index and Image Index
		var temp_sprite_index = temp_render_object_miniature_icon ? temp_instance.miniature_sprite_index : temp_instance.sprite_index;
		var temp_image_index = temp_render_object_miniature_icon ? 0 : temp_instance.image_index;
		
		// Check if Render Object is the Celestial Simulator's Selected Render Object Instance
		if (temp_instance == render_object_selected_instance)
		{
			// The Celestial Simulator's Selected Render Object Instance will NOT have a Miniature Sprite rendered
			temp_sprite_index = temp_instance.sprite_index;
			temp_image_index = temp_instance.image_index;
			
			// Check Selected Render Object's Render Object Type to perform appropriate Alpha Calculation
			switch (temp_instance.celestial_render_object_type)
			{
				case CelestialRenderObjectType.City:
				case CelestialRenderObjectType.Unit:
					// Establish Selected Render Object's Sprite Alpha Transparency
					var temp_default_depth_alpha = inverse_lerp(camera_observing_instance.render_depth_radius * global_render_objects_default_depth_transparent_end, camera_observing_instance.render_depth_radius * global_render_objects_default_depth_transparent_start, temp_depth);
					temp_render_object_selected_alpha = power(temp_default_depth_alpha, 3);
					break;
				case CelestialRenderObjectType.Satellite:
					// Establish Selected Satellite Render Object's Sprite Alpha Transparency
					var temp_satellite_depth_alpha = inverse_lerp(camera_observing_instance.render_depth_radius * global_render_objects_satellite_depth_transparent_end, camera_observing_instance.render_depth_radius * global_render_objects_satellite_depth_transparent_start, temp_depth);
					temp_render_object_selected_alpha = power(temp_satellite_depth_alpha, 3);
					break;
				default:
					// Render Object Instance is Invalid - Skip Alpha Calculation
					break;
			}
		}
		
		// Establish Render Object's Unlit Sprite Alpha
		var temp_alpha = temp_instance.image_alpha;
		
		// Check Celestial Render Object's Render Object Type to perform appropriate Render Behaviour
		switch (temp_instance.celestial_render_object_type)
		{
			case CelestialRenderObjectType.City:
				// Establish Render Object's Unlit Sprite Alpha Transparency
				var temp_city_depth_alpha = inverse_lerp(camera_observing_instance.render_depth_radius * global_render_objects_default_depth_transparent_end, camera_observing_instance.render_depth_radius * global_render_objects_default_depth_transparent_start, temp_depth);
				temp_alpha *= power(temp_city_depth_alpha, 3);
				
				// Check if City Name should be Rendered when Celestial Simulator's Observation Zoom is not Toggled
				if (!temp_render_object_miniature_icon)
				{
					// Establish Render Object City Name Position Variables
					var temp_city_name_x = temp_instance.x;
					var temp_city_name_y = temp_instance.y - (sprite_get_yoffset(temp_sprite_index) - sprite_get_bbox_top(temp_sprite_index)) + render_object_city_name_vertical_offset;
					
					// Draw City Name Text above City Sprite
					draw_set_alpha(temp_alpha * temp_alpha * temp_alpha);
					draw_text_outline(temp_city_name_x, temp_city_name_y, temp_instance.city_name, c_white, c_black);
					draw_set_alpha(1);
				}
				break;
			default:
				// Render Object Instance is Invalid - Skip Render
				break;
		}
		
		// Increment Celestial Object's Render Object Index
		temp_render_object_index++;
	}
	
	// Draw Selection Render Object if Celestial Simulator has a Selected Render Object Instance
	if (instance_exists(render_object_selected_instance))
	{
		// Reset Surface Target
		surface_reset_target();
		
		// Set Celestial Temporary Render Surface as Surface Targets
		surface_set_target(CelestialSimulator.temp_surface);
		
		// Reset Celestial Temporary Render Surface
		draw_clear_alpha(c_black, 0);
		
		// Draw Selected Render Object Instance
		with (render_object_selected_instance)
		{
			// Enable White Pixel Binary Shader
			shader_set(shd_white_pixel_binary);
			
			// Draw Selected Render Object's White Outline
			draw_sprite_ext(sprite_index, image_index, x - 1, y, image_xscale, image_yscale, image_angle, image_blend, 1);
			draw_sprite_ext(sprite_index, image_index, x, y - 1, image_xscale, image_yscale, image_angle, image_blend, 1);
			draw_sprite_ext(sprite_index, image_index, x + 1, y, image_xscale, image_yscale, image_angle, image_blend, 1);
			draw_sprite_ext(sprite_index, image_index, x, y + 1, image_xscale, image_yscale, image_angle, image_blend, 1);
			
			// Reset Shader
			shader_reset();
			
			// Draw Selected Render Object Instance
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1);
		}
		
		// Reset Surface Target
		surface_reset_target();
		
		// Set Celestial Simulator's UI Surface as Render Target
		surface_set_target(LightingEngine.ui_surface);
		
		// Draw Outlined Selected Render Object Instance with correct Alpha
		draw_surface_ext(CelestialSimulator.temp_surface, 0, 0, 1, 1, 0, c_white, image_alpha * temp_render_object_selected_alpha * temp_render_object_selected_alpha);
		
		// Check if Unit Pathfinding Movement Path UI rendering is toggled
		if (selected_unit_movement_path_ui)
		{
			// Draw Animated Triangle Icon over the Celestial Simulator's Selected Render Object Instance's Last Movement Path Entry
			var temp_path_entry_index = selected_unit_movement_path_entries - 1;
			render_triangle_ui(selected_unit_movement_path_point_b_position_x_array[temp_path_entry_index], selected_unit_movement_path_point_b_position_y_array[temp_path_entry_index], selected_unit_movement_path_point_b_alpha_array[temp_path_entry_index]);
		}
	}
	
	// Reset Text Alignment
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

// Reset Surface Target
surface_reset_target();