/// @description GUI Draw Event
// Draws the Game GUI to Screen

/*
// Cursor Position
var temp_cursor_x = round(game_width * (window_mouse_get_x() / window_get_width()));
var temp_cursor_y = round(game_height * (window_mouse_get_y() / window_get_height()));

// Cursor GUI Behaviour
draw_set_alpha(1);
if (cursor_icon) {
	// Draw Cursor Icon
	draw_sprite(sInteractCursorIcons, cursor_index, temp_cursor_x, temp_cursor_y);
	cursor_icon = false;
}
else {
	// Draw Cursor Crosshair
	draw_sprite(sCursorCrosshairIcons, 1, temp_cursor_x, temp_cursor_y);
}
