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

global.celestial_battle_combat_grid_population_minimum = 5;

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

enum CelestialBattleCombatGridSide
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
/// @description Creates and returns a Celestial Battle Instance within the Celestial Simulation with the given Celestial Object Instance and Hostile Celestial Factions, if the given Celestial Factions do not have a Hostile Relationship the Celestial Battle will not be created
/// @param {real:Id.Instance} celestial_object The Celestial Object Instance the Celestial Battle will belong to
/// @param {real:Id.Instance} celestial_faction_a The first Celestial Faction Instance that is engaged in the Celestial Battle
/// @param {real:Id.Instance} celestial_faction_b The second Celestial Faction Instance that is engaged in the Celestial Battle
/// @returns {?real:Id.Instance} Returns a Celestial Battle Instance
function celestial_battle_create(celestial_object, celestial_faction_a, celestial_faction_b)
{
	// Check if the given Celestial Factions are hostile to eachother
	if (!celestial_faction_is_relationship_hostile(celestial_faction_a, celestial_faction_b))
	{
		// The Celestial Factions do not have a hostile relationship - Skip Battle Initialization and return null
		return noone;
	}
	
	// Create Celestial Battle Instance
	var temp_celestial_battle_instance = instance_create_depth(0, 0, 0, oCelestialBattle);
	
	// Update Celestial Battle's Celestial Body Instance
	temp_celestial_battle_instance.celestial_body_instance = celestial_object;
	
	// Update Celestial Battle's Factions
	var temp_first_faction = celestial_faction_a;
	var temp_second_faction = celestial_faction_b;
	
	if (celestial_faction_b == CelestialSimulator.player_faction)
	{
		temp_first_faction = celestial_faction_b;
		temp_second_faction = celestial_faction_a;
	}
	else if (celestial_faction_a != CelestialSimulator.player_faction and random(1.0) > 0.5)
	{
		temp_first_faction = celestial_faction_b;
		temp_second_faction = celestial_faction_a;
	}
	
	temp_celestial_battle_instance.battle_faction_a = temp_first_faction;
	temp_celestial_battle_instance.battle_faction_b = temp_second_faction;
	
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

function celestial_battle_add_unit(battle_instance, unit_instance)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		// Battle Instance does not exist - Early Exit
		return;
	}
	
	// Establish Celestial Unit Instance's Battle Combat Grid Side
	var temp_battle_combat_grid_side = CelestialBattleCombatGridSide.None;
	
	// Determine the Combat Grid Side of the Celestial Unit Instance based on their Faction's Participation in the Battle
	if (celestial_faction_is_relationship_allied(unit_instance.unit_faction, battle_instance.battle_faction_a) and celestial_faction_is_relationship_hostile(unit_instance.unit_faction, battle_instance.battle_faction_b))
	{
		temp_battle_combat_grid_side = CelestialBattleCombatGridSide.Left;
	}
	else if (celestial_faction_is_relationship_allied(unit_instance.unit_faction, battle_instance.battle_faction_b) and celestial_faction_is_relationship_hostile(unit_instance.unit_faction, battle_instance.battle_faction_a))
	{
		temp_battle_combat_grid_side = CelestialBattleCombatGridSide.Right;
	}
	else
	{
		// Index Battle in Unit Instance's Unengaged Celestial Battles Array
		array_push(unit_instance.unengaged_battles, battle_instance);
		
		// Celestial Unit Instance is not involved in this conflict - Early Exit
		return;
	}
	
	// Check if Celestial Unit already is engaged with the Battle
	if (array_get_index(battle_instance.battle_units, unit_instance) != -1)
	{
		// Celestial Unit has already been added to this Battle - Early Exit
		return;
	}
	
	// Index Battle in Unit Instance's Engaged Celestial Battles Arrays
	array_push(unit_instance.engaged_battles, battle_instance);
	array_push(unit_instance.engaged_battles_combat_units, array_create(0));
	array_push(unit_instance.engaged_battles_combat_units_contribution, 0);
	
	// Index and Sort the given Celestial Unit in Battle's Celestial Units Array
	array_push(battle_instance.battle_units, unit_instance);
	array_sort(battle_instance.battle_units, true);
	
	// Index Celestial Unit in Battle's Factional Celestial Units Arrays
	switch (temp_battle_combat_grid_side)
	{
		case CelestialBattleCombatGridSide.Left:
			array_push(battle_instance.battle_units_a, unit_instance);
			break;
		case CelestialBattleCombatGridSide.Right:
			array_push(battle_instance.battle_units_b, unit_instance);
			break;
	}
	
	// Update that Unit Instance has entered Combat
	unit_instance.engaged_in_battle = true;
	
	// Update Unit Instance's Battle Popup
	unit_instance.emotion_battle_popup_timer = unit_instance.emotion_battle_popup_duration;
	
	// Randomize Unit Instance's Collision Check Timer
	unit_instance.collision_check_timer = random(CelestialSimulator.global_collision_check_interval);
	
	// Load Celestial Unit's Combat Units into this Battle
	celestial_battle_load_combat_units(battle_instance, unit_instance);
}

