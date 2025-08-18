/// @description Interaction Selection Behaviour
// Performs the Interaction's Positioning, Hover Selection, and Collision Behaviours

// Check if Interaction Object Exists
if (!instance_exists(interaction_object))
{
	// Iteraction's Target Object no longer exists - Destroy Interaction Instance
	instance_destroy();
}
else
{
	// Reset Interaction Selection Variables
	interaction_hover = interaction_selected;
	interaction_option_index = -1;
	
	// Match Interaction Target Object's Object Mask
	sprite_index = interaction_object.sprite_index;
	image_index = interaction_object.image_index;
	
	// Calculate Collision Bounds of Interaction
	var temp_collision_top = interaction_object.bbox_top - interaction_collision_vertical_padding;
	var temp_collision_bottom = interaction_object.bbox_bottom + interaction_collision_vertical_padding;
	var temp_collision_left = interaction_object.bbox_left - interaction_collision_horizontal_padding;
	var temp_collision_right = interaction_object.bbox_right + interaction_collision_horizontal_padding;
	
	// Interaction Menu Position
	x = interaction_object.bbox_right + interaction_horizontal_offset;
	y = interaction_object.bbox_top;
	
	// Interaction Rendered Check
	var temp_render_left = LightingEngine.render_x - LightingEngine.render_border;
	var temp_render_top = LightingEngine.render_y - LightingEngine.render_border;
	var temp_render_right = LightingEngine.render_x + GameManager.game_width + LightingEngine.render_border;
	var temp_render_bottom = LightingEngine.render_y + GameManager.game_height + LightingEngine.render_border;
	
	if (!point_in_rectangle(interaction_object.x, interaction_object.y, temp_render_left, temp_render_top, temp_render_right, temp_render_bottom))
	{
		// Interaction not within render range - Early Return
		interaction_hover = false;
		interaction_selected = false;
		return;
	}
	
	// Set Title Font for correct Text Width Calculation
	draw_set_font(GameManager.ui_inspection_text_font);
	
	// Calculate Interaction Menu Title Dimensions
	interact_menu_width = string_width(interaction_object_name) + (interaction_text_horizontal_offset * 2);
	interact_menu_height = interaction_option_height;
	
	// Set Option Font for correct Text Width Calculation
	draw_set_font(interact_menu_option_font);
	
	// Calculate Interaction Menu Options Dimensions
	for (var i = 0; i < array_length(interact_options); i++)
	{
		interact_menu_width = max(interact_menu_width, string_width(interact_options[i].option_name) + (interaction_text_horizontal_offset * 2) + interaction_option_text_horizontal_offset + interaction_option_triangle_horizontal_offset);
		interact_menu_height += interaction_option_height;
	}
	
	// Calculate Interaction Menu Dimensions based on Interaction Menu Minimum Size
	interact_menu_width = max(interact_menu_width, interact_menu_width_minimum);
	interact_menu_height = max(interact_menu_height, interact_menu_height_minimum);
	
	// Find Cursor Position 
	var temp_interaction_cursor_x = GameManager.cursor_x + LightingEngine.render_x;
	var temp_interaction_cursor_y = GameManager.cursor_y + LightingEngine.render_y;
	
	// Interaction Collision Detection
	var temp_interact_object_collision = point_in_rectangle(temp_interaction_cursor_x, temp_interaction_cursor_y, temp_collision_left, temp_collision_top, temp_collision_right, temp_collision_bottom);
	var temp_interact_menu_collision = interaction_selected ? point_in_rectangle(temp_interaction_cursor_x, temp_interaction_cursor_y, x, y, x + interact_menu_width, y + interact_menu_height) : false;
	
	// Interaction Menu Behaviour
	if (temp_interact_object_collision or temp_interact_menu_collision)
	{
		// Reset all Interactions
		with (oInteraction)
		{
			interaction_hover = interaction_selected;
		}
		
		// Set Interaction and Gamemanager's Interaction Cursor Selection Behaviour
		interaction_hover = true;
		GameManager.cursor_interact = true;
		GameManager.cursor_interaction_object = id;
		GameManager.input_interaction_selection = true;
		
		// Interaction Object Selection Behaviour
		if (!mouse_check_button_pressed(mb_right))
		{
			// No Selection - Early Return
			return;
		}
		
		// Reset All Interaction Instances' Selection Behaviour
		with (oInteraction)
		{
			interaction_hover = false;
			interaction_selected = false;
		}
		
		// Set Interaction Instance Selected
		interaction_hover = true;
		interaction_selected = true;
		
		// Force Player Unit to switch to their unarmed Inventory Slot
		unit_inventory_change_slot(GameManager.player_unit, -1);
	}
}
