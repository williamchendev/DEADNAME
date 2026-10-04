// Celestial Combat Unit Inventory Slot Types
enum CelestialCombatUnitInventorySlotType
{
	InfantryLight,
	InfantryModerate,
	InfantryHefty,
	InfantryCumbersome,
	TankMainCannon,
	ArtilleryCannon
}

// Celestial Combat Unit Animation State
enum CelestialCombatUnitAnimationState
{
	EntryDelayed,
	Entry,
	Exit,
	Idle,
	ActionAttack,
	ActionSupport
}

// Global Celestial Combat Action Enums
enum CelestialCombatUnitActionType
{
	None,
	Attack,
	AttackLinearProjectile,
	AttackArcProjectile,
	Support
}

#region Combat Units
// Celestial Combat Unit Enum
enum CelestialCombatUnitType
{
	DefaultInfantry,
	DefaultTank,
	DefaultArtillery
}

// Global Celestial Combat Units
global.celestial_combat_units[CelestialCombatUnitType.DefaultInfantry] =
{
	// Unit Sprites
	unit_idle_sprite: sOverworld_Unit_William_Idle,
	unit_move_sprite: sOverworld_Unit_William_Move,
	unit_attack_sprite: noone,
	
	// Unit Stats
	unit_health: 10,
	unit_accuracy: 6,
	unit_evasion: 6,
	unit_attack: 2,
	unit_armor: 1,
	unit_agility: 0.04,
	unit_size: 1,
	unit_entrenchment: 0,
	
	// Terrain Settings
	unit_terrain_type: CelestialUnitTerrainType.Terrestrial,
	
	// Combat Settings
	unit_combat_mandatory_attendance: false,
	
	unit_combat_column_type: CelestialBattleColumnType.Frontline,
	
	unit_attack_assassination: false,
	
	// Inventory Settings
	unit_inventory_slots: 
	[ 
		CelestialCombatUnitInventorySlotType.InfantryHefty,
		CelestialCombatUnitInventorySlotType.InfantryModerate,
		CelestialCombatUnitInventorySlotType.InfantryLight,
		CelestialCombatUnitInventorySlotType.InfantryLight
	],
	
	// Item Settings
	unit_item_pivot_x: 0,
	unit_item_pivot_y: -14,
	
	unit_item_aim_pivot_x: 3,
	unit_item_aim_pivot_y: -16,
	
	unit_item_idle_ambient_angle: 0,
	unit_item_move_ambient_angle: 45,
};

global.celestial_combat_units[CelestialCombatUnitType.DefaultTank] =
{
	// Unit Sprites
	unit_idle_sprite: sOverworld_Unit_Tank_Medium,
	unit_move_sprite: sOverworld_Unit_Tank_Medium,
	unit_attack_sprite: sOverworld_Unit_Tank_Medium_Attack,
	
	// Unit Stats
	unit_health: 10,
	unit_accuracy: 6,
	unit_evasion: 6,
	unit_attack: 2,
	unit_armor: 1,
	unit_agility: 0.02,
	unit_size: 1,
	unit_entrenchment: 0,
	
	// Terrain Settings
	unit_terrain_type: CelestialUnitTerrainType.Terrestrial,
	
	// Combat Settings
	unit_combat_mandatory_attendance: false,
	
	unit_combat_column_type: CelestialBattleColumnType.Frontline,
	
	unit_attack_assassination: false,
	
	// Inventory Settings
	unit_inventory_slots: 
	[ 
		CelestialCombatUnitInventorySlotType.TankMainCannon
	],
	
	// Item Settings
	unit_item_pivot_x: 8,
	unit_item_pivot_y: -11,
	
	unit_item_aim_pivot_x: 8,
	unit_item_aim_pivot_y: -11,
	
	unit_item_idle_ambient_angle: 0,
	unit_item_move_ambient_angle: 45,
};

