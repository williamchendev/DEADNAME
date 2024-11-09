/// @description Insert description here
// You can write your code in this editor

if (player_input) 
{
	// Preset Player Controls
	if (game_manager != noone)
	{
		move_left = keyboard_check(game_manager.left_check);
		move_right = keyboard_check(game_manager.right_check);

		move_drop_down = keyboard_check_pressed(game_manager.down_check);
		
		move_jump_hold = keyboard_check(game_manager.jump_check);
		move_double_jump = keyboard_check_pressed(game_manager.jump_check);
	}
}


// Inherit the parent event
event_inherited();