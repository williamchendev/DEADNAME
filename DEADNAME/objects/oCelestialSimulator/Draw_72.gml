/// @description Celestial UI Event
// Renders some UI for the Celestial Simulator

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Set Default Blendmode
gpu_set_blendmode(bm_normal);

// Set Celestial Simulator's UI Surface as Render Target
surface_set_target(LightingEngine.ui_surface);

#region Debug UI Rendering
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
#endregion

#region Object UI Rendering
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
	var temp_sub_object_count = array_length(camera_observing_instance.sub_objects_front_layer_index_array);
	
	repeat (temp_sub_object_count)
	{
		// Find Celestial Object's Sub Object Index
		var temp_index = camera_observing_instance.sub_objects_front_layer_index_array[temp_sub_object_index];
		
		// Find Celestial Object's Sub Object Depth & Instance from Sub Object Index
		var temp_depth = camera_observing_instance.sub_objects_front_layer_depth_array[temp_index];
		var temp_instance = camera_observing_instance.sub_objects_front_layer_instance_array[temp_index];
		
		// Establish Sub Object's Unlit Sprite Index and Image Index
		var temp_sprite_index = temp_sub_object_miniature_icon ? temp_instance.miniature_sprite_index : temp_instance.sprite_index;
		var temp_image_index = temp_sub_object_miniature_icon ? 0 : temp_instance.image_index;
		
		// Calculate Sprite Vertical Offset
		var temp_sprite_vertical_offset = -sprite_get_yoffset(temp_sprite_index) + sprite_get_bbox_top(temp_sprite_index);
		
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
				case CelestialSubObjectType.Battle:
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
			case CelestialSubObjectType.Unit:
				// Celestial Unit UI Drawing Behaviour
				if (temp_instance.celestial_sub_object_type == CelestialSubObjectType.Unit)
				{
					// Unit Emotion Battle Popup Animation Rendering Behaviour
					if (temp_instance.engaged_in_battle and temp_instance.emotion_battle_popup_timer > 0)
					{
						// Calculate Unit Emotion Battle Popup Animation Values
						var temp_emotion_battle_popup_anim_value = power(temp_instance.emotion_battle_popup_timer / temp_instance.emotion_battle_popup_duration, temp_instance.emotion_battle_popup_animation_multiplier);
						var temp_emotion_battle_popup_scale = lerp(1, temp_instance.emotion_battle_popup_initial_scale, temp_emotion_battle_popup_anim_value * temp_emotion_battle_popup_anim_value);
						var temp_emotion_battle_popup_y = temp_instance.y + temp_sprite_vertical_offset + (temp_instance.emotion_battle_popup_vertical_movement * temp_emotion_battle_popup_anim_value);
						
						// Unit Engaged in Battle Popup Animation Draw Sprite Behaviour
						draw_sprite_ext(sOverworld_Emotion_Battle, 0, temp_instance.x, temp_emotion_battle_popup_y, temp_instance.image_xscale * temp_emotion_battle_popup_scale, temp_emotion_battle_popup_scale, 0, c_white, temp_alpha);
					}
				}
				break;
			case CelestialSubObjectType.City:
				// Establish Sub Object's Unlit Sprite Alpha Transparency
				var temp_city_depth_alpha = inverse_lerp(camera_observing_instance.render_depth_radius * global_sub_objects_default_depth_transparent_end, camera_observing_instance.render_depth_radius * global_sub_objects_default_depth_transparent_start, temp_depth);
				temp_alpha *= power(temp_city_depth_alpha, 3);
				
				// Check if City Name should be Rendered when Celestial Simulator's Observation Zoom is not Toggled
				if (!temp_sub_object_miniature_icon)
				{
					// Establish Sub Object City Name Position Variables
					var temp_city_name_x = temp_instance.x;
					var temp_city_name_y = temp_instance.y + temp_sprite_vertical_offset + sub_object_city_name_vertical_offset;
					
					// Draw City Name Text above City Sprite
					draw_set_alpha(temp_alpha * temp_alpha * temp_alpha);
					draw_text_outline(temp_city_name_x, temp_city_name_y, temp_instance.city_name, c_white, c_black);
					
					// Draw City Notification Texts above City Sprite
					var temp_city_notification_index = 0;
					var temp_city_notification_count = array_length(temp_instance.notifications);
					
					repeat (temp_city_notification_count)
					{
						// Establish City Notification Struct
						var temp_city_notification_struct = temp_instance.notifications[temp_city_notification_index];
						
						// Find City Notification Duration Value
						var temp_city_notification_duration_value = clamp(temp_city_notification_struct.duration / 5, 0, 1);
						
						// DEBUG DEBUG DEBUG PLS DO NOT LET THIS BE IN THE FINAL GAME
						// Draw Notification
						draw_set_alpha(temp_alpha * temp_alpha * temp_alpha * temp_city_notification_duration_value);
						draw_text_outline(temp_city_name_x, temp_city_name_y - 12 - 12 * (1 - temp_city_notification_duration_value), temp_city_notification_struct.text, c_white, c_black);
						
						// Increment City Notification Index
						temp_city_notification_index++;
					}
					
					// Reset Draw Alpha
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
			
			// Celestial Unit Selected UI Drawing Behaviour
			if (celestial_sub_object_type == CelestialSubObjectType.Unit)
			{
				// Calculate Unit's Sprite Vertical Offset
				var temp_selected_inst_sprite_vertical_offset = -sprite_get_yoffset(sprite_index) + sprite_get_bbox_top(sprite_index);
				
				// Unit Emotion Battle Popup Animation Rendering Behaviour
				if (engaged_in_battle and emotion_battle_popup_timer > 0)
				{
					// Calculate Unit Emotion Battle Popup Animation Values
					var temp_selected_inst_emotion_battle_popup_anim_value = power(emotion_battle_popup_timer / emotion_battle_popup_duration, emotion_battle_popup_animation_multiplier);
					var temp_selected_inst_emotion_battle_popup_scale = lerp(1, emotion_battle_popup_initial_scale, temp_selected_inst_emotion_battle_popup_anim_value * temp_selected_inst_emotion_battle_popup_anim_value);
					var temp_selected_inst_emotion_battle_popup_y = y + temp_selected_inst_sprite_vertical_offset + (emotion_battle_popup_vertical_movement * temp_selected_inst_emotion_battle_popup_anim_value);
					
					// Unit Engaged in Battle Popup Animation Draw Sprite Behaviour
					draw_sprite_ext(sOverworld_Emotion_Battle, 0, x, temp_selected_inst_emotion_battle_popup_y, image_xscale * temp_selected_inst_emotion_battle_popup_scale, temp_selected_inst_emotion_battle_popup_scale, 0, c_white, temp_alpha);
				}
				
				// Unit Emotion Sprite Animation Rendering Behaviour
				if (!temp_sub_object_miniature_icon and emotion_sprite_index != -1)
				{
					// Unit Emotion Animation Draw Sprite Behaviour
					draw_sprite_ext(emotion_sprite_index, emotion_image_index, x, y + temp_selected_inst_sprite_vertical_offset, 1, 1, 0, c_white, temp_alpha);
				}
			}
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
#endregion

// Set Default Alpha Enabled Blendmode - Correctly Layers Transparent Images over each other on Surfaces
gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

#region Selection UI Rendering
// DEBUG UNFINISHED BULLSHIT WILLPOWER UI - PLEASE FIX
// Draw Selected Celestial Sub Object UI
if (instance_exists(sub_object_selected_instance))
{
	if (sub_object_selected_instance.celestial_sub_object_type == CelestialSubObjectType.Unit)
	{
		//
		var temp_unit_ui_x = 0;
		var temp_unit_ui_y = GameManager.game_height;
		
		//
		draw_sprite(sUI_Overworld_UnitSelect_Background, 0, temp_unit_ui_x, temp_unit_ui_y);
		draw_sprite(sUI_Overworld_UnitSelect_DebugUnit, 0, temp_unit_ui_x, temp_unit_ui_y);
		
		//
		draw_sprite(sUI_Overworld_Solar_Icon, sub_object_selected_instance.unit_solar, temp_unit_ui_x + 152, temp_unit_ui_y - 64);
		
		//
		var temp_willpower_horizontal_offset = 152;
		var temp_willpower_vertical_offset = -28;
		
		//
		var temp_willpower_sun = sub_object_selected_instance.willpower_sun;
		var temp_willpower_moon = sub_object_selected_instance.willpower_moon;
		
		//
		var temp_willpower_index = 0;
		var temp_willpower_total = temp_willpower_sun + temp_willpower_moon;
		
		//
		while (temp_willpower_total > 0)
		{
			//
			var temp_willpower_index_h_offset = temp_willpower_index * 20;
			
			if (temp_willpower_sun > 0)
			{
				//
				draw_sprite(sUI_Overworld_Willpower, 0, temp_unit_ui_x + temp_willpower_horizontal_offset + temp_willpower_index_h_offset, temp_unit_ui_y + temp_willpower_vertical_offset);
				
				//
				temp_willpower_sun--;
			}
			else if (temp_willpower_moon > 0)
			{
				//
				draw_sprite(sUI_Overworld_Willpower, 1, temp_unit_ui_x + temp_willpower_horizontal_offset + temp_willpower_index_h_offset, temp_unit_ui_y + temp_willpower_vertical_offset);
				
				//
				temp_willpower_moon--;
			}
			
			//
			temp_willpower_index++;
			
			//
			temp_willpower_total--;
		}
	}
	else if (sub_object_selected_instance.celestial_sub_object_type == CelestialSubObjectType.Battle)
	{
		// Calculate Battle's Trapezoidal Shaped Platform Vertex Positions
		var temp_battle_platform_ax = (GameManager.game_width * 0.5) - (battle_platform_top_horizontal_width * 0.5);
		var temp_battle_platform_ay = battle_platform_top_vertical_position;
		
		var temp_battle_platform_bx = (GameManager.game_width * 0.5) + (battle_platform_top_horizontal_width * 0.5);
		var temp_battle_platform_by = battle_platform_top_vertical_position;
		
		var temp_battle_platform_cx = (GameManager.game_width * 0.5) - (battle_platform_bottom_horizontal_width * 0.5);
		var temp_battle_platform_cy = battle_platform_bottom_vertical_position;
		
		var temp_battle_platform_dx = (GameManager.game_width * 0.5) + (battle_platform_bottom_horizontal_width * 0.5);
		var temp_battle_platform_dy = battle_platform_bottom_vertical_position;
		
		// Perform Battle Platform's Inital Opening Animation
		if (battle_platform_animation)
		{
			// Increment Battle Platform Animation Values
			battle_platform_animation_momentum += battle_platform_animation_spd * frame_delta;
			battle_platform_animation_value += battle_platform_animation_momentum * frame_delta;
			
			// Calculate the transformation lerp value of the Battle Platform from a Square to an Isosceles Trapezoid
			var temp_battle_platform_animation_isosceles_trapezoid_lerp = battle_platform_animation_cycles >= battle_platform_animation_cycle_count ? battle_platform_animation_value : 0;
			temp_battle_platform_animation_isosceles_trapezoid_lerp = temp_battle_platform_animation_isosceles_trapezoid_lerp * temp_battle_platform_animation_isosceles_trapezoid_lerp;
			
			// Check if the Animation has completed a Cycle
			if (battle_platform_animation_value > 1)
			{
				// Check if the Cycle completed was the final Cycle in the Battle Platform's Animation 
				if (battle_platform_animation_cycles < battle_platform_animation_cycle_count)
				{
					// Animation has not finished - Increment Cycle
					battle_platform_animation_value -= 1;
					battle_platform_animation_cycles++;
				}
				else
				{
					// Animation has finished - End Animation
					battle_platform_animation = false;
					battle_platform_animation_value = 1;
					
					temp_battle_platform_animation_isosceles_trapezoid_lerp = 1;
				}
			}
			
			// Calculate the Rotation of the Battle Platform
			var temp_battle_platform_animation_rotation = battle_platform_animation_value * 360;
			
			// Calculate the Center of the Battle Platform
			var temp_battle_platform_center_x = lerp(sub_object_selected_instance.x, GameManager.game_width * 0.5, temp_battle_platform_animation_isosceles_trapezoid_lerp);
			var temp_battle_platform_center_y = lerp(sub_object_selected_instance.y, lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, 0.5), temp_battle_platform_animation_isosceles_trapezoid_lerp);
			
			// Calculate the Point Directions of each Battle Platform Vertex from the Center of the Battle Platform
			var temp_battle_platform_angle_a = point_direction(GameManager.game_width * 0.5, lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, 0.5), temp_battle_platform_ax, temp_battle_platform_ay);
			var temp_battle_platform_angle_b = point_direction(GameManager.game_width * 0.5, lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, 0.5), temp_battle_platform_bx, temp_battle_platform_by);
			var temp_battle_platform_angle_c = point_direction(GameManager.game_width * 0.5, lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, 0.5), temp_battle_platform_cx, temp_battle_platform_cy);
			var temp_battle_platform_angle_d = point_direction(GameManager.game_width * 0.5, lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, 0.5), temp_battle_platform_dx, temp_battle_platform_dy);
			
			// Calculate the Point Distances of each Battle Platform Vertex from the Center of the Battle Platform
			var temp_battle_platform_length_a = point_distance(GameManager.game_width * 0.5, lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, 0.5), temp_battle_platform_ax, temp_battle_platform_ay);
			var temp_battle_platform_length_b = point_distance(GameManager.game_width * 0.5, lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, 0.5), temp_battle_platform_bx, temp_battle_platform_by);
			var temp_battle_platform_length_c = point_distance(GameManager.game_width * 0.5, lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, 0.5), temp_battle_platform_cx, temp_battle_platform_cy);
			var temp_battle_platform_length_d = point_distance(GameManager.game_width * 0.5, lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, 0.5), temp_battle_platform_dx, temp_battle_platform_dy);
			
			// Lerp the angles of the Battle Platform's Animation Square Vertex Directions into their Isosceles Trapezoid form
			temp_battle_platform_angle_a = temp_battle_platform_animation_rotation + 135 + angle_difference(temp_battle_platform_angle_a, 135) * temp_battle_platform_animation_isosceles_trapezoid_lerp;
			temp_battle_platform_angle_b = temp_battle_platform_animation_rotation + 45 + angle_difference(temp_battle_platform_angle_b, 45) * temp_battle_platform_animation_isosceles_trapezoid_lerp;
			temp_battle_platform_angle_c = temp_battle_platform_animation_rotation + 225 + angle_difference(temp_battle_platform_angle_c, 225) * temp_battle_platform_animation_isosceles_trapezoid_lerp;
			temp_battle_platform_angle_d = temp_battle_platform_animation_rotation + 315 + angle_difference(temp_battle_platform_angle_d, 315) * temp_battle_platform_animation_isosceles_trapezoid_lerp;
			
			// Calculate the size of the Battle Platform's Animation Square Size
			var temp_battle_platform_square_value = sqr((battle_platform_animation_cycles + battle_platform_animation_value) / (battle_platform_animation_cycle_count + 1)) * (battle_platform_animation_cycle_count + 1);
			var temp_battle_platform_square_size = temp_battle_platform_square_value * battle_platform_animation_square_size;
			
			// Lerp the length of the Battle Platform's Animation Square Vertex Distances into their Isosceles Trapezoid form
			temp_battle_platform_length_a = lerp(temp_battle_platform_square_size, temp_battle_platform_length_a, temp_battle_platform_animation_isosceles_trapezoid_lerp);
			temp_battle_platform_length_b = lerp(temp_battle_platform_square_size, temp_battle_platform_length_b, temp_battle_platform_animation_isosceles_trapezoid_lerp);
			temp_battle_platform_length_c = lerp(temp_battle_platform_square_size, temp_battle_platform_length_c, temp_battle_platform_animation_isosceles_trapezoid_lerp);
			temp_battle_platform_length_d = lerp(temp_battle_platform_square_size, temp_battle_platform_length_d, temp_battle_platform_animation_isosceles_trapezoid_lerp);
			
			// Calculate the Battle Platform's Animated Vertex Positions
			temp_battle_platform_ax = rot_dist_x(temp_battle_platform_length_a, temp_battle_platform_angle_a) + temp_battle_platform_center_x;
			temp_battle_platform_ay = rot_dist_y(temp_battle_platform_length_a) + temp_battle_platform_center_y;
			
			temp_battle_platform_bx = rot_dist_x(temp_battle_platform_length_b, temp_battle_platform_angle_b) + temp_battle_platform_center_x;
			temp_battle_platform_by = rot_dist_y(temp_battle_platform_length_b) + temp_battle_platform_center_y;
			
			temp_battle_platform_cx = rot_dist_x(temp_battle_platform_length_c, temp_battle_platform_angle_c) + temp_battle_platform_center_x;
			temp_battle_platform_cy = rot_dist_y(temp_battle_platform_length_c) + temp_battle_platform_center_y;
			
			temp_battle_platform_dx = rot_dist_x(temp_battle_platform_length_d, temp_battle_platform_angle_d) + temp_battle_platform_center_x;
			temp_battle_platform_dy = rot_dist_y(temp_battle_platform_length_d) + temp_battle_platform_center_y;
		}
		else
		{
			// Set Draw Color as White - For the Battle Platform's Outline Color
			draw_set_color(c_white);
			
			// Draw the Battle Platform's White Background
			draw_triangle(temp_battle_platform_ax + 1, temp_battle_platform_ay, temp_battle_platform_bx + 1, temp_battle_platform_by, temp_battle_platform_cx + 1, temp_battle_platform_cy, false);
			draw_triangle(temp_battle_platform_bx + 1, temp_battle_platform_by, temp_battle_platform_cx + 1, temp_battle_platform_cy, temp_battle_platform_dx + 1, temp_battle_platform_dy, false);
			
			draw_triangle(temp_battle_platform_ax - 1, temp_battle_platform_ay, temp_battle_platform_bx - 1, temp_battle_platform_by, temp_battle_platform_cx - 1, temp_battle_platform_cy, false);
			draw_triangle(temp_battle_platform_bx - 1, temp_battle_platform_by, temp_battle_platform_cx - 1, temp_battle_platform_cy, temp_battle_platform_dx - 1, temp_battle_platform_dy, false);
			
			draw_triangle(temp_battle_platform_ax, temp_battle_platform_ay + 1, temp_battle_platform_bx, temp_battle_platform_by + 1, temp_battle_platform_cx, temp_battle_platform_cy + 1, false);
			draw_triangle(temp_battle_platform_bx, temp_battle_platform_by + 1, temp_battle_platform_cx, temp_battle_platform_cy + 1, temp_battle_platform_dx, temp_battle_platform_dy + 1, false);
			
			draw_triangle(temp_battle_platform_ax, temp_battle_platform_ay - 1, temp_battle_platform_bx, temp_battle_platform_by - 1, temp_battle_platform_cx, temp_battle_platform_cy - 1, false);
			draw_triangle(temp_battle_platform_bx, temp_battle_platform_by - 1, temp_battle_platform_cx, temp_battle_platform_cy - 1, temp_battle_platform_dx, temp_battle_platform_dy - 1, false);
			
			// Draw Battle Round Clock
			draw_set_halign(fa_center);
			draw_text_outline(GameManager.game_width * 0.5, battle_platform_top_vertical_position - 32, $"{sub_object_selected_instance.battle_round}");
			draw_text_outline(GameManager.game_width * 0.5, battle_platform_top_vertical_position - 18, $"{string_delete(string(sub_object_selected_instance.battle_round_timer), -1, -1)}");
			draw_set_halign(fa_left);
		}
		
		// Set Draw Color as Black - For the Battle Platform's Color
		draw_set_color(c_black);
		
		// Draw the Battle Platform
		draw_triangle(temp_battle_platform_ax, temp_battle_platform_ay, temp_battle_platform_bx, temp_battle_platform_by, temp_battle_platform_cx, temp_battle_platform_cy, false);
		draw_triangle(temp_battle_platform_bx, temp_battle_platform_by, temp_battle_platform_cx, temp_battle_platform_cy, temp_battle_platform_dx, temp_battle_platform_dy, false);
		
		// Draw Battle Tiles
		if (!battle_platform_animation)
		{
			// Perform Render Behaviour for Celestial Battle's Choreography Stack
			render_celestial_battle_choreography_stack();
			
			// Reset Draw Alpha
			draw_set_color(1);
		}
		
		// Reset Color
		draw_set_color(c_white);
	}
}
#endregion

// Reset Surface Target
surface_reset_target();