global.celestial_combat_units[CelestialCombatUnitType.DefaultArtillery] =
{
	// Unit Sprites
	unit_idle_sprite: sOverworld_Unit_Artillery,
	unit_move_sprite: sOverworld_Unit_Artillery,
	unit_attack_sprite: noone,
	
	// Unit Stats
	unit_health: 10,
	unit_accuracy: 6,
	unit_evasion: 6,
	unit_attack: 2,
	unit_armor: 1,
	unit_agility: 0.04,
	unit_size: 1,
	unit_entrenchment: 0,
	
	// Terrain Settings
	unit_terrain_type: CelestialUnitTerrainType.Terrestrial,
	
	// Combat Settings
	unit_combat_mandatory_attendance: false,
	
	unit_combat_column_type: CelestialBattleColumnType.Midline,
	
	unit_attack_assassination: false,
	
	// Inventory Settings
	unit_inventory_slots: 
	[ 
		CelestialCombatUnitInventorySlotType.ArtilleryCannon,
	],
	
	// Item Settings
	unit_item_pivot_x: 9,
	unit_item_pivot_y: -18,
	
	unit_item_aim_pivot_x: 9,
	unit_item_aim_pivot_y: -18,
	
	unit_item_idle_ambient_angle: 0,
	unit_item_move_ambient_angle: 45,
};
#endregion

#region Combat Items
// Celestial Combat Item Enum
enum CelestialCombatItem
{
	DefaultFirearm,
	DefaultArtillery
}

// Global Celestial Combat Items
global.celestial_combat_items[CelestialCombatItem.DefaultFirearm] =
{
	// Item Sprite
	item_render: true,
	item_sprite: sOverworld_Unit_William_Firearm,
	
	// Inventory Settings
	inventory_slot_type: CelestialCombatUnitInventorySlotType.InfantryHefty,
	
	// Action Settings
	action_type: CelestialCombatUnitActionType.AttackLinearProjectile,
	action_weight: 16,
	action_count: 3,
	action_delay: 30,
	action_duration: 12,
	action_instance: oCelestialCombatAction_LinearProjectile,
	
	// Rotation Settings
	item_rotate_spd: 0.1,
	
	// Aim Settings
	item_aiming_aim_transition_spd: 0.12,
	item_aiming_hip_transition_spd: 0.08,
	
	// Recoil Settings
	item_recoil_recovery_spd: 0.1,
	
	item_angle_recoil_min: 3,
	item_angle_recoil_max: 13,
	item_horizontal_recoil_min: -6,
	item_horizontal_recoil_max: -4,
	item_vertical_recoil_min: -3,
	item_vertical_recoil_max: -1,
	
	// Muzzle Settings
	item_muzzle_x: 10,
	item_muzzle_y: -1,
	
	item_muzzle_emission_sprite: sOverworld_Unit_William_Firearm_MuzzleFlash,
	item_muzzle_emission_duration: 3,
	
	// Projectile Settings
	projectile_speed: 1,
	projectile_gravity: -1,
	projectile_air_resistance: -1,
};

global.celestial_combat_items[CelestialCombatItem.DefaultArtillery] =
{
	// Item Sprite
	item_render: false,
	item_sprite: sOverworld_Unit_William_Firearm,
	
	// Inventory Settings
	inventory_slot_type: CelestialCombatUnitInventorySlotType.ArtilleryCannon,
	
	// Action Settings
	action_type: CelestialCombatUnitActionType.AttackArcProjectile,
	action_weight: 16,
	action_count: 1,
	action_delay: 30,
	action_duration: 30,
	action_instance: oCelestialCombatAction_ArcProjectile,
	
	// Rotation Settings
	item_rotate_spd: 0.1,
	
	// Aim Settings
	item_aiming_aim_transition_spd: 0.12,
	item_aiming_hip_transition_spd: 0.08,
	
	// Recoil Settings
	item_recoil_recovery_spd: 0.1,
	
	item_angle_recoil_min: 3,
	item_angle_recoil_max: 13,
	item_horizontal_recoil_min: -6,
	item_horizontal_recoil_max: -4,
	item_vertical_recoil_min: -3,
	item_vertical_recoil_max: -1,
	
	// Muzzle Settings
	item_muzzle_x: 0,
	item_muzzle_y: 0,
	
	item_muzzle_emission_sprite: sOverworld_Unit_William_Firearm_MuzzleFlash,
	item_muzzle_emission_duration: 3,
	
	// Projectile Settings
	projectile_speed: 26,
	projectile_gravity: 1,
	projectile_air_resistance: 0,
};
#endregion

