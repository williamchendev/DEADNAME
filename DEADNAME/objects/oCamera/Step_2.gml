/// @description Camera Step Event
// Performs the Camera's behaviour, stabilizing its position and retrieving a surface from the default camera view

// Game Manager Screen Size
if (game_manager != noone) {
	if (instance_exists(game_manager)) {
		camera_width = game_manager.game_width;
		camera_height = game_manager.game_height;
	}
}

// Adjust Floored Camera Position (Smooth Camera)
camera_set_view_pos(view_camera[0], floor(x), floor(y));

// Set Camera View Surface
if (!surface_exists(background_surface)) {
    background_surface = surface_create(camera_width, camera_height);
}
if (!surface_exists(view_surface)) {
    view_surface = surface_create(camera_width + 1, camera_height + 1);
}
if (!surface_exists(gui_surface)) {
    gui_surface = surface_create(camera_width, camera_height);
}
view_surface_id[0] = view_surface;