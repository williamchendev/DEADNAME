/// @description Insert description here
// You can write your code in this editor

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
	
	input_cursor_x = GameManager.cursor_x + LightingEngine.render_x;
	input_cursor_y = GameManager.cursor_y + LightingEngine.render_y;
	
	// DEBUG
	GameManager.player_unit = id;
	LightingEngine.render_position(x - (GameManager.game_width * 0.5), y - (GameManager.game_height * 0.7));
}
