//
enum ItemPack
{
	None,
	CorsoRifle,
	OilerSMG,
	Ammo
}

enum ItemType
{
	None,
	Default,
	Weapon
}

enum ItemHand
{
	Primary,
	Secondary,
	Both
}

//
function instance_create_item(item_pack, item_x, item_y, item_count = -1)
{
	// Check if Item Pack is valid
	if (item_pack == -1 or item_pack == ItemPack.None)
	{
		// Item Pack is invalid - Return Empty Instance
		return noone;
	}
	
	// Create Item Object Instance
	var temp_inventory_item_var_struct = { item_pack: item_pack, item_count: item_count <= 0 ? 1 : clamp(item_count, 1, global.item_packs[item_pack].item_count_limit) };
	var temp_inventory_item_object = instance_create_depth(item_x, item_y, 0, global.item_packs[item_pack].item_object, temp_inventory_item_var_struct);
	
	// Perform Item Object Instantiation Behaviour based on Item's Type
	switch (global.item_packs[item_pack].item_type)
	{
		case ItemType.Default:
			// Default Item Instance Instantiation
			break;
		case ItemType.Weapon:
			// Weapon Item Instance Instantiation
			var temp_item_weapon_rotation_angle = random(360);
			
			// Establish Physics Settings for Weapon Item Instance
			temp_inventory_item_object.phy_rotation = -temp_item_weapon_rotation_angle;
			temp_inventory_item_object.image_angle = temp_item_weapon_rotation_angle;
			temp_inventory_item_object.image_yscale = random(1.0) > 0.5 ? 1 : -1;
			
			// Create new Weapon Instance to pair with the Item Instance
			temp_inventory_item_object.weapon_instance = create_weapon_from_weapon_pack(global.item_packs[item_pack].weapon_pack);
			temp_inventory_item_object.weapon_instance.init_weapon_physics(item_x, item_y, temp_item_weapon_rotation_angle);
			temp_inventory_item_object.weapon_instance.weapon_facing_sign = temp_inventory_item_object.image_yscale;
			break;
		case ItemType.None:
		default:
			// Invalid Item Instance Instantiation
			break;
	}
	
	// Return Item Object Instance
	return temp_inventory_item_object;
}

// 
global.item_packs[ItemPack.None] = 
{
	item_name: "Empty",
	item_description: "",
	item_dialogue: "",
	item_sprite: -1,
	item_type: ItemType.None,
	item_hand: ItemHand.Both,
	item_slot_tier: UnitInventorySlotTier.None,
	item_object: noone,
	item_count_limit: -1,
};

// 
global.item_packs[ItemPack.CorsoRifle] =
{
	item_name: "\"Corso\" Bolt-Action Rifle",
	item_description: "",
	item_dialogue: [ "It'll be poetic that this Tyrant's Rifle", "will end the cruelty that rules our world." ],
	item_sprite: sItem_CorsoRifle,
	item_type: ItemType.Weapon,
	item_hand: ItemHand.Both,
	item_slot_tier: UnitInventorySlotTier.Hefty,
	item_object: oItem_Weapon_CorsoRifle,
	item_count_limit: -1,
	
	weapon_pack: WeaponPack.Corso
};

// 
global.item_packs[ItemPack.OilerSMG] =
{
	item_name: "Oiler Sub-Machine Gun",
	item_description: "",
	item_dialogue: "",
	item_sprite: sItem_CorsoRifle,
	item_type: ItemType.Weapon,
	item_hand: ItemHand.Both,
	item_slot_tier: UnitInventorySlotTier.Hefty,
	item_object: noone,
	item_count_limit: -1,
	
	weapon_pack: WeaponPack.SMG
};

//
global.item_packs[ItemPack.Ammo] =
{
	item_name: "7.62 ARKOVIAN",
	item_description: "",
	item_dialogue: "",
	item_sprite: sItem_Ammo,
	item_type: ItemType.Default,
	item_hand: ItemHand.Primary,
	item_slot_tier: UnitInventorySlotTier.Light,
	item_object: oItem_ArkovianRifleAmmo,
	item_count_limit: 3,
	
	item_horizontal_offset: 4,
	item_vertical_offset: 0,
	
	item_primary_hand_horizontal_offset: 0,
	item_primary_hand_vertical_offset: 0,
	
	item_secondary_hand_horizontal_offset: 0,
	item_secondary_hand_vertical_offset: 0,
};
