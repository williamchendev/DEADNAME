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
		var temp_player_inventory_slot_x = round(player_unit.x - LightingEngine.render_x);
		var temp_player_inventory_slot_y = round(player_unit.bbox_top - 48 - LightingEngine.render_y);
		
		//
		var temp_slot_contrast_color = merge_color(c_white, c_black, 0.7);
		var temp_slot_size = 24;
		var temp_slot_padding = 12;
		
		//
		draw_set_font(font_Inno);
		
		//
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		//
		var temp_player_slot_bar_width = ((temp_slot_size * array_length(player_unit.inventory_slots)) + (temp_slot_padding * (array_length(player_unit.inventory_slots) - 1))) * 0.5;
		
		//
		for (var temp_player_inventory_slot_index = 0; temp_player_inventory_slot_index < array_length(player_unit.inventory_slots); temp_player_inventory_slot_index++)
		{
			//
			var temp_player_slot_x = temp_player_inventory_slot_x + (temp_slot_size * 0.5) + (temp_player_inventory_slot_index * (temp_slot_size + temp_slot_padding)) - temp_player_slot_bar_width;
			var temp_player_slot_y = temp_player_inventory_slot_y;
			
			//
			//draw_circle_color(temp_player_slot_x, temp_player_inventory_slot_y, 12, c_black, c_black, false);
			//draw_roundrect_color_ext(temp_player_slot_x - (temp_slot_size * 0.5), temp_player_slot_y - (temp_slot_size * 0.5), temp_player_slot_x + (temp_slot_size * 0.5), temp_player_slot_y + (temp_slot_size * 0.5), 4, 4, c_black, c_black, false);
			
			if (player_unit.inventory_index == temp_player_inventory_slot_index)
			{
				draw_sprite_ext(sInventoryTier, 0, temp_player_slot_x, temp_player_inventory_slot_y, 1, 1, 0, c_white, 1);
				draw_sprite_ext(sInventoryTier, player_unit.inventory_slots[temp_player_inventory_slot_index].tier, temp_player_slot_x, temp_player_inventory_slot_y + 1, 1, 1, 0, player_unit.inventory_slots[temp_player_inventory_slot_index].tier_contrast_color, 1);
				draw_sprite_ext(sInventoryTier, player_unit.inventory_slots[temp_player_inventory_slot_index].tier, temp_player_slot_x + 1, temp_player_inventory_slot_y + 1, 1, 1, 0, player_unit.inventory_slots[temp_player_inventory_slot_index].tier_contrast_color, 1);
				draw_sprite_ext(sInventoryTier, player_unit.inventory_slots[temp_player_inventory_slot_index].tier, temp_player_slot_x, temp_player_inventory_slot_y, 1, 1, 0, player_unit.inventory_slots[temp_player_inventory_slot_index].tier_color, 1);
			}
			else
			{
				draw_sprite_ext(sInventoryTier, 0, temp_player_slot_x, temp_player_inventory_slot_y, 1, 1, 0, c_black, 1);
				draw_sprite_ext(sInventoryTier, player_unit.inventory_slots[temp_player_inventory_slot_index].tier, temp_player_slot_x, temp_player_inventory_slot_y + 1, 1, 1, 0, player_unit.inventory_slots[temp_player_inventory_slot_index].tier_contrast_color, 0.5);
				draw_sprite_ext(sInventoryTier, player_unit.inventory_slots[temp_player_inventory_slot_index].tier, temp_player_slot_x + 1, temp_player_inventory_slot_y + 1, 1, 1, 0, player_unit.inventory_slots[temp_player_inventory_slot_index].tier_contrast_color, 0.5);
				draw_sprite_ext(sInventoryTier, player_unit.inventory_slots[temp_player_inventory_slot_index].tier, temp_player_slot_x, temp_player_inventory_slot_y, 1, 1, 0, player_unit.inventory_slots[temp_player_inventory_slot_index].tier_color, 0.5);
			}
			
			//
			draw_text_outline(temp_player_slot_x + (temp_slot_size * 0.5) - 2, temp_player_inventory_slot_y + 4, $"{temp_player_inventory_slot_index}");
			
			//
			if (player_unit.inventory_slots[temp_player_inventory_slot_index].item_pack != InventoryItemPack.None)
			{
				draw_sprite_ext(global.inventory_item_packs[player_unit.inventory_slots[temp_player_inventory_slot_index].item_pack].item_sprite, 0, temp_player_slot_x, temp_player_inventory_slot_y, 1, 1, 0, c_white, 1);
			}
		}
		
		//
		if (player_unit.inventory_index != -1)
		{
			//
			draw_set_font(font_Default);
			
			//
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			
			//
			draw_text_outline(temp_player_inventory_slot_x, temp_player_inventory_slot_y + 24, $"{player_unit.inventory_slots[player_unit.inventory_index].name} [EMPTY]", player_unit.inventory_slots[player_unit.inventory_index].tier_color, c_black);
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
