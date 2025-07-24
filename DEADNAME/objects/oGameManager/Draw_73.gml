/// @description Late UI Draw Event
// Draws the Player's Cursor after the Default Layer's UI is Drawn

// Draw to UI Surface
surface_set_target(LightingEngine.ui_surface);

// Cursor GUI Behaviour
draw_set_alpha(1);
draw_set_color(c_white);

// Player Cursor Behaviour
if (cursor_interact) 
{
	// Draw Interaction Cursor
	draw_sprite(sCursorMenu, 0, cursor_x, cursor_y);
	
	// Draw Interaction Instance Details
	if (instance_exists(GameManager.cursor_interaction_object) and !GameManager.cursor_interaction_object.interaction_selected)
	{
		// Set Interaction Detail Text Font
		draw_set_font(font_Default);
		
		// Set Interaction Detail Text Alignment
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		// Draw Interaction Detail Text Outlined
		draw_text_outline(cursor_x + 15, cursor_y - 3, $"( {GameManager.cursor_interaction_object.interaction_object_name} )");
	}
	
	// Reset Interaction Cursor
	cursor_interact = false;
}
else if (cursor_icon) 
{
	// Draw Cursor Icon
	draw_sprite(sInteractCursorIcons, cursor_icon_index, cursor_x, cursor_y);
	
	// Reset Cursor Icon
	cursor_icon = false;
}
else if (!global.debug)
{
	// Draw Cursor Crosshair
	draw_sprite(sCursorCrosshairIcons, 1, cursor_x, cursor_y);
}

// Reset Surface
surface_reset_target();