function celestial_battle_remove_unit(battle_instance, unit_instance)
{
	// Find the index of the given Celestial Unit Instance within the Celestial Battle's Celestial Units Array
	var temp_battle_units_index = array_get_index(battle_instance.battle_units, unit_instance);
	
	// Check if given Celestial Unit Instance is engaged in the Celestial Battle
	if (temp_battle_units_index == -1)
	{
		// Celestial Unit Instance is not indexed within the Celestial Battle - Early Return
		return;
	}
	
	// Delete Celestial Unit Instance's Entry within the Celestial Battle's Celestial Units Array
	array_delete(battle_instance.battle_units, temp_battle_units_index, 1);
	
	// Check if Celestial Unit Instance was indexed on the Left or Right Factional Celestial Units Array
	var temp_battle_units_left_index = array_get_index(battle_instance.battle_units_a, unit_instance);
	
	if (temp_battle_units_left_index == -1)
	{
		// Find the index of the given Celestial Unit Instance within the Celestial Battle's Right-Side Celestial Units Array
		var temp_battle_units_right_index = array_get_index(battle_instance.battle_units_b, unit_instance);
		
		// Remove the Celestial Unit Instance from the Celestial Battle's Right-Side Celestial Units Array
		array_delete(battle_instance.battle_units_b, temp_battle_units_right_index, 1);
		
		// Check if there are any more Celestial Unit Instances fighting on the Right-Side of the Celestial Battle
		if (array_length(battle_instance.battle_units_b) < 1)
		{
			// Toggle the Celestial Battle has ended
			battle_instance.battle_exists = false;
		}
	}
	else
	{
		// Remove the Celestial Unit Instance from the Celestial Battle's Left-Side Celestial Units Array
		array_delete(battle_instance.battle_units_a, temp_battle_units_left_index, 1);
		
		// Check if there are any more Celestial Unit Instances fighting on the Left-Side of the Celestial Battle
		if (array_length(battle_instance.battle_units_a) < 1)
		{
			// Toggle the Celestial Battle has ended
			battle_instance.battle_exists = false;
		}
	}
	
	// Iterate through Celestial Unit's Engaged Frontline Combat Units Array to remove them from the current Battle
	var temp_frontline_engaged_combat_unit_count = array_length(unit_instance.frontline_combat_unit_engaged);
	var temp_frontline_engaged_combat_unit_index = temp_frontline_engaged_combat_unit_count - 1;
	
	repeat (temp_frontline_engaged_combat_unit_count)
	{
		// Find the Engaged Combat Unit Instance
		var temp_frontline_engaged_combat_unit_instance = unit_instance.frontline_combat_unit_engaged[temp_frontline_engaged_combat_unit_index];
		
		// Check if Engaged Combat Unit Instance is participating in the given Celestial Battle
		if (temp_frontline_engaged_combat_unit_instance.battle_instance == battle_instance)
		{
			// Remove the Engaged Combat Unit Instance from the Celestial Battle
			celestial_battle_remove_combat_unit(battle_instance, temp_frontline_engaged_combat_unit_instance);
		}
		
		// Decrement the Engaged Combat Unit Index
		temp_frontline_engaged_combat_unit_index--;
	}
	
	// Iterate through Celestial Unit's Engaged Midline Combat Units Array to remove them from the current Battle
	var temp_midline_engaged_combat_unit_count = array_length(unit_instance.midline_combat_unit_engaged);
	var temp_midline_engaged_combat_unit_index = temp_midline_engaged_combat_unit_count - 1;
	
	repeat (temp_midline_engaged_combat_unit_count)
	{
		// Find the Engaged Combat Unit Instance
		var temp_midline_engaged_combat_unit_instance = unit_instance.midline_combat_unit_engaged[temp_midline_engaged_combat_unit_index];
		
		// Check if Engaged Combat Unit Instance is participating in the given Celestial Battle
		if (temp_midline_engaged_combat_unit_instance.battle_instance == battle_instance)
		{
			// Remove the Engaged Combat Unit Instance from the Celestial Battle
			celestial_battle_remove_combat_unit(battle_instance, temp_midline_engaged_combat_unit_instance);
		}
		
		// Decrement the Engaged Combat Unit Index
		temp_midline_engaged_combat_unit_index--;
	}
	
	// Iterate through Celestial Unit's Engaged Backline Combat Units Array to remove them from the current Battle
	var temp_backline_engaged_combat_unit_count = array_length(unit_instance.backline_combat_unit_engaged);
	var temp_backline_engaged_combat_unit_index = temp_backline_engaged_combat_unit_count - 1;
	
	repeat (temp_backline_engaged_combat_unit_count)
	{
		// Find the Engaged Combat Unit Instance
		var temp_backline_engaged_combat_unit_instance = unit_instance.backline_combat_unit_engaged[temp_backline_engaged_combat_unit_index];
		
		// Check if Engaged Combat Unit Instance is participating in the given Celestial Battle
		if (temp_backline_engaged_combat_unit_instance.battle_instance == battle_instance)
		{
			// Remove the Engaged Combat Unit Instance from the Celestial Battle
			celestial_battle_remove_combat_unit(battle_instance, temp_backline_engaged_combat_unit_instance);
		}
		
		// Decrement the Engaged Combat Unit Index
		temp_backline_engaged_combat_unit_index--;
	}
	
	// Remove Battle from Celestial Unit's Engaged Celestial Battles Arrays
	var temp_engaged_battles_index = array_get_index(unit_instance.engaged_battles, battle_instance);
	array_delete(unit_instance.engaged_battles, temp_engaged_battles_index, 1);
	array_delete(unit_instance.engaged_battles_combat_units, temp_engaged_battles_index, 1);
	array_delete(unit_instance.engaged_battles_combat_units_contribution, temp_engaged_battles_index, 1);
	
	// Check if Celestial Unit is still engaged in Battle
	if (array_length(unit_instance.engaged_battles) < 1)
	{
		// Toggle Celestial Unit is no longer participating in Combat
		unit_instance.engaged_in_battle = false;
	}
	else
	{
		// Load Combat Units into Celestial Unit's next available Engaged Battle
		celestial_battle_load_combat_units(unit_instance.engaged_battles[0], unit_instance);
	}
	
	//
	if (battle_instance.battle_exists)
	{
		// Check if Celestial Body Instance exists
		if (instance_exists(battle_instance.celestial_body_instance))
		{
			//
			var temp_battle_instance_celestial_body_battles_index = array_get_index(battle_instance.celestial_body_instance.battles, battle_instance);
			
			// Remove Celestial Battle Instance from Celestial Body's Battles Array
			var temp_celestial_body_battles_count = array_length(battle_instance.celestial_body_instance.battles);
			var temp_celestial_body_battles_index = temp_celestial_body_battles_count - 1;
			
			repeat (temp_celestial_body_battles_count)
			{
				//
				if (temp_celestial_body_battles_index == temp_battle_instance_celestial_body_battles_index)
				{
					//
					temp_celestial_body_battles_index--
					
					//
					continue;
				}
				
				//
				var temp_celestial_body_battles_instance = battle_instance.celestial_body_instance.battles[temp_celestial_body_battles_index];
				
				//
				if (array_equals(battle_instance.battle_units, temp_celestial_body_battles_instance.battle_units))
				{
					// Toggle that the given Celestial Battle has ended
					battle_instance.battle_exists = false;
					
					//
					// Check if the given Celestial Battle is currently selected by the Player
					if (battle_instance == CelestialSimulator.sub_object_selected_instance)
					{
						// Select the new Celestial Battle that matches the given Celestial Battle that has ended
						CelestialSimulator.select_sub_object_instance(temp_celestial_body_battles_instance);
					}
					
					//
					return;
				}
				
				//
				temp_celestial_body_battles_index--;
			}
		}
	}
}

