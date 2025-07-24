/// @description Game Resolution & Settings

// Resolution
surface_resize(application_surface, game_width, game_height);
window_set_size(game_width * game_scale, game_height * game_scale);
window_center();

// Sleep Margin
display_set_timing_method(tm_sleep);
display_set_sleep_margin(10);

// Vsync
display_reset(0, true);