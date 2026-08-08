// Global Celestial Battle Properties
#macro CelestialBattleCombatGridColumns 10
#macro CelestialBattleCombatGridRows 10

global.celestial_battle_combat_grid_column_type[0] = CelestialBattleColumnType.Frontline;
global.celestial_battle_combat_grid_column_type[1] = CelestialBattleColumnType.Frontline;
global.celestial_battle_combat_grid_column_type[2] = CelestialBattleColumnType.Frontline;
global.celestial_battle_combat_grid_column_type[3] = CelestialBattleColumnType.Frontline;
global.celestial_battle_combat_grid_column_type[4] = CelestialBattleColumnType.Frontline;
global.celestial_battle_combat_grid_column_type[5] = CelestialBattleColumnType.Midline;
global.celestial_battle_combat_grid_column_type[6] = CelestialBattleColumnType.Midline;
global.celestial_battle_combat_grid_column_type[7] = CelestialBattleColumnType.Midline;
global.celestial_battle_combat_grid_column_type[8] = CelestialBattleColumnType.Backline;
global.celestial_battle_combat_grid_column_type[9] = CelestialBattleColumnType.Backline;

global.celestial_battle_exit_stage_animation_mult = 1.5;
global.celestial_battle_exit_stage_animation_spd = 0.02;
global.celestial_battle_exit_stage_animation_movement_distance = 32;

// Battle Enums
enum CelestialBattleColumnType
{
	Frontline,
	Midline,
	Backline
}

enum CelestialBattlePlatformSide
{
	Left,
	None,
	Right
}

enum CelestialBattleChoreographyObjectType
{
	Actor,
	Prop,
	LinearProjectile,
	ArcProjectile,
	SmokeParticle
}

// Celestial Battle Sorting Functions
/// @function celestial_battle_create(celestial_object);
/// @description Creates and returns a Celestial Battle Instance within the Celestial Simulation with the given Celestial Object Instance
/// @param {real:Id.Instance} celestial_object The Celestial Object Instance the Celestial Battle will belong to
/// @returns {real:Id.Instance} Returns a Celestial Battle Instance
function celestial_battle_create(celestial_object)
{
	// Create Celestial Battle Instance
	var temp_celestial_battle_instance = instance_create_depth(0, 0, 0, oCelestialBattle);
	
	// Update Celestial Battle's Celestial Body Instance
	temp_celestial_battle_instance.celestial_body_instance = celestial_object;
	
	// Calculate Combat Engagement Threshold
	temp_celestial_battle_instance.battle_near_collision_threshold = cos(temp_celestial_battle_instance.battle_near_collision_radius / celestial_object.radius);
	temp_celestial_battle_instance.battle_far_collision_threshold = cos(temp_celestial_battle_instance.battle_far_collision_radius / celestial_object.radius);
	
	// Index Celestial Battle Instance in Celestial Object Battle Array
	array_push(celestial_object.battles, temp_celestial_battle_instance);
	
	// Return Celestial Battle Instance
	return temp_celestial_battle_instance;
}

function celestial_battle_end(celestial_battle)
{
	
}

