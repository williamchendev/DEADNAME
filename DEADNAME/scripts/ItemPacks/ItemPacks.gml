// Item Pack Enums
enum ItemPack
{
	None,
	CorsoRifle,
	OilerSMG,
	BoxRevolver,
	Ammo,
	StickGrenade,
	Molotov
}

// Item Trait Enums
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

// Weapon Trait Enums
enum WeaponType
{
    Default,
    Melee,
    Thrown,
    Grenade,
    Molotov,
    Firearm,
    BoltActionFirearm
}

// Create Item Functions
/// create_item_class_instance_from_item_pack(item_pack);
/// @description Creates the corresponding ItemClass from the given Item Pack enum
/// @param {number, ItemPack} item_pack The Item Pack enum to create an ItemClass from 
/// @returns {?ItemClass, ?Struct} returns an ItemClass Instance with the given Item Pack's Settings, and noone if the Item Pack is invalid or empty
function create_item_class_instance_from_item_pack(item_pack) 
{
	// Establish Return Item Class
    var temp_item_class = noone;
    
    // Compare the Item Pack's Item Type
    if (global.item_packs[item_pack].item_type == ItemType.Weapon)
    {
    	// Weapon Item Class Creation
    	switch (global.item_packs[item_pack].weapon_data.weapon_type)
		{
			case WeaponType.Thrown:
			case WeaponType.Grenade:
			case WeaponType.Molotov:
				// Thrown Weapon Item Class
				temp_item_class = NEW(ThrownClass);
				break;
			case WeaponType.Firearm:
			case WeaponType.BoltActionFirearm:
				// Firearm Item Class
				temp_item_class = NEW(FirearmClass);
				break;
			default:
				// Default Weapon Item Class
				temp_item_class = NEW(WeaponClass);
				break;
		}
    }
    else if (global.item_packs[item_pack].item_type == ItemType.Default)
    {
    	// Default Item Class Creation
    	temp_item_class = NEW(ItemClass);
    }
    else
    {
    	// Item Type is Invalid - Early Return
    	return noone;
    }
	
	// Initialize Item Class with Item Pack settings
	temp_item_class.init_item_pack(item_pack);
	
	// Return Item Class
	return temp_item_class;
}

/// instance_create_item(item_pack, item_x, item_y, item_count);
/// @description Instantiates an Item Object within the active Scene at the given coordinates with the given Item Pack and number of Items
/// @param {number, ItemPack} item_pack The Item Pack enum to create an Item Object Instance from
/// @param {real} item_x The horizontal position to instantiate the new Item Object Instance at
/// @param {real} item_y The vertical position to instantiate the new Item Object Instance at
/// @param {int} item_count The number of the given Item's stack to create within the new Item Object Instance
/// @returns {?Id.Instance, oLighting_Dynamic_Item} returns an Item Object Instance with the given Item Pack's Settings, and noone if the Item Pack is invalid or empty
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
		case ItemType.Weapon:
			// Item Instance Instantiation
			var temp_item_rotation_angle = random(360);
			
			// Establish Physics Settings for Item Instance
			temp_inventory_item_object.phy_rotation = -temp_item_rotation_angle;
			temp_inventory_item_object.image_angle = temp_item_rotation_angle;
			temp_inventory_item_object.image_yscale = random(1.0) > 0.5 ? 1 : -1;
			
			// Create new Item Instance to pair with the Item Object
			temp_inventory_item_object.item_instance = create_item_class_instance_from_item_pack(item_pack);
			temp_inventory_item_object.item_instance.init_item_physics(item_x, item_y, temp_item_rotation_angle);
			temp_inventory_item_object.item_instance.item_facing_sign = temp_inventory_item_object.image_yscale;
			break;
		case ItemType.None:
		default:
			// Invalid Item Instance Instantiation
			break;
	}
	
	// Return Item Object Instance
	return temp_inventory_item_object;
}

