/// @description Insert description here
// You can write your code in this editor

//
if (!instance_exists(interaction_object))
{
	// Iteraction's Target Object no longer exists - Destroy Interaction Instance
	instance_destroy();
}
else
{
	// Match Interaction Target Object's Object Mask
	sprite_index = interaction_object.sprite_index;
	image_index = interaction_object.image_index;
	
	// 
	var temp_collision_top = interaction_object.bbox_top - interaction_collision_vertical_padding;
	var temp_collision_bottom = interaction_object.bbox_bottom + interaction_collision_vertical_padding;
	var temp_collision_left = interaction_object.bbox_left - interaction_collision_horizontal_padding;
	var temp_collision_right = interaction_object.bbox_right + interaction_collision_horizontal_padding;
	
	//
	interact_menu_width = 0;
	interact_menu_height = 0;
	
	for (var i = -1; i < array_length(interact_options); i++)
	{
		interact_menu_width = max(interact_menu_width, string_width(i == -1 ? interaction_object_name : interact_options[i].option_name));
		interact_menu_height += interaction_text_vertical_padding + interaction_text_height;
	}
	
	//
	interact_menu_width = max(interact_menu_width, interact_menu_width_minimum);
	interact_menu_height = max(interact_menu_height, interact_menu_height_minimum);
	
	//
	x = interaction_object.bbox_right + interaction_horizontal_offset;
	y = interaction_object.bbox_top;
	
	// Find Cursor Position 
	var temp_interaction_cursor_x = GameManager.cursor_x + LightingEngine.render_x;
	var temp_interaction_cursor_y = GameManager.cursor_y + LightingEngine.render_y;
	
	// 
	interaction_hover = interaction_selected;
	interaction_option_index = -1;
	
	//
	if (GameManager.input_interaction_selection)
	{
		return;
	}
	
	//
	var temp_interact_object_collision = point_in_rectangle(temp_interaction_cursor_x, temp_interaction_cursor_y, temp_collision_left, temp_collision_top, temp_collision_right, temp_collision_bottom);
	var temp_interact_menu_collision = interaction_selected ? point_in_rectangle(temp_interaction_cursor_x, temp_interaction_cursor_y, x, y, x + interact_menu_width, y + interact_menu_height) : false;
	
	if (temp_interact_object_collision or temp_interact_menu_collision)
	{
		//
		interaction_hover = true;
		GameManager.cursor_interact = true;
		GameManager.cursor_interaction_object = id;
		GameManager.input_interaction_selection = true;
		
		//
		var temp_interaction_option_vertical_position = interaction_text_vertical_padding + interaction_text_height;
		
		for (var q = 0; q < array_length(interact_options); q++)
		{
			var temp_interact_option_collision = point_in_rectangle(temp_interaction_cursor_x, temp_interaction_cursor_y, x, y + temp_interaction_option_vertical_position, x + interact_menu_width, y + temp_interaction_option_vertical_position + interaction_text_vertical_padding + interaction_text_height);
			
			if (temp_interact_option_collision)
			{
				//
				interaction_option_index = q;
				
				//
				interaction_option_animation_value += interaction_option_animation_speed * frame_delta;
				interaction_option_animation_value = interaction_option_animation_value mod 1;
				
				interaction_option_triangle_breath = interaction_option_triangle_offset + sin(interaction_option_animation_value * 2 * pi) * interaction_option_breath_padding;
				interaction_option_triangle_draw_angle = interaction_option_triangle_angle + (interaction_option_triangle_rotate_range * ((sin(interaction_option_animation_value * 2 * pi * interaction_option_triangle_rotate_spd) * 0.5) + 0.5));
				
				// Interaction Option Triangle Behaviour
				tri_x_1 = rot_dist_x(interaction_option_triangle_radius, interaction_option_triangle_draw_angle) + interaction_option_triangle_breath;
				tri_y_1 = rot_dist_y(interaction_option_triangle_radius) + temp_interaction_option_vertical_position;
				tri_x_2 = rot_dist_x(interaction_option_triangle_radius, interaction_option_triangle_draw_angle + 120) + interaction_option_triangle_breath;
				tri_y_2 = rot_dist_y(interaction_option_triangle_radius) + temp_interaction_option_vertical_position;
				tri_x_3 = rot_dist_x(interaction_option_triangle_radius, interaction_option_triangle_draw_angle + 240) + interaction_option_triangle_breath;
				tri_y_3 = rot_dist_y(interaction_option_triangle_radius) + temp_interaction_option_vertical_position;
				break;
			}
			
			temp_interaction_option_vertical_position += interaction_text_vertical_padding + interaction_text_height;
		}
		
		//
		if (!mouse_check_button_pressed(mb_right))
		{
			return;
		}
		
		//
		with (oInteraction)
		{
			interaction_selected = false;
		}
		
		//
		interaction_selected = true;
	}
}
