// Celestial Unit Enums
enum CelestialUnitTerrainType
{
	Terrestrial,
	Aquatic
}

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

#region Combat Units
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
	
	// Terrain Settings
	unit_terrain_type: CelestialUnitTerrainType.Terrestrial,
	
	// Combat Settings
	unit_combat_mandatory_attendance: false,
	
	unit_combat_column_type: CelestialBattleColumnType.Frontline,
	
	unit_attack_assassination: false,
	
	// Action Settings
	unit_attack_types: [CelestialCombatUnitAction.DefaultFirearm],
	
	// Unit Weapon Animation Settings
	unit_weapon_enabled: true,
	
	unit_weapon_sprite: sOverworld_Unit_William_Firearm,
	
	unit_weapon_pivot_x: 0,
	unit_weapon_pivot_y: -14,
	
	unit_weapon_aim_pivot_x: 3,
	unit_weapon_aim_pivot_y: -16,
	
	unit_weapon_idle_ambient_angle: 0,
	unit_weapon_move_ambient_angle: 45,
	
	unit_weapon_recoil_recovery_spd: 0.1,
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
	
	// Terrain Settings
	unit_terrain_type: CelestialUnitTerrainType.Terrestrial,
	
	// Combat Settings
	unit_combat_mandatory_attendance: false,
	
	unit_combat_column_type: CelestialBattleColumnType.Frontline,
	
	unit_attack_assassination: false,
	
	// Action Settings
	unit_attack_types: [CelestialCombatUnitAction.DefaultTankCannon],
	
	// Unit Weapon Animation Settings
	unit_weapon_enabled: false,
	
	unit_weapon_sprite: noone,
	
	unit_weapon_pivot_x: 8,
	unit_weapon_pivot_y: -11,
	
	unit_weapon_aim_pivot_x: 8,
	unit_weapon_aim_pivot_y: -11,
	
	unit_weapon_idle_ambient_angle: 0,
	unit_weapon_move_ambient_angle: 45,
	
	unit_weapon_recoil_recovery_spd: 0.1,
};
#endregion

#region Combat Actions
// Global Celestial Combat Action Enums
enum CelestialCombatUnitActionType
{
	Attack,
	Support
}

enum CelestialCombatUnitAction
{
	DefaultFirearm,
	DefaultTankCannon,
}

// Global Celestial Combat Actions
global.celestial_combat_unit_actions[CelestialCombatUnitAction.DefaultFirearm] =
{
	// Action Settings
	action_type: CelestialCombatUnitActionType.Attack,
	action_count: 1,
	action_duration: 5.5,
	action_instance: noone,
	
	// Animation Settings
	action_animation_type: CelestialCombatUnitActionAnimationType.Firearm,
	action_animation_count: 3,
};

global.celestial_combat_unit_actions[CelestialCombatUnitAction.DefaultTankCannon] =
{
	// Action Settings
	action_type: CelestialCombatUnitActionType.Attack,
	action_count: 1,
	action_duration: 5.5,
	action_instance: noone,
	
	// Animation Settings
	action_animation_type: CelestialCombatUnitActionAnimationType.TankCannon,
	action_animation_count: 1,
};

// Celestial Unit Action Animations Enum
enum CelestialCombatUnitActionAnimationType
{
	Firearm,
	TankCannon
}

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

#region Faction Methods
/// @function celestial_unit_join_faction(celestial_faction, celestial_unit);
/// @description Adds the given Celestial Unit to the Celestial Faction
/// @param {real:Id.Instance<oCelestialFaction>} celestial_faction The Celestial Faction the Celestial Unit is joining
/// @param {real:Id.Instance<oCelestialUnit>} celestial_unit The Celestial Unit joining the Celestial Faction
function celestial_unit_join_faction(celestial_unit, celestial_faction)
{
	// Check if the given Celestial Unit already belongs to a Celestial Faction
	if (instance_exists(celestial_unit.unit_faction))
	{
		// Remove the Celestial Unit from its previous Celestial Faction
		celestial_unit_leave_faction(celestial_unit);
	}
	
	// Check if Celestial Faction already has the given Celestial Unit
	if (!array_contains(celestial_faction.units, celestial_unit))
	{
		// Add the Celestial Unit to the Celestial Faction's Units Array
		array_push(celestial_faction.units, celestial_unit);
		
		// Update Celestial Unit's Faction
		celestial_unit.unit_faction = celestial_faction;
	}
}