// Empty Item Pack
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
	// Item Data
	item_name: "\"Cane Knife\" Bolt-Action Rifle",
	item_description: "",
	item_dialogue: [ "The Gun has gold print that says:", "\"Liberté ou la Mort\"" ],
	item_sprite: sItem_CorsoRifle,
	item_type: ItemType.Weapon,
	item_hand: ItemHand.Both,
	item_slot_tier: UnitInventorySlotTier.Hefty,
	item_object: oItem_Weapon_CorsoRifle,
	item_count_limit: -1,
	
    // Render Data
    render_data:
    {
		// Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
		render_sprite: sArkov_CorsoRifle,
		render_normalmap: sArkov_CorsoRifle_NormalMap,
		render_metallicroughnessmap: sArkov_CorsoRifle_MetallicRoughnessMap,
		render_emissivemap: noone,
		
		// PBR Settings
		normal_strength: 0.9,
		metallic: false,
		roughness: 0.2,
		emissive: 0,
    },
    
    // Weapon Data
    weapon_data:
    {
		// Weapon Type
		weapon_type: WeaponType.BoltActionFirearm,
		
		// Weapon Ammo
		firearm_ammo_item_pack: ItemPack.Ammo,
		firearm_ammo_max_capacity: 5,
		
		firearm_ammo_eject_case_after_firing: false,
		
		firearm_ammo_random_eject_horizontal_force_min: -2,
		firearm_ammo_random_eject_horizontal_force_max: -1,
		
		firearm_ammo_random_eject_vertical_force_min: -2,
		firearm_ammo_random_eject_vertical_force_max: -1,
		
		firearm_ammo_eject_rotation_force: 2,
		
		// Weapon Properties
		firearm_attack_delay: 14,
		firearm_attack_distance: 1200,
		firearm_attack_hit_percentage: 0.5,
		
		firearm_attack_damage: 3,
		firearm_attack_luck_damage: 0.7,
		
		firearm_attack_impulse_power: 50,
		
		// Weapon Reload
		firearm_reload_with_secondary_hand: false,
		
		firearm_reload_spin: false,
		firearm_reload_spin_spd: -5,
		
		firearm_reload_magazine: false,
		
		firearm_reload_individual_rounds: true,
		
		// Weapon FX
		firearm_muzzle_smoke_object: oFirearm_MuzzleSmoke_Medium,
		firearm_muzzle_smoke_min: 4,
		firearm_muzzle_smoke_max: 6,
		
		firearm_muzzle_flare_object: oFirearm_MuzzleFlare_Medium,
		
		firearm_smoke_trail_object: oFirearm_SmokeTrail_Medium,
		
		// Weapon Safety Angles
		firearm_idle_safety_angle: -15,
		firearm_moving_safety_angle: -45,
		firearm_reload_safety_angle: 15,
		
		// Weapon Recoil
		firearm_recoil_recovery_delay: 9,
		
		firearm_random_recoil_horizontal_min: -4.5,
		firearm_random_recoil_horizontal_max: -3,
		firearm_total_recoil_horizontal: 4.5,
		
		firearm_random_recoil_vertical_min: -0.2,
		firearm_random_recoil_vertical_max: -0.05,
		firearm_total_recoil_vertical: 3,
		
		firearm_random_recoil_angle_min: 2,
		firearm_random_recoil_angle_max: 3,
		firearm_total_recoil_angle: 13,
		
		// Weapon Position Offset
		weapon_position_horizontal_offset: 0,
		weapon_position_vertical_offset: 0,
		
		// Weapon Bolt Operation
		firearm_bolt_handle_position_x: 3,
		firearm_bolt_handle_position_y: 2,
		
		firearm_bolt_handle_charge_offset_x: -6,
		firearm_bolt_handle_charge_offset_y: -2,
		
		// Weapon Hand Positions
		weapon_hand_position_primary_x: 4,
		weapon_hand_position_primary_y: 3,
		
		weapon_hand_position_offhand_x: 17,
		weapon_hand_position_offhand_y: 2,
		
		// Weapon Reload Positions
		firearm_reload_x: 6,
		firearm_reload_y: -1,
		
		firearm_reload_offset_x: 0,
		firearm_reload_offset_y: -7,
		
		// Weapon Muzzle Positions
		firearm_muzzle_x: 29,
		firearm_muzzle_y: -1,
    },
    
    // Held Item Data (Weapon Reload Held Item)
	held_item_data:
	{
		// Held Item Object
		held_item_object: oFirearm_ShellCasing,
		
		// Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
		render_sprite: sBulletCase_Medium,
		render_normalmap: noone,
		render_metallicroughnessmap: noone,
		render_emissivemap: noone,
		
		// Weapon PBR Settings
		normal_strength: 1,
		metallic: false,
		roughness: 0.15,
		emissive: 0.1,
	},
};

