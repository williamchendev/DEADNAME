/// @description Late UI Draw Event
// Draws the Player's Cursor after the Default Layer's UI is Drawn

// Draw to UI Surface
surface_set_target(LightingEngine.ui_surface);

// Cursor GUI Behaviour
draw_set_alpha(1);
draw_set_color(c_white);

// Player UI Behaviour Variables
var temp_player_unit_weapon_equipped = instance_exists(player_unit) and player_unit.equipment_active and global.item_packs[player_unit.item_equipped.item_pack].item_type == ItemType.Weapon;

// Draw Player Unit Weapon UI Behaviour
if (temp_player_unit_weapon_equipped)
{
	// Draw Player Unit's Weapon UI based on Weapon Type Equipped
	switch (global.item_packs[player_unit.item_equipped.item_pack].weapon_data.weapon_type)
	{
		case WeaponType.Thrown:
		case WeaponType.Grenade:
		case WeaponType.Molotov:
			// Draw Throwable Weapon Fuze Timer
			if (!is_undefined(player_unit.item_equipped.thrown_weapon_fuze_timer))
			{
				// Create Throwable Weapon Fuze Timer's Text
				var temp_thrown_weapon_fuze_timer_display_text = string_delete(string(player_unit.item_equipped.thrown_weapon_fuze_timer), -1, -1);
				
				// Set Throwable Weapon Fuze Timer Text Font
				draw_set_font(font_Default);
				
				// Set Throwable Weapon Fuze Timer Text Alignment
				draw_set_halign(fa_center);
				draw_set_valign(fa_bottom);
				
				// Draw Throwable Weapon Fuze Timer's Text
				draw_text_outline(player_unit.x - LightingEngine.render_x + 2, player_unit.y - LightingEngine.render_y - player_unit.sprite_height, $"{temp_thrown_weapon_fuze_timer_display_text}s");
			}
			break;
		default:
			break;
	}
}

// Player Cursor Behaviour
if (cursor_interact) 
{
	// Draw Interaction Cursor
	draw_sprite(sUI_CursorMenu, 0, cursor_x, cursor_y);
	
	// Draw Interaction Instance Details
	if (instance_exists(cursor_interaction_object) and !cursor_interaction_object.interaction_selected)
	{
		// Set Interaction Detail Text Font
		draw_set_font(ui_inspection_text_font);
		
		// Set Interaction Detail Text Alignment
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		// Draw Interaction Detail Text Outlined
		draw_text_outline(cursor_x + 17, cursor_y - 3, $"{cursor_interaction_object.interaction_object_name}");
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
	if (temp_player_unit_weapon_equipped)
	{
		// Draw Weapon Crosshair Cursor
		switch (global.item_packs[player_unit.item_equipped.item_pack].weapon_data.weapon_type)
		{
			case WeaponType.Thrown:
			case WeaponType.Grenade:
			case WeaponType.Molotov:
				// Draw Throwable Weapon Cursor Crosshair
				if (player_unit.unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.ThrowWindup)
				{
					// Calculate Expandable Crosshair Distance
					var temp_throw_crosshair_distance = (player_unit.thrown_weapon_aim_transition_value * player_unit.thrown_weapon_aim_transition_value * player_unit.thrown_weapon_aim_transition_value * 12) + 4;
					
					// Draw Throwable Weapon Active Aiming Expandable "Iron Cross Type" Crosshair
					draw_sprite_ext(sUI_CursorCrosshairIcons, 3, cursor_x - temp_throw_crosshair_distance, cursor_y - temp_throw_crosshair_distance, 1, 1, 180, c_white, 1);
					draw_sprite_ext(sUI_CursorCrosshairIcons, 3, cursor_x + temp_throw_crosshair_distance, cursor_y - temp_throw_crosshair_distance, 1, 1, 90, c_white, 1);
					draw_sprite_ext(sUI_CursorCrosshairIcons, 3, cursor_x - temp_throw_crosshair_distance, cursor_y + temp_throw_crosshair_distance, 1, 1, 270, c_white, 1);
					draw_sprite_ext(sUI_CursorCrosshairIcons, 3, cursor_x + temp_throw_crosshair_distance, cursor_y + temp_throw_crosshair_distance, 1, 1, 0, c_white, 1);
				}
				else
				{
					// Draw Throwable Weapon Inactive Aiming "Dot Type" Crosshair
					draw_sprite(sUI_CursorCrosshairIcons, 2, cursor_x, cursor_y);
				}
				break;
			case WeaponType.Firearm:
			case WeaponType.BoltActionFirearm:
				// Draw Firearm Crosshair
				draw_sprite(sUI_CursorCrosshairIcons, 1, cursor_x, cursor_y);
				break;
		}
	}
	else
	{
		// Draw Interaction Cursor
		draw_sprite(sUI_CursorMenu, 0, cursor_x, cursor_y);
	}
}

// Reset Surface
surface_reset_target();
