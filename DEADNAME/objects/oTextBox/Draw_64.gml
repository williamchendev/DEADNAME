/// @description Insert description here
// You can write your code in this editor

// Knockout Skip Behaviour
if (instance_exists(oKnockout)) {
	return;
}

// Check if Text Exists
if (string_length(display_text) <= 0) {
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

// Set Font Properties
draw_set_font(font);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Set Alpha
draw_set_alpha(destroy_alpha * destroy_alpha);

// Text Variables
var temp_text_separation = text_separation + string_height("ABCDEFGHIJKLMNOPQRSTUVWYXZ");

// Move Text Box over Unit & Draw Unit Triangle
if (unit != noone) {
	// Text Box Movement
	old_y = y;

	x = unit_draw_x;
	var temp_y = unit_draw_y - ((string_height_ext(display_text, temp_text_separation, text_wrap_width) / 2) + (box_vertical_padding / 2) + box_breath_padding + sprite_get_height(sTextboxTriangle));
	
	if (temp_y == old_y) {
		y = round(temp_y);
	}
	else if (round(temp_y) == old_y) {
		y = old_y;
	}
	else {
		y = temp_y;
	}
}

// Draw Display Text
x -= temp_camera_x;
y -= temp_camera_y;
draw_set_color(font_contrast_color);
draw_text_ext(x, y + 1, display_text, temp_text_separation, text_wrap_width);
draw_text_ext(x + 1, y + 1, display_text, temp_text_separation, text_wrap_width);
draw_set_color(font_color);
draw_text_ext(x, y, display_text, temp_text_separation, text_wrap_width);
x += temp_camera_x;
y += temp_camera_y;

// Reset Draw Properties
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);