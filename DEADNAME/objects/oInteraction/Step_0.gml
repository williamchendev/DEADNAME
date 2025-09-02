/// @description Interaction Menu Behaviour
// Performs the Interaction's Menu UI Collisions and Option Selection Behaviours

// Interaction Menu Hover Behaviour
if (!instance_exists(interaction_object))
{
	// Iteraction's Target Object no longer exists - Destroy Interaction Instance
	instance_destroy();
}
else if (interaction_hover)
{
	// Interaction Menu Option Selection Behaviour
	if (interaction_selected)
	{
		// Find Cursor Position 
		var temp_interaction_cursor_x = GameManager.cursor_x + LightingEngine.render_x;
		var temp_interaction_cursor_y = GameManager.cursor_y + LightingEngine.render_y;
		
		// Establish Interaction Option's Vertical Offset by the Height of the Interaction Menu's Title
		var temp_interaction_option_vertical_position = interaction_option_height;
		
		// Iterate through Interaction Menu's Options
		for (var q = 0; q < array_length(interact_options); q++)
		{
			// Interaction Option Collision Detection
			var temp_interact_option_collision = point_in_rectangle(temp_interaction_cursor_x, temp_interaction_cursor_y, x, y + temp_interaction_option_vertical_position, x + interact_menu_width, y + temp_interaction_option_vertical_position + interaction_option_height);
			
			// Interaction Option Behaviour
			if (temp_interact_option_collision)
			{
				// Check if Interaction Option was Clicked
				if (mouse_check_button_pressed(mb_left))
				{
					// Interaction has not been Selected - Reset all Interaction Object Instances
					with (oInteraction)
					{
						// Reset Interaction Selection Behaviours
						interaction_hover = false;
						interaction_selected = false;
					}
					
					// Force Player Unit to switch to their unarmed Inventory Slot
					unit_inventory_change_slot(GameManager.player_unit, -1);
					
					// Reset Player Unit's Weapon to prevent attack on Click after Selecting Interaction Menu Option
					if (instance_exists(GameManager.player_unit) and GameManager.player_unit.equipment_active)
					{
						GameManager.player_unit.item_equipped.weapon_attack_reset = false;
					}
					
					// Set Ignore Click to prevent Player Input
					GameManager.input_unit_ignore_click = true;
					
					// Perform Interaction Option's Function Behaviour
					if (!is_undefined(interact_options[q].option_function))
					{
						interact_options[q].option_function(id);
					}
					
					// Interaction Option's Behaviour Performed and Interaction Menu Reset - Early Return
					GameManager.cursor_interaction_object = noone;
					return;
				}
				
				// Set Interaction Option Index
				interaction_option_index = q;
				
				// Interaction Option Triangle Animation Behaviour
				interaction_option_animation_value += interaction_option_animation_speed * frame_delta;
				interaction_option_animation_value = interaction_option_animation_value mod 1;
				
				var temp_interaction_option_triangle_breath = sin(interaction_option_animation_value * 2 * pi) * interaction_option_breath_padding;
				interaction_option_triangle_draw_angle = interaction_option_triangle_angle + (interaction_option_triangle_rotate_range * ((sin(interaction_option_animation_value * 2 * pi * interaction_option_triangle_rotate_spd) * 0.5) + 0.5));
				
				// Interaction Option Triangle Behaviour
				tri_x_1 = rot_dist_x(interaction_option_triangle_radius, interaction_option_triangle_draw_angle) + temp_interaction_option_triangle_breath;
				tri_y_1 = rot_dist_y(interaction_option_triangle_radius) + temp_interaction_option_vertical_position;
				tri_x_2 = rot_dist_x(interaction_option_triangle_radius, interaction_option_triangle_draw_angle + 120) + temp_interaction_option_triangle_breath;
				tri_y_2 = rot_dist_y(interaction_option_triangle_radius) + temp_interaction_option_vertical_position;
				tri_x_3 = rot_dist_x(interaction_option_triangle_radius, interaction_option_triangle_draw_angle + 240) + temp_interaction_option_triangle_breath;
				tri_y_3 = rot_dist_y(interaction_option_triangle_radius) + temp_interaction_option_vertical_position;
				break;
			}
			
			// Increment Interaction Option's Vertical Offset by the Height of the Option Button
			temp_interaction_option_vertical_position += interaction_option_height;
		}
	}
}
