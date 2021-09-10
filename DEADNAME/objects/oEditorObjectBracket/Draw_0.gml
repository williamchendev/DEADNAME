/// @description Editor Object Sub-Menu Draw
// Draws the Bracket to the screen along with the bracket name and the hover text

// Set the font
draw_set_font(fHeartBit);

// Draw the bottom bracket seperators
draw_rectangle(x, y, x + 107, y + 10, false);
if (expanded) {
	draw_rectangle(x, y + height + 15, x + 107, y + height + 17, false);
}
else {
	draw_rectangle(x, y + 15, x + 107, y + 17, false);
}

// Draw the name of the bracket
draw_text_outline(x + 3, y - 3, c_white, c_black, bar_name);

// Draw the hover text
if (hover_text != noone) {
	draw_set_font(fHeartBit);
	draw_text_outline(mouse_get_x() + 6, mouse_get_y() - 16, c_white, c_black, hover_text);
	
	// Draw Hover Details if User has hovered over the object
	if (hover_text_details_timer <= 0) {
		draw_text_outline(mouse_get_x() + 6, mouse_get_y() - 6, c_white, c_black, " + " + hover_text_details);
	}
}