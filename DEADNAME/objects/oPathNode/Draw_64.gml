/// @description Debug Node Draw Event
// Draws Debug info on the Node Object

if (!global.debug) {
	return;
}

// Camera GUI Layer
var temp_camera_x = 0;
var temp_camera_y = 0;
var temp_camera_width = 640;
var temp_camera_height = 360;
var temp_camera_exists = instance_exists(oCamera);
if (temp_camera_exists) {
	var temp_camera_inst = instance_find(oCamera, 0);
	temp_camera_x = temp_camera_inst.x;
	temp_camera_y = temp_camera_inst.y;
	temp_camera_width = temp_camera_inst.camera_width;
	temp_camera_height = temp_camera_inst.camera_height;
	display_set_gui_size(temp_camera_width, temp_camera_height);
}

// Draw Path Node
draw_set_color(c_purple);
draw_line(x - temp_camera_x, y - temp_camera_y, x_position - temp_camera_x, y_position - temp_camera_y);
draw_circle(x_position - temp_camera_x, y_position - temp_camera_y, 3, false);
draw_set_color(c_white);

draw_circle(x - temp_camera_x, y - temp_camera_y, 5, false);