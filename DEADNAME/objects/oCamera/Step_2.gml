/// @description Camera Step Event
// Performs the Camera's behaviour, stabilizing its position and retrieving a surface from the default camera view

// Adjust Floored Camera Position (Smooth Camera)
camera_set_view_pos(view_camera[0], floor(x), floor(y));

// Set Camera View Surface
if (!surface_exists(view_surface)) {
    view_surface = surface_create(camera_width + 1, camera_height + 1);
}
view_surface_id[0] = view_surface;