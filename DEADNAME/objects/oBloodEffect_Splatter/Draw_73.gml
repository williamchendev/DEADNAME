/// @description Blood Draw Event
// Draws the Blood to the surface

// Skip if Knockout
if (instance_exists(oKnockout)) {
	return;
}

// Camera GUI Layer
var temp_camera_x = 0;
var temp_camera_y = 0;
var temp_camera_exists = instance_exists(oCamera);
if (temp_camera_exists) {
	var temp_camera_inst = instance_find(oCamera, 0);
	temp_camera_x = temp_camera_inst.x;
	temp_camera_y = temp_camera_inst.y;
	x -= temp_camera_x;
	y -= temp_camera_y;
	surface_set_target(temp_camera_inst.gui_surface);
}

// Draw Splatter
draw_self();

// Reset Camera GUI Layer
if (temp_camera_exists) {
	x += temp_camera_x;
	y += temp_camera_y;
	surface_reset_target();
}