///
function celestial_battle_load_combat_units(battle_instance, unit_instance, combat_units_count = -1)
{
	// Establish Celestial Unit Instance's Battle Combat Grid Side
	var temp_battle_combat_grid_side = CelestialBattleCombatGridSide.None;
	
	// Determine the Combat Grid Side of the Celestial Unit Instance based on their Faction's Participation in the Battle
	if (celestial_faction_is_relationship_allied(unit_instance.unit_faction, battle_instance.battle_faction_a) and celestial_faction_is_relationship_hostile(unit_instance.unit_faction, battle_instance.battle_faction_b))
	{
		temp_battle_combat_grid_side = CelestialBattleCombatGridSide.Left;
	}
	else if (celestial_faction_is_relationship_allied(unit_instance.unit_faction, battle_instance.battle_faction_b) and celestial_faction_is_relationship_hostile(unit_instance.unit_faction, battle_instance.battle_faction_a))
	{
		temp_battle_combat_grid_side = CelestialBattleCombatGridSide.Right;
	}
	else
	{
		// Celestial Unit Instance is not involved in this conflict - Early Exit
		return;
	}
	
	// Establish Add Combat Unit Toggle & Combat Unit Added Count
	var temp_can_add_units = true;
	var temp_combat_units_added = 0;
	
	// Establish Combat Grid Column Type Unengaged Combat Unit Counts
	var temp_frontline_combat_unit_count = array_length(unit_instance.frontline_combat_unit_unengaged);
	var temp_midline_combat_unit_count = array_length(unit_instance.midline_combat_unit_unengaged);
	var temp_backline_combat_unit_count = array_length(unit_instance.backline_combat_unit_unengaged);
	
	// Establish Combat Grid Column Type Add Combat Unit Toggles
	var temp_can_add_frontline_units = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? (battle_instance.battle_frontline_available_slots_count_a > 0) : (battle_instance.battle_frontline_available_slots_count_b > 0);
	var temp_can_add_midline_units = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? (battle_instance.battle_midline_available_slots_count_a > 0) : (battle_instance.battle_midline_available_slots_count_b > 0);
	var temp_can_add_backline_units = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? (battle_instance.battle_backline_available_slots_count_a > 0) : (battle_instance.battle_backline_available_slots_count_b > 0);
	
	// Check if Unit can still add more Combat Units to Battle
	while (temp_can_add_units)
	{
		// Check Combat Grid Column Types for available slots for the First Unit's Combat Units
		if (temp_can_add_frontline_units and temp_frontline_combat_unit_count > 0)
		{
			// Find random Unengaged Frontline Combat Unit from the First Unit
			var temp_random_frontline_combat_unit_index = irandom(temp_frontline_combat_unit_count - 1);
			var temp_random_frontline_combat_unit_instance = array_get(unit_instance.frontline_combat_unit_unengaged, temp_random_frontline_combat_unit_index);
			
			// Add random Unengaged Frontline Combat Unit to the Celestial Battle
			celestial_battle_add_combat_unit(battle_instance, temp_random_frontline_combat_unit_instance, temp_battle_combat_grid_side);
			
			// Increment Combat Units Added
			temp_combat_units_added++;
			
			// Decrement Frontline Combat Unit Count
			temp_frontline_combat_unit_count--;
			
			// Check if more Combat Units can be added to the Combat Grid's Frontline
			temp_can_add_frontline_units = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? (battle_instance.battle_frontline_available_slots_count_a > 0) : (battle_instance.battle_frontline_available_slots_count_b > 0);
		}
		else if (temp_can_add_midline_units and temp_midline_combat_unit_count > 0)
		{
			// Find random Unengaged Midline Combat Unit from the First Unit
			var temp_random_midline_combat_unit_index = irandom(temp_midline_combat_unit_count - 1);
			var temp_random_midline_combat_unit_instance = array_get(unit_instance.midline_combat_unit_unengaged, temp_random_midline_combat_unit_index);
			
			// Add random Unengaged Midline Combat Unit to the Celestial Battle
			celestial_battle_add_combat_unit(battle_instance, temp_random_midline_combat_unit_instance, temp_battle_combat_grid_side);
			
			// Increment Combat Units Added
			temp_combat_units_added++;
			
			// Decrement Midline Combat Unit Count
			temp_midline_combat_unit_count--;
			
			// Check if more Combat Units can be added to the Combat Grid's Midline
			temp_can_add_midline_units = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? (battle_instance.battle_midline_available_slots_count_a > 0) : (battle_instance.battle_midline_available_slots_count_b > 0);
		}
		else if (temp_can_add_backline_units and temp_backline_combat_unit_count > 0)
		{
			// Find random Unengaged Backline Combat Unit from the First Unit
			var temp_random_backline_combat_unit_index = irandom(temp_backline_combat_unit_count - 1);
			var temp_random_backline_combat_unit_instance = array_get(unit_instance.backline_combat_unit_unengaged, temp_random_backline_combat_unit_index);
			
			// Add random Unengaged Backline Combat Unit to the Celestial Battle
			celestial_battle_add_combat_unit(battle_instance, temp_random_backline_combat_unit_instance, temp_battle_combat_grid_side);
			
			// Increment Combat Units Added
			temp_combat_units_added++;
			
			// Decrement Backline Combat Unit Count
			temp_backline_combat_unit_count--;
			
			// Check if more Combat Units can be added to the Combat Grid's Backline
			temp_can_add_backline_units = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? (battle_instance.battle_backline_available_slots_count_a > 0) : (battle_instance.battle_backline_available_slots_count_b > 0);
		}
		else
		{
			// There are no more Available Slots on the Combat Grid for the First Unit's Combat Units to occupy or the First Unit has no more available Combat Units to add to the Combat Grid
			temp_can_add_units = false;
		}
		
		// Check if Combat Units Added count exceeds the limit of Combat Units to add to the Battle
		if (combat_units_count != -1 and temp_can_add_units >= combat_units_count)
		{
			// Toggle Combat Units Added count has met or exceeds the limit of Combat Units to add to the Battle - End adding Combat Units to Battle Behaviour
			temp_can_add_units = false;
		}
	}
}