/// @function celestial_battle_add_primary_units(battle_instance, unit_instance_a, unit_instance_b);
/// @description Creates and returns a Celestial Battle Instance within the Celestial Simulation with the given Celestial Object Instance
/// @param {real:Id.Instance<oCelestialUnit>} unit_instance_a The Celestial Object Instance the Celestial Battle will belong to
/// @param {real:Id.Instance<oCelestialUnit>} unit_instance_b The Celestial Object Instance the Celestial Battle will belong to
function celestial_battle_add_primary_units(battle_instance, unit_instance_a, unit_instance_b)
{
	// Battle Unit Sorting Behaviour
	var temp_first_unit = unit_instance_a;
	var temp_second_unit = unit_instance_b;
	
	if (unit_instance_b.unit_faction == CelestialSimulator.player_faction)
	{
		temp_first_unit = unit_instance_b;
		temp_second_unit = unit_instance_a;
	}
	else if (unit_instance_a.unit_faction != CelestialSimulator.player_faction and random(1.0) > 0.5)
	{
		temp_first_unit = unit_instance_b;
		temp_second_unit = unit_instance_a;
	}
	
	// Set Battle's Primary Units and Factions
	battle_instance.battle_faction_a = temp_first_unit.unit_faction;
	battle_instance.battle_primary_unit_a = temp_first_unit;
	
	battle_instance.battle_faction_b = temp_second_unit.unit_faction;
	battle_instance.battle_primary_unit_b = temp_second_unit;
	
	// Iterate through Primary Unit's Combat Unit Arrays and add all possible Combat Units to Battle's Combat Grid
	var temp_first_unit_can_add_units = true;
	var temp_second_unit_can_add_units = true;
	
	while (temp_first_unit_can_add_units or temp_second_unit_can_add_units)
	{
		// Check if the First Unit can add Combat Units to Combat Grid
		if (temp_first_unit_can_add_units)
		{
			// Check Combat Grid Column Types for available slots for the First Unit's Combat Units
			if (battle_instance.battle_frontline_available_slots_count_a > 0 and temp_first_unit.frontline_combat_unit_unengaged_count > 0)
			{
				// Find random Unengaged Frontline Combat Unit from the First Unit
				var temp_random_frontline_combat_unit_index_a = irandom(temp_first_unit.frontline_combat_unit_unengaged_count - 1);
				var temp_random_frontline_combat_unit_instance_a = array_get(temp_first_unit.frontline_combat_unit_unengaged, temp_random_frontline_combat_unit_index_a);
				
				// Move Selected Combat Unit from Unengaged Array to Engaged Array
				temp_first_unit.frontline_combat_unit_unengaged_count--;
				array_delete(temp_first_unit.frontline_combat_unit_unengaged, temp_random_frontline_combat_unit_index_a, 1);
				array_push(temp_first_unit.frontline_combat_unit_engaged, temp_random_frontline_combat_unit_instance_a);
				
				// Add Selected Combat Unit to Battle's Combat Units Pool
				array_insert(battle_instance.battle_combat_units, 0, temp_random_frontline_combat_unit_instance_a);
				
				// Add Selected Combat Unit to Battle's Faction & Frontline Combat Unit Pools
				array_push(battle_instance.battle_combat_units_a, temp_random_frontline_combat_unit_instance_a);
				array_push(battle_instance.battle_frontline_combat_units_a, temp_random_frontline_combat_unit_instance_a);
				
				// Find random Available Slot in the Combat Grid's Frontline
				var temp_random_frontline_combat_grid_available_slot_index_a = irandom(battle_instance.battle_frontline_available_slots_count_a - 1);
				var temp_random_frontline_combat_grid_available_slot_a = array_get(battle_instance.battle_frontline_available_slots_a, temp_random_frontline_combat_grid_available_slot_index_a);
				
				// Remove Available Slot from Available Slot Array
				battle_instance.battle_frontline_available_slots_count_a--;
				array_delete(battle_instance.battle_frontline_available_slots_a, temp_random_frontline_combat_grid_available_slot_index_a, 1);
				
				// Set Selected Combat Unit's Column and Row from Available Slot Index
				temp_random_frontline_combat_unit_instance_a.combat_grid_column = temp_random_frontline_combat_grid_available_slot_index_a div CelestialBattleCombatGridColumns;
				temp_random_frontline_combat_unit_instance_a.combat_grid_row = temp_random_frontline_combat_grid_available_slot_index_a mod CelestialBattleCombatGridRows;
				
				// Place Selected Combat Unit in the Combat Grid's Available Slot
				array_set(array_get(battle_instance.battle_combat_grid_a, temp_random_frontline_combat_unit_instance_a.combat_grid_column), temp_random_frontline_combat_unit_instance_a.combat_grid_row, temp_random_frontline_combat_unit_instance_a);
				array_push(array_get(battle_instance.battle_combat_grid_instances_a, temp_random_frontline_combat_unit_instance_a.combat_grid_column), temp_random_frontline_combat_unit_instance_a);
			}
			else if (battle_instance.battle_midline_available_slots_count_a > 0 and temp_first_unit.midline_combat_unit_unengaged_count > 0)
			{
				// Find random Unengaged Midline Combat Unit from the First Unit
				var temp_random_midline_combat_unit_index_a = irandom(temp_first_unit.midline_combat_unit_unengaged_count - 1);
				var temp_random_midline_combat_unit_instance_a = array_get(temp_first_unit.midline_combat_unit_unengaged, temp_random_midline_combat_unit_index_a);
				
				// Move Selected Combat Unit from Unengaged Array to Engaged Array
				temp_first_unit.midline_combat_unit_unengaged_count--;
				array_delete(temp_first_unit.midline_combat_unit_unengaged, temp_random_midline_combat_unit_index_a, 1);
				array_push(temp_first_unit.midline_combat_unit_engaged, temp_random_midline_combat_unit_instance_a);
				
				// Add Selected Combat Unit to Battle's Combat Units Pool
				array_insert(battle_instance.battle_combat_units, 0, temp_random_midline_combat_unit_instance_a);
				
				// Add Selected Combat Unit to Battle's Faction & Midline Combat Unit Pools
				array_push(battle_instance.battle_combat_units_a, temp_random_midline_combat_unit_instance_a);
				array_push(battle_instance.battle_midline_combat_units_a, temp_random_midline_combat_unit_instance_a);
				
				// Find random Available Slot in the Combat Grid's Midline
				var temp_random_midline_combat_grid_available_slot_index_a = irandom(battle_instance.battle_midline_available_slots_count_a - 1);
				var temp_random_midline_combat_grid_available_slot_a = array_get(battle_instance.battle_midline_available_slots_a, temp_random_midline_combat_grid_available_slot_index_a);
				
				// Remove Available Slot from Available Slot Array
				battle_instance.battle_midline_available_slots_count_a--;
				array_delete(battle_instance.battle_midline_available_slots_a, temp_random_midline_combat_grid_available_slot_index_a, 1);
				
				// Set Selected Combat Unit's Column and Row from Available Slot Index
				temp_random_midline_combat_unit_instance_a.combat_grid_column = temp_random_midline_combat_grid_available_slot_index_a div CelestialBattleCombatGridColumns;
				temp_random_midline_combat_unit_instance_a.combat_grid_row = temp_random_midline_combat_grid_available_slot_index_a mod CelestialBattleCombatGridRows;
				
				// Place Selected Combat Unit in the Combat Grid's Available Slot
				array_set(array_get(battle_instance.battle_combat_grid_a, temp_random_midline_combat_unit_instance_a.combat_grid_column), temp_random_midline_combat_unit_instance_a.combat_grid_row, temp_random_midline_combat_unit_instance_a);
				array_push(array_get(battle_instance.battle_combat_grid_instances_a, temp_random_midline_combat_unit_instance_a.combat_grid_column), temp_random_midline_combat_unit_instance_a);
			}
			else if (battle_instance.battle_backline_available_slots_count_a > 0 and temp_first_unit.backline_combat_unit_unengaged_count > 0)
			{
				// Find random Unengaged Backline Combat Unit from the First Unit
				var temp_random_backline_combat_unit_index_a = irandom(temp_first_unit.backline_combat_unit_unengaged_count - 1);
				var temp_random_backline_combat_unit_instance_a = array_get(temp_first_unit.backline_combat_unit_unengaged, temp_random_backline_combat_unit_index_a);
				
				// Move Selected Combat Unit from Unengaged Array to Engaged Array
				temp_first_unit.backline_combat_unit_unengaged_count--;
				array_delete(temp_first_unit.backline_combat_unit_unengaged, temp_random_backline_combat_unit_index_a, 1);
				array_push(temp_first_unit.backline_combat_unit_engaged, temp_random_backline_combat_unit_instance_a);
				
				// Add Selected Combat Unit to Battle's Combat Units Pool
				array_insert(battle_instance.battle_combat_units, 0, temp_random_backline_combat_unit_instance_a);
				
				// Add Selected Combat Unit to Battle's Faction & Backline Combat Unit Pools
				array_push(battle_instance.battle_combat_units_a, temp_random_backline_combat_unit_instance_a);
				array_push(battle_instance.battle_backline_combat_units_a, temp_random_backline_combat_unit_instance_a);
				
				// Find random Available Slot in the Combat Grid's Backline
				var temp_random_backline_combat_grid_available_slot_index_a = irandom(battle_instance.battle_backline_available_slots_count_a - 1);
				var temp_random_backline_combat_grid_available_slot_a = array_get(battle_instance.battle_backline_available_slots_a, temp_random_backline_combat_grid_available_slot_index_a);
				
				// Remove Available Slot from Available Slot Array
				battle_instance.battle_backline_available_slots_count_a--;
				array_delete(battle_instance.battle_backline_available_slots_a, temp_random_backline_combat_grid_available_slot_index_a, 1);
				
				// Set Selected Combat Unit's Column and Row from Available Slot Index
				temp_random_backline_combat_unit_instance_a.combat_grid_column = temp_random_backline_combat_grid_available_slot_index_a div CelestialBattleCombatGridColumns;
				temp_random_backline_combat_unit_instance_a.combat_grid_row = temp_random_backline_combat_grid_available_slot_index_a mod CelestialBattleCombatGridRows;
				
				// Place Selected Combat Unit in the Combat Grid's Available Slot
				array_set(array_get(battle_instance.battle_combat_grid_a, temp_random_backline_combat_unit_instance_a.combat_grid_column), temp_random_backline_combat_unit_instance_a.combat_grid_row, temp_random_backline_combat_unit_instance_a);
				array_push(array_get(battle_instance.battle_combat_grid_instances_a, temp_random_backline_combat_unit_instance_a.combat_grid_column), temp_random_backline_combat_unit_instance_a);
			}
			else
			{
				// There are no more Available Slots on the Combat Grid for the First Unit's Combat Units to occupy or the First Unit has no more available Combat Units to add to the Combat Grid
				temp_first_unit_can_add_units = false;
			}
		}
		
		// Check if the Second Unit can add Combat Units to Combat Grid
		if (temp_second_unit_can_add_units)
		{
			// Check Combat Grid Column Types for available slots for the Second Unit's Combat Units
			if (battle_instance.battle_frontline_available_slots_count_b > 0 and temp_second_unit.frontline_combat_unit_unengaged_count > 0)
			{
				// Find random Unengaged Frontline Combat Unit from the Second Unit
				var temp_random_frontline_combat_unit_index_b = irandom(temp_second_unit.frontline_combat_unit_unengaged_count - 1);
				var temp_random_frontline_combat_unit_instance_b = array_get(temp_second_unit.frontline_combat_unit_unengaged, temp_random_frontline_combat_unit_index_b);
				
				// Move Selected Combat Unit from Unengaged Array to Engaged Array
				temp_second_unit.frontline_combat_unit_unengaged_count--;
				array_delete(temp_second_unit.frontline_combat_unit_unengaged, temp_random_frontline_combat_unit_index_b, 1);
				array_push(temp_second_unit.frontline_combat_unit_engaged, temp_random_frontline_combat_unit_instance_b);
				
				// Add Selected Combat Unit to Battle's Combat Units Pool
				array_insert(battle_instance.battle_combat_units, 0, temp_random_frontline_combat_unit_instance_b);
				
				// Add Selected Combat Unit to Battle's Faction & Frontline Combat Unit Pools
				array_push(battle_instance.battle_combat_units_b, temp_random_frontline_combat_unit_instance_b);
				array_push(battle_instance.battle_frontline_combat_units_b, temp_random_frontline_combat_unit_instance_b);
				
				// Find random Available Slot in the Combat Grid's Frontline
				var temp_random_frontline_combat_grid_available_slot_index_b = irandom(battle_instance.battle_frontline_available_slots_count_b - 1);
				var temp_random_frontline_combat_grid_available_slot_b = array_get(battle_instance.battle_frontline_available_slots_b, temp_random_frontline_combat_grid_available_slot_index_b);
				
				// Remove Available Slot from Available Slot Array
				battle_instance.battle_frontline_available_slots_count_b--;
				array_delete(battle_instance.battle_frontline_available_slots_b, temp_random_frontline_combat_grid_available_slot_index_b, 1);
				
				// Set Selected Combat Unit's Column and Row from Available Slot Index
				temp_random_frontline_combat_unit_instance_b.combat_grid_column = temp_random_frontline_combat_grid_available_slot_index_b div CelestialBattleCombatGridColumns;
				temp_random_frontline_combat_unit_instance_b.combat_grid_row = temp_random_frontline_combat_grid_available_slot_index_b mod CelestialBattleCombatGridRows;
				
				// Place Selected Combat Unit in the Combat Grid's Available Slot
				array_set(array_get(battle_instance.battle_combat_grid_b, temp_random_frontline_combat_unit_instance_b.combat_grid_column), temp_random_frontline_combat_unit_instance_b.combat_grid_row, temp_random_frontline_combat_unit_instance_b);
				array_push(array_get(battle_instance.battle_combat_grid_instances_b, temp_random_frontline_combat_unit_instance_b.combat_grid_column), temp_random_frontline_combat_unit_instance_b);
			}
			else if (battle_instance.battle_midline_available_slots_count_b > 0 and temp_second_unit.midline_combat_unit_unengaged_count > 0)
			{
				// Find random Unengaged Midline Combat Unit from the Second Unit
				var temp_random_midline_combat_unit_index_b = irandom(temp_second_unit.midline_combat_unit_unengaged_count - 1);
				var temp_random_midline_combat_unit_instance_b = array_get(temp_second_unit.midline_combat_unit_unengaged, temp_random_midline_combat_unit_index_b);
				
				// Move Selected Combat Unit from Unengaged Array to Engaged Array
				temp_second_unit.midline_combat_unit_unengaged_count--;
				array_delete(temp_second_unit.midline_combat_unit_unengaged, temp_random_midline_combat_unit_index_b, 1);
				array_push(temp_second_unit.midline_combat_unit_engaged, temp_random_midline_combat_unit_instance_b);
				
				// Add Selected Combat Unit to Battle's Combat Units Pool
				array_insert(battle_instance.battle_combat_units, 0, temp_random_midline_combat_unit_instance_b);
				
				// Add Selected Combat Unit to Battle's Faction & Midline Combat Unit Pools
				array_push(battle_instance.battle_combat_units_b, temp_random_midline_combat_unit_instance_b);
				array_push(battle_instance.battle_midline_combat_units_b, temp_random_midline_combat_unit_instance_b);
				
				// Find random Available Slot in the Combat Grid's Midline
				var temp_random_midline_combat_grid_available_slot_index_b = irandom(battle_instance.battle_midline_available_slots_count_b - 1);
				var temp_random_midline_combat_grid_available_slot_b = array_get(battle_instance.battle_midline_available_slots_b, temp_random_midline_combat_grid_available_slot_index_b);
				
				// Remove Available Slot from Available Slot Array
				battle_instance.battle_midline_available_slots_count_b--;
				array_delete(battle_instance.battle_midline_available_slots_b, temp_random_midline_combat_grid_available_slot_index_b, 1);
				
				// Set Selected Combat Unit's Column and Row from Available Slot Index
				temp_random_midline_combat_unit_instance_b.combat_grid_column = temp_random_midline_combat_grid_available_slot_index_b div CelestialBattleCombatGridColumns;
				temp_random_midline_combat_unit_instance_b.combat_grid_row = temp_random_midline_combat_grid_available_slot_index_b mod CelestialBattleCombatGridRows;
				
				// Place Selected Combat Unit in the Combat Grid's Available Slot
				array_set(array_get(battle_instance.battle_combat_grid_b, temp_random_midline_combat_unit_instance_b.combat_grid_column), temp_random_midline_combat_unit_instance_b.combat_grid_row, temp_random_midline_combat_unit_instance_b);
				array_push(array_get(battle_instance.battle_combat_grid_instances_b, temp_random_midline_combat_unit_instance_b.combat_grid_column), temp_random_midline_combat_unit_instance_b);
			}
			else if (battle_instance.battle_backline_available_slots_count_b > 0 and temp_second_unit.backline_combat_unit_unengaged_count > 0)
			{
				// Find random Unengaged Backline Combat Unit from the Second Unit
				var temp_random_backline_combat_unit_index_b = irandom(temp_second_unit.backline_combat_unit_unengaged_count - 1);
				var temp_random_backline_combat_unit_instance_b = array_get(temp_second_unit.backline_combat_unit_unengaged, temp_random_backline_combat_unit_index_b);
				
				// Move Selected Combat Unit from Unengaged Array to Engaged Array
				temp_second_unit.backline_combat_unit_unengaged_count--;
				array_delete(temp_second_unit.backline_combat_unit_unengaged, temp_random_backline_combat_unit_index_b, 1);
				array_push(temp_second_unit.backline_combat_unit_engaged, temp_random_backline_combat_unit_instance_b);
				
				// Add Selected Combat Unit to Battle's Combat Units Pool
				array_insert(battle_instance.battle_combat_units, 0, temp_random_backline_combat_unit_instance_b);
				
				// Add Selected Combat Unit to Battle's Faction & Backline Combat Unit Pools
				array_push(battle_instance.battle_combat_units_b, temp_random_backline_combat_unit_instance_b);
				array_push(battle_instance.battle_backline_combat_units_b, temp_random_backline_combat_unit_instance_b);
				
				// Find random Available Slot in the Combat Grid's Backline
				var temp_random_backline_combat_grid_available_slot_index_b = irandom(battle_instance.battle_backline_available_slots_count_b - 1);
				var temp_random_backline_combat_grid_available_slot_b = array_get(battle_instance.battle_backline_available_slots_b, temp_random_backline_combat_grid_available_slot_index_b);
				
				// Remove Available Slot from Available Slot Array
				battle_instance.battle_backline_available_slots_count_b--;
				array_delete(battle_instance.battle_backline_available_slots_b, temp_random_backline_combat_grid_available_slot_index_b, 1);
				
				// Set Selected Combat Unit's Column and Row from Available Slot Index
				temp_random_backline_combat_unit_instance_b.combat_grid_column = temp_random_backline_combat_grid_available_slot_index_b div CelestialBattleCombatGridColumns;
				temp_random_backline_combat_unit_instance_b.combat_grid_row = temp_random_backline_combat_grid_available_slot_index_b mod CelestialBattleCombatGridRows;
				
				// Place Selected Combat Unit in the Combat Grid's Available Slot
				array_set(array_get(battle_instance.battle_combat_grid_b, temp_random_backline_combat_unit_instance_b.combat_grid_column), temp_random_backline_combat_unit_instance_b.combat_grid_row, temp_random_backline_combat_unit_instance_b);
				array_push(array_get(battle_instance.battle_combat_grid_instances_b, temp_random_backline_combat_unit_instance_b.combat_grid_column), temp_random_backline_combat_unit_instance_b);
			}
			else
			{
				// There are no more Available Slots on the Combat Grid for the Second Unit's Combat Units to occupy or the Second Unit has no more available Combat Units to add to the Combat Grid
				temp_second_unit_can_add_units = false;
			}
		}
	}
}

