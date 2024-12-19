/// @description Early Step Event

// Toggle Debug Mode
if (keyboard_check_pressed(vk_f7)) {
	global.debug = !global.debug;
}

// Debug Mode Functions
if (global.debug) {
	
}

// Game Fullscreen
if (keyboard_check_pressed(vk_f11)) {
	if (window_get_fullscreen()) {
		window_set_size(game_width * 2, game_height * 2);
		window_set_fullscreen(false);
	}
	else {
		window_set_size(1920, 1080);
		window_set_fullscreen(true);
	}
	surface_resize(application_surface, game_width, game_height);
}