///
function celestial_battle_combat_unit_enter(battle_instance, combat_unit_instance)
{
	// Check Combat Unit's Grid Direction
	switch (combat_unit_instance.combat_grid_side)
	{
		case CelestialBattleCombatGridSide.Left:
			// Add Combat Unit Instance from Celestial Battle's Combat Column Type Arrays
			switch (global.celestial_combat_units[combat_unit_instance.combat_unit_type].unit_combat_column_type)
			{
				case CelestialBattleColumnType.Frontline:
					// Add Combat Unit to Battle's Frontline Combat Unit Pools
					array_push(battle_instance.battle_frontline_combat_units_a, combat_unit_instance);
					break;
				case CelestialBattleColumnType.Midline:
					// Add Combat Unit to Battle's Midline Combat Unit Pools
					array_push(battle_instance.battle_midline_combat_units_a, combat_unit_instance);
					break;
				case CelestialBattleColumnType.Backline:
					// Add Combat Unit to Battle's Backline Combat Unit Pools
					array_push(battle_instance.battle_backline_combat_units_a, combat_unit_instance);
					break;
			}
			
			// Place Selected Combat Unit in the Combat Grid's Available Slot
			array_set(array_get(battle_instance.battle_combat_grid_a, combat_unit_instance.combat_grid_column), combat_unit_instance.combat_grid_row, combat_unit_instance);
			array_push(array_get(battle_instance.battle_combat_grid_instances_a, combat_unit_instance.combat_grid_column), combat_unit_instance);
			break;
		case CelestialBattleCombatGridSide.Right:
			// Add Combat Unit Instance from Celestial Battle's Combat Column Type Arrays
			switch (global.celestial_combat_units[combat_unit_instance.combat_unit_type].unit_combat_column_type)
			{
				case CelestialBattleColumnType.Frontline:
					// Add Combat Unit to Battle's Frontline Combat Unit Pools
					array_push(battle_instance.battle_frontline_combat_units_b, combat_unit_instance);
					break;
				case CelestialBattleColumnType.Midline:
					// Add Combat Unit to Battle's Midline Combat Unit Pools
					array_push(battle_instance.battle_midline_combat_units_b, combat_unit_instance);
					break;
				case CelestialBattleColumnType.Backline:
					// Add Combat Unit to Battle's Backline Combat Unit Pools
					array_push(battle_instance.battle_backline_combat_units_b, combat_unit_instance);
					break;
			}
			
			// Place Selected Combat Unit in the Combat Grid's Available Slot
			array_set(array_get(battle_instance.battle_combat_grid_b, combat_unit_instance.combat_grid_column), combat_unit_instance.combat_grid_row, combat_unit_instance);
			array_push(array_get(battle_instance.battle_combat_grid_instances_b, combat_unit_instance.combat_grid_column), combat_unit_instance);
			break;
	}
}

///
function celestial_battle_combat_unit_leave(battle_instance, combat_unit_instance)
{
	
}