/// @function celestial_unit_leave_faction(celestial_unit);
/// @description Removes the given Celestial Unit from their Celestial Faction
/// @param {real:Id.Instance<oCelestialUnit>} celestial_unit The Celestial Unit leaving their Celestial Faction
function celestial_unit_leave_faction(celestial_unit)
{
	// Find the Index of the given Celestial Unit within the Celestial Faction's Units Array
	var temp_celestial_unit_index = array_find_index(celestial_unit.unit_faction.units, celestial_unit);
	
	// Check if the given Celestial Unit exists within the Celestial Faction's Units Array
	if (temp_celestial_unit_index != -1)
	{
		// Delete the Celestial Unit from the given Celestial Faction's Units Array
		array_delete(celestial_unit.unit_faction.units, temp_celestial_unit_index, 1);
		
		// Remove Celestial Unit's Faction
		celestial_unit.unit_faction = noone;
	}
}
#endregion

// Combat Methods
/// @function celestial_unit_add_combat_unit(celestial_unit, combat_unit_type);
/// @description Adds a Combat Unit to the given Celestial Unit
/// @param {real:Id.Instance<oCelestialUnit>} celestial_unit The Celestial Unit to add a Combat Unit to
/// @param {int<CelestialCombatUnitTypes>} combat_unit_type The Combat Unit Type of the Combat Unit to add to the given Celestial Unit
function celestial_unit_add_combat_unit(celestial_unit, combat_unit_type)
{
	// Check if Combat Unit Type is eligible to be added to the given Celestial Unit based on their shared Terrain Type
	if (celestial_unit.unit_terrain_type != global.celestial_combat_units[combat_unit_type].unit_terrain_type)
	{
		// Incompatible Combat Unit Type with given Celestial Unit - Return False
		return false;
	}
	
	// Check if Celestial Unit has the space to allow the given Combat Unit Type to join
	switch (global.celestial_combat_units[combat_unit_type].unit_combat_column_type)
	{
		case CelestialBattleColumnType.Frontline:
			// Calculate Total Frontline Combat Units in the Celestial Unit
			var temp_total_frontline_combat_units_count = array_length(celestial_unit.frontline_combat_unit_engaged) + array_length(celestial_unit.frontline_combat_unit_unengaged);
			
			// Check if Celestial Unit has the space to add the Combat Unit
			if (temp_total_frontline_combat_units_count >= celestial_unit.unit_frontline_combat_units_max)
			{
				// Celestial Unit does not have the space to add the given Combat Unit - Early Return
				return;
			}
			break;
		case CelestialBattleColumnType.Midline:
			// Calculate Total Midline Combat Units in the Celestial Unit
			var temp_total_midline_combat_units_count = array_length(celestial_unit.midline_combat_unit_engaged) + array_length(celestial_unit.midline_combat_unit_unengaged);
			
			// Check if Celestial Unit has the space to add the Combat Unit
			if (temp_total_midline_combat_units_count >= celestial_unit.unit_midline_combat_units_max)
			{
				// Celestial Unit does not have the space to add the given Combat Unit - Early Return
				return;
			}
			break;
		case CelestialBattleColumnType.Backline:
			// Calculate Total Backline Combat Units in the Celestial Unit
			var temp_total_backline_combat_units_count = array_length(celestial_unit.backline_combat_unit_engaged) + array_length(celestial_unit.backline_combat_unit_unengaged);
			
			// Check if Celestial Unit has the space to add the Combat Unit
			if (temp_total_backline_combat_units_count >= celestial_unit.unit_backline_combat_units_max)
			{
				// Celestial Unit does not have the space to add the given Combat Unit - Early Return
				return;
			}
			break;
		default:
			break;
	}
	
	// Initialize Empty Combat Unit Instance
	var temp_combat_unit_instance = instance_create_depth(0, 0, 0, oCelestialCombatUnit);
	
	// Set Combat Unit's Properties from Combat Unit Type
	temp_combat_unit_instance.combat_unit_type = combat_unit_type;
	temp_combat_unit_instance.combat_unit_health = global.celestial_combat_units[combat_unit_type].unit_health;
	
	// Index Combat Unit Instance within Celestial Unit's Combat Units Array
	array_push(celestial_unit.combat_units, temp_combat_unit_instance);
	
	// Add Combat Unit Instance to Celestial Unit's Combat Unit Arrays based on Combat Unit's Combat Column Type
	switch (global.celestial_combat_units[combat_unit_type].unit_combat_column_type)
	{
		case CelestialBattleColumnType.Frontline:
			// Find Index of Combat Unit Type in Frontline Combat
			var temp_combat_unit_type_frontline_index = array_get_index(celestial_unit.frontline_combat_unit_type, combat_unit_type);
			
			// Check if Combat Unit Type has already been indexed within the Celestial Unit Instance's Frontline Combat Unit Arrays
			if (temp_combat_unit_type_frontline_index != -1)
			{
				// Increment Combat Unit Type's Total Instances Count
				var temp_frontline_combat_unit_count = array_get(celestial_unit.frontline_combat_unit_count, temp_combat_unit_type_frontline_index);
				array_set(celestial_unit.frontline_combat_unit_count, temp_combat_unit_type_frontline_index, temp_frontline_combat_unit_count + 1);
				
				// Increment Combat Unit Type's Unengaged Instances Count
				var temp_frontline_combat_unit_unengaged_count = array_get(celestial_unit.frontline_combat_unit_unengaged_count, temp_combat_unit_type_frontline_index);
				array_set(celestial_unit.frontline_combat_unit_unengaged_count, temp_combat_unit_type_frontline_index, temp_frontline_combat_unit_unengaged_count + 1);
				
				// Add Combat Unit Instance to Combat Unit Type's Instances Array
				array_push(array_get(celestial_unit.frontline_combat_unit_instances, temp_combat_unit_type_frontline_index), temp_combat_unit_instance);
				
				// Add Combat Unit Instance to Frontline's Unengaged Combat Units Array
				array_push(celestial_unit.frontline_combat_unit_unengaged, temp_combat_unit_instance);
			}
			else
			{
				// Add new Combat Unit Type to Celestial Unit Instance's Frontline Combat Unit Type Array
				array_push(celestial_unit.frontline_combat_unit_type, combat_unit_type);
				
				// Increment Combat Unit Type's Total Instances Count
				array_push(celestial_unit.frontline_combat_unit_count, 1);
				
				// Increment Combat Unit Type's Unengaged Instances Count
				array_push(celestial_unit.frontline_combat_unit_unengaged_count, 1);
				
				// Add Combat Unit Instance to Combat Unit Type's Instances Array
				var temp_new_frontline_combat_unit_instances_array = array_create(0);
				array_push(temp_new_frontline_combat_unit_instances_array, temp_combat_unit_instance);
				array_push(celestial_unit.frontline_combat_unit_instances, temp_new_frontline_combat_unit_instances_array);
				
				// Add Combat Unit Instance to Frontline's Unengaged Combat Units Array
				array_push(celestial_unit.frontline_combat_unit_unengaged, temp_combat_unit_instance);
			}
			break;
		case CelestialBattleColumnType.Midline:
			// Find Index of Combat Unit Type in Midline Combat
			var temp_combat_unit_type_midline_index = array_get_index(celestial_unit.midline_combat_unit_type, combat_unit_type);
			
			// Check if Combat Unit Type has already been indexed within the Celestial Unit Instance's Midline Combat Unit Arrays
			if (temp_combat_unit_type_midline_index != -1)
			{
				// Increment Combat Unit Type's Total Instances Count
				var temp_midline_combat_unit_count = array_get(celestial_unit.midline_combat_unit_count, temp_combat_unit_type_midline_index);
				array_set(celestial_unit.midline_combat_unit_count, temp_combat_unit_type_midline_index, temp_midline_combat_unit_count + 1);
				
				// Increment Combat Unit Type's Unengaged Instances Count
				var temp_midline_combat_unit_unengaged_count = array_get(celestial_unit.midline_combat_unit_unengaged_count, temp_combat_unit_type_midline_index);
				array_set(celestial_unit.midline_combat_unit_unengaged_count, temp_combat_unit_type_midline_index, temp_midline_combat_unit_unengaged_count + 1);
				
				// Add Combat Unit Instance to Combat Unit Type's Instances Array
				array_push(array_get(celestial_unit.midline_combat_unit_instances, temp_combat_unit_type_midline_index), temp_combat_unit_instance);
				
				// Add Combat Unit Instance to Midline's Unengaged Combat Units Array
				array_push(celestial_unit.midline_combat_unit_unengaged, temp_combat_unit_instance);
			}
			else
			{
				// Add new Combat Unit Type to Celestial Unit Instance's Midline Combat Unit Type Array
				array_push(celestial_unit.midline_combat_unit_type, combat_unit_type);
				
				// Increment Combat Unit Type's Total Instances Count
				array_push(celestial_unit.midline_combat_unit_count, 1);
				
				// Increment Combat Unit Type's Unengaged Instances Count
				array_push(celestial_unit.midline_combat_unit_unengaged_count, 1);
				
				// Add Combat Unit Instance to Combat Unit Type's Instances Array
				var temp_new_midline_combat_unit_instances_array = array_create(0);
				array_push(temp_new_midline_combat_unit_instances_array, temp_combat_unit_instance);
				array_push(celestial_unit.midline_combat_unit_instances, temp_new_midline_combat_unit_instances_array);
				
				// Add Combat Unit Instance to Midline's Unengaged Combat Units Array
				array_push(celestial_unit.midline_combat_unit_unengaged, temp_combat_unit_instance);
			}
			break;
		case CelestialBattleColumnType.Backline:
			// Find Index of Combat Unit Type in Backline Combat
			var temp_combat_unit_type_backline_index = array_get_index(celestial_unit.backline_combat_unit_type, combat_unit_type);
			
			// Check if Combat Unit Type has already been indexed within the Celestial Unit Instance's Backline Combat Unit Arrays
			if (temp_combat_unit_type_backline_index != -1)
			{
				// Increment Combat Unit Type's Total Instances Count
				var temp_backline_combat_unit_count = array_get(celestial_unit.backline_combat_unit_count, temp_combat_unit_type_backline_index);
				array_set(celestial_unit.backline_combat_unit_count, temp_combat_unit_type_backline_index, temp_backline_combat_unit_count + 1);
				
				// Increment Combat Unit Type's Unengaged Instances Count
				var temp_backline_combat_unit_unengaged_count = array_get(celestial_unit.backline_combat_unit_unengaged_count, temp_combat_unit_type_backline_index);
				array_set(celestial_unit.backline_combat_unit_unengaged_count, temp_combat_unit_type_backline_index, temp_backline_combat_unit_unengaged_count + 1);
				
				// Add Combat Unit Instance to Combat Unit Type's Instances Array
				array_push(array_get(celestial_unit.backline_combat_unit_instances, temp_combat_unit_type_backline_index), temp_combat_unit_instance);
				
				// Add Combat Unit Instance to Backline's Unengaged Combat Units Array
				array_push(celestial_unit.backline_combat_unit_unengaged, temp_combat_unit_instance);
			}
			else
			{
				// Add new Combat Unit Type to Celestial Unit Instance's Backline Combat Unit Type Array
				array_push(celestial_unit.backline_combat_unit_type, combat_unit_type);
				
				// Increment Combat Unit Type's Total Instances Count
				array_push(celestial_unit.backline_combat_unit_count, 1);
				
				// Increment Combat Unit Type's Unengaged Instances Count
				array_push(celestial_unit.backline_combat_unit_unengaged_count, 1);
				
				// Add Combat Unit Instance to Combat Unit Type's Instances Array
				var temp_new_backline_combat_unit_instances_array = array_create(0);
				array_push(temp_new_backline_combat_unit_instances_array, temp_combat_unit_instance);
				array_push(celestial_unit.backline_combat_unit_instances, temp_new_backline_combat_unit_instances_array);
				
				// Add Combat Unit Instance to Backline's Unengaged Combat Units Array
				array_push(celestial_unit.backline_combat_unit_unengaged, temp_combat_unit_instance);
			}
			break;
		default:
			break;
	}
	
	// Set Combat Unit Instance's Unit Instance
	temp_combat_unit_instance.unit_instance = celestial_unit;
	
	// Compatible Combat Unit Type with given Celestial Unit - Return True
	return true;
}