// 
global.item_packs[ItemPack.OilerSMG] =
{
	// Item Data
	item_name: "Oiler Sub-Machine Gun",
	item_description: "",
	item_dialogue: "",
	item_sprite: sItem_CorsoRifle,
	item_type: ItemType.Weapon,
	item_hand: ItemHand.Both,
	item_slot_tier: UnitInventorySlotTier.Hefty,
	item_object: oItem_Weapon_OilerSubmachineGun,
	item_count_limit: -1,
	
	// Render Data
	render_data:
	{
		// Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
		render_sprite: sBlackMarket_OilerSubmachineGun,
		render_normalmap: sBlackMarket_OilerSubmachineGun_NormalMap,
		render_metallicroughnessmap: noone,
		render_emissivemap: noone,
		
		// Weapon PBR Settings
		normal_strength: 1,
		metallic: false,
		roughness: 0.2,
		emissive: 0,
	},
	
	// Weapon Data
    weapon_data:
    {
		// Weapon Type
		weapon_type: WeaponType.Firearm,
		
		// Weapon Ammo
		firearm_ammo_item_pack: ItemPack.Ammo,
		firearm_ammo_max_capacity: 16,
		
		firearm_ammo_eject_case_after_firing: true,
		
		firearm_ammo_random_eject_horizontal_force_min: -2,
		firearm_ammo_random_eject_horizontal_force_max: -1,
		
		firearm_ammo_random_eject_vertical_force_min: -2,
		firearm_ammo_random_eject_vertical_force_max: -1,
		
		firearm_ammo_eject_rotation_force: 2,
		
		// Weapon Properties
		firearm_attack_delay: 5,
		firearm_attack_distance: 1200,
		firearm_attack_hit_percentage: 0.25,
		
		firearm_attack_damage: 2,
		firearm_attack_luck_damage: 0.2,
		
		firearm_attack_impulse_power: 35,
		
		// Weapon Reload
		firearm_reload_with_secondary_hand: false,
		
		firearm_reload_spin: false,
		firearm_reload_spin_spd: -5,
		
		firearm_reload_magazine: true,
		
		firearm_reload_individual_rounds: false,
		
		// Weapon FX
		firearm_muzzle_smoke_object: oFirearm_MuzzleSmoke_Small,
		firearm_muzzle_smoke_min: 1,
		firearm_muzzle_smoke_max: 2,
		
		firearm_muzzle_flare_object: oFirearm_MuzzleFlare_Small,
		
		firearm_smoke_trail_object: oFirearm_SmokeTrail_Small,
		
		// Weapon Safety Angles
		firearm_idle_safety_angle: -10,
		firearm_moving_safety_angle: -25,
		firearm_reload_safety_angle: 15,
		
		// Weapon Recoil
		firearm_recoil_recovery_delay: 2,
		
		firearm_random_recoil_horizontal_min: -6,
		firearm_random_recoil_horizontal_max: -2,
		firearm_total_recoil_horizontal: 6,
		
		firearm_random_recoil_vertical_min: -0.25,
		firearm_random_recoil_vertical_max: 1.6,
		firearm_total_recoil_vertical: 2,
		
		firearm_random_recoil_angle_min: -2,
		firearm_random_recoil_angle_max: 6,
		firearm_total_recoil_angle: 8,
		
		// Weapon Position Offset
		weapon_position_horizontal_offset: 0,
		weapon_position_vertical_offset: 0,
		
		// Weapon Bolt Operation
		firearm_bolt_handle_position_x: 0,
		firearm_bolt_handle_position_y: 0,
		
		firearm_bolt_handle_charge_offset_x: 0,
		firearm_bolt_handle_charge_offset_y: 0,
		
		// Weapon Hand Positions
		weapon_hand_position_primary_x: 2,
		weapon_hand_position_primary_y: 3,
		
		weapon_hand_position_offhand_x: 12,
		weapon_hand_position_offhand_y: 1,
		
		// Weapon Reload Positions
		firearm_reload_x: 7,
		firearm_reload_y: 2,
		
		firearm_reload_offset_x: 0,
		firearm_reload_offset_y: 6,
		
		// Weapon Muzzle Positions
		firearm_muzzle_x: 18,
		firearm_muzzle_y: 0,
    },
    
    // Held Item Data (Weapon Reload Held Item)
	held_item_data:
	{
		// Held Item Object
		held_item_object: oFirearm_Magazine,
		
		// Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
		render_sprite: sBlackMarket_OilerSubmachineGun_Magazine,
		render_normalmap: sBlackMarket_OilerSubmachineGun_Magazine_NormalMap,
		render_metallicroughnessmap: noone,
		render_emissivemap: noone,
		
		// Weapon PBR Settings
		normal_strength: 1,
		metallic: false,
		roughness: 0.2,
		emissive: 0,
	},
};

