/// @description Insert description here
// You can write your code in this editor


if (player_input) {
	// Preset Player Controls
	if (game_manager != noone) {
		key_left = keyboard_check(game_manager.left_check);
		key_right = keyboard_check(game_manager.right_check);
		key_up = keyboard_check(game_manager.up_check);
		key_down = keyboard_check(game_manager.down_check);

		key_left_press = keyboard_check_pressed(game_manager.left_check);
		key_right_press = keyboard_check_pressed(game_manager.right_check);
		key_up_press = keyboard_check_pressed(game_manager.up_check);
		key_down_press = keyboard_check_pressed(game_manager.down_check);
		
		key_jump = keyboard_check(game_manager.jump_check);
		key_jump_press = keyboard_check_pressed(game_manager.jump_check);
		
		key_shift = keyboard_check(game_manager.shift_check);
		key_interact_press = keyboard_check_pressed(game_manager.interact_check);
		key_inventory_press = keyboard_check_pressed(game_manager.inventory_check);
		
		key_fire_press = mouse_check_button(mb_left);
		key_aim_press = mouse_check_button(mb_right);
		key_reload_press = keyboard_check_pressed(game_manager.reload_check);
		
		key_command = keyboard_check_pressed(game_manager.command_check);
		
		cursor_x = mouse_x;
		cursor_y = mouse_y;
	}
}


// Inherit the parent event
event_inherited();