/// @function celestial_battle_add_unit(battle_instance, unit_instance);
/// @description Adds a given Celestial Unit Instance to the ongoing Battle with the given Celestial Battle Instance (this function prevents Celestial Units from being redundantly "double added" to the Celestial Battle)
/// @param {oCelestialBattle} battle_instance The Celestial Battle the given Celestial Unit Instance will be added to
/// @param {real:Id.Instance} unit_instance The Celestial Unit Instance that will be added to the given Celestial Battle Instance
function celestial_battle_add_supporting_unit(battle_instance, unit_instance)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		// Battle Instance does not exist - Early Exit
		return;
	}
	
	// Update that Unit Instance has entered Combat
	unit_instance.engaged_in_battle = true;
	
	// Update Unit Instance's Battle Popup
	unit_instance.emotion_battle_popup_timer = unit_instance.emotion_battle_popup_duration;
	
	// Randomize Unit Instance's Collision Check Timer
	unit_instance.collision_check_timer = random(CelestialSimulator.global_collision_check_interval);
}

function celestial_battle_remove_unit(battle_instance, unit_instance)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		// Battle Instance does not exist - Early Exit
		return;
	}
}

/// @function celestial_battle_add_choreography_actor(battle_instance, actor_combat_unit_instance);
/// @description Adds a Celestial Combat Unit as an Actor to a Celestial Battle's choreography arrays
/// @param {oCelestialBattle} battle_instance The Celestial Battle to add a Choreography Actor to
/// @param {real:Id.Instance} actor_combat_unit_instance The Celestial Combat Unit to add as a Choreography Actor
function celestial_battle_add_choreography_actor(battle_instance, actor_combat_unit_instance)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		return;
	}
	
	// Establish Actor Battle Platform Side & Faction
	var temp_actor_platform_side = CelestialBattlePlatformSide.None;
	var temp_actor_faction_instance = instance_exists(actor_combat_unit_instance.unit_instance) ? actor_combat_unit_instance.unit_instance.unit_faction : noone;
	
	// Check what Battle Platform Side the Actor is participating on
	if (temp_actor_faction_instance == CelestialSimulator.player_faction)
	{
		// Establish Actor Battle Platform Side
		temp_actor_platform_side = CelestialBattlePlatformSide.Left;
	}
	else if (instance_exists(temp_actor_faction_instance) and instance_exists(CelestialSimulator.player_faction))
	{
		// Check the Player Faction's Relationship with the Actor Faction
		var temp_player_faction_hostile_check = ds_map_find_value(CelestialSimulator.player_faction.relationships, temp_actor_faction_instance) == CelestialFactionRelationshipType.Hostile;
		var temp_actor_faction_hostile_check = ds_map_find_value(temp_actor_faction_instance.relationships, CelestialSimulator.player_faction) == CelestialFactionRelationshipType.Hostile;
		
		var temp_player_faction_allied_check = ds_map_find_value(CelestialSimulator.player_faction.relationships, temp_actor_faction_instance) == CelestialFactionRelationshipType.Allied;
		var temp_actor_faction_allied_check = ds_map_find_value(temp_actor_faction_instance.relationships, CelestialSimulator.player_faction) == CelestialFactionRelationshipType.Allied;
		
		// Establish Actor Battle Platform Side
		if (temp_player_faction_hostile_check or temp_actor_faction_hostile_check)
		{
			temp_actor_platform_side = CelestialBattlePlatformSide.Right;
		}
		else if (temp_player_faction_allied_check or temp_actor_faction_allied_check)
		{
			temp_actor_platform_side = CelestialBattlePlatformSide.Left;
		}
	}
	else if (instance_exists(CelestialSimulator.player_faction))
	{
		// Check the Player Faction's Relationship with the Actor Faction
		var temp_player_faction_null_faction_hostile_check = ds_map_find_value(CelestialSimulator.player_faction.relationships, temp_actor_faction_instance) == CelestialFactionRelationshipType.Hostile;
		var temp_player_faction_null_faction_allied_check = ds_map_find_value(CelestialSimulator.player_faction.relationships, temp_actor_faction_instance) == CelestialFactionRelationshipType.Allied;
		
		// Establish Actor Battle Platform Side
		if (temp_player_faction_null_faction_hostile_check)
		{
			temp_actor_platform_side = CelestialBattlePlatformSide.Right;
		}
		else if (temp_player_faction_null_faction_allied_check)
		{
			temp_actor_platform_side = CelestialBattlePlatformSide.Left;
		}
	}
	
	// Check if Actor is participating in the Battle's Choreography
	if (temp_actor_platform_side != CelestialBattlePlatformSide.None)
	{
		// Initialize (Actor) Battle Choreography Stack Struct
		var temp_actor_struct =
		{
			// Object Type Variables
			choreography_object_type: CelestialBattleChoreographyObjectType.Actor,
			
			// Object Depth Sorting Variables
			vertical_depth: 0,
			
			// Rendering Variables
			draw_sprite_index: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_idle_sprite,
			draw_image_index: 0,
			
			draw_x: 0,
			draw_y: 0,
			
			draw_xscale: 1,
			
			draw_color: instance_exists(temp_actor_faction_instance) ? temp_actor_faction_instance.faction_color : c_white,
			draw_alpha: 0,
			
			// Advanced Rendering Variables
			facing_direction: temp_actor_platform_side == CelestialBattlePlatformSide.Left ? 1 : -1,
			
			draw_image_index_value: random(sprite_get_number(global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_move_sprite)),
			
			draw_offset_x: 0,
			draw_offset_y: 0,
			
			draw_random_offset_x: irandom_range(-3, 3),
			draw_random_offset_y: irandom_range(-1, 3),
			
			// Actor Combat Unit & Faction Variables
			combat_unit_type: actor_combat_unit_instance.combat_unit_type,
			combat_unit_instance: actor_combat_unit_instance,
			combat_unit_faction: temp_actor_faction_instance,
			
			target_combat_unit: noone,
			target_faction: noone,
			
			action_enabled: true,
			action_delay_timer: random(1.0) + (celestial_unit_check_status_effect(actor_combat_unit_instance.unit_instance, CelestialUnitStatusEffectType.CombatActionStun) ? -3.5 : -1.5),
			action_duration_timer: -1,
			
			// Actor Battle Variables
			actor_platform_side: temp_actor_platform_side,
			actor_priority_rank: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_priority_rank,
			actor_vertical_tile: 0,
			
			// Actor Tile Variables
			battle_tile_ax: 0,
			battle_tile_ay: 0,
			
			battle_tile_bx: 0,
			battle_tile_by: 0,
			
			battle_tile_cx: 0,
			battle_tile_cy: 0,
			
			battle_tile_dx: 0,
			battle_tile_dy: 0,
			
			// Actor Action Variables
			actor_action_type: -1,
			actor_action_animation_delay: 0,
			
			actor_action_animation_count: 0,
			actor_action_animation_success: array_create(0),
			
			//
			actor_weapon_enabled: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_weapon_enabled,
			actor_weapon_sprite: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_weapon_sprite,
			
			actor_weapon_pivot_x: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_weapon_pivot_x,
			actor_weapon_pivot_y: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_weapon_pivot_y,
			
			actor_weapon_aim_pivot_x: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_weapon_aim_pivot_x,
			actor_weapon_aim_pivot_y: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_weapon_aim_pivot_y,
			
			actor_weapon_aim: 0,
			
			actor_weapon_offset_x: 0,
			actor_weapon_offset_y: 0,
			
			actor_weapon_target_x: 0,
			actor_weapon_target_y: 0,
			
			actor_weapon_angle: 270,
			
			actor_weapon_angle_recoil: 0,
			actor_weapon_horizontal_recoil: 0,
			actor_weapon_vertical_recoil: 0,
			
			actor_weapon_vertical_bobbing_height: -1,
			actor_weapon_vertical_bobbing_y_offset: 0,
			
			//
			actor_weapon_attack_sprite_index: -1,
			actor_weapon_attack_image_index: 0,
			actor_weapon_attack_image_angle: 0,
			actor_weapon_attack_x: 0,
			actor_weapon_attack_y: 0,
			actor_weapon_attack_timer: 0,
			
			// Actor Entry Animation Variables
			actor_entry_animation: true,
			actor_entry_animation_value: 0,
			actor_entry_delay_duration: random(18),
			
			// Actor Exit Animation Variables
			actor_exit_animation: false,
			actor_exit_animation_value: 1,
			actor_exit_delay_duration: random(18),
		};
		
		// Increment Battle's Vertical Tile Count for Choreography Actor Vertical Placement
		if (temp_actor_platform_side == CelestialBattlePlatformSide.Left)
		{
			battle_instance.battle_choreography_actors_battle_column_sizes[CelestialBattlePriorityRankMax - temp_actor_struct.actor_priority_rank - 1] += 1;
		}
		else if (temp_actor_platform_side == CelestialBattlePlatformSide.Right)
		{
			battle_instance.battle_choreography_actors_battle_column_sizes[CelestialBattlePriorityRankMax + temp_actor_struct.actor_priority_rank] += 1;
		}
		
		// Index Actor Struct into Battle's Choreography Actors Array
		array_push(battle_instance.battle_choreography_actors, temp_actor_struct);
	}
}

