//
enum UnitInventorySlotTier
{
	None,
	Light,
	Moderate,
	Hefty,
	Cumbersome
}

//
function unit_inventory_slot_tier_color(slot_tier)
{
	//
	var temp_tier_color = c_white;
	
	//
	switch (slot_tier)
	{
		case UnitInventorySlotTier.Light:
			temp_tier_color = make_color_rgb(252, 171, 85);
			break;
		case UnitInventorySlotTier.Moderate:
			temp_tier_color = make_color_rgb(85, 174, 252);
			break;
		case UnitInventorySlotTier.Hefty:
			temp_tier_color = make_color_rgb(166, 85, 252);
			break;
		case UnitInventorySlotTier.Cumbersome:
			temp_tier_color = make_color_rgb(252, 85, 127);
			break;
		default:
			break;
	}
	
	//
	return temp_tier_color;
}

function unit_inventory_slot_tier_name(slot_tier)
{
	//
	var temp_tier_name = "none";
	
	//
	switch (slot_tier)
	{
		case UnitInventorySlotTier.Light:
			temp_tier_name = "Pocket";
			break;
		case UnitInventorySlotTier.Moderate:
			temp_tier_name = "none";
			break;
		case UnitInventorySlotTier.Hefty:
			temp_tier_name = "none";
			break;
		default:
			break;
	}
	
	//
	return temp_tier_name;
}

//
function unit_inventory_init(unit, cumbersome_slots_count, hefty_slots_count, moderate_slots_count, light_slots_count)
{
	// Create Unit's Light Item Slots
	for (var temp_light_slots_index = 0; temp_light_slots_index < light_slots_count; temp_light_slots_index++)
	{
		unit_inventory_add_slot(unit, UnitInventorySlotTier.Light, "Moralist Infantry's Chest Pocket");
	}
	
	// Create Unit's Moderate Item Slots
	for (var temp_moderate_slots_index = 0; temp_moderate_slots_index < moderate_slots_count; temp_moderate_slots_index++)
	{
		unit_inventory_add_slot(unit, UnitInventorySlotTier.Moderate, "Moralist Infantry's Belt Box");
	}
	
	// Create Unit's Hefty Item Slots
	for (var temp_hefty_slots_index = 0; temp_hefty_slots_index < hefty_slots_count; temp_hefty_slots_index++)
	{
		unit_inventory_add_slot(unit, UnitInventorySlotTier.Hefty, "Moralist Infantry's Backpack");
	}
	
	// Create Unit's Cumbersome Item Slots
	for (var temp_cumbersome_slots_index = 0; temp_cumbersome_slots_index < cumbersome_slots_count; temp_cumbersome_slots_index++)
	{
		unit_inventory_add_slot(unit, UnitInventorySlotTier.Cumbersome, "Willpower and Mental Fortitude");
	}
}

