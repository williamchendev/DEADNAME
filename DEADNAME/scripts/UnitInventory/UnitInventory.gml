// Unit Inventory Enums
enum UnitInventorySlotTier
{
	None,
	Light,
	Moderate,
	Hefty,
	Cumbersome
}

enum UnitInventorySlotRenderOrder
{
	None,
	Front,
	Back
}

// Unit Inventory UI Settings
global.unit_inventory_ui_vertical_offset = -54;
global.unit_inventory_ui_inspect_text_vertical_offset = 36;

global.unit_inventory_ui_inspect_text_font = font_Default;
global.unit_inventory_ui_item_counter_font = font_Inno;

global.unit_inventory_ui_contrast_color = merge_color(c_white, c_black, 0.7);
global.unit_inventory_ui_empty_alpha = 0.8;

global.unit_inventory_ui_slot_size = 36;
global.unit_inventory_ui_slot_padding = 10;
global.unit_inventory_ui_slot_tier_offset = 17;

// Unit Death & Inventory Destruction Event Item Drop Physics Settings
global.unit_destroy_inventory_item_drop_combat_impulse_mult = 0.7;

global.unit_destroy_inventory_item_drop_random_horizontal_power = 8;
global.unit_destroy_inventory_item_drop_random_vertical_power = 8;

// Unit Inventory Functions
/// unit_inventory_slot_tier_color(slot_tier);
/// @description This function returns the color corresponding to the given Inventory Item Slot's Tier
/// @param {number, UnitInventorySlotTier} slot_tier The given Inventory Item Slot's Tier to find the corresponding color of
/// @returns {Constant.Colour} Returns the color corresponding to the given Inventory Item Slot's Tier
function unit_inventory_slot_tier_color(slot_tier)
{
	// Establish Slot Tier Return Color - Default White
	var temp_tier_color = c_white;
	
	// Compare given Slot Tier argument
	switch (slot_tier)
	{
		case UnitInventorySlotTier.Light:
			// Light Slot Tier - Pastel Orange 
			temp_tier_color = make_color_rgb(252, 171, 85);
			temp_tier_color = make_color_rgb(255, 150, 79);
			break;
		case UnitInventorySlotTier.Moderate:
			// Moderate Slot Tier - Pastel Cerulean Blue
			temp_tier_color = make_color_rgb(85, 174, 252);
			break;
		case UnitInventorySlotTier.Hefty:
			// Hefty Slot Tier - Violet 
			temp_tier_color = make_color_rgb(166, 85, 252);
			temp_tier_color = make_color_rgb(107, 40, 179);
			temp_tier_color = make_color_rgb(181, 126, 220);
			break;
		case UnitInventorySlotTier.Cumbersome:
			// Cumbersome Slot Tier - Labor Red
			temp_tier_color = make_color_rgb(252, 85, 127);
			temp_tier_color = make_color_rgb(128, 14, 20);
			temp_tier_color = make_color_rgb(178, 17, 25);
			break;
		default:
			break;
	}
	
	// Return Slot Tier Color
	return temp_tier_color;
}

