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

// Celestial Simulator Debug UI Behaviour
if (global.debug)
{
	if (instance_exists(camera_observing_instance))
	{
		celestial_pathfinding_draw_navigation_mesh_gizmos(camera_observing_instance);
	}
	
	if (instance_exists(camera_observing_instance) and instance_exists(sub_object_selected_instance) and sub_object_selected_instance.celestial_body_instance == camera_observing_instance)
	{
		if (sub_object_selected_instance.celestial_sub_object_type == CelestialSubObjectType.Unit and !is_undefined(sub_object_selected_instance.pathfinding_path))
		{
			celestial_pathfinding_draw_path_gizmos(camera_observing_instance, sub_object_selected_instance);
		}
	}
}

// Celestial Simulator Observing Celestial Object UI Behaviour
if (instance_exists(camera_observing_instance))
{
	// Set Centered Text Alignment
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	// Establish Default (Transparent) Selected Sub Object Alpha
	var temp_sub_object_selected_alpha = 0;
	
	// Check if Celestial Simulator should Render the Miniature Version of the Sub Object's Sprite
	var temp_sub_object_miniature_icon = camera_observing_instance_radius_offset_value > camera_observing_instance_radius_offset_zoom_in_threshold;
	
	// Iterate through Celestial Object's Depth Sorted Celestial Sub Objects
	var temp_sub_object_index = 0;
	
	repeat (array_length(camera_observing_instance.sub_objects_front_layer_index_array))
	{
		// Find Celestial Object's Sub Object Index
		var temp_index = camera_observing_instance.sub_objects_front_layer_index_array[temp_sub_object_index];
		
		// Find Celestial Object's Sub Object Depth & Instance from Sub Object Index
		var temp_depth = camera_observing_instance.sub_objects_front_layer_depth_array[temp_index];
		var temp_instance = camera_observing_instance.sub_objects_front_layer_instance_array[temp_index];
		
		// Establish Sub Object's Unlit Sprite Index and Image Index
		var temp_sprite_index = temp_sub_object_miniature_icon ? temp_instance.miniature_sprite_index : temp_instance.sprite_index;
		var temp_image_index = temp_sub_object_miniature_icon ? 0 : temp_instance.image_index;
		
		// Check if Sub Object is the Celestial Simulator's Selected Sub Object Instance
		if (temp_instance == sub_object_selected_instance)
		{
			// The Celestial Simulator's Selected Sub Object Instance will NOT have a Miniature Sprite rendered
			temp_sprite_index = temp_instance.sprite_index;
			temp_image_index = temp_instance.image_index;
			
			// Check Selected Sub Object's Sub Object Type to perform appropriate Alpha Calculation
			switch (temp_instance.celestial_sub_object_type)
			{
				case CelestialSubObjectType.City:
				case CelestialSubObjectType.Unit:
					// Establish Selected Sub Object's Sprite Alpha Transparency
					var temp_default_depth_alpha = inverse_lerp(camera_observing_instance.render_depth_radius * global_sub_objects_default_depth_transparent_end, camera_observing_instance.render_depth_radius * global_sub_objects_default_depth_transparent_start, temp_depth);
					temp_sub_object_selected_alpha = power(temp_default_depth_alpha, 3);
					break;
				case CelestialSubObjectType.Satellite:
					// Establish Selected Satellite Sub Object's Sprite Alpha Transparency
					var temp_satellite_depth_alpha = inverse_lerp(camera_observing_instance.render_depth_radius * global_sub_objects_satellite_depth_transparent_end, camera_observing_instance.render_depth_radius * global_sub_objects_satellite_depth_transparent_start, temp_depth);
					temp_sub_object_selected_alpha = power(temp_satellite_depth_alpha, 3);
					break;
				default:
					// Sub Object Instance is Invalid - Skip Alpha Calculation
					break;
			}
		}
		
		// Establish Sub Object's Unlit Sprite Alpha
		var temp_alpha = temp_instance.image_alpha;
		
		// Check Celestial Sub Object's Sub Object Type to perform appropriate Render Behaviour
		switch (temp_instance.celestial_sub_object_type)
		{
			case CelestialSubObjectType.City:
				// Establish Sub Object's Unlit Sprite Alpha Transparency
				var temp_city_depth_alpha = inverse_lerp(camera_observing_instance.render_depth_radius * global_sub_objects_default_depth_transparent_end, camera_observing_instance.render_depth_radius * global_sub_objects_default_depth_transparent_start, temp_depth);
				temp_alpha *= power(temp_city_depth_alpha, 3);
				
				// Check if City Name should be Rendered when Celestial Simulator's Observation Zoom is not Toggled
				if (!temp_sub_object_miniature_icon)
				{
					// Establish Sub Object City Name Position Variables
					var temp_city_name_x = temp_instance.x;
					var temp_city_name_y = temp_instance.y - (sprite_get_yoffset(temp_sprite_index) - sprite_get_bbox_top(temp_sprite_index)) + sub_object_city_name_vertical_offset;
					
					// Draw City Name Text above City Sprite
					draw_set_alpha(temp_alpha * temp_alpha * temp_alpha);
					draw_text_outline(temp_city_name_x, temp_city_name_y, temp_instance.city_name, c_white, c_black);
					draw_set_alpha(1);
				}
				break;
			default:
				// Sub Object Instance is Invalid - Skip Render
				break;
		}
		
		// Increment Celestial Object's Sub Object Index
		temp_sub_object_index++;
	}
	
	// Draw Selection Sub Object if Celestial Simulator has a Selected Sub Object Instance
	if (instance_exists(sub_object_selected_instance) and sub_object_selected_instance.celestial_body_instance == camera_observing_instance)
	{
		// Reset Surface Target
		surface_reset_target();
		
		// Set Celestial Temporary Render Surface as Surface Targets
		surface_set_target(CelestialSimulator.temp_surface);
		
		// Reset Celestial Temporary Render Surface
		draw_clear_alpha(c_black, 0);
		
		// Draw Selected Sub Object Instance
		with (sub_object_selected_instance)
		{
			// Enable White Pixel Binary Shader
			shader_set(shd_white_pixel_binary);
			
			// Draw Selected Sub Object's White Outline
			draw_sprite_ext(sprite_index, image_index, x - 1, y, image_xscale, image_yscale, image_angle, image_blend, 1);
			draw_sprite_ext(sprite_index, image_index, x, y - 1, image_xscale, image_yscale, image_angle, image_blend, 1);
			draw_sprite_ext(sprite_index, image_index, x + 1, y, image_xscale, image_yscale, image_angle, image_blend, 1);
			draw_sprite_ext(sprite_index, image_index, x, y + 1, image_xscale, image_yscale, image_angle, image_blend, 1);
			
			// Reset Shader
			shader_reset();
			
			// Draw Selected Sub Object Instance
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1);
		}
		
		// Reset Surface Target
		surface_reset_target();
		
		// Set Celestial Simulator's UI Surface as Render Target
		surface_set_target(LightingEngine.ui_surface);
		
		// Draw Outlined Selected Sub Object Instance with correct Alpha
		draw_surface_ext(CelestialSimulator.temp_surface, 0, 0, 1, 1, 0, c_white, image_alpha * temp_sub_object_selected_alpha * temp_sub_object_selected_alpha);
		
		// Check if Unit Pathfinding Movement Path UI rendering is toggled
		if (selected_unit_movement_path_ui)
		{
			// Draw Animated Triangle Icon over the Celestial Simulator's Selected Sub Object Instance's Last Movement Path Entry
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