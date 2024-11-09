/// @description Insert description here
// You can write your code in this editor

/*
if (global.debug) {
	if (path != noone) {
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
		
		// Draw Path
		draw_set_color(c_red);
		for (var i = 0; i < array_length_1d(path); i++) {
			draw_circle(path[i].x - temp_camera_x, path[i].y - temp_camera_y, 2, false);
		}
		for (var i = 0; i < array_length_1d(path) - 1; i++) {
			draw_line(path[i].x - temp_camera_x, path[i].y - temp_camera_y, path[i + 1].x - temp_camera_x, path[i + 1].y - temp_camera_y);
		}
		draw_set_color(c_blue);
		draw_circle(path[0].x - temp_camera_x, path[0].y - temp_camera_y, 2, false);
		draw_set_color(c_white);
	}
}
*/