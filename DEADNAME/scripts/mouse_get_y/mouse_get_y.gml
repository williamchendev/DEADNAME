/// mouse_get_y();
/// @description Uses the position of the oCamera Camera Manager Object and the mouse_y variable to return the true mouse position in the room
/// @returns {real} Returns the mouse position's y coordinate in the form of a real number

// Finds and returns the mouse y position
var temp_camera = instance_find(oCamera, 0);
return mouse_y + temp_camera.y;