#region Inventory Functions
/// @function celestial_combat_unit_equip_item(combat_unit_instance, inventory_index);
/// @description Equips the given Celestial Combat Unit with the Inventory Item (or lack thereof) in the given Inventory Index's Inventory Slot
/// @param {real:Id.Instance<oCelestialCombatUnit>} combat_unit_instance The Celestial Combat Unit that will perform the Equip Behaviour
/// @param {int} inventory_index The Index of the Inventory Slot to equip an Item (or lack thereof) from
function celestial_combat_unit_equip_item(combat_unit_instance, inventory_index)
{
	// Update Combat Unit's Equipped Item Inventory Index
	combat_unit_instance.item_inventory_index = inventory_index;
	
	// Check if Item Exists
	if (inventory_index != -1 and combat_unit_instance.item_inventory[inventory_index].item != -1)
	{
		// Find Inventory Item's Combat Item Struct
		var temp_inventory_item = combat_unit_instance.item_inventory[inventory_index].item;
		
		// Update Combat Unit's Item Sprite
		combat_unit_instance.item_sprite = global.celestial_combat_items[temp_inventory_item].item_sprite;
	}
	else
	{
		// Update Combat Unit's Item Sprite
		combat_unit_instance.item_sprite = -1;
	}
	
	// Reset Combat Unit's Item Variables
	combat_unit_instance.item_aim = 0;
	
	combat_unit_instance.item_offset_x = 0;
	combat_unit_instance.item_offset_y = 0;
	
	combat_unit_instance.item_target_x = 0;
	combat_unit_instance.item_target_y = 0;
	combat_unit_instance.item_target_angle = 0;
	
	combat_unit_instance.item_angle = 90 + (combat_unit_instance.draw_xscale * -90);
	
	combat_unit_instance.item_angle_recoil = 0;
	combat_unit_instance.item_horizontal_recoil = 0;
	combat_unit_instance.item_vertical_recoil = 0;
	
	combat_unit_instance.item_muzzle_offset_x = 0;
	combat_unit_instance.item_muzzle_offset_y = 0;
	
	combat_unit_instance.item_muzzle_emission_duration = 0;
	combat_unit_instance.item_muzzle_emission_image_index = 0;
}

/// @function celestial_combat_unit_add_item(combat_unit_instance, combat_item_type, inventory_index);
/// @description Adds a Celestial Combat Item to the given Celestial Combat Unit Instance's Inventory Slot
/// @param {real:Id.Instance<oCelestialCombatUnit>} combat_unit_instance The Celestial Combat Unit that will have an Item added to their Inventory
/// @param {int<CelestialCombatItem>} combat_item_type The Celestial Combat Item type enum to add the Combat Item of to the Celestial Combat Unit's Inventory
/// @param {int} inventory_index The Index of the Inventory Slot to add an Item to
/// @returns {bool} Returns true or false if the Combat Item was able to be added to the Combat Unit's Inventory
function celestial_combat_unit_add_item(combat_unit_instance, combat_item_type, inventory_index)
{
	// Check if the given Inventory Index is a valid index within Combat Unit's Inventory Array
	if (inventory_index < 0 or inventory_index >= array_length(combat_unit_instance.item_inventory))
	{
		// Not a valid index - Return failed to add item to Combat Unit's Inventory
		return false;
	}

	// Check if the given Combat Item to add to the given Combat Unit's Inventory Slot is compatible with the Inventory Slot's Type
	if (!celestial_combat_unit_inventory_slot_is_compatible(combat_unit_instance.item_inventory[inventory_index].slot_type, global.celestial_combat_items[combat_item_type].inventory_slot_type))
	{
		// Combat Item is not compatible with the Inventory Slot's Type - Return failed to add item to Combat Unit's Inventory
		return false;
	}
	
	// Establish Inventory Slot's Previously Held Item
	var temp_former_inventory_item = combat_unit_instance.item_inventory[inventory_index].item;
	
	// Set Combat Unit's Inventory Slot Item to the given Item
	combat_unit_instance.item_inventory[inventory_index].item = combat_item_type;
	
	// Check if Combat Unit needs perform Inventory Item Equip Behaviour
	if (inventory_index == combat_unit_instance.item_inventory_index and temp_former_inventory_item != combat_item_type)
	{
		celestial_combat_unit_equip_item(combat_unit_instance, inventory_index);
	}
	
	// Added the Combat Item to the Combat Unit's Inventory - Return success condition
	return true;
}