/// unit_inventory_render_ui(unit, alpha);
/// @description This function renders the Inventory UI of the given Unit Instance on to the LightingEngine's UI Surface with the given alpha transparency
/// @param {Id.Instance, oUnit} unit The given Unit Instance to render their Inventory UI
/// @param {real} alpha The transparency to draw the Inventory UI with
function unit_inventory_render_ui(unit, alpha)
{
	// Check if Unit Inventory Alpha Transparency is greater than 0
	if (alpha <= 0)
	{
		// Unit Inventory is fully Transparent - Redundant Render can be Skipped
		return;	
	}
	
	// Set Effect Surface Target and Clear Effect Surface
	surface_set_target(LightingEngine.fx_surface);
	draw_clear_alpha(c_white, 0);
	
	// Find Unit Inventory UI Render Position
	var temp_unit_inventory_ui_x = round(unit.x - LightingEngine.render_x);
	var temp_unit_inventory_ui_y = round(unit.y - ((unit.bbox_bottom - unit.bbox_top) * unit.draw_yscale) + global.unit_inventory_ui_vertical_offset - LightingEngine.render_y);
	
	// Set Text Font for Inventory Slot Item Counter
	draw_set_font(global.unit_inventory_ui_item_counter_font);
	
	// Set Text Alignment for Inventory Slot Item Counter
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	// Find Half Width of Cumulative Unit Inventory UI Slots
	var temp_unit_inventory_ui_width = ((global.unit_inventory_ui_slot_size * array_length(unit.inventory_slots)) + (global.unit_inventory_ui_slot_padding * (array_length(unit.inventory_slots) - 1))) * 0.5;
	
	// Iterate through Unit Inventory Slots
	for (var temp_unit_inventory_slot_index = 0; temp_unit_inventory_slot_index < array_length(unit.inventory_slots); temp_unit_inventory_slot_index++)
	{
		// Find Unit Inventory Slot Horizontal Position
		var temp_unit_slot_x = temp_unit_inventory_ui_x + (global.unit_inventory_ui_slot_size * 0.5) + (temp_unit_inventory_slot_index * (global.unit_inventory_ui_slot_size + global.unit_inventory_ui_slot_padding)) - temp_unit_inventory_ui_width;
		
		// Find Unit Inventory Slot Tier Image Index
		var temp_unit_slot_tier = unit.inventory_slots[temp_unit_inventory_slot_index].slot_tier - 1;
		
		// Draw Unit Inventory Slot Behaviour
		if (unit.inventory_index == temp_unit_inventory_slot_index)
		{
			// Unit Inventory Slot Selected Behaviour
			if (unit.inventory_slots[temp_unit_inventory_slot_index].item_pack != ItemPack.None)
			{
				// Draw Unit Inventory Slot Selected with Item
				draw_sprite_ext(sUI_Inventory_Slot_Background, 0, temp_unit_slot_x, temp_unit_inventory_ui_y, 1, 1, 0, unit.inventory_slots[temp_unit_inventory_slot_index].slot_tier_color, 1);
				
				// Draw Unit Inventory Slot Tier Icon (Top Left Corner)
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon_Shadow, temp_unit_slot_tier, temp_unit_slot_x - global.unit_inventory_ui_slot_tier_offset, temp_unit_inventory_ui_y - global.unit_inventory_ui_slot_tier_offset, 1, 1, 0, c_black, 1);
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon, temp_unit_slot_tier, temp_unit_slot_x - global.unit_inventory_ui_slot_tier_offset, temp_unit_inventory_ui_y - global.unit_inventory_ui_slot_tier_offset + 1, 1, 1, 0, global.unit_inventory_ui_contrast_color, 1);
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon, temp_unit_slot_tier, temp_unit_slot_x - global.unit_inventory_ui_slot_tier_offset + 1, temp_unit_inventory_ui_y - global.unit_inventory_ui_slot_tier_offset + 1, 1, 1, 0, global.unit_inventory_ui_contrast_color, 1);
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon, temp_unit_slot_tier, temp_unit_slot_x - global.unit_inventory_ui_slot_tier_offset, temp_unit_inventory_ui_y - global.unit_inventory_ui_slot_tier_offset, 1, 1, 0, c_white, 1);
			}
			else
			{
				// Draw Unit Inventory Slot Selected without Item
				draw_sprite_ext(sUI_Inventory_Slot_Background, 0, temp_unit_slot_x, temp_unit_inventory_ui_y, 1, 1, 0, c_white, 1);
				
				// Draw Unit Inventory Slot Tier Icon (Centered and Transparent)
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon, temp_unit_slot_tier, temp_unit_slot_x, temp_unit_inventory_ui_y + 1, 1, 1, 0, unit.inventory_slots[temp_unit_inventory_slot_index].slot_tier_contrast_color, 1);
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon, temp_unit_slot_tier, temp_unit_slot_x + 1, temp_unit_inventory_ui_y + 1, 1, 1, 0, unit.inventory_slots[temp_unit_inventory_slot_index].slot_tier_contrast_color, 1);
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon, temp_unit_slot_tier, temp_unit_slot_x, temp_unit_inventory_ui_y, 1, 1, 0, unit.inventory_slots[temp_unit_inventory_slot_index].slot_tier_color, 1);
			}
		}
		else
		{
			// Draw Unit Inventory Slot Background
			draw_sprite_ext(sUI_Inventory_Slot_Background, 0, temp_unit_slot_x, temp_unit_inventory_ui_y, 1, 1, 0, c_black, 1);
			
			// Unit Inventory Slot Unselected Behaviour
			if (unit.inventory_slots[temp_unit_inventory_slot_index].item_pack != ItemPack.None)
			{
				// Draw Unit Inventory Slot Tier Icon (Top Left Corner)
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon_Shadow, temp_unit_slot_tier, temp_unit_slot_x - global.unit_inventory_ui_slot_tier_offset, temp_unit_inventory_ui_y - global.unit_inventory_ui_slot_tier_offset, 1, 1, 0, c_black, 1);
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon, temp_unit_slot_tier, temp_unit_slot_x - global.unit_inventory_ui_slot_tier_offset, temp_unit_inventory_ui_y - global.unit_inventory_ui_slot_tier_offset + 1, 1, 1, 0, global.unit_inventory_ui_contrast_color, 1);
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon, temp_unit_slot_tier, temp_unit_slot_x - global.unit_inventory_ui_slot_tier_offset + 1, temp_unit_inventory_ui_y - global.unit_inventory_ui_slot_tier_offset + 1, 1, 1, 0, global.unit_inventory_ui_contrast_color, 1);
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon, temp_unit_slot_tier, temp_unit_slot_x - global.unit_inventory_ui_slot_tier_offset, temp_unit_inventory_ui_y - global.unit_inventory_ui_slot_tier_offset, 1, 1, 0, c_white, 1);
			}
			else
			{
				// Draw Unit Inventory Slot Tier Icon (Centered and Transparent)
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon, temp_unit_slot_tier, temp_unit_slot_x, temp_unit_inventory_ui_y + 1, 1, 1, 0, unit.inventory_slots[temp_unit_inventory_slot_index].slot_tier_contrast_color, global.unit_inventory_ui_empty_alpha);
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon, temp_unit_slot_tier, temp_unit_slot_x + 1, temp_unit_inventory_ui_y + 1, 1, 1, 0, unit.inventory_slots[temp_unit_inventory_slot_index].slot_tier_contrast_color, global.unit_inventory_ui_empty_alpha);
				draw_sprite_ext(sUI_Inventory_Slot_TierIcon, temp_unit_slot_tier, temp_unit_slot_x, temp_unit_inventory_ui_y, 1, 1, 0, unit.inventory_slots[temp_unit_inventory_slot_index].slot_tier_color, global.unit_inventory_ui_empty_alpha);
			}
		}
		
		// Unit Inventory Slot Item Portrait & Item Count
		if (unit.inventory_slots[temp_unit_inventory_slot_index].item_pack != ItemPack.None)
		{
			// Unit Inventory Slot Item Count
			if (global.item_packs[unit.inventory_slots[temp_unit_inventory_slot_index].item_pack].item_count_limit != -1)
			{
				draw_text_outline(temp_unit_slot_x + global.unit_inventory_ui_slot_tier_offset - 2, temp_unit_inventory_ui_y + global.unit_inventory_ui_slot_tier_offset - 8, $"{unit.inventory_slots[temp_unit_inventory_slot_index].item_count}");
			}
			
			// Establish Inventory Slot Portrait Image Index based on Inventory Slot's Item Count
			var temp_inventory_slot_portrait_image_index = unit.inventory_slots[temp_unit_inventory_slot_index].item_count - 1;
			
			// Draw Unit Inventory Slot Item Portrait Outline
			draw_sprite_ext(global.item_packs[unit.inventory_slots[temp_unit_inventory_slot_index].item_pack].item_sprite, temp_inventory_slot_portrait_image_index, temp_unit_slot_x - 1, temp_unit_inventory_ui_y, 1, 1, 0, c_black, 1);
			draw_sprite_ext(global.item_packs[unit.inventory_slots[temp_unit_inventory_slot_index].item_pack].item_sprite, temp_inventory_slot_portrait_image_index, temp_unit_slot_x, temp_unit_inventory_ui_y - 1, 1, 1, 0, c_black, 1);
			draw_sprite_ext(global.item_packs[unit.inventory_slots[temp_unit_inventory_slot_index].item_pack].item_sprite, temp_inventory_slot_portrait_image_index, temp_unit_slot_x + 1, temp_unit_inventory_ui_y, 1, 1, 0, c_black, 1);
			draw_sprite_ext(global.item_packs[unit.inventory_slots[temp_unit_inventory_slot_index].item_pack].item_sprite, temp_inventory_slot_portrait_image_index, temp_unit_slot_x, temp_unit_inventory_ui_y + 1, 1, 1, 0, c_black, 1);
			
			// Draw Unit Inventory Slot Item Portrait Sprite
			draw_sprite_ext(global.item_packs[unit.inventory_slots[temp_unit_inventory_slot_index].item_pack].item_sprite, temp_inventory_slot_portrait_image_index, temp_unit_slot_x, temp_unit_inventory_ui_y, 1, 1, 0, c_white, 1);
		}
	}
	
	// Draw Inventory Slot Inspection Text
	if (unit.inventory_index != -1)
	{
		// Set Text Font for Inventory Slot Item Inspect Text
		draw_set_font(global.unit_inventory_ui_inspect_text_font);
		
		// Set Text Alignment for Inventory Slot Item Inspect Text
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		
		// Establish Inventory Slot Item Inspect Text
		var temp_unit_inventory_slot_inspect_text = "";
		
		if (unit.inventory_slots[unit.inventory_index].item_pack != ItemPack.None)
		{
			// Use Item Name Title as Inspect Text
			temp_unit_inventory_slot_inspect_text = $"{global.item_packs[unit.inventory_slots[unit.inventory_index].item_pack].item_name}";
		}
		else
		{
			// Use Item Slot Title as Inspect Text
			temp_unit_inventory_slot_inspect_text = $"{unit.inventory_slots[unit.inventory_index].slot_name} [EMPTY]";
		}
		
		// Establish Inventory Slot Item Inspect Text's Width
		var temp_slot_inspect_text_width = (string_width(temp_unit_inventory_slot_inspect_text) * 0.5) + 4;
		
		// Draw Black Rectangle for contrast with Inventory Slot Item Inspect Text
		draw_set_color(c_black);
		
		draw_rectangle
		(
			temp_unit_inventory_ui_x - temp_slot_inspect_text_width, 
			temp_unit_inventory_ui_y + global.unit_inventory_ui_inspect_text_vertical_offset - 7, 
			temp_unit_inventory_ui_x + temp_slot_inspect_text_width,
			temp_unit_inventory_ui_y + global.unit_inventory_ui_inspect_text_vertical_offset + 9,
			false
		);
		
		// Draw Inventory Slot Item Inspect Text
		draw_set_color(unit.inventory_slots[unit.inventory_index].slot_tier_color);
		draw_text(temp_unit_inventory_ui_x, temp_unit_inventory_ui_y + global.unit_inventory_ui_inspect_text_vertical_offset, temp_unit_inventory_slot_inspect_text);
	}
	
	// Reset Surface Target
	surface_reset_target();
	
	// Set Surface Target to UI Surface
	surface_set_target(LightingEngine.ui_surface);
	
	// Draw Completed Unit Inventory UI from FX Surface to UI Surface with Transparency
	draw_surface_ext(LightingEngine.fx_surface, 0, 0, 1, 1, 0, c_white, alpha);
	
	// Reset Surface Target
	surface_reset_target();
}

