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
	interact_menu_height = 0;
	
	for (var i = 0; i < array_length(interact_options); i++)
	{
		interact_menu_width = max(string_width(interact_options[i].option_name));
		interact_menu_height += string_height(interact_options[i].option_name);
	}
	
	//
	interact_menu_width = max(interact_menu_width, interact_menu_width_minimum);
	interact_menu_height += max(interact_menu_height, interact_menu_height_minimum);
	
	//
	x = interaction_object.bbox_right + interaction_horizontal_offset;
	y = interaction_object.bbox_top;
	
	// Find Cursor Position 
	var temp_interaction_cursor_x = GameManager.cursor_x + LightingEngine.render_x;
	var temp_interaction_cursor_y = GameManager.cursor_y + LightingEngine.render_y;
	
	// 
	interaction_hover = interaction_selected;
	
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
