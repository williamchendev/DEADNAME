/// @description Insert description here
// You can write your code in this editor

//
if (!instance_exists(interaction_object))
{
	//
	show_debug_message("Destroyed");
	instance_destroy();
}
else
{
	//
	sprite_index = interaction_object.sprite_index;
	image_index = interaction_object.image_index;
	
	//
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
	if (instance_position(temp_interaction_cursor_x, temp_interaction_cursor_y, interaction_object))
	{
		//
		interaction_hover = true;
		GameManager.input_selection = true;
		
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
