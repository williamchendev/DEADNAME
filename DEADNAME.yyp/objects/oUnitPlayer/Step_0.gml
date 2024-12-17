/// @description Insert description here
// You can write your code in this editor

if (player_input) 
{
	// Preset Player Controls
	if (game_manager != noone)
	{
		input_left = keyboard_check(game_manager.left_check);
		input_right = keyboard_check(game_manager.right_check);

		input_drop_down = keyboard_check_pressed(game_manager.down_check);
		
		input_jump_hold = keyboard_check(game_manager.jump_check);
		input_double_jump = keyboard_check_pressed(game_manager.jump_check);
		
		input_attack = mouse_check_button(mb_left);
		input_aim = mouse_check_button(mb_right);
		
		input_reload = keyboard_check_pressed(game_manager.reload_check);
		
		input_cursor_x = mouse_x;
		input_cursor_y = mouse_y;
	}
}


// Inherit the parent event
event_inherited();