///
function celestial_battle_add_combat_unit(battle_instance, combat_unit_instance, combat_grid_side = CelestialBattleCombatGridSide.None)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		// Battle Instance does not exist - Early Exit
		return;
	}
	
	// Establish Celestial Unit Instance's Battle Combat Grid Side
	var temp_battle_combat_grid_side = combat_grid_side;
	
	// Check if Combat Grid Side was already Determined
	if (temp_battle_combat_grid_side == CelestialBattleCombatGridSide.None)
	{
		// Determine the Combat Grid Side of the Combat Unit Instance based on their Faction's Participation in the Battle
		if (celestial_faction_is_relationship_allied(combat_unit_instance.unit_instance.unit_faction, battle_instance.battle_faction_a) and celestial_faction_is_relationship_hostile(combat_unit_instance.unit_instance.unit_faction, battle_instance.battle_faction_b))
		{
			temp_battle_combat_grid_side = CelestialBattleCombatGridSide.Left;
		}
		else if (celestial_faction_is_relationship_allied(combat_unit_instance.unit_instance.unit_faction, battle_instance.battle_faction_b) and celestial_faction_is_relationship_hostile(combat_unit_instance.unit_instance.unit_faction, battle_instance.battle_faction_a))
		{
			temp_battle_combat_grid_side = CelestialBattleCombatGridSide.Right;
		}
		else
		{
			// Combat Unit Instance is not involved in this conflict - Early Exit
			return;
		}
	}
	
	// Establish Combat Unit's Type & Combat Grid Available Slot
	var temp_combat_unit_type = combat_unit_instance.combat_unit_type;
	var temp_combat_grid_available_slot = -1;
	
	// Search for an Available Slot within the Battle's Combat Grid for the given Combat Unit
	switch (global.celestial_combat_units[temp_combat_unit_type].unit_combat_column_type)
	{
		case CelestialBattleColumnType.Frontline:
			// Find Combat Unit's Unengaged Index
			var temp_frontline_combat_unit_unengaged_index = array_get_index(combat_unit_instance.unit_instance.frontline_combat_unit_unengaged, combat_unit_instance);
			
			// Check if Combat Unit is currently Engaged in Combat
			if (temp_frontline_combat_unit_unengaged_index == -1)
			{
				// Combat Unit is currently Engaged in Combat - Early Return
				return;
			}
			
			// Find the index of the Combat Unit's Type within their Unit Instance's Combat Unit Types Array
			var temp_frontline_combat_unit_type_index = array_get_index(combat_unit_instance.unit_instance.frontline_combat_unit_type, temp_combat_unit_type);
			
			// Move Selected Combat Unit from Unengaged Array to Engaged Array
			combat_unit_instance.unit_instance.frontline_combat_unit_unengaged_count[temp_frontline_combat_unit_type_index] -= 1;
			array_delete(combat_unit_instance.unit_instance.frontline_combat_unit_unengaged, temp_frontline_combat_unit_unengaged_index, 1);
			array_push(combat_unit_instance.unit_instance.frontline_combat_unit_engaged, combat_unit_instance);
			
			// Add Selected Combat Unit to Battle's Faction Combat Unit Pools
			switch (temp_battle_combat_grid_side)
			{
				case CelestialBattleCombatGridSide.Left:
					// Find random Available Slot in the Combat Grid's Frontline
					var temp_random_frontline_combat_grid_available_slot_index_a = irandom(battle_instance.battle_frontline_available_slots_count_a - 1);
					temp_combat_grid_available_slot = array_get(battle_instance.battle_frontline_available_slots_a, temp_random_frontline_combat_grid_available_slot_index_a);
					
					// Remove Available Slot from Available Slot Array
					array_delete(battle_instance.battle_frontline_available_slots_a, temp_random_frontline_combat_grid_available_slot_index_a, 1);
					
					// Decrement Combat Grid Available Slots Count
					battle_instance.battle_frontline_available_slots_count_a--;
					break;
				case CelestialBattleCombatGridSide.Right:
					// Find random Available Slot in the Combat Grid's Frontline
					var temp_random_frontline_combat_grid_available_slot_index_b = irandom(battle_instance.battle_frontline_available_slots_count_b - 1);
					temp_combat_grid_available_slot = array_get(battle_instance.battle_frontline_available_slots_b, temp_random_frontline_combat_grid_available_slot_index_b);
					
					// Remove Available Slot from Available Slot Array
					array_delete(battle_instance.battle_frontline_available_slots_b, temp_random_frontline_combat_grid_available_slot_index_b, 1);
					
					// Decrement Combat Grid Available Slots Count
					battle_instance.battle_frontline_available_slots_count_b--;
					break;
			}
			break;
		case CelestialBattleColumnType.Midline:
			// Find Combat Unit's Unengaged Index
			var temp_midline_combat_unit_unengaged_index = array_get_index(combat_unit_instance.unit_instance.midline_combat_unit_unengaged, combat_unit_instance);
			
			// Check if Combat Unit is currently Engaged in Combat
			if (temp_midline_combat_unit_unengaged_index == -1)
			{
				// Combat Unit is currently Engaged in Combat - Early Return
				return;
			}
			
			// Find the index of the Combat Unit's Type within their Unit Instance's Combat Unit Types Array
			var temp_midline_combat_unit_type_index = array_get_index(combat_unit_instance.unit_instance.midline_combat_unit_type, temp_combat_unit_type);
			
			// Move Selected Combat Unit from Unengaged Array to Engaged Array
			combat_unit_instance.unit_instance.midline_combat_unit_unengaged_count[temp_midline_combat_unit_type_index] -= 1;
			array_delete(combat_unit_instance.unit_instance.midline_combat_unit_unengaged, temp_midline_combat_unit_unengaged_index, 1);
			array_push(combat_unit_instance.unit_instance.midline_combat_unit_engaged, combat_unit_instance);
			
			// Add Selected Combat Unit to Battle's Faction Combat Unit Pools
			switch (temp_battle_combat_grid_side)
			{
				case CelestialBattleCombatGridSide.Left:
					// Find random Available Slot in the Combat Grid's Midline
					var temp_random_midline_combat_grid_available_slot_index_a = irandom(battle_instance.battle_midline_available_slots_count_a - 1);
					temp_combat_grid_available_slot = array_get(battle_instance.battle_midline_available_slots_a, temp_random_midline_combat_grid_available_slot_index_a);
					
					// Remove Available Slot from Available Slot Array
					array_delete(battle_instance.battle_midline_available_slots_a, temp_random_midline_combat_grid_available_slot_index_a, 1);
					
					// Decrement Combat Grid Available Slots Count
					battle_instance.battle_midline_available_slots_count_a--;
					break;
				case CelestialBattleCombatGridSide.Right:
					// Find random Available Slot in the Combat Grid's Midline
					var temp_random_midline_combat_grid_available_slot_index_b = irandom(battle_instance.battle_midline_available_slots_count_b - 1);
					temp_combat_grid_available_slot = array_get(battle_instance.battle_midline_available_slots_b, temp_random_midline_combat_grid_available_slot_index_b);
					
					// Remove Available Slot from Available Slot Array
					array_delete(battle_instance.battle_midline_available_slots_b, temp_random_midline_combat_grid_available_slot_index_b, 1);
					
					// Decrement Combat Grid Available Slots Count
					battle_instance.battle_midline_available_slots_count_b--;
					break;
			}
			break;
		case CelestialBattleColumnType.Backline:
			// Find Combat Unit's Unengaged Index
			var temp_backline_combat_unit_unengaged_index = array_get_index(combat_unit_instance.unit_instance.backline_combat_unit_unengaged, combat_unit_instance);
			
			// Check if Combat Unit is currently Engaged in Combat
			if (temp_backline_combat_unit_unengaged_index == -1)
			{
				// Combat Unit is currently Engaged in Combat - Early Return
				return;
			}
			
			// Find the index of the Combat Unit's Type within their Unit Instance's Combat Unit Types Array
			var temp_backline_combat_unit_type_index = array_get_index(combat_unit_instance.unit_instance.backline_combat_unit_type, temp_combat_unit_type);
			
			// Move Selected Combat Unit from Unengaged Array to Engaged Array
			combat_unit_instance.unit_instance.backline_combat_unit_unengaged_count[temp_backline_combat_unit_type_index] -= 1;
			array_delete(combat_unit_instance.unit_instance.backline_combat_unit_unengaged, temp_backline_combat_unit_unengaged_index, 1);
			array_push(combat_unit_instance.unit_instance.backline_combat_unit_engaged, combat_unit_instance);
			
			// Add Selected Combat Unit to Battle's Faction Combat Unit Pools
			switch (temp_battle_combat_grid_side)
			{
				case CelestialBattleCombatGridSide.Left:
					// Find random Available Slot in the Combat Grid's Backline
					var temp_random_backline_combat_grid_available_slot_index_a = irandom(battle_instance.battle_backline_available_slots_count_a - 1);
					temp_combat_grid_available_slot = array_get(battle_instance.battle_backline_available_slots_a, temp_random_backline_combat_grid_available_slot_index_a);
					
					// Remove Available Slot from Available Slot Array
					array_delete(battle_instance.battle_backline_available_slots_a, temp_random_backline_combat_grid_available_slot_index_a, 1);
					
					// Decrement Combat Grid Available Slots Count
					battle_instance.battle_backline_available_slots_count_a--;
					break;
				case CelestialBattleCombatGridSide.Right:
					// Find random Available Slot in the Combat Grid's Backline
					var temp_random_backline_combat_grid_available_slot_index_b = irandom(battle_instance.battle_backline_available_slots_count_b - 1);
					temp_combat_grid_available_slot = array_get(battle_instance.battle_backline_available_slots_b, temp_random_backline_combat_grid_available_slot_index_b);
					
					// Remove Available Slot from Available Slot Array
					array_delete(battle_instance.battle_backline_available_slots_b, temp_random_backline_combat_grid_available_slot_index_b, 1);
					
					// Decrement Combat Grid Available Slots Count
					battle_instance.battle_backline_available_slots_count_b--;
					break;
			}
			break;
		default:
			break;
	}
	
	// Set Selected Combat Unit's Column and Row from Available Slot Index
	combat_unit_instance.combat_grid_column = temp_combat_grid_available_slot div CelestialBattleCombatGridRows;
	combat_unit_instance.combat_grid_row = temp_combat_grid_available_slot mod CelestialBattleCombatGridRows;
	
	// Set Selected Combat Unit's Facing Direction
	combat_unit_instance.combat_grid_side = temp_battle_combat_grid_side;
	
	// Set Combat Unit's Battle Instance
	combat_unit_instance.battle_instance = battle_instance;
	
	// Find the index of this Battle Instance within the Combat Unit's Celestial Unit's Engaged Battles Array, Increment their Battle Combat Unit Contribution, and add the Combat Unit to the Engaged Battle Combat Unit Array
	var temp_engaged_battles_index = array_get_index(combat_unit_instance.unit_instance.engaged_battles, battle_instance);
	combat_unit_instance.unit_instance.engaged_battles_combat_units_contribution[temp_engaged_battles_index] += 1;
	array_push(combat_unit_instance.unit_instance.engaged_battles_combat_units[temp_engaged_battles_index], combat_unit_instance);
	
	// Add Selected Combat Unit to Battle's Combat Units Pool
	array_insert(battle_instance.battle_combat_units, 0, combat_unit_instance);
	
	// Add Selected Combat Unit to Battle's Faction Combat Unit Pools
	switch (temp_battle_combat_grid_side)
	{
		case CelestialBattleCombatGridSide.Left:
			array_push(battle_instance.battle_combat_units_a, combat_unit_instance);
			break;
		case CelestialBattleCombatGridSide.Right:
			array_push(battle_instance.battle_combat_units_b, combat_unit_instance);
			break;
	}
	
	// Reset Combat Unit Instance's Celestial Battle Behaviour
	celestial_battle_reset_combat_unit(combat_unit_instance);
}