/// unit_inventory_add_slot(unit, name, tier, horizontal_offset, vertical_offset, rotation, render_order);
/// @description Adds an Inventory Slot to the given Unit Instance with the given Inventory Slot Settings
/// @param {?Id.Instance, oUnit} unit The given Unit Instance to add an Item Slot to their Unit Item Inventory
/// @param {string} name The name of the new Inventory Item Slot being added to the Unit Instance
/// @param {number, UnitInventorySlotTier} tier The Inventory Slot Tier of the new Inventory Item Slot being added to the Unit Instance
/// @param {real} horizontal_offset The horizontal offset of the new Inventory Item Slot's relative position located on their Unit Instance
/// @param {real} vertical_offset The vertical offset of the new Inventory Item Slot's relative position located on their Unit Instance
/// @param {real} rotation The angle of the new Inventory Item Slot relative to the rotation of their Unit Instance
/// @param {number, UnitInventorySlotRenderOrder} render_order The Render Order of the new Inventory Item Slot: Front draws the Item in front of the Unit, Back draws the Item behind the Unit, None does not draw the Item when placed in the Inventory Item Slot
function unit_inventory_add_slot(unit, name, tier, horizontal_offset, vertical_offset, rotation, render_order)
{
	// Check if Unit Instance Exists
	if (!instance_exists(unit))
	{
		// Unit Instance is Invalid - Early Return
		return;
	}
	
	// Check if Slot Tier is Valid
	if (tier == UnitInventorySlotTier.None)
	{
		// Slot Tier is not Valid - Early Return
		return;
	}
	
	// Find the Index to insert or add the new Unit Inventory Slot into the Unit's Inventory Slot Array
	var temp_new_slot_index = -1;
	
	for (var i = 0; i < array_length(unit.inventory_slots); i++)
	{
		// Compare Inventory Slot tiers to organize Unit Inventory Slots by Tier
		if (tier > unit.inventory_slots[i].slot_tier)
		{
			temp_new_slot_index = i;
			break;
		}
	}
	
	// Create the new Unit Inventory Slot
	var temp_new_slot =
	{
		slot_name: name,
		
		slot_tier: tier,
		slot_tier_color: unit_inventory_slot_tier_color(tier),
		slot_tier_contrast_color: merge_color(unit_inventory_slot_tier_color(tier), c_black, 0.7),
		
		slot_render_order: tier != UnitInventorySlotTier.Light ? render_order : UnitInventorySlotRenderOrder.None,
		
		slot_unit_offset_x: horizontal_offset,
		slot_unit_offset_y: vertical_offset,
		
		slot_angle: rotation,
		
		slot_position_x: 0,
		slot_position_y: 0,
		
		item_pack: ItemType.None,
		item_count: -1,
		item_instance: noone
	};
	
	// Check to insert or add the new Slot to the Unit's Inventory Slot Array
	if (temp_new_slot_index == -1)
	{
		unit.inventory_slots[array_length(unit.inventory_slots)] = temp_new_slot;
	}
	else
	{
		array_insert(unit.inventory_slots, temp_new_slot_index, temp_new_slot);
	}
}

/// unit_inventory_remove_slot(unit, slot_tier);
/// @description Removes an Inventory Slot from the given Unit Instance that shares the same given Inventory Slot Tier (and additionally drops an item physics object instance of the given item if it existed in the Unit's Inventory Slot that was removed)
/// @param {?Id.Instance, oUnit} unit The given Unit Instance to remove an Item Slot from their Unit Inventory
/// @param {number, UnitInventorySlotTier} slot_tier The Inventory Slot Tier of the Inventory Item Slot to remove from the Unit's Inventory
function unit_inventory_remove_slot(unit, slot_tier)
{
	// Check if Unit Instance Exists
	if (!instance_exists(unit))
	{
		// Unit Instance is Invalid - Early Return
		return;
	}
	
	// Find the appropriate Unit Inventory Slot to remove based on the given Inventory Slot Tier
	var temp_remove_slot_index = -1;
	
	for (var i = array_length(unit.inventory_slots) - 1; i >= 0; i--)
	{
		if (slot_tier == unit.inventory_slots[i].slot_tier)
		{
			temp_remove_slot_index = i;
			break;
		}
	}
	
	// Delete the Inventory Slot from the Unit's Inventory Slot Array at the given Remove Slot Index
	if (temp_remove_slot_index != -1)
	{
		// Check if Item exists in Inventory Slot being deleted and drop Item if it exists
		if (global.item_packs[unit.inventory_slots[temp_remove_slot_index].item_pack].item_type != ItemType.None)
		{
			// Drop Inventory Item in Inventory Slot being deleted
			var temp_dropped_item = unit_inventory_drop_item_instance(unit, temp_remove_slot_index);
			
			// Apply Physics Forces to Dropped Inventory Item
			with (temp_dropped_item)
			{
				var temp_combat_impulse_horizontal_vector = unit.combat_attack_impulse_power * unit.combat_attack_impulse_horizontal_vector * global.unit_destroy_inventory_item_drop_combat_impulse_mult;
				var temp_combat_impulse_vertical_vector = unit.combat_attack_impulse_power * unit.combat_attack_impulse_vertical_vector * global.unit_destroy_inventory_item_drop_combat_impulse_mult;
				
				var temp_item_horizontal_drop_power = random_range(-global.unit_destroy_inventory_item_drop_random_horizontal_power, global.unit_destroy_inventory_item_drop_random_horizontal_power);
				var temp_item_vertical_drop_power = random_range(-global.unit_destroy_inventory_item_drop_random_vertical_power, global.unit_destroy_inventory_item_drop_random_vertical_power);
				physics_apply_impulse(x, y, temp_item_horizontal_drop_power + temp_combat_impulse_horizontal_vector, temp_item_vertical_drop_power + temp_combat_impulse_vertical_vector);
			}
		}
		
		// Delete Inventory Slot
		array_delete(unit.inventory_slots, temp_remove_slot_index, 1);
	}
}

/// unit_inventory_remove_all_slots(unit);
/// @description Removes all the Inventory Slots from the given Unit Instance's Inventory (and additionally drops the item physics object instances of the given items that exist in the Unit's Inventory Slots when they are removed)
/// @param {?Id.Instance, oUnit} unit The given Unit Instance to remove all Inventory Item Slots from their Unit Inventory
function unit_inventory_remove_all_slots(unit)
{
	// Check if Unit Instance Exists
	if (!instance_exists(unit))
	{
		// Unit Instance is Invalid - Early Return
		return;
	}
	
	// Iterate through all the Unit's Inventory Slots
	for (var i = array_length(unit.inventory_slots) - 1; i >= 0; i--)
	{
		// Check if the Unit's Inventory Item Slot contains an Item
		if (global.item_packs[unit.inventory_slots[i].item_pack].item_type != ItemType.None)
		{
			// Drop Inventory Item in Inventory Slot being deleted
			var temp_dropped_item = unit_inventory_drop_item_instance(unit, i);
			
			// Apply Physics Forces to Dropped Inventory Item
			with (temp_dropped_item)
			{
				var temp_combat_impulse_horizontal_vector = unit.combat_attack_impulse_power * unit.combat_attack_impulse_horizontal_vector * global.unit_destroy_inventory_item_drop_combat_impulse_mult;
				var temp_combat_impulse_vertical_vector = unit.combat_attack_impulse_power * unit.combat_attack_impulse_vertical_vector * global.unit_destroy_inventory_item_drop_combat_impulse_mult;
				
				var temp_item_horizontal_drop_power = random_range(-global.unit_destroy_inventory_item_drop_random_horizontal_power, global.unit_destroy_inventory_item_drop_random_horizontal_power);
				var temp_item_vertical_drop_power = random_range(-global.unit_destroy_inventory_item_drop_random_vertical_power, global.unit_destroy_inventory_item_drop_random_vertical_power);
				physics_apply_impulse(x, y, temp_item_horizontal_drop_power + temp_combat_impulse_horizontal_vector, temp_item_vertical_drop_power + temp_combat_impulse_vertical_vector);
			}
		}
	}
	
	// Clear and Destroy all Unit's Inventory Slots
	array_clear(unit.inventory_slots);
}

