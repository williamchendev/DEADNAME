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
// Celestial Sub-Unit Enum
enum CelestialSubUnitTypes
{
	DefaultInfantry,
	DefaultTank
}

// Global Celestial Sub-Units
global.celestial_subunits[CelestialSubUnitTypes.DefaultInfantry] =
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
	unit_agility: 4,
	unit_experience: 0,
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

global.celestial_subunits[CelestialSubUnitTypes.DefaultTank] =
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
	unit_agility: 4,
	unit_experience: 0,
	unit_entrenchment: 0,
	
	// Movement Settings
	unit_terrain_type: CelestialTerrainType.Land,
	
	// Combat Settings
	unit_combat: true,
	unit_combat_attendance: false,
	
	unit_priority_rank: 0,
	
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
	//
	action_duration: 5.5,
	
	//
	action_animation_count: 3,
	
	//
	linear_projectile_hitmarker_hit_sprite: sOverworld_Hitmarker,
	linear_projectile_hitmarker_miss_sprite: sOverworld_HitmarkerMiss,
	
	//
	linear_projectile_width: 2,
	linear_projectile_decay: 0.2,
	
};

global.celestial_unit_action_animations[CelestialUnitActionType.DefaultTankCannon] =
{
	//
	action_duration: 5.5,
	
	//
	action_animation_count: 1,
	
	//
	linear_projectile_hitmarker_hit_sprite: sOverworld_Hitmarker,
	linear_projectile_hitmarker_miss_sprite: sOverworld_HitmarkerMiss_Large,
	
	//
	linear_projectile_width: 3,
	linear_projectile_decay: 0.08,
};
#endregion

//
function celestial_unit_attack_stat_to_value_conversion(attack_stat)
{
	// Damage Reference - 1 damage is like getting a concussion from being hit with a baseball bat
	
	//
	switch (attack_stat)
	{
		case 1:
			// Pistol Round
			return 3;
		case 2:
			// Full-Sized Rifle Round
			return 5;
		case 3:
			// Mortar Shell / Small Explosive
			return 10;
		case 4:
			// Artillery Shell
			return 14;
		case 5:
			// Anti Armor Round
			return 17;
		case 6:
			// Anti Armor Round
			return 20;
		case 7:
			// Large Artillery Shell
			return 23;
		case 8:
			// Very Large Artillery Shell
			return 28;
		case 9:
			// Bunker Buster Bomb
			return 32;
		case 10:
			// Fictional Bullshit
			return 42;
		case 11:
			// Fictional Bullshit
			return 54;
		case 12:
			// Fictional Bullshit
			return 64;
	}
	
	//
	return 1;
}

function celestial_unit_armor_stat_to_value_conversion(armor_stat)
{
	// Damage Reference - 1 damage is like getting a concussion from being hit with a baseball bat
	
	//
	switch (armor_stat)
	{
		case 1:
			// Light Body Armor (Protective Cladding and Improvised Civillian Armored Clothing)
			return 2;
		case 2:
			// Heavy Body Armor (Anti-Terrorism Small Arms Stopping Armored Plate Carriers & Militarized Police Armor)
			return 4;
		case 3:
			// Light (Improvised) Defensive Structures - Wood Material Fixtures & Sandbags
			// Light Aircraft
			return 8;
		case 4:
			// Medium Defensive Structures - Unhardened Civilian Buildings & Infrustructure
			// Infantry with Fictional Power Armor
			// Armored Cars & Light Tanks
			// Medium Aircraft
			return 12;
		case 5:
			// Medium Tanks
			// Heavy Aircraft
			return 15;
		case 6:
			// Heavy Tanks
			return 18;
		case 7:
			// Heavy Defensive Structures - Hardened Concrete Infrustructure
			return 21;
		case 8:
			// Super Heavy Defensive Structures - Steel clad reinforced Concrete Infrustructure
			return 26;
		case 9:
			// Fictional Bullshit
			return 30;
		case 10:
			// Fictional Bullshit
			return 40;
		case 11:
			// Fictional Bullshit
			return 50;
		case 12:
			// Fictional Bullshit
			return 60;
	}
	
	//
	return 0;
}

function celestial_unit_agility_stat_to_value_conversion(agility_stat)
{
	//  
	return 0.05;
	
	//
	switch (agility_stat)
	{
		case 1:
			// Slow
			return 2;
		case 2:
			// Heavy Body Armor (Anti-Terrorism Small Arms Stopping Armored Plate Carriers & Militarized Police Armor)
			return 4;
		case 3:
			// Light (Improvised) Defensive Structures - Wood Material Fixtures & Sandbags
			// Light Aircraft
			return 8;
		case 4:
			// Medium Defensive Structures - Unhardened Civilian Buildings & Infrustructure
			// Infantry with Fictional Power Armor
			// Armored Cars & Light Tanks
			// Medium Aircraft
			return 12;
		case 5:
			// Medium Tanks
			// Heavy Aircraft
			return 15;
		case 6:
			// Heavy Tanks
			return 18;
		case 7:
			// Heavy Defensive Structures - Hardened Concrete Infrustructure
			return 21;
		case 8:
			// Super Heavy Defensive Structures - Steel clad reinforced Concrete Infrustructure
			return 26;
		case 9:
			// Fictional Bullshit
			return 30;
		case 10:
			// Fictional Bullshit
			return 40;
		case 11:
			// Fictional Bullshit
			return 50;
		case 12:
			// Fictional Bullshit
			return 60;
	}
	
	//
	return 0;
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

//
function celestial_unit_add_subunit(celestial_unit, celestial_subunit)
{
	//
	array_push(celestial_unit.sub_units, celestial_subunit);
	
	//
	celestial_subunit.unit_instance = celestial_unit;
}

