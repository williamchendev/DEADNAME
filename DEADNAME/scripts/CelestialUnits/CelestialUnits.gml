// Celestial Unit Enums
enum CelestialUnitBehaviourType
{
	None,
	Attack,
	Regroup,
	Hunt,
	Patrol,
	Garrison,
	Retreat
}

#region Unit Types
// Celestial Combat Unit Enum
enum CelestialCombatUnitTypes
{
	DefaultInfantry,
	DefaultTank
}

// Global Celestial Combat Units
global.celestial_combat_units[CelestialCombatUnitTypes.DefaultInfantry] =
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
	
	// Movement Settings
	unit_terrain_type: CelestialTerrainType.Land,
	
	// Combat Settings
	unit_combat: true,
	unit_combat_attendance: false,
	
	unit_priority_rank: 4,
	
	unit_attack_air: false,
	unit_attack_land: true,
	unit_attack_sea: false,
	
	unit_attack_assassination: false,
	
	// Action Settings
	unit_attack_types: [CelestialUnitActionType.DefaultFirearm],
	
	// Unit Weapon Animation Settings
	unit_weapon_enabled: true,
	unit_weapon_sprite: sOverworld_Unit_William_Firearm,
	unit_weapon_pivot_x: 0,
	unit_weapon_pivot_y: -14,
	unit_weapon_aim_pivot_x: 3,
	unit_weapon_aim_pivot_y: -16,
};

global.celestial_combat_units[CelestialCombatUnitTypes.DefaultTank] =
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
	
	// Movement Settings
	unit_terrain_type: CelestialTerrainType.Land,
	
	// Combat Settings
	unit_combat: true,
	unit_combat_attendance: false,
	
	unit_priority_rank: 2,
	
	unit_attack_air: false,
	unit_attack_land: true,
	unit_attack_sea: false,
	
	unit_attack_assassination: false,
	
	// Action Settings
	unit_attack_types: [CelestialUnitActionType.DefaultTankCannon],
	
	// Unit Weapon Animation Settings
	unit_weapon_enabled: false,
	unit_weapon_sprite: noone,
	unit_weapon_pivot_x: 0,
	unit_weapon_pivot_y: 0,
	unit_weapon_aim_pivot_x: 0,
	unit_weapon_aim_pivot_y: 0,
};
#endregion

#region Status Effects
// Celestial Unit Status Effect Enum
enum CelestialUnitStatusEffectType
{
	CombatActionStun
}

// Global Celestial Unit Status Effects
global.celestial_unit_status_effects[CelestialUnitStatusEffectType.CombatActionStun] =
{
	status_effect_name: "Ambushed!",
	status_effect_duration: 120
};
#endregion

#region Action Types
// Celestial Unit Action Enum
enum CelestialUnitActionType
{
	DefaultFirearm,
	DefaultTankCannon,
}

// Global Celestial Unit Action Animations
global.celestial_unit_action_animations[CelestialUnitActionType.DefaultFirearm] =
{
	// Action Settings
	action_duration: 5.5,
	
	// Animation Settings
	action_animation_count: 3,
	
	// Hitmarker Settings
	linear_projectile_hitmarker_hit_sprite: sOverworld_Hitmarker,
	linear_projectile_hitmarker_miss_sprite: sOverworld_HitmarkerMiss,
	
	// Linear Projectile Settings
	linear_projectile_width: 2,
	linear_projectile_decay: 0.2,
	
};

global.celestial_unit_action_animations[CelestialUnitActionType.DefaultTankCannon] =
{
	// Action Settings
	action_duration: 5.5,
	
	// Animation Settings
	action_animation_count: 1,
	
	// Hitmarker Settings
	linear_projectile_hitmarker_hit_sprite: sOverworld_Hitmarker,
	linear_projectile_hitmarker_miss_sprite: sOverworld_HitmarkerMiss_Large,
	
	// Linear Projectile Settings
	linear_projectile_width: 3,
	linear_projectile_decay: 0.08,
};
#endregion

//
function celestial_unit_add_combat_unit(celestial_unit, combat_unit_type)
{
	// Initialize Empty Combat Unit Instance
	var temp_combat_unit_instance = instance_create_depth(0, 0, 0, oCelestialCombatUnit);
	
	// Set Combat Unit's Properties from Combat Unit Type
	temp_combat_unit_instance.combat_unit_type = combat_unit_type;
	temp_combat_unit_instance.combat_unit_health = global.celestial_combat_units[combat_unit_type].unit_health;
	
	// Index Combat Unit Instance within Celestial Unit's Combat Units Array
	array_push(celestial_unit.combat_units, temp_combat_unit_instance);
	
	// Set Combat Unit Instance's Unit Instance
	temp_combat_unit_instance.unit_instance = celestial_unit;
}

function celestial_unit_remove_combat_unit(celestial_unit, celestial_combat_unit)
{
	// Find Combat Unit's Array Index within Celestial Unit's Combat Units Array
	var temp_combat_unit_array_index = array_get_index(celestial_unit.combat_units, celestial_combat_unit);
	
	// Delete Combat Unit from Unit Instance's Combat Units Array
	if (temp_combat_unit_array_index != -1)
	{
		array_delete(celestial_unit.combat_units, temp_combat_unit_array_index, 1);
	}
}

//
function celestial_unit_add_status_effect(celestial_unit, status_effect_type)
{
	//
	var temp_status_effect_index = array_get_index(celestial_unit.status_effect_array, status_effect_type);
	
	//
	if (temp_status_effect_index != -1)
	{
		//
		celestial_unit.status_effect_duration_array = global.celestial_unit_status_effects[status_effect_type].status_effect_duration;
	}
	else
	{
		//
		array_push(celestial_unit.status_effect_array, status_effect_type);
		array_push(celestial_unit.status_effect_duration_array, global.celestial_unit_status_effects[status_effect_type].status_effect_duration);
	}
}

function celestial_unit_check_status_effect(celestial_unit, status_effect_type)
{
	//
	return array_get_index(celestial_unit.status_effect_array, status_effect_type) != -1;
}