/// unit_inventory_add_item(unit, item_pack, item_count);
/// @description Adds an Item to the given Unit Instance's Inventory with the given Item Pack and the number of the item to add
/// @param {?Id.Instance, oUnit} unit The given Unit Instance to add the Item to their Unit Inventory
/// @param {number, ItemPack} item_pack The Item Pack of the Item to add to the Unit's Inventory
/// @param {number} item_count The number of the given Item to be added to the Unit's Inventory (if this number is negative, it adds the Item Pack's Full Stack Count multiplied by the absolute value of the given Item Count to add to the Inventory)
/// @returns {number} Returns the Inventory Slot Index of the Item added to the Unit's Inventory
function unit_inventory_add_item(unit, item_pack, item_count = 1)
{
	// Check if Unit Instance Exists
	if (!instance_exists(unit))
	{
		// Unit Instance is Invalid - Early Return
		return -1;
	}
	
	// Check if Item Instance's Item Pack is a valid Item Pack Index
	if (item_pack < 0 or item_pack == ItemPack.None)
	{
		// Item Pack is an invalid Item Pack Index - Early Return
		return -1;
	}
	
	// Check if the Item Count is Zero
	if (item_count == 0)
	{
		// Cannot add Zero Count of an Item to the Unit's Inventory
		return -1;
	}
	
	// Check if Item Count is Negative - A Negative Item Count is the Count of Full Item Stacks to add to the Inventory
	item_count = item_count < 0 ? abs(item_count) * global.item_packs[item_pack].item_count_limit : item_count;
	
	// Place Item in Unit Inventory Behaviour
	var temp_inventory_index = -1;
	var temp_item_placed_count = 0;
	
	while (temp_item_placed_count < item_count)
	{
		// Establish Slot Index to check for Valid Inventory Slot Placement
		var temp_slot_index = -1;
		
		// Iterate through Unit Inventory Slots for Valid Inventory Slot to place Item
		for (var i = array_length(unit.inventory_slots) - 1; i >= 0; i--)
		{
			// Check if Inventory Slot contains an Item already
			if (unit.inventory_slots[i].item_pack >= 0 and unit.inventory_slots[i].item_pack != ItemType.None)
			{
				// Check if Inventory Slot can stack multiple instances of the given Item to place in the Unit Inventory
				if (unit.inventory_slots[i].item_pack == item_pack)
				{
					// Check if given Item is Stackable
					if (global.item_packs[item_pack].item_count_limit > 1 and unit.inventory_slots[i].item_count < global.item_packs[item_pack].item_count_limit)
					{
						// Inventory Slot can contain multiples of the given Stackable Item - Item can be placed in Inventory Slot 
						temp_slot_index = i;
						break;
					}
				}
				
				// Inventory Slot is already filled - Skip adding Item to this Inventory Slot
				continue;
			}
			
			// Check if empty Inventory Slot has the correct tier to house Inventory Item
			if (unit.inventory_slots[i].slot_tier >= global.item_packs[item_pack].item_slot_tier)
			{
				// Compare stored Inventory Slot tier to prioritize placing the given Item into the lowest possible tier to save Inventory Space
				if (temp_slot_index == -1 or (unit.inventory_slots[i].slot_tier <= unit.inventory_slots[temp_slot_index].slot_tier and i < temp_slot_index))
				{
					// Item can be placed in Inventory Slot
					temp_slot_index = i;
				}
			}
		}
		
		// Check if Valid Inventory Slot found
		if (temp_slot_index == -1)
		{
			// No valid inventory slot - break from Inventory Item Placement Loop
			break;
		}
		else
		{
			// Store Inventory Slot Placement to return placed item's Inventory Slot Index
			temp_inventory_index = temp_slot_index;
		}
		
		// Place a single instance of the given Item
		unit.inventory_slots[temp_slot_index].item_pack = item_pack;
		unit.inventory_slots[temp_slot_index].item_count = unit.inventory_slots[temp_slot_index].item_count < 1 ? 1 : unit.inventory_slots[temp_slot_index].item_count + 1;
		
		// Item's Placement Behaviour
		if (unit.inventory_slots[temp_slot_index].item_instance == noone)
		{
			// Instantiate the placed item's Item Class Instance
			unit.inventory_slots[temp_slot_index].item_instance = create_item_class_instance_from_item_pack(item_pack);
			
			// Initialize the placed item's physics properties with its given Item Class Instance
			unit.inventory_slots[temp_slot_index].item_instance.init_item_physics(unit.inventory_slots[temp_slot_index].slot_position_x, unit.inventory_slots[temp_slot_index].slot_position_y);
			
			// Check if Unit should perform unequip/equip behaviour if the placed item's item slot is the same as the Unit Instance's currently selected item slot
			if (unit.inventory_index == temp_slot_index)
			{
				// Reset Unit's Equipment State
				unit_inventory_change_slot(unit, unit.inventory_index);
			}
		}
		
		// Increment Count of Items Placed in Unit Inventory
		temp_item_placed_count++;
	}
	
	// Show Unit Inventory UI if the Unit Inventory belongs to the Player's Unit
	if (unit.player_input and temp_slot_index != -1 and !instance_exists(LightingEngine.lighting_engine_worker))
	{
		unit.player_inventory_ui_alpha = 1;
		unit.player_inventory_ui_fade_timer = unit.player_inventory_ui_fade_delay;
	}
	
	// Return the Inventory Slot Index in the Player's Inventory the Item was placed in
	return temp_inventory_index;
}

/// unit_inventory_check_item(unit, item_pack, item_count);
/// @description Checks if an Item exists within the given Unit Instance's Inventory (and optionally checks if the Unit Instance's Inventory contains a quantity of the given Item to search for)
/// @param {?Id.Instance, oUnit} unit The given Unit Instance to search for the Item within their Unit Inventory
/// @param {number, ItemPack} item_pack The Item Pack of the Item to search for in the Unit's Inventory
/// @param {number} item_count The number of the given Item to check if the Unit's Inventory contains (by default this is 1)
/// @returns {Bool} Returns true or false if the given Item (and optionally also the given quantity) exists inside the Unit's Inventory
function unit_inventory_check_item(unit, item_pack, item_count = 1)
{
	// Check if Unit Instance Exists
	if (!instance_exists(unit))
	{
		// Unit Instance is Invalid - Early Return
		return false;
	}
	
	// Check if Item Instance's Item Pack is a valid Item Pack Index
	if (item_pack < 0 or item_pack == ItemPack.None)
	{
		// Item Pack is an invalid Item Pack Index - Early Return
		return false;
	}
	
	// Establish Item Count
	var temp_item_count = 0;
	
	// Iterate through Unit Inventory Slots to search for the given Inventory Item
	for (var i = 0; i < array_length(unit.inventory_slots); i++)
	{
		// Check if Inventory Slot contains the given Item
		if (unit.inventory_slots[i].item_pack == item_pack)
		{
			// Add Inventory Slot's number of the given item
			temp_item_count += unit.inventory_slots[i].item_count;
		}
	}
	
	// Return true if the item exists in the Inventory (and if there is a quantity more or equal than the given item count)
	return temp_item_count >= item_count;
}