/// @function celestial_combat_unit_remove_item(combat_unit_instance, inventory_index);
/// @description Removes a Celestial Combat Item from the given Celestial Combat Unit Instance's Inventory Slot
/// @param {real:Id.Instance<oCelestialCombatUnit>} combat_unit_instance The Celestial Combat Unit that will have an Item removed from their Inventory
/// @param {int} inventory_index The Index of the Inventory Slot to remove an Item from
function celestial_combat_unit_remove_item(combat_unit_instance, inventory_index)
{
	// Check if the given Inventory Index is a valid index within Combat Unit's Inventory Array
	if (inventory_index < 0 or inventory_index >= array_length(combat_unit_instance.item_inventory))
	{
		// Not a valid index - Early Return
		return;
	}
	
	// Establish Inventory Slot's Previously Held Item
	var temp_former_inventory_item = combat_unit_instance.item_inventory[inventory_index].item;
	
	// Set Combat Unit's Inventory Slot Item to nothing
	combat_unit_instance.item_inventory[inventory_index].item = -1;
	
	// Check if Combat Unit needs perform Inventory Item Equip Behaviour
	if (inventory_index == combat_unit_instance.item_inventory_index and temp_former_inventory_item != -1)
	{
		celestial_combat_unit_equip_item(combat_unit_instance, inventory_index);
	}
}

/// @function celestial_combat_unit_initialize_inventory(combat_unit_instance);
/// @description Initializes the Inventory of the given Celestial Combat Unit Instance using their Celestial Combat Unit Type's Inventory as a template
/// @param {real:Id.Instance<oCelestialCombatUnit>} combat_unit_instance The Celestial Combat Unit Instance that will have their Inventory initialized
function celestial_combat_unit_initialize_inventory(combat_unit_instance)
{
	// Initialize Combat Unit's Inventory from Combat Unit Type
	var temp_combat_unit_inventory_count = array_length(global.celestial_combat_units[combat_unit_instance.combat_unit_type].unit_inventory_slots);
	var temp_combat_unit_inventory_index = 0;
	
	array_resize(combat_unit_instance.item_inventory, temp_combat_unit_inventory_count);
	
	repeat (temp_combat_unit_inventory_count)
	{
		// Initialize Empty Inventory Slot
		combat_unit_instance.item_inventory[temp_combat_unit_inventory_index] = 
		{
			item: -1,
			slot_type: global.celestial_combat_units[combat_unit_instance.combat_unit_type].unit_inventory_slots[temp_combat_unit_inventory_index]
		};
		
		// Increment Combat Unit Inventory Index
		temp_combat_unit_inventory_index++;
	}
	
	// Reset Combat Unit's Equipped Item Index
	combat_unit_instance.item_inventory_index = -1;
}

