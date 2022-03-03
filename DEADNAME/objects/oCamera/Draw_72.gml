/// @description Camera Surface Event
// Clears Camera Surfaces

// Clear Color Surface
surface_set_target(background_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();
surface_set_target(gui_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();