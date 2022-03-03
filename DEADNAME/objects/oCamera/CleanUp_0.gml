/// @description Camera Cleanup Event
// Cleans up any unnecessary data from use during the Camera Behaviour

// Camera Management Garabage Collection
if (surface_exists(background_surface)) {
	surface_free(background_surface);
	background_surface = -1;
}
if (surface_exists(view_surface)) {
    surface_free(view_surface);
    view_surface = -1;
}
if (surface_exists(gui_surface)) {
    surface_free(gui_surface);
    gui_surface = -1;
}