function celestial_battle_assign_depth_choreography_actors(battle_instance)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		return;
	}
	
	// Check if Celestial Battle should perform Depth Sort for the Battle's Choreography Actors Arrays and Data Structures
	if (!instance_exists(CelestialSimulator.player_faction) or array_get_index(battle_instance.battle_factions, CelestialSimulator.player_faction) == -1)
	{
		return;
	}
	
	// Create and Populate Battle Choreography's Column Possible Positions Array with Possible Positions
	var temp_battle_choreography_actors_battle_column_possible_positions = array_create(0);
	var temp_battle_choreography_actors_battle_column_sizes_index = 0;
	
	repeat (array_length(battle_instance.battle_choreography_actors_battle_column_sizes))
	{
		// Find Battle Column's Size
		var temp_battle_column_size = max(battle_instance.battle_choreography_actors_battle_column_sizes[temp_battle_choreography_actors_battle_column_sizes_index], CelestialSimulator.battle_default_column_size);
		
		// Update Battle's Column Size
		battle_instance.battle_choreography_actors_battle_column_sizes[temp_battle_choreography_actors_battle_column_sizes_index] = temp_battle_column_size;
		
		// Create and Populate Battle Column Possible Positions Array with Possible Positions
		var temp_battle_column_possible_positions_array = array_create(temp_battle_column_size);
		var temp_battle_column_possible_positions_index = 0;
		
		repeat (temp_battle_column_size)
		{
			// Index the Battle Column Possible Position in the Battle Column Possible Positions Array
			temp_battle_column_possible_positions_array[temp_battle_column_possible_positions_index] = temp_battle_column_possible_positions_index;
			
			// Increment Battle Column Possible Positions Index
			temp_battle_column_possible_positions_index++;
		}
		
		// Add Battle Column Possible Positions Array to Battle Choreography's Column Possible Positions Array
		array_push(temp_battle_choreography_actors_battle_column_possible_positions, temp_battle_column_possible_positions_array);
		
		// Increment Battle Choreography Column Sizes Index
		temp_battle_choreography_actors_battle_column_sizes_index++;
	}
	
	// Increment through Battle's Choreography Actors Array
	var temp_battle_choreography_actors_count = array_length(battle_instance.battle_choreography_actors);
	var temp_battle_choreography_actors_index = 0;
	
	repeat (temp_battle_choreography_actors_count)
	{
		// Find Battle Choreography Actor Struct
		var temp_battle_choreography_actor_struct = array_get(battle_instance.battle_choreography_actors, temp_battle_choreography_actors_index);
		
		// Assign Random Vertical Column Position
		var temp_battle_actor_column_index = CelestialBattlePriorityRankMax - 1 - temp_battle_choreography_actor_struct.actor_priority_rank;
		temp_battle_actor_column_index = temp_battle_choreography_actor_struct.actor_platform_side == CelestialBattlePlatformSide.Right ? CelestialBattlePriorityRankMax + temp_battle_choreography_actor_struct.actor_priority_rank : temp_battle_choreography_actor_struct.actor_priority_rank;
		var temp_battle_actor_column_size = battle_instance.battle_choreography_actors_battle_column_sizes[temp_battle_actor_column_index];
		var temp_battle_actor_column_possible_positions_array = array_get(temp_battle_choreography_actors_battle_column_possible_positions, temp_battle_actor_column_index);
		
		if (array_length(temp_battle_actor_column_possible_positions_array) > 0)
		{
			var temp_random_column_possible_positions_index = irandom(array_length(temp_battle_actor_column_possible_positions_array) - 1);
			temp_battle_choreography_actor_struct.actor_vertical_tile = temp_battle_actor_column_possible_positions_array[temp_random_column_possible_positions_index];
			array_delete(temp_battle_actor_column_possible_positions_array, temp_random_column_possible_positions_index, 1);
		}
		
		// Increment Battle Choreography Actors Index
		temp_battle_choreography_actors_index++;
	}
	
	// Iterate through Battle's Choreography Actors and Index them into Battle Choreography Actors DS Map
	temp_battle_choreography_actors_index = 0;
	
	repeat (temp_battle_choreography_actors_count)
	{
		// Index Battle Choreography Actor into Battle Choreography Actors DS Map
		ds_map_add(battle_instance.battle_choreography_actors_map, battle_instance.battle_choreography_actors[temp_battle_choreography_actors_index].combat_unit_instance, temp_battle_choreography_actors_index);
		
		// Increment Battle Choreography Actors Index
		temp_battle_choreography_actors_index++;
	}
	
	// Cleanup Unused Battle Choreography's Column Possible Positions Array
	temp_battle_choreography_actors_battle_column_sizes_index = 0;
	
	repeat (array_length(battle_instance.battle_choreography_actors_battle_column_sizes))
	{
		// Clear Unused Array
		array_resize(temp_battle_choreography_actors_battle_column_possible_positions[temp_battle_choreography_actors_battle_column_sizes_index], 0);
		
		// Increment Battle Choreography Column Sizes Index
		temp_battle_choreography_actors_battle_column_sizes_index++;
	}
	
	array_resize(temp_battle_choreography_actors_battle_column_possible_positions, 0);
}