/// unit_inventory_remove_item(unit, item_pack, item_count);
/// @description Removes the given Item within the given Unit Instance's Inventory (and optionally removes a quantity of the given Item)
/// @param {?Id.Instance, oUnit} unit The given Unit Instance to remove the Item within their Unit Inventory
/// @param {number, ItemPack} item_pack The Item Pack of the Item to remove from the Unit's Inventory
/// @param {number} item_count The number of the given Item to remove from the Unit's Inventory (by default this is 1)
function unit_inventory_remove_item(unit, item_pack, item_count = 1)
{
	// Check if Unit Instance Exists
	if (!instance_exists(unit))
	{
		// Unit Instance is Invalid - Early Return
		return;
	}
	
	// Check if Item Instance's Item Pack is a valid Item Pack Index
	if (item_pack < 0 or item_pack == ItemPack.None)
	{
		// Item Pack is an invalid Item Pack Index - Early Return
		return;
	}
	
	// Establish Item Remove Count
	var temp_item_remove_count = max(item_count, 0);
	
	// Check if Item Remove Count is Valid
	if (temp_item_remove_count == 0)
	{
		// Remove zero items from your inventory? You are crazy lmao - Early Return
		return;
	}
	
	// Iterate through Unit Inventory Slots to search for the Valid Inventory Item to remove
	for (var i = 0; i < array_length(unit.inventory_slots); i++)
	{
		// Check if Inventory Slot contains an Item already
		if (unit.inventory_slots[i].item_pack == item_pack)
		{
			// Check the quantity to remove from the item slot
			var temp_remove_quantity = min(unit.inventory_slots[i].item_count, temp_item_remove_count);
			
			// Decrement Inventory Slot's Item Count & Item's Remove Count
			unit.inventory_slots[i].item_count -= temp_remove_quantity;
			temp_item_remove_count -= temp_remove_quantity;
			
			// Check Inventory Slot's Item Count
			if (unit.inventory_slots[i].item_count <= 0)
			{
				// Inventory Slot is storing single Item - Remove Item from Inventory Slot
				unit.inventory_slots[i].item_pack = ItemPack.None;
				unit.inventory_slots[i].item_count = -1;
				
				// Unequip Item Behaviour
				if (unit.equipment_active and unit.inventory_index == i)
				{
					unit.inventory_slots[i].item_instance.unequip_item();
				}
				
				// Check if Item has an Item Class Instance to delete
				if (unit.inventory_slots[i].item_instance != noone)
				{
					// Delete Item Class Instance
					DELETE(unit.inventory_slots[i].item_instance);
					
					// Set Item Instance to empty "noone" null reference
					unit.inventory_slots[i].item_instance = noone;
				}
				
				// Reset Unit's Equipment State
				if (unit.inventory_index == i)
				{
					unit_inventory_change_slot(unit, i);
				}
			}
		}
		
		// Check if Finished Removing Items from Inventory
		if (temp_item_remove_count == 0)
		{
			// The sufficent quantity of the given item to remove from the Inventory has been removed - Early Return
			return;
		}
	}
}

