/// @description Early UI Draw Event
// Draws the Player's UI before the Default Layer's UI is Drawn

// Draw to UI Surface
surface_set_target(LightingEngine.ui_surface);

// Reset Draw UI Behaviour
draw_set_alpha(1);
draw_set_color(c_white);

// Draw Player UI
if (instance_exists(player_unit))
{
	//
	if (true)
	{
		//
		var temp_player_inventory_slot_x = player_unit.x - LightingEngine.render_x;
		var temp_player_inventory_slot_y = player_unit.bbox_top - 32 - LightingEngine.render_y;
		
		//
		var temp_slot_size = 16;
		var temp_slot_padding = 16;
		
		//
		var temp_slot_bar_width = ((temp_slot_size * array_length(player_unit.inventory_slots)) + (temp_slot_padding * (array_length(player_unit.inventory_slots) - 1))) * 0.5;
		
		//
		for (var temp_player_inventory_slot_index = 0; temp_player_inventory_slot_index < array_length(player_unit.inventory_slots); temp_player_inventory_slot_index++)
		{
			//
			draw_circle(temp_player_inventory_slot_x + (temp_slot_size * 0.5) + (temp_player_inventory_slot_index * (temp_slot_size + temp_slot_padding)) - temp_slot_bar_width, temp_player_inventory_slot_y, 10, false);
		}
	}
	
	// Player Cursor Behaviour
	if (!cursor_interact and !cursor_icon and !global.debug)
	{
		// Player Weapon Crosshair
		if (player_unit.weapon_active)
		{
			player_unit.weapon_equipped.render_cursor_behaviour();
		}
	}
}

// Reset Surface
surface_reset_target();
