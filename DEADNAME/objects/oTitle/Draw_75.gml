/// @description Title Draw Event
// Draws the Title to the Screen

// Title Behaviour
if (title_destroy) {
	title_timer -= title_fadeout_spd * global.realdeltatime;
	if (title_timer <= 0) {
		instance_destroy();
		return;
	}
}
else if (title_sustain) {
	title_timer = 1;
	title_sustain_timer += title_sustain_spd * global.realdeltatime;
	if (title_sustain_timer >= 1) {
		title_destroy = true;
	}
}
else {
	title_timer += title_fadein_spd * global.realdeltatime;
	if (title_timer >= 1) {
		title_sustain = true;
	}
}
title_timer = clamp(title_timer, 0, 1);

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

// Draw Title
draw_set_alpha(title_timer);
draw_set_font(title_font);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(merge_color(title_color, c_black, 0.5));
draw_text((temp_camera_width / 2) + 1, (temp_camera_height / 2) + 1, title_text);
draw_set_color(title_color);
draw_text((temp_camera_width / 2), (temp_camera_height / 2), title_text);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_alpha(1);
draw_set_font(fNormalFont);
draw_set_color(c_white);