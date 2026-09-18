// Celestial Combat Unit Inventory Slot Types
enum CelestialCombatUnitInventorySlotType
{
	InfantryLight,
	InfantryModerate,
	InfantryHefty,
	InfantryCumbersome,
	TankMainCannon,
}

// Celestial Combat Unit Animation State
enum CelestialCombatUnitAnimationState
{
	EntryDelayed,
	Entry,
	Idle,
	ActionAttack,
	ActionSupport
}

// Global Celestial Combat Action Enums
enum CelestialCombatUnitActionType
{
	None,
	Attack,
	Support
}

#region Combat Units
// Celestial Combat Unit Enum
enum CelestialCombatUnitType
{
	DefaultInfantry,
	DefaultTank
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
#endregion

#region Combat Items
// Celestial Combat Item Enum
enum CelestialCombatItem
{
	DefaultFirearm
}

// Global Celestial Combat Units
global.celestial_combat_items[CelestialCombatItem.DefaultFirearm] =
{
	// Item Sprite
	item_sprite: sOverworld_Unit_William_Firearm,
	
	// Inventory Settings
	inventory_slot_type: CelestialCombatUnitInventorySlotType.InfantryHefty,
	
	// Action Settings
	action_type: CelestialCombatUnitActionType.Attack,
	action_weight: 16,
	action_count: 3,
	action_delay: 30,
	action_duration: 12,
	action_instance: oCelestialCombatAction,
	
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
};
#endregion

/*
// Global Celestial Unit Action Animations
global.celestial_combat_unit_action_animations[CelestialCombatUnitActionAnimationType.Firearm] =
{
	// Hitmarker Settings
	linear_projectile_hitmarker_hit_sprite: sOverworld_Hitmarker,
	linear_projectile_hitmarker_miss_sprite: sOverworld_HitmarkerMiss,
	
	// Linear Projectile Settings
	linear_projectile_width: 2,
	linear_projectile_decay: 0.2,
};

global.celestial_combat_unit_action_animations[CelestialCombatUnitActionAnimationType.Firearm] =
{
	// Hitmarker Settings
	linear_projectile_hitmarker_hit_sprite: sOverworld_Hitmarker,
	linear_projectile_hitmarker_miss_sprite: sOverworld_HitmarkerMiss_Large,
	
	// Linear Projectile Settings
	linear_projectile_width: 3,
	linear_projectile_decay: 0.08,
};
*/

////
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
}

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
}

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
		default:
			break;
	}
	
	// Return Inventory Slot Compatibility
	return temp_inventory_slot_is_compatible;
}