/// unit_inventory_take_item_instance(unit, item_instance);
/// @description Adds an Item to a Unit's Inventory, intended to be used for Item Objects that exist in the active Scene
/// @param {?Id.Instance, oUnit} unit The given Unit Instance to add the Item to their Unit Inventory
/// @param {?Id.Instance, oLighting_Dynamic_Item} item_instance The given Item Instance to add to the Unit's Inventory
/// @returns {number} Returns the inventory slot index of the Item placed within the Unit's Inventory (and returns -1 if the Item was unable to be placed within the Unit's Inventory)
function unit_inventory_take_item_instance(unit, item_instance)
{
	// Check if Unit Instance and Item Instance Exist
	if (!instance_exists(item_instance) or !instance_exists(unit))
	{
		// Unit Instance or Item Instance is Invalid - Early Return
		return -1;
	}
	
	// Check if Item Instance's Item Pack is a valid Item Pack Index
	if (item_instance.item_pack == -1 or item_instance.item_pack == ItemPack.None)
	{
		// Item Instance's Item Pack is an invalid Item Pack Index - Destroy Invalid Item Instance and Early Return
		instance_destroy(item_instance);
		return -1;
	}
	
	// Place Item in Unit Inventory Behaviour
	var temp_inventory_index = -1;
	var temp_item_placed_count = 0;
	
	while (temp_item_placed_count < item_instance.item_count)
	{
		// Establish Slot Index to check for Valid Inventory Slot Placement
		var temp_slot_index = -1;
		
		// Iterate through Unit Inventory Slots for Valid Inventory Slot to place Item
		for (var i = array_length(unit.inventory_slots) - 1; i >= 0; i--)
		{
			// Check if Inventory Slot contains an Item already
			if (unit.inventory_slots[i].item_pack >= 0 and unit.inventory_slots[i].item_pack != ItemType.None)
			{
				// Check if Inventory Slot can stack multiple instances of the given Item to place in the Unit Inventory
				if (unit.inventory_slots[i].item_pack == item_instance.item_pack)
				{
					// Check if given Item is Stackable
					if (global.item_packs[item_instance.item_pack].item_count_limit > 1 and unit.inventory_slots[i].item_count < global.item_packs[item_instance.item_pack].item_count_limit)
					{
						// Inventory Slot can contain multiples of the given Stackable Item - Item can be placed in Inventory Slot 
						temp_slot_index = i;
						break;
					}
				}
				
				// Inventory Slot is already filled - Skip adding Item to this Inventory Slot
				continue;
			}
			
			// Check if empty Inventory Slot has the correct tier to house Inventory Item
			if (unit.inventory_slots[i].slot_tier >= global.item_packs[item_instance.item_pack].item_slot_tier)
			{
				// Compare stored Inventory Slot tier to prioritize placing the given Item into the lowest possible tier to save Inventory Space
				if (temp_slot_index == -1 or (unit.inventory_slots[i].slot_tier <= unit.inventory_slots[temp_slot_index].slot_tier and i < temp_slot_index))
				{
					// Item can be placed in Inventory Slot
					temp_slot_index = i;
				}
			}
		}
		
		// Check if Valid Inventory Slot found
		if (temp_slot_index == -1)
		{
			// No valid inventory slot - break from Inventory Item Placement Loop
			break;
		}
		else
		{
			// Store Inventory Slot Placement to return placed item's Inventory Slot Index
			temp_inventory_index = temp_slot_index;
		}
		
		// Place a single instance of the given Item
		unit.inventory_slots[temp_slot_index].item_pack = item_instance.item_pack;
		unit.inventory_slots[temp_slot_index].item_count = unit.inventory_slots[temp_slot_index].item_count < 1 ? 1 : unit.inventory_slots[temp_slot_index].item_count + 1;
		
		// Item's Placement Behaviour
		if (unit.inventory_slots[temp_slot_index].item_instance == noone)
		{
			// Check if the Item's Class Instance already exists
			if (item_instance.item_instance == noone)
			{
				// Creates a new Item Class Instance for the placed Item and initializes its Item Physics
				unit.inventory_slots[temp_slot_index].item_instance = create_item_class_instance_from_item_pack(item_instance.item_pack);
				unit.inventory_slots[temp_slot_index].item_instance.init_item_physics(unit.inventory_slots[temp_slot_index].slot_position_x, unit.inventory_slots[temp_slot_index].slot_position_y);
			}
			else
			{
				// Places the Item Class Instance that belonged to the picked up Item in the Unit's Inventory
				unit.inventory_slots[temp_slot_index].item_instance = item_instance.item_instance;
				item_instance.item_instance.item_angle = sign(item_instance.item_instance.item_facing_sign) != sign(unit.draw_xscale) ? item_instance.image_angle + 180 : item_instance.image_angle;
				
				// Remove the Item Class Instance reference from the picked up Item so it does not get deleted when the Item Object is destroyed
				item_instance.item_instance = noone;
			}
			
			// Check if Unit should perform unequip/equip behaviour if the placed item's item slot is the same as the Unit Instance's currently selected item slot
			if (unit.inventory_index == temp_slot_index)
			{
				// Reset Unit's Equipment State
				unit_inventory_change_slot(unit, unit.inventory_index);
			}
		}
		else
		{
			// Restore Item Properties to Unit Inventory's Item Slot's Item Instance
			switch (global.item_packs[item_instance.item_pack].weapon_data.weapon_type)
			{
				case WeaponType.Thrown:
				case WeaponType.Grenade:
				case WeaponType.Molotov:
					// Thrown Weapon Safety Properties Update Behaviour
					unit.inventory_slots[temp_slot_index].item_instance.thrown_weapon_safety_active = unit.inventory_slots[temp_slot_index].item_instance.thrown_weapon_safety_active and item_instance.item_instance.thrown_weapon_safety_active;
					
					// Thrown Weapon Fuze Properties Update Behaviour
					if (!is_undefined(global.item_packs[item_instance.item_pack].weapon_data.thrown_weapon_fuze_timer))
					{
						// Establish Thrown Weapon Fuze Timer Values for both the Unit's Inventory Item Slot Item Instance and Item Pickup Instance
						var temp_unit_inventory_thrown_weapon_fuze_timer = unit.inventory_slots[temp_slot_index].item_instance.thrown_weapon_fuze_timer;
						var temp_item_pickup_thrown_weapon_fuze_timer = item_instance.item_instance.thrown_weapon_fuze_timer;
						
						// Compare Thrown Weapon Fuze Timer Values and Select the Lowest and Viable Fuze Timer
						if (!is_undefined(temp_unit_inventory_thrown_weapon_fuze_timer) and !is_undefined(temp_item_pickup_thrown_weapon_fuze_timer))
						{
							unit.inventory_slots[temp_slot_index].item_instance.thrown_weapon_fuze_timer = temp_unit_inventory_thrown_weapon_fuze_timer < temp_item_pickup_thrown_weapon_fuze_timer ? temp_unit_inventory_thrown_weapon_fuze_timer : temp_item_pickup_thrown_weapon_fuze_timer;
						}
						else if (!is_undefined(temp_unit_inventory_thrown_weapon_fuze_timer))
						{
							unit.inventory_slots[temp_slot_index].item_instance.thrown_weapon_fuze_timer = temp_unit_inventory_thrown_weapon_fuze_timer;
						}
						else if (!is_undefined(temp_item_pickup_thrown_weapon_fuze_timer))
						{
							unit.inventory_slots[temp_slot_index].item_instance.thrown_weapon_fuze_timer = temp_item_pickup_thrown_weapon_fuze_timer;
						}
						else
						{
							unit.inventory_slots[temp_slot_index].item_instance.thrown_weapon_fuze_timer = undefined;
						}
					}
					break;
				default:
					break;
			}
		}
		
		// Increment Count of Items Placed in Unit Inventory
		temp_item_placed_count++;
	}
	
	// Check if enough Items have been placed to delete Item Instance
	if (temp_item_placed_count == item_instance.item_count)
	{
		// Successfully placed all of the Item Instance's Item Count in the Unit Inventory - Destroy Item Instance
		instance_destroy(item_instance);
	}
	else
	{
		// Item Instance still has a remaining Item Count - Subtract Item Instance's Item Count by the number of Items placed in Unit Inventory
		item_instance.item_count -= temp_item_placed_count;
	}
	
	// Show Unit Inventory UI if the Unit Inventory belongs to the Player's Unit
	if (unit.player_input and temp_slot_index != -1)
	{
		unit.player_inventory_ui_alpha = 1;
		unit.player_inventory_ui_fade_timer = unit.player_inventory_ui_fade_delay;
	}
	
	// Return the Inventory Slot Index in the Player's Inventory the Item was placed in
	return temp_inventory_index;
}