/// @function celestial_battle_reset_combat_unit(combat_unit_instance);
function celestial_battle_reset_combat_unit(combat_unit_instance)
{
	// Reset Combat Unit Instance's Combat Action Behaviour
	combat_unit_instance.combat_unit_action = -1;
	combat_unit_instance.combat_unit_action_time = 0;
	combat_unit_instance.combat_unit_action_count = -1;
	combat_unit_instance.combat_unit_action_exhaustion = -1;
	combat_unit_instance.combat_unit_action_duration = -1;
	
	// Reset Combat Unit Instance's Combat Action Target Variables
	combat_unit_instance.combat_unit_action_target_inst = noone;
	combat_unit_instance.combat_unit_action_target_combat_grid_side = CelestialBattleCombatGridSide.None;
	combat_unit_instance.combat_unit_action_target_combat_grid_column = -1;
	combat_unit_instance.combat_unit_action_target_combat_grid_row = -1;
	
	// Randomize Combat Unit Instance's Position Offset
	combat_unit_instance.random_offset_x = irandom_range(-3, 3);
	combat_unit_instance.random_offset_y = irandom_range(-1, 3);
	
	// Reset Combat Unit Instance's Entry Animation Variables
	combat_unit_instance.entry_animation = true;
	combat_unit_instance.entry_animation_value = 0;
	combat_unit_instance.entry_delay_duration = random(60);
	
	// Reset Combat Unit Instance's Exit Animation Variables
	combat_unit_instance.exit_animation = false;
	combat_unit_instance.exit_animation_value = 1;
	combat_unit_instance.exit_delay_duration = random(18);
}

