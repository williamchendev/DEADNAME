/// mouse_get_x();
/// @description Uses the position of the oCamera Camera Manager Object and the mouse_x variable to return the true mouse position in the room
/// @returns {real} Returns the mouse position's x coordinate in the form of a real number

// Finds and returns the mouse x position
var temp_camera = instance_find(oCamera, 0);
return mouse_x + temp_camera.x;