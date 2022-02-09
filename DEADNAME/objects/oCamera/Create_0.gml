/// @description Camera Init Event
// Creates the variables and settings of the Camera Management Object

// Camera Settings
camera_width = 640;
camera_height = 360;

// Camera Variables
camera_lerp_x = camera_get_view_x(view_camera[0]);
camera_lerp_y = camera_get_view_y(view_camera[0]);

// Camera Surface
view_surface = -1;

// Camera View Properties
application_surface_enable(false);
camera_set_view_size(view_camera[0], camera_width + 1, camera_height + 1);
display_set_gui_size(camera_width, camera_height);

// Game Manager
game_manager = noone;
if (instance_exists(oGameManager)) {
	game_manager = instance_find(oGameManager, 0);
}

// Debug
sprite_index = -1;