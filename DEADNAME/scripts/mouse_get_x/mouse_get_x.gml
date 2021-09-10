/// mouse_get_x();
/// @description Uses the position of the oCamera Camera Manager Object and the mouse_x variable to return the true mouse position in the room
/// @returns {real} Returns the mouse position's x coordinate in the form of a real number

// Finds and returns the mouse x position
var temp_camera = instance_find(oCamera, 0);
var temp_mouse_x = (window_mouse_get_x() / window_get_width()) * temp_camera.camera_width;
return temp_camera.x + temp_mouse_x;