/// @function celestial_battle_remove_combat_unit(battle_instance, combat_unit_instance);
function celestial_battle_remove_combat_unit(battle_instance, combat_unit_instance)
{
	// Find Combat Unit's Index within the Celestial Battle's Combat Units Array
	var temp_battle_combat_unit_index = array_get_index(battle_instance.battle_combat_units, combat_unit_instance);
	
	// Check if Combat Unit exists within the Celestial Battle
	if (temp_battle_combat_unit_index == -1)
	{
		// Combat Unit doesn't exist in the Celestial Battle - Early Return
		return;
	}
	
	// Delete the Combat Unit Instance from the Celestial Battle's Combat Units Array
	array_delete(battle_instance.battle_combat_units, temp_battle_combat_unit_index, 1);
	
	// Perform Combat Unit's Leave Battle Behaviour
	celestial_battle_combat_unit_leave(battle_instance, combat_unit_instance);
	
	// Find the index of this Battle Instance within the Combat Unit's Celestial Unit's Engaged Battles Array and Decrement their Battle Combat Unit Contribution
	var temp_engaged_battles_index = array_get_index(combat_unit_instance.unit_instance.engaged_battles, battle_instance);
	combat_unit_instance.unit_instance.engaged_battles_combat_units_contribution[temp_engaged_battles_index] -= 1;
	
	// Remove the Combat Unit from their Celestial Unit's Engaged Battles Combat Units Array
	var temp_engaged_battles_combat_unit_index = array_get_index(combat_unit_instance.unit_instance.engaged_battles_combat_units[temp_engaged_battles_index], combat_unit_instance);
	array_delete(combat_unit_instance.unit_instance.engaged_battles_combat_units[temp_engaged_battles_index], temp_engaged_battles_combat_unit_index, 1);
	
	// Check Combat Unit's Grid Direction
	switch (combat_unit_instance.combat_grid_side)
	{
		case CelestialBattleCombatGridSide.Left:
			// Remove Combat Unit Instance from Celestial Battle's Combat Column Type Arrays
			switch (global.celestial_combat_units[combat_unit_instance.combat_unit_type].unit_combat_column_type)
			{
				case CelestialBattleColumnType.Frontline:
					// Move Combat Unit from the Engaged Combat Unit Pool to the Unengaged Combat Unit Pool within their Celestial Unit Instance
					array_delete(combat_unit_instance.unit_instance.frontline_combat_unit_engaged, array_get_index(combat_unit_instance.unit_instance.frontline_combat_unit_engaged, combat_unit_instance), 1);
					array_push(combat_unit_instance.unit_instance.frontline_combat_unit_unengaged, combat_unit_instance);
					combat_unit_instance.unit_instance.frontline_combat_unit_unengaged_count[array_get_index(combat_unit_instance.unit_instance.frontline_combat_unit_type, combat_unit_instance.combat_unit_type)] += 1;
					
					// Calculate Battle Available Slot and add the Available Slot Index back to its Available Slot Pool
					var temp_frontline_combat_grid_available_slot_a = (CelestialBattleCombatGridRows * combat_unit_instance.combat_grid_column) + combat_unit_instance.combat_grid_row;
					array_push(battle_instance.battle_frontline_available_slots_a, temp_frontline_combat_grid_available_slot_a);
					
					// Increment Battle Available Slots Count
					battle_instance.battle_frontline_available_slots_count_a++;
					
					// Check if Combat Unit has been indexed in the Celestial Battle's Frontline Combat Units Array
					var temp_combat_unit_frontline_a_index = array_get_index(battle_instance.battle_frontline_combat_units_a, combat_unit_instance);
					
					if (temp_combat_unit_frontline_a_index != -1)
					{
						// Remove Combat Unit from Celestial Battle's Frontline Combat Units Array
						array_delete(battle_instance.battle_frontline_combat_units_a, temp_combat_unit_frontline_a_index, 1);
					}
					break;
				case CelestialBattleColumnType.Midline:
					// Move Combat Unit from the Engaged Combat Unit Pool to the Unengaged Combat Unit Pool within their Celestial Unit Instance
					array_delete(combat_unit_instance.unit_instance.midline_combat_unit_engaged, array_get_index(combat_unit_instance.unit_instance.midline_combat_unit_engaged, combat_unit_instance), 1);
					array_push(combat_unit_instance.unit_instance.midline_combat_unit_unengaged, combat_unit_instance);
					combat_unit_instance.unit_instance.midline_combat_unit_unengaged_count[array_get_index(combat_unit_instance.unit_instance.midline_combat_unit_type, combat_unit_instance.combat_unit_type)] += 1;
					
					// Calculate Battle Available Slot and add the Available Slot Index back to its Available Slot Pool
					var temp_midline_combat_grid_available_slot_a = (CelestialBattleCombatGridRows * combat_unit_instance.combat_grid_column) + combat_unit_instance.combat_grid_row;
					array_push(battle_instance.battle_midline_available_slots_a, temp_midline_combat_grid_available_slot_a);
					
					// Increment Battle Available Slots Count
					battle_instance.battle_midline_available_slots_count_a++;
					
					// Check if Combat Unit has been indexed in the Celestial Battle's Midline Combat Units Array
					var temp_combat_unit_midline_a_index = array_get_index(battle_instance.battle_midline_combat_units_a, combat_unit_instance);
					
					if (temp_combat_unit_midline_a_index != -1)
					{
						// Remove Combat Unit from Celestial Battle's Midline Combat Units Array
						array_delete(battle_instance.battle_midline_combat_units_a, temp_combat_unit_midline_a_index, 1);
					}
					break;
				case CelestialBattleColumnType.Backline:
					// Move Combat Unit from the Engaged Combat Unit Pool to the Unengaged Combat Unit Pool within their Celestial Unit Instance
					array_delete(combat_unit_instance.unit_instance.backline_combat_unit_engaged, array_get_index(combat_unit_instance.unit_instance.backline_combat_unit_engaged, combat_unit_instance), 1);
					array_push(combat_unit_instance.unit_instance.backline_combat_unit_unengaged, combat_unit_instance);
					combat_unit_instance.unit_instance.backline_combat_unit_unengaged_count[array_get_index(combat_unit_instance.unit_instance.backline_combat_unit_type, combat_unit_instance.combat_unit_type)] += 1;
					
					// Calculate Battle Available Slot and add the Available Slot Index back to its Available Slot Pool
					var temp_backline_combat_grid_available_slot_a = (CelestialBattleCombatGridRows * combat_unit_instance.combat_grid_column) + combat_unit_instance.combat_grid_row;
					array_push(battle_instance.battle_backline_available_slots_a, temp_backline_combat_grid_available_slot_a);
					
					// Increment Battle Available Slots Count
					battle_instance.battle_backline_available_slots_count_a++;
					
					// Check if Combat Unit has been indexed in the Celestial Battle's Backline Combat Units Array
					var temp_combat_unit_backline_a_index = array_get_index(battle_instance.battle_backline_combat_units_a, combat_unit_instance);
					
					if (temp_combat_unit_backline_a_index != -1)
					{
						// Remove Combat Unit from Celestial Battle's Backline Combat Units Array
						array_delete(battle_instance.battle_backline_combat_units_a, temp_combat_unit_backline_a_index, 1);
					}
					break;
			}
			
			// Check if Combat Unit exists within the Celestial Battle's Combat Grid Instances Array
			var temp_combat_unit_combat_grid_instances_a_index = array_get_index(battle_instance.battle_combat_grid_instances_a[combat_unit_instance.combat_grid_column], combat_unit_instance);
			
			if (temp_combat_unit_combat_grid_instances_a_index != -1)
			{
				// Remove Combat Unit from Celestial Battle's Combat Grid
				array_set(array_get(battle_instance.battle_combat_grid_a, combat_unit_instance.combat_grid_column), combat_unit_instance.combat_grid_row, noone);
				
				// Remove Combat Unit from Celestial Battle's Combat Grid Instances Array
				array_delete(battle_instance.battle_combat_grid_instances_a[combat_unit_instance.combat_grid_column], temp_combat_unit_combat_grid_instances_a_index, 1);
			}
			
			// Remove Combat Unit from Celestial Battle's Left Combat Units Pool
			array_delete(battle_instance.battle_combat_units_a, array_get_index(battle_instance.battle_combat_units_a, combat_unit_instance), 1);
			break;
		case CelestialBattleCombatGridSide.Right:
			// Remove Combat Unit Instance from Celestial Battle's Combat Column Type Arrays
			switch (global.celestial_combat_units[combat_unit_instance.combat_unit_type].unit_combat_column_type)
			{
				case CelestialBattleColumnType.Frontline:
					// Move Combat Unit from the Engaged Combat Unit Pool to the Unengaged Combat Unit Pool within their Celestial Unit Instance
					array_delete(combat_unit_instance.unit_instance.frontline_combat_unit_engaged, array_get_index(combat_unit_instance.unit_instance.frontline_combat_unit_engaged, combat_unit_instance), 1);
					array_push(combat_unit_instance.unit_instance.frontline_combat_unit_unengaged, combat_unit_instance);
					combat_unit_instance.unit_instance.frontline_combat_unit_unengaged_count[array_get_index(combat_unit_instance.unit_instance.frontline_combat_unit_type, combat_unit_instance.combat_unit_type)] += 1;
					
					// Calculate Battle Available Slot and add the Available Slot Index back to its Available Slot Pool
					var temp_frontline_combat_grid_available_slot_b = (CelestialBattleCombatGridRows * combat_unit_instance.combat_grid_column) + combat_unit_instance.combat_grid_row;
					array_push(battle_instance.battle_frontline_available_slots_b, temp_frontline_combat_grid_available_slot_b);
					
					// Increment Battle Available Slots Count
					battle_instance.battle_frontline_available_slots_count_b++;
					
					// Check if Combat Unit has been indexed in the Celestial Battle's Frontline Combat Units Array
					var temp_combat_unit_frontline_b_index = array_get_index(battle_instance.battle_frontline_combat_units_b, combat_unit_instance);
					
					if (temp_combat_unit_frontline_b_index != -1)
					{
						// Remove Combat Unit from Celestial Battle's Frontline Combat Units Array
						array_delete(battle_instance.battle_frontline_combat_units_b, temp_combat_unit_frontline_b_index, 1);
					}
					break;
				case CelestialBattleColumnType.Midline:
					// Move Combat Unit from the Engaged Combat Unit Pool to the Unengaged Combat Unit Pool within their Celestial Unit Instance
					array_delete(combat_unit_instance.unit_instance.midline_combat_unit_engaged, array_get_index(combat_unit_instance.unit_instance.midline_combat_unit_engaged, combat_unit_instance), 1);
					array_push(combat_unit_instance.unit_instance.midline_combat_unit_unengaged, combat_unit_instance);
					combat_unit_instance.unit_instance.midline_combat_unit_unengaged_count[array_get_index(combat_unit_instance.unit_instance.midline_combat_unit_type, combat_unit_instance.combat_unit_type)] += 1;
					
					// Calculate Battle Available Slot and add the Available Slot Index back to its Available Slot Pool
					var temp_midline_combat_grid_available_slot_b = (CelestialBattleCombatGridRows * combat_unit_instance.combat_grid_column) + combat_unit_instance.combat_grid_row;
					array_push(battle_instance.battle_midline_available_slots_b, temp_midline_combat_grid_available_slot_b);
					
					// Increment Battle Available Slots Count
					battle_instance.battle_midline_available_slots_count_b++;
					
					// Check if Combat Unit has been indexed in the Celestial Battle's Midline Combat Units Array
					var temp_combat_unit_midline_b_index = array_get_index(battle_instance.battle_midline_combat_units_b, combat_unit_instance);
					
					if (temp_combat_unit_midline_b_index != -1)
					{
						// Remove Combat Unit from Celestial Battle's Midline Combat Units Array
						array_delete(battle_instance.battle_midline_combat_units_b, temp_combat_unit_midline_b_index, 1);
					}
					break;
				case CelestialBattleColumnType.Backline:
					// Move Combat Unit from the Engaged Combat Unit Pool to the Unengaged Combat Unit Pool within their Celestial Unit Instance
					array_delete(combat_unit_instance.unit_instance.backline_combat_unit_engaged, array_get_index(combat_unit_instance.unit_instance.backline_combat_unit_engaged, combat_unit_instance), 1);
					array_push(combat_unit_instance.unit_instance.backline_combat_unit_unengaged, combat_unit_instance);
					combat_unit_instance.unit_instance.backline_combat_unit_unengaged_count[array_get_index(combat_unit_instance.unit_instance.backline_combat_unit_type, combat_unit_instance.combat_unit_type)] += 1;
					
					// Calculate Battle Available Slot and add the Available Slot Index back to its Available Slot Pool
					var temp_backline_combat_grid_available_slot_b = (CelestialBattleCombatGridRows * combat_unit_instance.combat_grid_column) + combat_unit_instance.combat_grid_row;
					array_push(battle_instance.battle_backline_available_slots_b, temp_backline_combat_grid_available_slot_b);
					
					// Increment Battle Available Slots Count
					battle_instance.battle_backline_available_slots_count_b++;
					
					// Check if Combat Unit has been indexed in the Celestial Battle's Backline Combat Units Array
					var temp_combat_unit_backline_b_index = array_get_index(battle_instance.battle_backline_combat_units_b, combat_unit_instance);
					
					if (temp_combat_unit_backline_b_index != -1)
					{
						// Remove Combat Unit from Celestial Battle's Backline Combat Units Array
						array_delete(battle_instance.battle_backline_combat_units_b, temp_combat_unit_backline_b_index, 1);
					}
					break;
			}
			
			// Check if Combat Unit exists within the Celestial Battle's Combat Grid Instances Array
			var temp_combat_unit_combat_grid_instances_b_index = array_get_index(battle_instance.battle_combat_grid_instances_b[combat_unit_instance.combat_grid_column], combat_unit_instance);
			
			if (temp_combat_unit_combat_grid_instances_b_index != -1)
			{
				// Remove Combat Unit from Celestial Battle's Combat Grid
				array_set(array_get(battle_instance.battle_combat_grid_b, combat_unit_instance.combat_grid_column), combat_unit_instance.combat_grid_row, noone);
				
				// Remove Combat Unit from Celestial Battle's Combat Grid Instances Array
				array_delete(battle_instance.battle_combat_grid_instances_b[combat_unit_instance.combat_grid_column], temp_combat_unit_combat_grid_instances_b_index, 1);
			}
			
			// Remove Combat Unit from Celestial Battle's Left Combat Units Pool
			array_delete(battle_instance.battle_combat_units_b, array_get_index(battle_instance.battle_combat_units_b, combat_unit_instance), 1);
			break;
	}
	
	// Reset Combat Unit's Combat Grid Variables
	combat_unit_instance.combat_grid_side = CelestialBattleCombatGridSide.None;
	combat_unit_instance.combat_grid_column = -1;
	combat_unit_instance.combat_grid_row = -1;
	
	// Reset Combat Unit's Battle Instance Variable
	combat_unit_instance.battle_instance = noone;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////=====================================================================

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
	var temp_actor_platform_side = CelestialBattleCombatGridSide.None;
	var temp_actor_faction_instance = instance_exists(actor_combat_unit_instance.unit_instance) ? actor_combat_unit_instance.unit_instance.unit_faction : noone;
	
	// Check what Battle Platform Side the Actor is participating on
	if (temp_actor_faction_instance == CelestialSimulator.player_faction)
	{
		// Establish Actor Battle Platform Side
		temp_actor_platform_side = CelestialBattleCombatGridSide.Left;
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
			temp_actor_platform_side = CelestialBattleCombatGridSide.Right;
		}
		else if (temp_player_faction_allied_check or temp_actor_faction_allied_check)
		{
			temp_actor_platform_side = CelestialBattleCombatGridSide.Left;
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
			temp_actor_platform_side = CelestialBattleCombatGridSide.Right;
		}
		else if (temp_player_faction_null_faction_allied_check)
		{
			temp_actor_platform_side = CelestialBattleCombatGridSide.Left;
		}
	}
	
	// Check if Actor is participating in the Battle's Choreography
	if (temp_actor_platform_side != CelestialBattleCombatGridSide.None)
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
			facing_direction: temp_actor_platform_side == CelestialBattleCombatGridSide.Left ? 1 : -1,
			
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
		if (temp_actor_platform_side == CelestialBattleCombatGridSide.Left)
		{
			battle_instance.battle_choreography_actors_battle_column_sizes[CelestialBattlePriorityRankMax - temp_actor_struct.actor_priority_rank - 1] += 1;
		}
		else if (temp_actor_platform_side == CelestialBattleCombatGridSide.Right)
		{
			battle_instance.battle_choreography_actors_battle_column_sizes[CelestialBattlePriorityRankMax + temp_actor_struct.actor_priority_rank] += 1;
		}
		
		// Index Actor Struct into Battle's Choreography Actors Array
		array_push(battle_instance.battle_choreography_actors, temp_actor_struct);
	}
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
function celestial_battle_damage_combat_unit(battle_instance, celestial_combat_unit, damage_value)
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
	
	
	//
	if (instance_exists(celestial_combat_unit.unit_instance))
	{
		//
		var temp_unit_instance = celestial_combat_unit.unit_instance;
		
		//
		celestial_unit_remove_combat_unit(temp_unit_instance, celestial_combat_unit);
		
		//
		if (array_length(temp_unit_instance.combat_units) < 1)
		{
			//
			if (battle_instance.battle_primary_unit_a == temp_unit_instance or battle_instance.battle_primary_unit_b == temp_unit_instance)
			{
				//
				celestial_battle_end(battle_instance);
			}
			
			//
			instance_destroy(temp_unit_instance);
		}
	}
	
	//
	instance_destroy(celestial_combat_unit);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////


