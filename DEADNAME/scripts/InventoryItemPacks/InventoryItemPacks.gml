//
enum InventoryItemPack
{
	None,
	CorsoRifle,
	OilerSMG,
	Ammo
}

enum InventoryItemType
{
	None,
	Default,
	Weapon
}

//
function create_inventory_item_object(item_pack, item_x, item_y)
{
	//
	if (item_pack == -1 or item_pack == InventoryItemPack.None)
	{
		//
		return noone;
	}
	
	//
	var temp_inventory_item_var_struct = { item_pack: item_pack };
	var temp_inventory_item_object = instance_create_depth(item_x, item_y, 0, global.inventory_item_packs[item_pack].item_object, temp_inventory_item_var_struct);
	
	//
	switch (global.inventory_item_packs[item_pack].item_type)
	{
		case InventoryItemType.Default:
			//
			break;
		case InventoryItemType.Weapon:
			//
			var temp_item_weapon_rotation_angle = random(360);
			temp_inventory_item_object.phy_rotation = temp_item_weapon_rotation_angle;
			temp_inventory_item_object.image_angle = temp_item_weapon_rotation_angle;
			temp_inventory_item_object.image_yscale = random(1.0) > 0.5 ? 1 : -1;
			
			//
			temp_inventory_item_object.weapon_instance = create_weapon_from_weapon_pack(global.inventory_item_packs[item_pack].weapon_pack);
			temp_inventory_item_object.weapon_instance.init_weapon_physics(item_x, item_y, temp_item_weapon_rotation_angle);
			temp_inventory_item_object.weapon_instance.weapon_facing_sign = temp_inventory_item_object.image_yscale;
			break;
		case InventoryItemType.None:
		default:
			//
			break;
	}
	
	//
	return temp_inventory_item_object;
}

// 
global.inventory_item_packs[InventoryItemPack.None] = 
{
	item_name: "Empty",
	item_description: "",
	item_dialogue: "",
	item_sprite: sItem_CorsoRifle,
	item_type: InventoryItemType.None,
	item_slot_tier: UnitInventorySlotTier.None,
	item_object: noone,
	item_count_limit: -1,
};

// 
global.inventory_item_packs[InventoryItemPack.CorsoRifle] =
{
	item_name: "Corso Rifle",
	item_description: "",
	item_dialogue: [ "It'll be poetic that this Tyrant's Rifle", "will end the cruelty that rules our world." ],
	item_sprite: sItem_CorsoRifle,
	item_type: InventoryItemType.Weapon,
	item_slot_tier: UnitInventorySlotTier.Hefty,
	item_object: oItem_Weapon_CorsoRifle,
	item_count_limit: -1,
	
	weapon_pack: WeaponPack.Corso
};

// 
global.inventory_item_packs[InventoryItemPack.OilerSMG] =
{
	item_name: "Oiler Sub-Machine Gun",
	item_description: "",
	item_dialogue: "",
	item_sprite: sItem_CorsoRifle,
	item_type: InventoryItemType.Weapon,
	item_slot_tier: UnitInventorySlotTier.Hefty,
	item_object: noone,
	item_count_limit: -1,
	
	weapon_pack: WeaponPack.SMG
};

//
global.inventory_item_packs[InventoryItemPack.Ammo] =
{
	item_name: "7.62 ARKOVIAN",
	item_description: "",
	item_dialogue: "",
	item_sprite: sItem_Ammo,
	item_type: InventoryItemType.Default,
	item_slot_tier: UnitInventorySlotTier.Light,
	item_object: noone,
	item_count_limit: 3
};
