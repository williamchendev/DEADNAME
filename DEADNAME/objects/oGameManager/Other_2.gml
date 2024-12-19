/// @description Game Resolution & Settings

// Resolution
var temp_default_size = 3;
surface_resize(application_surface, game_width, game_height);
window_set_size(game_width * temp_default_size, game_height * temp_default_size);
window_center();

// Sleep Margin
display_set_timing_method(tm_sleep);
display_set_sleep_margin(20);

// Game FPS Cap
game_set_speed(60, gamespeed_fps);

// Vsync
display_reset(0, true);

// Cursor
window_set_cursor(cr_none);