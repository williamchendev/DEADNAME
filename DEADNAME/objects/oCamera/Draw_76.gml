/// @description Camera Background
// Draws Background to Screen

surface_set_target(view_surface_id[0]);
draw_clear_alpha(c_white, 0);
surface_reset_target();

// Background Surface
display_set_gui_size(camera_width, camera_height);
if (surface_exists(background_surface)) {
	surface_set_target(background_surface);
	draw_clear_alpha(c_white, 1);
	for (var i = 0; i < instance_number(oBackground); i++) {
		var temp_background_inst = instance_find(oBackground, i);
		temp_background_inst.x -= x;
		temp_background_inst.y -= y;
		with (temp_background_inst) {
			draw_background = true;
			event_perform(ev_draw, 0);
			draw_background = false;
		}
		temp_background_inst.x += x;
		temp_background_inst.y += y;
	}
	surface_reset_target();
	draw_surface_ext(background_surface, 0, 0, window_get_width() / camera_width, window_get_height() / camera_height, 0, c_white, 1);
}