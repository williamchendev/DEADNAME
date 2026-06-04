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
					
					// Draw City Notification Texts above City Sprite
					var temp_city_notification_index = 0;
					
					repeat (array_length(temp_instance.notifications))
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
		// Check if Camera is Observing a Battle on a valid Celestial Body Instance and Move Camera to face Battle
		if (instance_exists(camera_observing_instance) and sub_object_selected_instance.celestial_body_instance == camera_observing_instance)
		{
			// Lerp Battle's Camera Movement Value
			battle_camera_observing_lerp += battle_camera_observing_lerp_spd * frame_delta;
			battle_camera_observing_lerp = clamp(battle_camera_observing_lerp, 0, 1);
			
			// Calculate Animation Curve for Battle's Camera Movement Value
			var temp_battle_camera_observing_lerp_value = power(battle_camera_observing_lerp, battle_camera_observing_lerp_multiplier);
			
			// Calculate Camera's new Polar Horizontal & Vertical Angles
			var temp_battle_target_camera_observing_polar_horizontal_angle = ((sub_object_selected_instance.local_position_u + 0.25) mod 1) * 360;
			var temp_battle_target_camera_observing_polar_vertical_angle = lerp(89.5, -89.5, sub_object_selected_instance.local_position_v);
			
			// Adjust Camera's Observing Polar Horizontal & Vertical based on the lerped Battle's Camera Movement Value
			camera_observing_polar_horizontal_angle = battle_camera_observing_polar_horizontal_angle + angle_difference(temp_battle_target_camera_observing_polar_horizontal_angle, battle_camera_observing_polar_horizontal_angle) * temp_battle_camera_observing_lerp_value;
			camera_observing_polar_vertical_angle = battle_camera_observing_polar_vertical_angle + angle_difference(temp_battle_target_camera_observing_polar_vertical_angle, battle_camera_observing_polar_vertical_angle) * temp_battle_camera_observing_lerp_value;
		}
		
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
			// Calculate Battle Row Count & Battle Tile Width
			var temp_battle_row_count = (CelestialBattlePriorityRankMax * 2) + 1;
			var temp_battle_tile_width = 1 / ((CelestialBattlePriorityRankMax * 2) + 1);
			
			// Iterate through Battle's Choreography Actors to Draw Battle Tiles
			var temp_battle_choreography_actors_count = array_length(sub_object_selected_instance.battle_choreography_actors);
			var temp_battle_choreography_actors_index = temp_battle_choreography_actors_count - 1;
			
			repeat (temp_battle_choreography_actors_count)
			{
				// Establish Battle Choreography Actors Struct
				var temp_battle_tile_choreography_actor = sub_object_selected_instance.battle_choreography_actors[temp_battle_choreography_actors_index];
				
				// Calculate Battle Tile's Horizontal and Vertical Grid Position
				var temp_battle_platform_tile_w = CelestialBattlePriorityRankMax - temp_battle_tile_choreography_actor.actor_priority_rank - 1;
				temp_battle_platform_tile_w = temp_battle_tile_choreography_actor.actor_platform_side == CelestialBattlePlatformSide.Right ? CelestialBattlePriorityRankMax + temp_battle_tile_choreography_actor.actor_priority_rank + 1 : temp_battle_platform_tile_w;
				var temp_battle_platform_tile_h = temp_battle_tile_choreography_actor.actor_vertical_tile;
				
				// Calculate Battle Actor's Column Index & Size
				var temp_battle_actor_column_index = CelestialBattlePriorityRankMax - temp_battle_tile_choreography_actor.actor_priority_rank - 1;
				temp_battle_actor_column_index = temp_battle_tile_choreography_actor.actor_platform_side == CelestialBattlePlatformSide.Right ? CelestialBattlePriorityRankMax + temp_battle_tile_choreography_actor.actor_priority_rank : temp_battle_actor_column_index;
				var temp_battle_column_size = sub_object_selected_instance.battle_choreography_actors_battle_column_sizes[temp_battle_actor_column_index];
				
				// Calculate Battle Tile Height
				var temp_battle_tile_height = 1 / temp_battle_column_size;
				
				// Calculate the Battle Column's Vertical Alignment
				var temp_battle_column_start = 0;
				
				if (temp_battle_column_size == battle_default_column_size - 1)
				{
					// Battle Column Size is one less than the Default Size - Shift vertical alignment slightly up to preserve the Isosceles Trapezoid Perspective
					temp_battle_column_start = 0.5 - (temp_battle_tile_height * temp_battle_column_size * 0.5) - temp_battle_tile_height * 0.25;
				}
				else if (temp_battle_column_size < battle_default_column_size)
				{
					// Battle Column Size is less than the Default Size - Shift vertical alignment by one tile's height up to preserve the Isosceles Trapezoid Perspective
					temp_battle_column_start = 0.5 - (temp_battle_tile_height * temp_battle_column_size * 0.5) - temp_battle_tile_height * 0.5;
				}
				
				// Calculate the Battle Tile's "Isosceles Trapezoid Perspective" Horizontal Linear Interpolation Values
				var temp_battle_tile_wa = temp_battle_platform_tile_w * temp_battle_tile_width + battle_tile_padding_horizontal;
				var temp_battle_tile_wb = (temp_battle_platform_tile_w * temp_battle_tile_width) + temp_battle_tile_width - battle_tile_padding_horizontal;
				
				// Calculate the Battle Tile's "Isosceles Trapezoid Perspective" Vertical Linear Interpolation Values
				var temp_battle_tile_ha = temp_battle_column_start + (temp_battle_platform_tile_h * temp_battle_tile_height) + battle_tile_padding_vertical;
				var temp_battle_tile_hb = temp_battle_column_start + (temp_battle_platform_tile_h * temp_battle_tile_height) + temp_battle_tile_height - battle_tile_padding_vertical;
				
				// Calculate the Battle Tile's "Isosceles Trapezoid Perspective" Horizontal Vertex Positions on the Isosceles Trapezoid's Left and Right Sides
				var temp_battle_tile_wa_top = lerp(temp_battle_platform_ax, temp_battle_platform_bx, temp_battle_tile_wa);
				var temp_battle_tile_wa_bottom = lerp(temp_battle_platform_cx, temp_battle_platform_dx, temp_battle_tile_wa);
				
				var temp_battle_tile_wb_top = lerp(temp_battle_platform_ax, temp_battle_platform_bx, temp_battle_tile_wb);
				var temp_battle_tile_wb_bottom = lerp(temp_battle_platform_cx, temp_battle_platform_dx, temp_battle_tile_wb);
				
				// Calculate the Battle Tile's Vertex Positions
				var temp_battle_tile_ax = lerp(temp_battle_tile_wa_top, temp_battle_tile_wa_bottom, temp_battle_tile_ha);
				var temp_battle_tile_ay = lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, temp_battle_tile_ha);
				
				var temp_battle_tile_bx = lerp(temp_battle_tile_wb_top, temp_battle_tile_wb_bottom, temp_battle_tile_ha);
				var temp_battle_tile_by = lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, temp_battle_tile_ha);
				
				var temp_battle_tile_cx = lerp(temp_battle_tile_wa_top, temp_battle_tile_wa_bottom, temp_battle_tile_hb);
				var temp_battle_tile_cy = lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, temp_battle_tile_hb);
				
				var temp_battle_tile_dx = lerp(temp_battle_tile_wb_top, temp_battle_tile_wb_bottom, temp_battle_tile_hb);
				var temp_battle_tile_dy = lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, temp_battle_tile_hb);
				
				// Update Battle Actor's Draw Position
				temp_battle_tile_choreography_actor.actor_draw_x = lerp(temp_battle_tile_ax, temp_battle_tile_bx, 0.5) + (temp_battle_tile_choreography_actor.actor_platform_side == CelestialBattlePlatformSide.Right ? 2 : 0);
				temp_battle_tile_choreography_actor.actor_draw_y = lerp(temp_battle_tile_ay, temp_battle_tile_cy, 0.8);
				
				// If the Battle Tile's Horizontal Alignment is at the Right-Hand most side, Adjust the Battle Tile's Isosceles Trapezoid's Right Size by one pixel to the Left
				temp_battle_tile_bx += temp_battle_platform_tile_w == temp_battle_row_count - 1 ? -1 : 0;
				temp_battle_tile_dx += temp_battle_platform_tile_w == temp_battle_row_count - 1 ? -1 : 0;
				
				// Draw Set Alpha Transparent
				draw_set_color(1.0);
				
				// Draw Set Color as White - For the Battle Tiles' Color
				draw_set_color(c_white);
				
				// Draw the Battle Tile
				draw_triangle(temp_battle_tile_ax, temp_battle_tile_ay, temp_battle_tile_bx, temp_battle_tile_by, temp_battle_tile_cx, temp_battle_tile_cy, false);
				draw_triangle(temp_battle_tile_bx, temp_battle_tile_by, temp_battle_tile_cx, temp_battle_tile_cy, temp_battle_tile_dx, temp_battle_tile_dy, false);
				
				// Decrement Battle Choreography Actors Index
				temp_battle_choreography_actors_index--;
			}
			
			// Iterate through Battle's Choreography Actors to Draw Actor Sprites
			temp_battle_choreography_actors_index = 0;
			
			repeat (temp_battle_choreography_actors_count)
			{
				// Establish Battle Choreography Actors Struct
				var temp_battle_actor = sub_object_selected_instance.battle_choreography_actors[temp_battle_choreography_actors_index];
				
				// Draw Battle Choreography Actor Sprite
				draw_sprite_ext(temp_battle_actor.actor_battle_sprite, 0, temp_battle_actor.actor_draw_x, temp_battle_actor.actor_draw_y, temp_battle_actor.actor_facing_direction, 1, 0, temp_battle_actor.actor_faction.faction_color, 1);
				
				// Increment Battle Choreography Actors Index
				temp_battle_choreography_actors_index++;
			}
			
			/*
			for (var temp_battle_platform_tile_w = 0; temp_battle_platform_tile_w < temp_battle_row_count; temp_battle_platform_tile_w++)
			{
				// 
				var temp_battle_column_size = 9;
				
				// Check to Skip Battle Row
				if (temp_battle_column_size <= 0)
				{
					continue;
				}
				
				//
				var temp_battle_tile_height = 1 / max(temp_battle_column_size, battle_default_column_size);
				
				
				
				//
				for (var temp_battle_platform_tile_h = 0; temp_battle_platform_tile_h < temp_battle_column_size; temp_battle_platform_tile_h++)
				{
					// Calculate the Battle Tile's "Isosceles Trapezoid Perspective" Horizontal Linear Interpolation Values
					var temp_battle_tile_wa = temp_battle_platform_tile_w * temp_battle_tile_width + battle_tile_padding_horizontal;
					var temp_battle_tile_wb = (temp_battle_platform_tile_w * temp_battle_tile_width) + temp_battle_tile_width - battle_tile_padding_horizontal;
					
					// Calculate the Battle Tile's "Isosceles Trapezoid Perspective" Vertical Linear Interpolation Values
					var temp_battle_tile_ha = temp_battle_column_start + (temp_battle_platform_tile_h * temp_battle_tile_height) + battle_tile_padding_vertical;
					var temp_battle_tile_hb = temp_battle_column_start + (temp_battle_platform_tile_h * temp_battle_tile_height) + temp_battle_tile_height - battle_tile_padding_vertical;
					
					// Calculate the Battle Tile's "Isosceles Trapezoid Perspective" Horizontal Vertex Positions on the Isosceles Trapezoid's Left and Right Sides
					var temp_battle_tile_wa_top = lerp(temp_battle_platform_ax, temp_battle_platform_bx, temp_battle_tile_wa);
					var temp_battle_tile_wa_bottom = lerp(temp_battle_platform_cx, temp_battle_platform_dx, temp_battle_tile_wa);
					
					var temp_battle_tile_wb_top = lerp(temp_battle_platform_ax, temp_battle_platform_bx, temp_battle_tile_wb);
					var temp_battle_tile_wb_bottom = lerp(temp_battle_platform_cx, temp_battle_platform_dx, temp_battle_tile_wb);
					
					// Calculate the Battle Tile's Vertex Positions
					var temp_battle_tile_ax = lerp(temp_battle_tile_wa_top, temp_battle_tile_wa_bottom, temp_battle_tile_ha);
					var temp_battle_tile_ay = lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, temp_battle_tile_ha);
					
					var temp_battle_tile_bx = lerp(temp_battle_tile_wb_top, temp_battle_tile_wb_bottom, temp_battle_tile_ha);
					var temp_battle_tile_by = lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, temp_battle_tile_ha);
					
					var temp_battle_tile_cx = lerp(temp_battle_tile_wa_top, temp_battle_tile_wa_bottom, temp_battle_tile_hb);
					var temp_battle_tile_cy = lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, temp_battle_tile_hb);
					
					var temp_battle_tile_dx = lerp(temp_battle_tile_wb_top, temp_battle_tile_wb_bottom, temp_battle_tile_hb);
					var temp_battle_tile_dy = lerp(battle_platform_top_vertical_position, battle_platform_bottom_vertical_position, temp_battle_tile_hb);
					
					// If the Battle Tile's Horizontal Alignment is at the Right-Hand most side, Adjust the Battle Tile's Isosceles Trapezoid's Right Size by one pixel to the Left
					temp_battle_tile_bx += temp_battle_platform_tile_w == temp_battle_row_count - 1 ? -1 : 0;
					temp_battle_tile_dx += temp_battle_platform_tile_w == temp_battle_row_count - 1 ? -1 : 0;
					
					// Draw Set Alpha Transparent
					draw_set_color(1.0);
					
					// Draw Set Color as White - For the Battle Tiles' Color
					draw_set_color(c_white);
					
					// Draw the Battle Tile
					draw_triangle(temp_battle_tile_ax, temp_battle_tile_ay, temp_battle_tile_bx, temp_battle_tile_by, temp_battle_tile_cx, temp_battle_tile_cy, false);
					draw_triangle(temp_battle_tile_bx, temp_battle_tile_by, temp_battle_tile_cx, temp_battle_tile_cy, temp_battle_tile_dx, temp_battle_tile_dy, false);
				}
			}
			*/
			
			// Reset Draw Alpha
			draw_set_color(1);
		}
		
		// Reset Color
		draw_set_color(c_white);
	}
}

// Reset Surface Target
surface_reset_target();