/// @function celestial_battle_clear_choreography_actors(battle_instance);
/// @description Clears the Choreography Actors array with the given Celestial Battle Instance
/// @param {oCelestialBattle} battle_instance The Celestial Battle to clear and reset the Choreography Actors array of
function celestial_battle_clear_choreography_actors(battle_instance)
{
	// Check if Celestial Battle Instance Exists
	if (!instance_exists(battle_instance))
	{
		return;
	}
	
	// Increment through Battle's Choreography Actors Array and Erase Battle's Choreography Actors Structs
	var temp_battle_choreography_actors_count = array_length(battle_instance.battle_choreography_actors);
	var temp_battle_choreography_actors_index = temp_battle_choreography_actors_count - 1;
	
	repeat (temp_battle_choreography_actors_count)
	{
		// Delete Battle Choreography Actors Struct
		delete battle_instance.battle_choreography_actors[temp_battle_choreography_actors_index];
		
		// Decrement Battle Choreography Actors Index
		temp_battle_choreography_actors_index--;
	}
	
	array_resize(battle_instance.battle_choreography_actors, 0);
	
	// Clear Battle's Choreography Actors DS Map
	ds_map_clear(battle_instance.battle_choreography_actors_map);
}

/// @function celestial_battle_clear_choreography_actions(battle_instance);
/// @description Clears the Choreography Actions array with the given Celestial Battle Instance
/// @param {oCelestialBattle} battle_instance The Celestial Battle to clear and reset the Choreography Actions array of
function celestial_battle_clear_choreography_actions(battle_instance)
{
	// Check if Celestial Battle Instance Exists
	if (!instance_exists(battle_instance))
	{
		return;
	}
	
	// Increment through Battle's Choreography Actions Array and Erase Battle's Choreography Actions Structs
	var temp_battle_choreography_actions_count = array_length(battle_instance.battle_choreography_actions);
	var temp_battle_choreography_actions_index = temp_battle_choreography_actions_count - 1;
	
	repeat (temp_battle_choreography_actions_count)
	{
		// Delete Battle Choreography Actions Struct
		delete battle_instance.battle_choreography_actions[temp_battle_choreography_actions_index];
		
		// Decrement Battle Choreography Actions Index
		temp_battle_choreography_actions_index--;
	}
	
	array_resize(battle_instance.battle_choreography_actions, 0);
}

/////////////////////////////////////////////////////////////////////////////
function celestial_battle_damage_combat_unit(celestial_combat_unit, damage_value)
{
	//
	celestial_combat_unit.combat_unit_health -= damage_value;
	
	//
	if (celestial_combat_unit.combat_unit_health > 0)
	{
		//
		return;
	}
	
	//
	if (instance_exists(celestial_combat_unit.unit_instance))
	{
		//
		celestial_unit_remove_combat_unit(celestial_combat_unit.unit_instance, celestial_combat_unit)
	}
	
	//
	instance_destroy(celestial_combat_unit);
}


