/// @description Unit Player Input Event
// Performs the Unit Instance's Player Input Behaviour

// Check if Unit has Player Input Enabled
if (player_input) 
{
	// Preset Player Controls
	input_left = keyboard_check(GameManager.left_check);
	input_right = keyboard_check(GameManager.right_check);

	input_drop_down = keyboard_check_pressed(GameManager.down_check);
	
	input_jump_hold = keyboard_check(GameManager.jump_check);
	input_double_jump = keyboard_check_pressed(GameManager.jump_check);
	
	input_attack = mouse_check_button(mb_left);
	input_aim = mouse_check_button(mb_right);
	
	input_reload = keyboard_check_pressed(GameManager.reload_check);
	input_drop = keyboard_check_pressed(GameManager.drop_check);
	
	input_cursor_x = GameManager.cursor_x + LightingEngine.render_x;
	input_cursor_y = GameManager.cursor_y + LightingEngine.render_y;
	
	// Player Unit Inventory Controls
	if (mouse_wheel_up())
	{
		inventory_index++;
		inventory_index = clamp(inventory_index, -1, array_length(inventory_slots) - 1);
	}
	else if (mouse_wheel_down())
	{
		inventory_index--;
		inventory_index = clamp(inventory_index, -1, array_length(inventory_slots) - 1);
	}
	
	// DEBUG
	GameManager.player_unit = id;
	
	var temp_render_position_x = lerp(LightingEngine.render_x, x - (GameManager.game_width * 0.5) + (x_velocity * 32), frame_delta * 0.05);
	var temp_render_position_y = lerp(LightingEngine.render_y, y - (GameManager.game_height * 0.7) + (y_velocity * 32), frame_delta * 0.05);
	
	LightingEngine.render_position(temp_render_position_x, temp_render_position_y);
}