/// @function celestial_unit_remove_combat_unit(celestial_unit, celestial_combat_unit);
/// @description Removes the given Combat Unit Instance from the given Celestial Unit
/// @param {real:Id.Instance<oCelestialUnit>} celestial_unit The Celestial Unit Instance to remove the Combat Unit from
/// @param {real:Id.Instance<oCelestialCombatUnit>} celestial_combat_unit The Combat Unit Instance to remove from the Celestial Unit
function celestial_unit_remove_combat_unit(celestial_unit, celestial_combat_unit)
{
	// Find Combat Unit's Type
	var temp_combat_unit_type = celestial_combat_unit.combat_unit_type;
	
	// Find Combat Unit's Array Index within Celestial Unit's Combat Units Array
	var temp_combat_unit_array_index = array_get_index(celestial_unit.combat_units, celestial_combat_unit);
	
	// Check if Combat Unit was indexed within the Celestial Unit's Combat Units Arrays
	if (temp_combat_unit_array_index == -1)
	{
		// Combat Unit was not indexed within the Celestial Unit - Early Return
		return;
	}
	
	// Delete Combat Unit from Celestial Unit Instance's Combat Units Array
	array_delete(celestial_unit.combat_units, temp_combat_unit_array_index, 1);
	
	// Remove Combat Unit Instance from Celestial Unit's Combat Unit Arrays based on Combat Unit's Combat Column Type
	switch (global.celestial_combat_units[combat_unit_type].unit_combat_column_type)
	{
		case CelestialBattleColumnType.Frontline:
			// Find Combat Unit's Type Index within the Celestial Unit's Frontline Combat Unit Arrays
			var temp_frontline_combat_unit_type_index = array_get_index(celestial_unit.frontline_combat_unit_type, temp_combat_unit_type);
			
			// Check if Combat Unit is Indexed in the Celestial Unit's Frontline Combat Unit Arrays
			if (temp_frontline_combat_unit_type_index != -1)
			{
				// Attempt to remove the Combat Unit from the Unengaged Combat Unit Array
				var temp_frontline_combat_unit_unengaged_index = array_get_index(celestial_unit.frontline_combat_unit_unengaged, celestial_combat_unit);
				
				if (temp_frontline_combat_unit_unengaged_index != -1)
				{
					array_delete(celestial_unit.frontline_combat_unit_unengaged, temp_frontline_combat_unit_unengaged_index, 1);
				}
				
				// Attempt to remove the Combat Unit from the Engaged Combat Unit Array
				var temp_frontline_combat_unit_engaged_index = array_get_index(celestial_unit.frontline_combat_unit_engaged, celestial_combat_unit);
				
				if (temp_frontline_combat_unit_engaged_index != -1)
				{
					array_delete(celestial_unit.frontline_combat_unit_engaged, temp_frontline_combat_unit_engaged_index, 1);
				}
				
				// Find the Combat Unit's Type Instance Array
				var temp_frontline_combat_unit_instance_array = array_get(celestial_unit.frontline_combat_unit_instances, temp_frontline_combat_unit_type_index);
				
				// Find the Combat Unit Instance's Index within the Combat Unit's Type Instance Array
				var temp_frontline_combat_unit_instance_index = array_get_index(temp_frontline_combat_unit_instance_array, celestial_combat_unit);
				
				// Attempt to remove the Combat Unit Instance from the Combat Unit's Type Instance Array
				if (temp_frontline_combat_unit_instance_index != -1)
				{
					// Delete the Combat Unit Instance from the Combat Unit's Type Instance Array
					array_delete(temp_frontline_combat_unit_instance_array, temp_frontline_combat_unit_instance_index, 1);
					
					// Decrement Combat Unit Type's Total Instances Count
					var temp_frontline_combat_unit_count = array_get(celestial_unit.frontline_combat_unit_count, temp_frontline_combat_unit_type_index);
					array_set(celestial_unit.frontline_combat_unit_count, temp_frontline_combat_unit_type_index, temp_frontline_combat_unit_count - 1);
					
					// Check if Combat Unit was indexed in the Unengaged Combat Units Array
					if (temp_frontline_combat_unit_unengaged_index != -1)
					{
						// Decrement Combat Unit Type's Unengaged Instances Count
						var temp_frontline_combat_unit_unengaged_count = array_get(celestial_unit.frontline_combat_unit_unengaged_count, temp_frontline_combat_unit_type_index);
						array_set(celestial_unit.frontline_combat_unit_unengaged_count, temp_frontline_combat_unit_type_index, temp_frontline_combat_unit_unengaged_count - 1);
					}
				}
				
				// Check if there are any remaining Combat Unit Instances in the Combat Unit Instances Array
				if (array_length(temp_frontline_combat_unit_instance_array) < 1)
				{
					// Delete Combat Unit Type from Celestial Unit's Combat Unit Arrays
					array_delete(celestial_unit.frontline_combat_unit_type, temp_frontline_combat_unit_type_index, 1);
					array_delete(celestial_unit.frontline_combat_unit_instances, temp_frontline_combat_unit_type_index, 1);
					array_delete(celestial_unit.frontline_combat_unit_count, temp_frontline_combat_unit_type_index, 1);
					array_delete(celestial_unit.frontline_combat_unit_unengaged_count, temp_frontline_combat_unit_type_index, 1);
				}
			}
			break;
		case CelestialBattleColumnType.Midline:
			// Find Combat Unit's Type Index within the Celestial Unit's Midline Combat Unit Arrays
			var temp_midline_combat_unit_type_index = array_get_index(celestial_unit.midline_combat_unit_type, temp_combat_unit_type);
			
			// Check if Combat Unit is Indexed in the Celestial Unit's Midline Combat Unit Arrays
			if (temp_midline_combat_unit_type_index != -1)
			{
				// Attempt to remove the Combat Unit from the Unengaged Combat Unit Array
				var temp_midline_combat_unit_unengaged_index = array_get_index(celestial_unit.midline_combat_unit_unengaged, celestial_combat_unit);
				
				if (temp_midline_combat_unit_unengaged_index != -1)
				{
					array_delete(celestial_unit.midline_combat_unit_unengaged, temp_midline_combat_unit_unengaged_index, 1);
				}
				
				// Attempt to remove the Combat Unit from the Engaged Combat Unit Array
				var temp_midline_combat_unit_engaged_index = array_get_index(celestial_unit.midline_combat_unit_engaged, celestial_combat_unit);
				
				if (temp_midline_combat_unit_engaged_index != -1)
				{
					array_delete(celestial_unit.midline_combat_unit_engaged, temp_midline_combat_unit_engaged_index, 1);
				}
				
				// Find the Combat Unit's Type Instance Array
				var temp_midline_combat_unit_instance_array = array_get(celestial_unit.midline_combat_unit_instances, temp_midline_combat_unit_type_index);
				
				// Find the Combat Unit Instance's Index within the Combat Unit's Type Instance Array
				var temp_midline_combat_unit_instance_index = array_get_index(temp_midline_combat_unit_instance_array, celestial_combat_unit);
				
				// Attempt to remove the Combat Unit Instance from the Combat Unit's Type Instance Array
				if (temp_midline_combat_unit_instance_index != -1)
				{
					// Delete the Combat Unit Instance from the Combat Unit's Type Instance Array
					array_delete(temp_midline_combat_unit_instance_array, temp_midline_combat_unit_instance_index, 1);
					
					// Decrement Combat Unit Type's Total Instances Count
					var temp_midline_combat_unit_count = array_get(celestial_unit.midline_combat_unit_count, temp_midline_combat_unit_type_index);
					array_set(celestial_unit.midline_combat_unit_count, temp_midline_combat_unit_type_index, temp_midline_combat_unit_count - 1);
					
					// Check if Combat Unit was indexed in the Unengaged Combat Units Array
					if (temp_midline_combat_unit_unengaged_index != -1)
					{
						// Decrement Combat Unit Type's Unengaged Instances Count
						var temp_midline_combat_unit_unengaged_count = array_get(celestial_unit.midline_combat_unit_unengaged_count, temp_midline_combat_unit_type_index);
						array_set(celestial_unit.midline_combat_unit_unengaged_count, temp_midline_combat_unit_type_index, temp_midline_combat_unit_unengaged_count - 1);
					}
				}
				
				// Check if there are any remaining Combat Unit Instances in the Combat Unit Instances Array
				if (array_length(temp_midline_combat_unit_instance_array) < 1)
				{
					// Delete Combat Unit Type from Celestial Unit's Combat Unit Arrays
					array_delete(celestial_unit.midline_combat_unit_type, temp_midline_combat_unit_type_index, 1);
					array_delete(celestial_unit.midline_combat_unit_instances, temp_midline_combat_unit_type_index, 1);
					array_delete(celestial_unit.midline_combat_unit_count, temp_midline_combat_unit_type_index, 1);
					array_delete(celestial_unit.midline_combat_unit_unengaged_count, temp_midline_combat_unit_type_index, 1);
				}
			}
			break;
		case CelestialBattleColumnType.Backline:
			// Find Combat Unit's Type Index within the Celestial Unit's Backline Combat Unit Arrays
			var temp_backline_combat_unit_type_index = array_get_index(celestial_unit.backline_combat_unit_type, temp_combat_unit_type);
			
			// Check if Combat Unit is Indexed in the Celestial Unit's Backline Combat Unit Arrays
			if (temp_backline_combat_unit_type_index != -1)
			{
				// Attempt to remove the Combat Unit from the Unengaged Combat Unit Array
				var temp_backline_combat_unit_unengaged_index = array_get_index(celestial_unit.backline_combat_unit_unengaged, celestial_combat_unit);
				
				if (temp_backline_combat_unit_unengaged_index != -1)
				{
					array_delete(celestial_unit.backline_combat_unit_unengaged, temp_backline_combat_unit_unengaged_index, 1);
				}
				
				// Attempt to remove the Combat Unit from the Engaged Combat Unit Array
				var temp_backline_combat_unit_engaged_index = array_get_index(celestial_unit.backline_combat_unit_engaged, celestial_combat_unit);
				
				if (temp_backline_combat_unit_engaged_index != -1)
				{
					array_delete(celestial_unit.backline_combat_unit_engaged, temp_backline_combat_unit_engaged_index, 1);
				}
				
				// Find the Combat Unit's Type Instance Array
				var temp_backline_combat_unit_instance_array = array_get(celestial_unit.backline_combat_unit_instances, temp_backline_combat_unit_type_index);
				
				// Find the Combat Unit Instance's Index within the Combat Unit's Type Instance Array
				var temp_backline_combat_unit_instance_index = array_get_index(temp_backline_combat_unit_instance_array, celestial_combat_unit);
				
				// Attempt to remove the Combat Unit Instance from the Combat Unit's Type Instance Array
				if (temp_backline_combat_unit_instance_index != -1)
				{
					// Delete the Combat Unit Instance from the Combat Unit's Type Instance Array
					array_delete(temp_backline_combat_unit_instance_array, temp_backline_combat_unit_instance_index, 1);
					
					// Decrement Combat Unit Type's Total Instances Count
					var temp_backline_combat_unit_count = array_get(celestial_unit.backline_combat_unit_count, temp_backline_combat_unit_type_index);
					array_set(celestial_unit.backline_combat_unit_count, temp_backline_combat_unit_type_index, temp_backline_combat_unit_count - 1);
					
					// Check if Combat Unit was indexed in the Unengaged Combat Units Array
					if (temp_backline_combat_unit_unengaged_index != -1)
					{
						// Decrement Combat Unit Type's Unengaged Instances Count
						var temp_backline_combat_unit_unengaged_count = array_get(celestial_unit.backline_combat_unit_unengaged_count, temp_backline_combat_unit_type_index);
						array_set(celestial_unit.backline_combat_unit_unengaged_count, temp_backline_combat_unit_type_index, temp_backline_combat_unit_unengaged_count - 1);
					}
				}
				
				// Check if there are any remaining Combat Unit Instances in the Combat Unit Instances Array
				if (array_length(temp_backline_combat_unit_instance_array) < 1)
				{
					// Delete Combat Unit Type from Celestial Unit's Combat Unit Arrays
					array_delete(celestial_unit.backline_combat_unit_type, temp_backline_combat_unit_type_index, 1);
					array_delete(celestial_unit.backline_combat_unit_instances, temp_backline_combat_unit_type_index, 1);
					array_delete(celestial_unit.backline_combat_unit_count, temp_backline_combat_unit_type_index, 1);
					array_delete(celestial_unit.backline_combat_unit_unengaged_count, temp_backline_combat_unit_type_index, 1);
				}
			}
			break;
		default:
			break;
	}
}

// Status Effect Methods
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

function celestial_unit_remove_status_effect(celestial_unit, status_effect_type)
{
	//
	var temp_status_effect_index = array_get_index(celestial_unit.status_effect_array, status_effect_type);
	
	//
	if (temp_status_effect_index != -1)
	{
		//
		celestial_unit.status_effect_duration_array = 0;
	}
}

function celestial_unit_check_status_effect(celestial_unit, status_effect_type)
{
	//
	return array_get_index(celestial_unit.status_effect_array, status_effect_type) != -1;
}