// 
global.item_packs[ItemPack.BoxRevolver] =
{
	// Item Data
	item_name: "Arkovian \"Box\" Revolver",
	item_description: "",
	item_dialogue: "",
	item_sprite: sItem_PlanetsiderRevolver,
	item_type: ItemType.Weapon,
	item_hand: ItemHand.Primary,
	item_slot_tier: UnitInventorySlotTier.Moderate,
	item_object: oItem_Weapon_CorsoRifle,
	item_count_limit: -1,
	
	// Render Data
	render_data:
	{
		// Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
		render_sprite: sBlackMarket_PlanetsideRevolver,
		render_normalmap: sBlackMarket_PlanetsideRevolver_NormalMap,
		render_metallicroughnessmap: noone,
		render_emissivemap: noone,
		
		// Weapon PBR Settings
		normal_strength: 1,
		metallic: false,
		roughness: 0.2,
		emissive: 0,
	},
	
	// Weapon Data
    weapon_data:
    {
		// Weapon Type
		weapon_type: WeaponType.Firearm,
		
		// Weapon Ammo
		firearm_ammo_item_pack: ItemPack.Ammo,
		firearm_ammo_max_capacity: 3,
		
		firearm_ammo_eject_case_after_firing: false,
		
		firearm_ammo_random_eject_horizontal_force_min: -0.75,
		firearm_ammo_random_eject_horizontal_force_max: 0.2,
		
		firearm_ammo_random_eject_vertical_force_min: -2,
		firearm_ammo_random_eject_vertical_force_max: -0.5,
		
		firearm_ammo_eject_rotation_force: 2,
		
		// Weapon Properties
		firearm_attack_delay: 28,
		firearm_attack_distance: 1200,
		firearm_attack_hit_percentage: 0.25,
		
		firearm_attack_damage: 3,
		firearm_attack_luck_damage: 0.7,
		
		firearm_attack_impulse_power: 50,
		
		// Weapon Reload
		firearm_reload_with_secondary_hand: true,
		
		firearm_reload_spin: true,
		firearm_reload_spin_spd: 23,
		
		firearm_reload_magazine: false,
		
		firearm_reload_individual_rounds: true,
		
		// Weapon FX
		firearm_muzzle_smoke_object: oFirearm_MuzzleSmoke_Medium,
		firearm_muzzle_smoke_min: 2,
		firearm_muzzle_smoke_max: 3,
		
		firearm_muzzle_flare_object: oFirearm_MuzzleFlare_Medium,
		
		firearm_smoke_trail_object: oFirearm_SmokeTrail_Medium,
		
		// Weapon Safety Angles
		firearm_idle_safety_angle: -18,
		firearm_moving_safety_angle: -28,
		firearm_reload_safety_angle: 25,
		
		// Weapon Recoil
		firearm_recoil_recovery_delay: 9,
		
		firearm_random_recoil_horizontal_min: -4.5,
		firearm_random_recoil_horizontal_max: -3,
		firearm_total_recoil_horizontal: 4.5,
		
		firearm_random_recoil_vertical_min: -0.2,
		firearm_random_recoil_vertical_max: -0.05,
		firearm_total_recoil_vertical: 3,
		
		firearm_random_recoil_angle_min: 11,
		firearm_random_recoil_angle_max: 15,
		firearm_total_recoil_angle: 12,
		
		// Weapon Position Offset
		weapon_position_horizontal_offset: 7,
		weapon_position_vertical_offset: 0,
		
		// Weapon Bolt Operation
		firearm_bolt_handle_position_x: 0,
		firearm_bolt_handle_position_y: 0,
		
		firearm_bolt_handle_charge_offset_x: 0,
		firearm_bolt_handle_charge_offset_y: 0,
		
		// Weapon Hand Positions
		weapon_hand_position_primary_x: 0,
		weapon_hand_position_primary_y: 2,
		
		weapon_hand_position_offhand_x: 0,
		weapon_hand_position_offhand_y: 2,
		
		// Weapon Reload Positions
		firearm_reload_x: 3,
		firearm_reload_y: 0,
		
		firearm_reload_offset_x: -2,
		firearm_reload_offset_y: -1,
		
		// Weapon Muzzle Positions
		firearm_muzzle_x: 12,
		firearm_muzzle_y: -2,
    },
    
    // Held Item Data (Weapon Reload Held Item)
	held_item_data:
	{
		// Held Item Object
		held_item_object: oFirearm_ShellCasing,
		
		// Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
		render_sprite: sBulletCase_Medium,
		render_normalmap: noone,
		render_metallicroughnessmap: noone,
		render_emissivemap: noone,
		
		// Weapon PBR Settings
		normal_strength: 1,
		metallic: false,
		roughness: 0.15,
		emissive: 0.1,
	},
};

