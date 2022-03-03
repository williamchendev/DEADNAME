/// @description Debug Draw Event
// Draws Game Manager Debug Info to the screen

// Check if Debugging mode is active 
if (global.debug) {
	// Camera GUI Layer
	var temp_camera_x = 0;
	var temp_camera_y = 0;
	var temp_camera_exists = instance_exists(oCamera);
	if (temp_camera_exists) {
		var temp_camera_inst = instance_find(oCamera, 0);
		temp_camera_x = camera_x;
		temp_camera_y = camera_y;
		camera_x = 0;
		camera_y = 0;
		surface_set_target(temp_camera_inst.gui_surface);
	}
	
	// Draw Set Font
	draw_set_font(fNormalFont);
	
	// Draw Debug Mode Active
	draw_text_outline(camera_x + debug_x_offset, camera_y + debug_y_offset, c_white, c_black, "Debug Mode Active");
	
	// Draw Debug Variable Bracket
	draw_set_color(c_black);
	draw_line(camera_x + debug_x_offset - 2, camera_y + debug_y_offset + 15, camera_x + debug_x_offset + 97, camera_y + debug_y_offset + 15);
	draw_line(camera_x + debug_x_offset - 3, camera_y + debug_y_offset + 16, camera_x + debug_x_offset + 98, camera_y + debug_y_offset + 16);
	draw_line(camera_x + debug_x_offset - 2, camera_y + debug_y_offset + 17, camera_x + debug_x_offset + 97, camera_y + debug_y_offset + 17);
	draw_set_color(c_white);
	draw_line(camera_x + debug_x_offset - 2, camera_y + debug_y_offset + 16, camera_x + debug_x_offset + 97, camera_y + debug_y_offset + 16);
	
	// Draw Time Modifier
	debug_fps_timer -= global.realdeltatime;
	if (debug_fps_timer <= 0) {
		debug_fps = round(fps_real);
		debug_fps_timer = 30;
	}
	draw_text_outline(camera_x + debug_x_offset, camera_y + debug_y_offset + 17, c_white, c_black, "Time: " + string(time_spd));
	draw_text_outline(camera_x + debug_x_offset, camera_y + debug_y_offset + 28, c_white, c_black, "FPS: " + string(debug_fps));
	
	// Reset Camera
	if (temp_camera_exists) {
		camera_x = temp_camera_x;
		camera_y = temp_camera_y;
		surface_reset_target();
	}
}