/// unit_inventory_drop_item_instance(unit, slot_index, drop_item_count);
/// @description Drops a physical Item Instance from the given Inventory Slot within the given Unit Instance's Inventory (and optionally removes a quantity of the given Item to drop)
/// @param {?Id.Instance, oUnit} unit The given Unit Instance to drop an Item from their Unit Inventory
/// @param {number} slot_index The Inventory slot index of the Item to drop from the Unit's Inventory
/// @param {number} drop_item_count The number of the given Item to drop from the Unit's Inventory (by default this is 1)
/// @returns {?Id.Instance, oLighting_Dynamic_Item} Returns the Item Instance created of the dropped item (and returns noone if dropping an item for the given Unit and its Inventory Slot Index was an invalid action)
function unit_inventory_drop_item_instance(unit, slot_index, drop_item_count = -1)
{
	// Check if Unit Exists
	if (!instance_exists(unit))
	{
		// Unit does not exist - Cannot drop an item from an invalid Unit
		return noone;
	}
	
	// Check if Inventory Slot Index is Valid
	if (slot_index <= -1 or slot_index >= array_length(unit.inventory_slots))
	{
		// Inventory Slot Index does not exist
		return noone;
	}
	
	// Check if Drop Item Count is a valid number of items to drop
	if (drop_item_count == 0)
	{
		// Drop Item Count cannot be zero, you cannot drop "0" items - Early Return
		return noone;
	}
	
	// Establish Blank Dropped Item Object Instance
	var temp_dropped_item_instance = noone;
	
	// Calculate Dropped Item Count
	drop_item_count = drop_item_count <= -1 ? unit.inventory_slots[slot_index].item_count : clamp(drop_item_count, 0, unit.inventory_slots[slot_index].item_count);
	
	// Dropped Item Object Instance Instantiation Behaviour
	switch (global.item_packs[unit.inventory_slots[slot_index].item_pack].item_type)
	{
		case ItemType.Default:
			// Establish Dropped Default Item Instance's Struct
			var temp_dropped_item_var_struct = 
			{ 
				sub_layer_index: lighting_engine_find_object_index(unit) + 1,
				item_pack: unit.inventory_slots[slot_index].item_pack,
				item_count: 1,
				image_angle: unit.inventory_slots[slot_index].item_instance.item_angle,
				image_yscale: unit.inventory_slots[slot_index].item_instance.item_facing_sign
			};
			
			// Create Dropped Default Item Instance
			temp_dropped_item_instance = instance_create_depth(unit.inventory_slots[slot_index].item_instance.item_x, unit.inventory_slots[slot_index].item_instance.item_y, 0, global.item_packs[unit.inventory_slots[slot_index].item_pack].item_object, temp_dropped_item_var_struct);
			
			// Set Dropped Item Instance's Settings
			with (temp_dropped_item_instance)
			{
				if (unit.inventory_slots[slot_index].item_count - drop_item_count > 0)
				{
					// Instantiate New Weapon Instance
					item_instance = create_item_class_instance_from_item_pack(unit.inventory_slots[slot_index].item_pack);
					item_instance.init_item_physics(x, y, image_angle);
				}
				else
				{
					// Unequip Weapon if Item's Weapon Instance is Equipped
					if (unit.equipment_active and unit.inventory_index == slot_index)
					{
						unit.inventory_slots[unit.inventory_index].item_instance.unequip_item();
					}
					
					// Establish Weapon Instance's Physical Transform Properties
					item_instance = unit.inventory_slots[slot_index].item_instance;
					
					// Update Dropped Item's Physics
					item_instance.update_item_physics(x, y, image_angle, item_instance.item_facing_sign);
					
					// Remove reference to the Item's Class Instance from the Unit's Inventory
					unit.inventory_slots[slot_index].item_instance = noone;
				}
				
				// Set Dropped Item's Physics Object Rotation
				phy_rotation = -image_angle;
			}
			break;
		case ItemType.Weapon:
			// Create Dropped Item Object
			var temp_dropped_item_weapon_instance = noone;
			
			// Establish Dropped Weapon Position, Rotation, and Scale
			var temp_dropped_item_weapon_position_x = unit.inventory_slots[slot_index].slot_position_x;
			var temp_dropped_item_weapon_position_y = unit.inventory_slots[slot_index].slot_position_y;
			
			var temp_dropped_item_weapon_angle = 0;
			
			var temp_dropped_item_weapon_xscale = 1;
			var temp_dropped_item_weapon_yscale = sign(unit.draw_xscale) != 0 ? sign(unit.draw_xscale) : 1;
			
			// Check if Inventory Slot contains Weapon Instance
			if (unit.inventory_slots[slot_index].item_count - drop_item_count > 0)
			{
				// Instantiate New Weapon Instance
				temp_dropped_item_weapon_instance = create_item_class_instance_from_item_pack(unit.inventory_slots[slot_index].item_pack);
				temp_dropped_item_weapon_instance.init_item_physics(temp_dropped_item_weapon_position_x, temp_dropped_item_weapon_position_y, 0);
			}
			else
			{
				// Unequip Weapon if Item's Weapon Instance is Equipped
				if (unit.equipment_active and unit.inventory_index == slot_index)
				{
					unit.inventory_slots[unit.inventory_index].item_instance.unequip_item();
				}
				
				// Set Dropped Weapon's Item Class Instance from the Unit's Inventory
				temp_dropped_item_weapon_instance = unit.inventory_slots[slot_index].item_instance;
				
				// Remove reference to the Item's Class Instance from the Unit's Inventory
				unit.inventory_slots[slot_index].item_instance = noone;
				
				// Establish Weapon Instance's Physical Transform Properties
				temp_dropped_item_weapon_angle = temp_dropped_item_weapon_instance.item_angle + (temp_dropped_item_weapon_instance.weapon_angle_recoil * temp_dropped_item_weapon_instance.item_facing_sign);
				temp_dropped_item_weapon_position_x = temp_dropped_item_weapon_instance.item_x;
				temp_dropped_item_weapon_position_y = temp_dropped_item_weapon_instance.item_y;
				
				temp_dropped_item_weapon_yscale = temp_dropped_item_weapon_instance.item_yscale * temp_dropped_item_weapon_instance.item_facing_sign;
			}
			
			// Update Dropped Weapon Physical Properties based on Weapon Type Behaviour
			switch (global.item_packs[unit.inventory_slots[slot_index].item_pack].weapon_data.weapon_type)
			{
				case WeaponType.Thrown:
				case WeaponType.Grenade:
				case WeaponType.Molotov:
					// Dropped Thrown Weapon Behaviour
					if (unit.equipment_active and unit.inventory_index == slot_index)
					{
						// Check if Unit's Primary Hand is Holding Thrown Weapon
						if (ds_list_size(unit.limb_primary_arm.limb_held_item_pack_list) > 0)
						{
							// Set Thrown Weapon Dropped Item Position from Primary Hand Position
							temp_dropped_item_weapon_position_x = unit.limb_primary_arm.limb_held_item_x;
							temp_dropped_item_weapon_position_y = unit.limb_primary_arm.limb_held_item_y;
							
							// Set Thrown Weapon Dropped Item Angle from Primary Hand Angle
							temp_dropped_item_weapon_angle = unit.limb_primary_arm.limb_pivot_b_angle + (unit.limb_primary_arm.limb_xscale < 0 ? 180 : 0);
							
							// Set Thrown Weapon Dropped Item Scale from Primary Hand Direction
							temp_dropped_item_weapon_xscale = unit.limb_primary_arm.limb_xscale;
							temp_dropped_item_weapon_yscale = 1;
							
							// Reset Unit Held Item Animation Behaviour
							unit.limb_primary_arm.remove_all_held_items();
							unit.limb_secondary_arm.remove_all_held_items();
							
							// Reset Unit Thrown Weapon Animation Behaviour
							unit.unit_thrown_weapon_animation_state = UnitThrownWeaponAnimationState.GrabWeapon;
							
							unit.thrown_weapon_aim_transition_value = 0;
							unit.thrown_weapon_operate_action_transition_value = 0
							unit.thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value = 1;
							
							unit.thrown_weapon_direction = sign(unit.draw_xscale);
							unit.thrown_weapon_angle = unit.thrown_weapon_direction >= 0 ? 1 : 179;
							
							// Update Dropped Thrown Weapon Instance's Properties with Unit's Held Item Properties
							temp_dropped_item_weapon_instance.item_x = temp_dropped_item_weapon_position_x;
							temp_dropped_item_weapon_instance.item_y = temp_dropped_item_weapon_position_y;
							
							temp_dropped_item_weapon_instance.item_angle = temp_dropped_item_weapon_angle;
							
							temp_dropped_item_weapon_instance.item_facing_sign = 1;
							
							temp_dropped_item_weapon_instance.item_xscale = temp_dropped_item_weapon_xscale;
							temp_dropped_item_weapon_instance.item_yscale = temp_dropped_item_weapon_yscale;
						}
					}
					
					// Update Dropped Thrown Weapon Safety Properties
					if (unit.inventory_slots[slot_index].item_instance != noone)
					{
						temp_dropped_item_weapon_instance.thrown_weapon_safety_active = unit.inventory_slots[slot_index].item_instance.thrown_weapon_safety_active;
						unit.inventory_slots[slot_index].item_instance.thrown_weapon_safety_active = true;
					}
					
					// Update Dropped Thrown Weapon Instance's Fuze Timer
					if (!is_undefined(global.item_packs[unit.inventory_slots[slot_index].item_pack].weapon_data.thrown_weapon_fuze_timer))
					{
						// Check if Instantiated New Weapon Instance
						if (unit.inventory_slots[slot_index].item_instance != noone and !is_undefined(unit.inventory_slots[slot_index].item_instance.thrown_weapon_fuze_timer))
						{
							// Set Dropped Thrown Weapon Item's Fuze Timer
							temp_dropped_item_weapon_instance.thrown_weapon_fuze_timer = unit.inventory_slots[slot_index].item_instance.thrown_weapon_fuze_timer;
							
							// Reset Unit Instance's Thrown Weapon Fuze Timer
							unit.inventory_slots[slot_index].item_instance.thrown_weapon_fuze_timer = undefined;
						}
					}
					break;
				default:
					break;
			}
			
			// Establish Dropped Weapon Item Instance's Struct
			var temp_dropped_item_weapon_var_struct = 
			{ 
				sub_layer_index: lighting_engine_find_object_index(unit) + 1,
				item_pack: unit.inventory_slots[slot_index].item_pack,
				item_count: 1,
				image_angle: temp_dropped_item_weapon_angle,
				image_xscale: temp_dropped_item_weapon_xscale,
				image_yscale: temp_dropped_item_weapon_yscale
			};
			
			// Create Dropped Item Instance
			temp_dropped_item_instance = instance_create_depth(temp_dropped_item_weapon_position_x, temp_dropped_item_weapon_position_y, 0, global.item_packs[unit.inventory_slots[slot_index].item_pack].item_object, temp_dropped_item_weapon_var_struct);
			
			// Set Dropped Item Instance's Settings
			with (temp_dropped_item_instance)
			{
				// Set Dropped Item's Instance
				item_instance = temp_dropped_item_weapon_instance;
				
				// Set Dropped Item's Sprite & Image Index
				sprite_index = item_instance.item_sprite;
				image_index = item_instance.item_image_index;
				
				// Set Dropped Item's Physics Object Rotation
				phy_rotation = -temp_dropped_item_weapon_angle;
				
				// Set Dropped Item's Lighting Engine Render Settings
				normalmap_spritepack = item_instance.item_normalmap_spritepack != undefined ? item_instance.item_normalmap_spritepack[item_instance.item_image_index].texture : undefined;
				metallicroughnessmap_spritepack = item_instance.item_metallicroughnessmap_spritepack != undefined ? item_instance.item_metallicroughnessmap_spritepack[item_instance.item_image_index].texture : undefined;
				emissivemap_spritepack = item_instance.item_emissivemap_spritepack != undefined ? item_instance.item_emissivemap_spritepack[item_instance.item_image_index].texture : undefined;
				normalmap_spritepack = item_instance.item_normalmap_spritepack != undefined ? item_instance.item_normalmap_spritepack[item_instance.item_image_index].uvs : undefined;
				metallicroughnessmap_spritepack = item_instance.item_metallicroughnessmap_spritepack != undefined ? item_instance.item_metallicroughnessmap_spritepack[item_instance.item_image_index].uvs : undefined;
				emissivemap_spritepack = item_instance.item_emissivemap_spritepack != undefined ? item_instance.item_emissivemap_spritepack[item_instance.item_image_index].uvs : undefined;
				normal_strength = item_instance.item_normal_strength;
				metallic = item_instance.item_metallic;
				roughness = item_instance.item_roughness;
				emissive = item_instance.item_emissive;
				emissive_multiplier = item_instance.item_emissive_multiplier;
				
				// Set Dropped Item's Color and Transparency
				image_blend = c_white;
				image_alpha = 1;
				
				// Set Dropped Item Not-Visible
				visible = false;
				
				// Update Dropped Item's Physics
				item_instance.update_item_physics(x, y, image_angle, item_instance.item_facing_sign);
				
				// Update Weapon Behaviour after Dropped Weapon Item Instance has been Created
				switch (global.item_packs[unit.inventory_slots[slot_index].item_pack].weapon_data.weapon_type)
				{
					case WeaponType.Thrown:
					case WeaponType.Grenade:
					case WeaponType.Molotov:
						// Set Dropped Thrown Weapon Item's Thrown Weapon Fuze Timer if dropped by a Player Controlled Unit Instance
						if (instance_exists(unit) and unit.player_input and !is_undefined(item_instance.thrown_weapon_fuze_timer))
						{
							visible = true;
							show_ui_fuze_timer = true;
						}
						break;
					default:
						break;
				}
			}
			break;
		case ItemType.None:
		default:
			// Item is Invalid - Impossible to create Dropped Item Instance
			return noone;
	}
	
	// Decrement Inventory Slot's Item Count
	unit.inventory_slots[slot_index].item_count -= drop_item_count;
	
	// Check Inventory Slot's Item Count
	if (unit.inventory_slots[slot_index].item_count <= 0)
	{
		// Inventory Slot is storing single Item - Remove Item from Inventory Slot
		unit.inventory_slots[slot_index].item_pack = ItemPack.None;
		unit.inventory_slots[slot_index].item_count = -1;
		
		// Check if Item has an Item Class Instance to delete
		if (unit.inventory_slots[slot_index].item_instance != noone)
		{
			// Delete Item Class Instance
			DELETE(unit.inventory_slots[slot_index].item_instance);
			
			// Set Item Instance to empty "noone" null reference
			unit.inventory_slots[slot_index].item_instance = noone;
		}
		
		// Reset Unit's Equipment State
		unit_inventory_change_slot(unit, slot_index);
	}
	
	// Apply Dropped Item Instance's Settings & Behaviours
	if (instance_exists(temp_dropped_item_instance))
	{
		// Apply Unit Physics Forces to Dropped Object
		temp_dropped_item_instance.phy_position_x += unit.x_velocity;
		temp_dropped_item_instance.phy_position_y += unit.y_velocity;
		
		// Set Dropped Item Instance's Item Count
		temp_dropped_item_instance.item_count = drop_item_count;
	}
	
	// Return Dropped Item Instance
	return temp_dropped_item_instance;
}

