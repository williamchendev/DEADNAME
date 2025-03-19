/// @description Debug Draw Event
// Draws Game Manager Debug Info to the screen

// Cursor Position
var temp_cursor_x = round(game_width * (window_mouse_get_x() / window_get_width()));
var temp_cursor_y = round(game_height * (window_mouse_get_y() / window_get_height()));

// Draw to UI Surface
surface_set_target(LightingEngine.ui_surface);

// Cursor GUI Behaviour
draw_set_alpha(1);
draw_set_color(c_white);

if (cursor_inventory) 
{
	draw_sprite(sCursorMenu, 0, temp_cursor_x, temp_cursor_y);
	cursor_inventory = false;
}
else if (cursor_icon) 
{
	// Draw Cursor Icon
	draw_sprite(sInteractCursorIcons, cursor_index, temp_cursor_x, temp_cursor_y);
	cursor_icon = false;
}
else if (!global.debug)
{
	// Draw Cursor Crosshair
	draw_sprite(sCursorCrosshairIcons, 1, temp_cursor_x, temp_cursor_y);
}

// Reset Surface
surface_reset_target();