function unit_inventory_add_slot(unit, slot_tier, slot_name)
{
	// Create the new Unit Inventory Slot
	var temp_new_slot =
	{
		tier: slot_tier,
		tier_color: unit_inventory_slot_tier_color(slot_tier),
		tier_contrast_color: merge_color(unit_inventory_slot_tier_color(slot_tier), c_black, 0.7),
		
		name: slot_name,
		
		item_pack: InventoryItemType.None,
		item_count: -1,
		item_instance: noone
	};
	
	// Find the Index to insert or add the new Unit Inventory Slot into the Unit's Inventory Slot Array
	var temp_new_slot_index = -1;
	
	for (var i = 0; i < array_length(unit.inventory_slots); i++)
	{
		// Compare Inventory Slot tiers to organize Unit Inventory Slots by Tier
		if (slot_tier > unit.inventory_slots[i].tier)
		{
			temp_new_slot_index = i;
			break;
		}
	}
	
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

function unit_inventory_remove_slot(unit, slot_tier)
{
	// Find the appropriate Unit Inventory Slot to remove based on the given Inventory Slot Tier
	var temp_remove_slot_index = -1;
	
	for (var i = array_length(unit.inventory_slots) - 1; i >= 0; i--)
	{
		if (slot_tier == unit.inventory_slots[i].tier)
		{
			temp_remove_slot_index = i;
			break;
		}
	}
	
	// Delete the Inventory Slot from the Unit's Inventory Slot Array at the given Remove Slot Index
	if (temp_remove_slot_index != -1)
	{
		array_delete(unit.inventory_slots, temp_remove_slot_index, 1);
	}
}

function unit_inventory_remove_all_slots(unit)
{
	//
	array_clear(unit.inventory_slots);
}

function unit_inventory_add_item()
{
	
}

function unit_inventory_take_item_instance(unit, item_instance)
{
	//
	if (!instance_exists(item_instance) or !instance_exists(unit))
	{
		//
		return false;
	}
	
	//
	if (item_instance.item_pack == -1 or item_instance.item_pack == InventoryItemPack.None)
	{
		//
		instance_destroy(item_instance);
		return false;
	}
	
	//
	var temp_slot_index = -1;
	
	for (var i = array_length(unit.inventory_slots) - 1; i >= 0; i--)
	{
		//
		if (unit.inventory_slots[i].item_pack != InventoryItemType.None)
		{
			//
			continue;
		}
		
		// Compare Inventory Slot tiers to organize Unit Inventory Slots by Tier
		if (unit.inventory_slots[i].tier >= global.inventory_item_packs[item_instance.item_pack].item_slot_tier)
		{
			//
			if (temp_slot_index == -1 or (unit.inventory_slots[i].tier <= unit.inventory_slots[temp_slot_index].tier and i < temp_slot_index))
			{
				//
				temp_slot_index = i;
			}
		}
	}
	
	//
	if (temp_slot_index == -1)
	{
		//
		return false;
	}
	
	//
	switch (global.inventory_item_packs[item_instance.item_pack].item_type)
	{
		case InventoryItemType.Default:
			//
			break;
		case InventoryItemType.Weapon:
			//
			unit.inventory_slots[temp_slot_index].item_instance = item_instance.weapon_instance;
			break;
		case InventoryItemType.None:
		default:
			//
			return false;
	}
	
	//
	unit.inventory_slots[temp_slot_index].item_pack = item_instance.item_pack;
	unit.inventory_slots[temp_slot_index].item_count = 1;
	
	//
	instance_destroy(item_instance);
	
	//
	return true;
}

function unit_inventory_drop_item_instance(unit, slot_index)
{
	//
	if (!instance_exists(unit))
	{
		return;
	}
	
	//
	if (slot_index <= -1 or slot_index >= array_length(unit.inventory_slots))
	{
		return;
	}
	
	//
	var temp_dropped_item_instance = noone;
	
	//
	switch (unit.inventory_slots[slot_index].item_pack)
	{
		case InventoryItemType.Default:
			//
			var temp_dropped_item_var_struct = 
			{ 
				sub_layer_index: lighting_engine_find_object_index(weapon_unit),
				item_pack: unit.inventory_slots[slot_index].item_pack
			};
			
			//
			temp_dropped_item_instance = instance_create_depth(unit.x + unit.backpack_position_x, unit.y + unit.backpack_position_y, 0, oItem_Default, temp_dropped_item_var_struct);
			break;
		case InventoryItemType.Weapon:
			//
			var temp_dropped_item_weapon_instance = noone;
			
			var temp_dropped_item_weapon_angle = 0;
			var temp_dropped_item_weapon_position_x = unit.x + unit.backpack_position_x;
			var temp_dropped_item_weapon_position_y = unit.y + unit.backpack_position_y;
			
			var temp_dropped_item_weapon_yscale = sign(unit.draw_xscale) != 0 ? sign(unit.draw_xscale) : 1;
			
			//
			if (instance_exists(unit.inventory_slots[slot_index].item_instance))
			{
				//
				temp_dropped_item_weapon_instance = unit.inventory_slots[slot_index].item_instance;
				
				temp_dropped_item_weapon_angle = unit.inventory_slots[slot_index].item_instance.weapon_angle + (unit.inventory_slots[slot_index].item_instance.weapon_angle_recoil * unit.inventory_slots[slot_index].item_instance.weapon_facing_sign);
				temp_dropped_item_weapon_position_x = unit.inventory_slots[slot_index].item_instance.weapon_x;
				temp_dropped_item_weapon_position_y = unit.inventory_slots[slot_index].item_instance.weapon_y;
				
				temp_dropped_item_weapon_yscale = unit.inventory_slots[slot_index].item_instance.weapon_yscale * unit.inventory_slots[slot_index].item_instance.weapon_facing_sign;
			}
			else
			{
				//
				temp_dropped_item_weapon_instance = create_weapon_from_weapon_pack(global.inventory_item_packs[unit.inventory_slots[slot_index].item_pack].weapon_pack);
				temp_dropped_item_weapon_instance.init_weapon_physics(temp_dropped_item_weapon_position_x, temp_dropped_item_weapon_position_y, 0);
			}
			
			//
			var temp_dropped_item_weapon_var_struct = 
			{ 
				image_angle: temp_dropped_item_weapon_angle,
				image_yscale: temp_dropped_item_weapon_yscale,
				sub_layer_index: lighting_engine_find_object_index(weapon_unit) + 1,
				item_pack: unit.inventory_slots[slot_index].item_pack,
			};
			
			//
			temp_dropped_item_instance = instance_create_depth(temp_dropped_item_weapon_position_x, temp_dropped_item_weapon_position_y, 0, global.inventory_item_packs[unit.inventory_slots[slot_index].item_pack].item_object, temp_dropped_item_weapon_var_struct);
			
			//
			with (temp_dropped_item_instance)
			{
				//
				weapon_instance = temp_dropped_item_weapon_instance;
				
				//
				sprite_index = weapon_instance.weapon_sprite;
				image_index = weapon_instance.weapon_image_index;
				
				//
				normalmap_spritepack = weapon_instance.weapon_normalmap_spritepack != undefined ? weapon_instance.weapon_normalmap_spritepack[weapon_instance.weapon_image_index].texture : undefined;
				metallicroughnessmap_spritepack = weapon_instance.weapon_metallicroughnessmap_spritepack != undefined ? weapon_instance.weapon_metallicroughnessmap_spritepack[weapon_instance.weapon_image_index].texture : undefined;
				emissivemap_spritepack = weapon_instance.weapon_emissivemap_spritepack != undefined ? weapon_instance.weapon_emissivemap_spritepack[weapon_instance.weapon_image_index].texture : undefined;
				normalmap_spritepack = weapon_instance.weapon_normalmap_spritepack != undefined ? weapon_instance.weapon_normalmap_spritepack[weapon_instance.weapon_image_index].uvs : undefined;
				metallicroughnessmap_spritepack = weapon_instance.weapon_metallicroughnessmap_spritepack != undefined ? weapon_instance.weapon_metallicroughnessmap_spritepack[weapon_instance.weapon_image_index].uvs : undefined;
				emissivemap_spritepack = weapon_instance.weapon_emissivemap_spritepack != undefined ? weapon_instance.weapon_emissivemap_spritepack[weapon_instance.weapon_image_index].uvs : undefined;
				normal_strength = weapon_instance.weapon_normal_strength;
				metallic = weapon_instance.weapon_metallic;
				roughness = weapon_instance.weapon_roughness;
				emissive = weapon_instance.weapon_emissive;
				emissive_multiplier = weapon_instance.weapon_emissive_multiplier;
				
				//
				image_blend = c_white;
				image_alpha = 1;
				
				//
				weapon_instance.update_weapon_behaviour();
				weapon_instance.update_weapon_physics(x, y, image_angle, weapon_instance.weapon_facing_sign);
			}
			break;
		case InventoryItemType.None:
		default:
			// Item is Invalid - Impossible to create Dropped Item Instance
			break;
	}
	
	//
	unit.inventory_slots[slot_index].item_pack = InventoryItemType.None;
	unit.inventory_slots[slot_index].item_count = -1;
	unit.inventory_slots[slot_index].item_instance = noone;
	
	//
	return temp_dropped_item_instance;
}

function unit_inventory_swap_item_instance()
{
	
}

function unit_inventory_change_slot()
{
	
}