/// unit_inventory_change_slot(unit, slot_index);
/// @description Performs the unequip and equip behaviour of the given Unit switching their selected Inventory Slot Index to the one given
/// @param {?Id.Instance, oUnit} unit The given Unit Instance to change their selected Inventory Slot Index
/// @param {number} slot_index The Inventory Slot Index to switch the Unit's Inventory Slot Index to
function unit_inventory_change_slot(unit, slot_index)
{
	// Check if Unit Exists
	if (!instance_exists(unit))
	{
		// Unit does not exist - Early Return
		return;
	}
	
	// Unit Inventory Slot Unequip Behaviour
	if (unit.inventory_index == slot_index)
	{
		if (unit.inventory_index != -1 and unit.inventory_slots[unit.inventory_index].item_instance == unit.item_equipped)
		{
			// Item is already Equipped
			return;
		}
	}
	else if (unit.inventory_index != -1 and unit.inventory_slots[unit.inventory_index].item_pack != ItemPack.None)
	{
		switch (global.item_packs[unit.inventory_slots[unit.inventory_index].item_pack].item_type)
		{
			default:
				// Default Item Unequip Behaviour
				unit.inventory_slots[unit.inventory_index].item_instance.unequip_item();
				break;
			case ItemType.None:
				// Item is Empty or Invalid
				break;
		}
	}
	
	// Unit Inventory Slot Equip Behaviour
	switch (slot_index == -1 ? ItemPack.None : global.item_packs[unit.inventory_slots[slot_index].item_pack].item_type)
	{
		case ItemType.None:
			// Item is Empty or Invalid
			unit.unit_equipment_animation_state = UnitEquipmentAnimationState.None;
			break;
		default:
			// Default Unit Item Equip Behaviour
			if (unit.inventory_slots[slot_index].item_instance.item_physics_exist)
			{
				// Establish Item Instance's Position and Rotation Variables
				var temp_item_x = unit.inventory_slots[slot_index].item_instance.item_x;
				var temp_item_y = unit.inventory_slots[slot_index].item_instance.item_y;
				var temp_item_angle = unit.inventory_slots[slot_index].item_instance.item_angle;
				
				// Perform Item Instance's Unit Equip Behaviour
				unit.inventory_slots[slot_index].item_instance.equip_item(unit);
				
				// Set Item Instance's Position and Rotation to match Item Instance
				unit.inventory_slots[slot_index].item_instance.item_x = temp_item_x;
				unit.inventory_slots[slot_index].item_instance.item_y = temp_item_y;
				unit.inventory_slots[slot_index].item_instance.item_angle = temp_item_angle;
			}
			else
			{
				// Perform Item Instance's Unit Equip Behaviour
				unit.inventory_slots[slot_index].item_instance.equip_item(unit);
			}
			break;
	}
	
	// Set the Unit's new Inventory Slot Index
	unit.inventory_index = slot_index;
}
