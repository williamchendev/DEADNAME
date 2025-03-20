/// @description Debug Draw Event
// Draws Game Manager Debug Info to the screen

// Draw to UI Surface
surface_set_target(LightingEngine.ui_surface);

// Cursor GUI Behaviour
draw_set_alpha(1);
draw_set_color(c_white);

if (cursor_inventory) 
{
	draw_sprite(sCursorMenu, 0, cursor_x, cursor_y);
	cursor_inventory = false;
}
else if (cursor_icon) 
{
	// Draw Cursor Icon
	draw_sprite(sInteractCursorIcons, cursor_index, cursor_x, cursor_y);
	cursor_icon = false;
}
else if (!global.debug)
{
	// Draw Cursor Crosshair
	draw_sprite(sCursorCrosshairIcons, 1, cursor_x, cursor_y);
}

// Reset Surface
surface_reset_target();
