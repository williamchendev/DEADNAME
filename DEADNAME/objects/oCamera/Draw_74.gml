/// @description Camera Draw Event
// Draws the Camera View to the Screen

// Draw View Surface
if (surface_exists(view_surface)) {
	draw_surface_part(view_surface, frac(x), frac(y), camera_width, camera_height, 0, 0);
}