//
global.item_packs[ItemPack.Ammo] =
{
	// Item Data
	item_name: "7.62 ARKOVIAN",
	item_description: "",
	item_dialogue: "",
	item_sprite: sItem_Ammo,
	item_type: ItemType.Default,
	item_hand: ItemHand.Primary,
	item_slot_tier: UnitInventorySlotTier.Light,
	item_object: oItem_ArkovianRifleAmmo,
	item_count_limit: 3,
	
	// Render Data
	render_data:
	{
		// Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
		render_sprite: sArkov_RifleAmmo_DiffuseMap,
		render_normalmap: sArkov_RifleAmmo_NormalMap,
		render_metallicroughnessmap: sArkov_RifleAmmo_MetallicRoughnessMap,
		render_emissivemap: noone,
		
		// Weapon PBR Settings
		normal_strength: 0.8,
		metallic: false,
		roughness: 0.2,
		emissive: 0,
	},
	
	// Item Data
	item_data:
	{
		item_horizontal_offset: 4,
		item_vertical_offset: 0,
		
		item_primary_hand_horizontal_offset: 0,
		item_primary_hand_vertical_offset: 0,
		
		item_secondary_hand_horizontal_offset: 0,
		item_secondary_hand_vertical_offset: 0,
	},
	
	// Ammo Data
	ammo_data:
	{
		ammo_object: oFirearm_ShellCasing
	},
};

