/// @description Camera Draw Event
// Draws the Camera View to the Screen

// Draw View Surface
display_set_gui_size(camera_width, camera_height);
if (surface_exists(view_surface)) {
	draw_surface_part(view_surface, frac(x), frac(y), camera_width, camera_height, 0, 0);
}
if (surface_exists(gui_surface)) {
	draw_surface_part(gui_surface, 0, 0, camera_width, camera_height, 0, 0);
}