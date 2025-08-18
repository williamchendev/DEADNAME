/// @description Early UI Draw Event
// Draws the Player's UI before the Default Layer's UI is Drawn

// Draw Player UI
if (instance_exists(player_unit))
{
	// Reset Draw UI Behaviour
	draw_set_alpha(1);
	draw_set_color(c_white);
	
	// Draw Unit Inventory UI
	unit_inventory_render_ui(player_unit, player_unit.player_inventory_ui_alpha);
	
	// Draw to UI Surface
	surface_set_target(LightingEngine.ui_surface);
	
	// Player Cursor Behaviour
	if (!cursor_interact and !cursor_icon and !global.debug)
	{
		// Player Weapon Crosshair
		if (player_unit.weapon_active)
		{
			player_unit.weapon_equipped.render_cursor_behaviour();
		}
	}
	
	// Reset Surface
	surface_reset_target();
}
