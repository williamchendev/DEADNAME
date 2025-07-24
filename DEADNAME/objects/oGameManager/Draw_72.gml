/// @description Early UI Draw Event
// Draws the Player's Cursor before the Default Layer's UI is Drawn

// Draw to UI Surface
surface_set_target(LightingEngine.ui_surface);

// Cursor GUI Behaviour
draw_set_alpha(1);
draw_set_color(c_white);

// Player Cursor Behaviour
if (!cursor_interact and !cursor_icon and !global.debug)
{
	// Player Weapon Crosshair
	if (instance_exists(player_unit) and player_unit.weapon_active)
	{
		player_unit.weapon_equipped.render_cursor_behaviour();
	}
}

// Reset Surface
surface_reset_target();
