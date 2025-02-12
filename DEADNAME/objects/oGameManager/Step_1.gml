/// @description Early Step Event

// Toggle Debug Mode
if (keyboard_check_pressed(vk_f7)) 
{
	global.debug = !global.debug;
}

// Debug Mode Functions
if (global.debug) 
{
	
}

// Game Fullscreen
if (keyboard_check_pressed(vk_f11)) 
{
	if (window_get_fullscreen()) 
	{
		game_scale = windowed_scale;
		
		window_set_size(game_width * game_scale, game_height * game_scale);
		window_set_fullscreen(false);
		
		window_center();
	}
	else 
	{
		windowed_scale = game_scale;
		game_scale = display_get_width() / game_width;
		
		window_set_size(game_width * game_scale, game_height * game_scale);
		window_set_fullscreen(true);
	}
}

// Restart Room
if (keyboard_check_pressed(vk_f8)) 
{
	room_restart();
}
