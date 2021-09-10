/// @description Main Object Menu Draw
// Draws the data of what the user has selected and where their mouse cursor is located

draw_set_font(fNormalFont);
var draw_offset_x = 16;
if (expanded) {
	draw_offset_x = 124;
}
var temp_mouse_x = format_string_numbers(string(round(mouse_get_x())), 5);
var temp_mouse_y = format_string_numbers(string(round(mouse_get_y())), 5);
var temp_box_x = format_string_numbers(string(floor(mouse_get_x() / 48)), 4);
var temp_box_y = format_string_numbers(string(floor(mouse_get_y() / 48)), 4);
if (selected) {
	draw_text_outline(oGameManager.camera_x + draw_offset_x, oGameManager.camera_y + oGameManager.camera_height - 31, c_white, c_black, selected_text);
}
draw_text_outline(oGameManager.camera_x + draw_offset_x, oGameManager.camera_y + oGameManager.camera_height - 18, c_white, c_black, "(" + temp_mouse_x + ", " + temp_mouse_y + ") [" + temp_box_x + ", " + temp_box_y + "]");