/// @function celestial_combat_unit_duplicate_equipped_item(combat_unit_instance_source, combat_unit_instance_destination);
/// @description Duplicates the Equipped Inventory Slot of the given Celestial Combat Unit Instance "Source" and copies it to the Celestial Combat Unit Instance "Destination", meant to be used on Duplicate Combat Unit Instances performing their Leave Animation
/// @param {real:Id.Instance<oCelestialCombatUnit>} combat_unit_instance_source The Celestial Combat Unit Instance that will have their Equipped Inventory Slot copied from
/// @param {real:Id.Instance<oCelestialCombatUnit>} combat_unit_instance_destination The Celestial Combat Unit Instance that will have their Equipped Inventory Slot copied to
function celestial_combat_unit_duplicate_equipped_item(combat_unit_instance_source, combat_unit_instance_destination)
{
	// Clear Destination Combat Unit Instance's Inventory Behaviour
	if (array_length(combat_unit_instance_destination.item_inventory) > 0)
	{
		// Clear Combat Unit's Inventory
		var temp_combat_unit_inventory_count = array_length(combat_unit_instance_destination.item_inventory);
		var temp_combat_unit_inventory_index = temp_combat_unit_inventory_count - 1;
		
		repeat (temp_combat_unit_inventory_count)
		{
			// Clear Inventory Slot Struct
			delete combat_unit_instance_destination.item_inventory[temp_combat_unit_inventory_index];
			combat_unit_instance_destination.item_inventory[temp_combat_unit_inventory_index] = -1;
			
			// Decrement Combat Unit Inventory Index
			temp_combat_unit_inventory_index--;
		}
		
		array_resize(combat_unit_instance_destination.item_inventory, 0);
	}
	
	// Duplicate Inventory Variables
	if (combat_unit_instance_source.item_inventory_index != -1)
	{
		// Create a single Inventory Slot for the Destination Combat Unit Instance
		array_resize(combat_unit_instance_destination.item_inventory, 1);
		
		// Initialize Inventory Slot as a Copy of the given Source Combat Unit Instance's Equipped Item
		combat_unit_instance_destination.item_inventory[0] = 
		{
			item: combat_unit_instance_source.item_inventory[combat_unit_instance_source.item_inventory_index].item,
			slot_type: combat_unit_instance_source.item_inventory[combat_unit_instance_source.item_inventory_index].slot_type
		};
		
		// Perform Destination Combat Unit Instance's Item Equip Behaviour for the newly duplicated Inventory Slot Item
		celestial_combat_unit_equip_item(combat_unit_instance_destination, 0);
	}
	else
	{
		// Perform Destination Combat Unit Instance's Item Unequip Behaviour
		celestial_combat_unit_equip_item(combat_unit_instance_destination, -1);
	}
}

/// @function celestial_combat_unit_inventory_slot_is_compatible(unit_inventory_slot_type, item_inventory_slot_type);
/// @description Checks wether the given Item's Inventory Slot Type is compatible with the Unit's Inventory Slot Type and can be placed
/// @param {int<CelestialCombatUnitInventorySlotType>} unit_inventory_slot_type The Unit's Inventory Slot type to check the compatibility with the given Item
/// @param {int<CelestialCombatUnitInventorySlotType>} item_inventory_slot_type The Item's Inventory Slot type to check the compatibility with the given Unit's Inventory Slot
/// @returns {bool} Returns true or false if the Item and the Unit's Inventory Slot are compatible or not
function celestial_combat_unit_inventory_slot_is_compatible(unit_inventory_slot_type, item_inventory_slot_type)
{
	// Establish Inventory Slot Compatibility Check
	var temp_inventory_slot_is_compatible = false;
	
	// Check Combat Unit's Inventory Slot Compatibility with given Item based on the Unit's Inventory Slot Type
	switch (unit_inventory_slot_type)
	{
		case CelestialCombatUnitInventorySlotType.InfantryLight:
		case CelestialCombatUnitInventorySlotType.InfantryModerate:
		case CelestialCombatUnitInventorySlotType.InfantryHefty:
		case CelestialCombatUnitInventorySlotType.InfantryCumbersome:
			// Check if Item's Required Slot Type is smaller or equal to the size of the Unit's Slot Type
			temp_inventory_slot_is_compatible = item_inventory_slot_type <= unit_inventory_slot_type;
			break;
		case CelestialCombatUnitInventorySlotType.TankMainCannon:
			// Check if Item's Slot Type is also a Tank's Main Cannon
			temp_inventory_slot_is_compatible = item_inventory_slot_type == CelestialCombatUnitInventorySlotType.TankMainCannon;
			break;
		case CelestialCombatUnitInventorySlotType.ArtilleryCannon:
			// Check if Item's Slot Type is also an Artillery Cannon
			temp_inventory_slot_is_compatible = item_inventory_slot_type == CelestialCombatUnitInventorySlotType.ArtilleryCannon;
			break;
		default:
			break;
	}
	
	// Return Inventory Slot Compatibility
	return temp_inventory_slot_is_compatible;
}
#endregion