//
global.item_packs[ItemPack.StickGrenade] =
{
	// Item Data
	item_name: "Potato Masher Stick Grenade",
	item_description: "Fml",
	item_dialogue: "Fml",
	item_sprite: sItem_PotatoMasherGrenade,
	item_type: ItemType.Weapon,
	item_hand: ItemHand.Primary,
	item_slot_tier: UnitInventorySlotTier.Light,
	item_object: oItem_Weapon_StickGrenade,
	item_count_limit: 3,
	
	// Render Data
	render_data:
	{
		// Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
		render_sprite: sArkov_PotatoMasher_Grenade,
		render_normalmap:sArkov_PotatoMasher_Grenade_NormalMap,
		render_metallicroughnessmap: noone,
		render_emissivemap: noone,
		
		// Weapon PBR Settings
		normal_strength: 1,
		metallic: false,
		roughness: 0.2,
		emissive: 0,
	},
	
	// Weapon Data
    weapon_data:
    {
		// Weapon Type
		weapon_type: WeaponType.Grenade,
		
		// Weapon Properties
		
		// Throw Animation Settings
		thrown_swing_underhand: false,
		
		// Operate Animation
		thrown_weapon_operate_angle: -20,
		
		thrown_weapon_operate_position_x: 0,
		thrown_weapon_operate_position_y: 2,
		
		thrown_weapon_operate_action_horizontal_offset: 6,
		thrown_weapon_operate_action_vertical_offset: 2,
    },
    
    // Held Item Data (Weapon Thrown Held Item)
	held_item_data:
	{
		// Held Item Object
		held_item_object: noone,
		
		// Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
		render_sprite: sArkov_PotatoMasher_Grenade,
		render_normalmap:sArkov_PotatoMasher_Grenade_NormalMap,
		render_metallicroughnessmap: noone,
		render_emissivemap: noone,
		
		// Weapon PBR Settings
		normal_strength: 1,
		metallic: false,
		roughness: 0.2,
		emissive: 0,
	},
};

//
global.item_packs[ItemPack.Molotov] =
{
	// Item Data
	item_name: "Molotov Cocktail",
	item_description: "Fml",
	item_dialogue: "Fml",
	item_sprite: sItem_PotatoMasherGrenade,
	item_type: ItemType.Weapon,
	item_hand: ItemHand.Primary,
	item_slot_tier: UnitInventorySlotTier.Light,
	item_object: oItem_Weapon_StickGrenade,
	item_count_limit: 3,
	
	// Render Data
	render_data:
	{
		// Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
		render_sprite: sArkov_Molotov,
		render_normalmap:sArkov_Molotov_NormalMap,
		render_metallicroughnessmap: noone,
		render_emissivemap: sArkov_Molotov_EmissiveMap,
		
		// Weapon PBR Settings
		normal_strength: 1,
		metallic: false,
		roughness: 0.2,
		emissive: 0,
	},
	
	// Weapon Data
    weapon_data:
    {
		// Weapon Type
		weapon_type: WeaponType.Molotov,
		
		// Weapon Properties
		
		// Throw Animation Settings
		thrown_swing_underhand: true,
		
		// Operate Animation
		thrown_weapon_operate_angle: -20,
		
		thrown_weapon_operate_position_x: 2,
		thrown_weapon_operate_position_y: -6,
		
		thrown_weapon_operate_action_horizontal_offset: 0,
		thrown_weapon_operate_action_vertical_offset: 0,
    },
    
    // Held Item Data (Weapon Thrown Held Item)
	held_item_data:
	{
		// Held Item Object
		held_item_object: noone,
		
		// Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
		render_sprite: sArkov_Molotov,
		render_normalmap:sArkov_Molotov_NormalMap,
		render_metallicroughnessmap: noone,
		render_emissivemap: sArkov_Molotov_EmissiveMap,
		
		// Weapon PBR Settings
		normal_strength: 1,
		metallic: false,
		roughness: 0.2,
		emissive: 0,
	},
};



