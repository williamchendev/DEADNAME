/// @description Battle Init Event
// Celestial Battle Init Behaviour Event

// Initialize as Persistent Object
persistent = true;

// Initialize Battle Celestial Sub Object Type
celestial_sub_object_type = CelestialSubObjectType.Battle;

// Initialize Celestial Sub Object Variables
local_position_u = 0.5;
local_position_v = 0.5;

world_position_x = 0;
world_position_y = 0;
world_position_z = 0;

sphere_vector_x = 0;
sphere_vector_y = 0;
sphere_vector_z = 0;

emissive = 0;
emissive_multiplier = 0;

miniature_sprite_index = sOverworld_Conflict_Icon;

// Clock Variables
battle_total_time = 0;
battle_round_timer = 0;

battle_round = 0;

// Battle Variables
battle_exists = true;

battle_x = 0;
battle_y = 0;
battle_z = 0;
battle_elevation = 0;

battle_near_collision_threshold = 2;
battle_far_collision_threshold = 2;

battle_collision_check_timer = CelestialSimulator.global_collision_check_interval + random(CelestialSimulator.global_collision_check_interval);

// Celestial Body Variables
celestial_body_instance = noone;

// Pathfinding Variables
pathfinding_node_a_index = -1;
pathfinding_node_b_index = -1;

// Initialize Battle Unit & Faction Variables
battle_faction_a = noone;
battle_faction_b = noone;

battle_primary_unit_a = noone;
battle_primary_unit_b = noone;

battle_supporting_units_a = array_create(0);
battle_supporting_units_b = array_create(0);

// Initialize Battle Combat Unit Variables
battle_combat_units = array_create(0);

battle_combat_units_a = array_create(0);
battle_combat_units_b = array_create(0);

battle_frontline_combat_units_a = array_create(0);
battle_midline_combat_units_a = array_create(0);
battle_backline_combat_units_a = array_create(0);

battle_frontline_combat_units_b = array_create(0);
battle_midline_combat_units_b = array_create(0);
battle_backline_combat_units_b = array_create(0);

battle_frontline_available_slots_a = array_create(0);
battle_midline_available_slots_a = array_create(0);
battle_backline_available_slots_a = array_create(0);

battle_frontline_available_slots_b = array_create(0);
battle_midline_available_slots_b = array_create(0);
battle_backline_available_slots_b = array_create(0);

battle_frontline_available_slots_count_a = 0;
battle_midline_available_slots_count_a = 0;
battle_backline_available_slots_count_a = 0;

battle_frontline_available_slots_count_b = 0;
battle_midline_available_slots_count_b = 0;
battle_backline_available_slots_count_b = 0;

// Initialize & Populate Battle's Empty Combat Grid Arrays
battle_combat_grid_a = array_create(CelestialBattleCombatGridColumns);
battle_combat_grid_b = array_create(CelestialBattleCombatGridColumns);

battle_combat_grid_instances_a = array_create(CelestialBattleCombatGridColumns);
battle_combat_grid_instances_b = array_create(CelestialBattleCombatGridColumns);

battle_combat_grid_a_structs = array_create(CelestialBattleCombatGridColumns);
battle_combat_grid_b_structs = array_create(CelestialBattleCombatGridColumns);

var temp_battle_combat_grid_column_index = 0;

repeat (CelestialBattleCombatGridColumns)
{
	// Initialize Battle Combat Grid's Column Array
	battle_combat_grid_a[temp_battle_combat_grid_column_index] = array_create(CelestialBattleCombatGridRows, noone);
	battle_combat_grid_b[temp_battle_combat_grid_column_index] = array_create(CelestialBattleCombatGridRows, noone);
	
	battle_combat_grid_instances_a[temp_battle_combat_grid_column_index] = array_create(0);
	battle_combat_grid_instances_b[temp_battle_combat_grid_column_index] = array_create(0);
	
	battle_combat_grid_a_structs[temp_battle_combat_grid_column_index] = array_create(CelestialBattleCombatGridRows);
	battle_combat_grid_b_structs[temp_battle_combat_grid_column_index] = array_create(CelestialBattleCombatGridRows);
	
	// Establish Column's Type to index Available Combat Grid Slots properly
	var temp_column_type_available_slots_a_array = battle_frontline_available_slots_a;
	var temp_column_type_available_slots_b_array = battle_frontline_available_slots_b;
	
	switch (global.celestial_battle_combat_grid_column_type[temp_battle_combat_grid_column_index])
	{
		case CelestialBattleColumnType.Midline:
			// Increment Column Type's Available Slots by the number of Rows within the Column
			battle_midline_available_slots_count_a += CelestialBattleCombatGridRows;
			battle_midline_available_slots_count_b += CelestialBattleCombatGridRows;
			
			// Set the Column Type's Available Slot Arrays to Midline
			temp_column_type_available_slots_a_array = battle_midline_available_slots_a;
			temp_column_type_available_slots_b_array = battle_midline_available_slots_b;
			break;
		case CelestialBattleColumnType.Backline:
			// Increment Column Type's Available Slots by the number of Rows within the Column
			battle_backline_available_slots_count_a += CelestialBattleCombatGridRows;
			battle_backline_available_slots_count_b += CelestialBattleCombatGridRows;
			
			// Set the Column Type's Available Slot Arrays to Backline
			temp_column_type_available_slots_a_array = battle_backline_available_slots_a;
			temp_column_type_available_slots_b_array = battle_backline_available_slots_b;
			break;
		case CelestialBattleColumnType.Frontline:
		default:
			// Increment Column Type's Available Slots by the number of Rows within the Column
			battle_frontline_available_slots_count_a += CelestialBattleCombatGridRows;
			battle_frontline_available_slots_count_b += CelestialBattleCombatGridRows;
			break;
	}
	
	// Iterate through the Battle Combat Grid Column's Rows
	var temp_battle_combat_grid_row_index = 0;
	
	repeat (CelestialBattleCombatGridRows)
	{
		// Initialize Combat Grid Tile Structs
		var temp_battle_combat_tile_struct_a = 
		{
			tile_alpha: 0
		};
		
		var temp_battle_combat_tile_struct_b = 
		{
			tile_alpha: 0
		};
		
		// Index Combat Grid Tile Structs in Combat Grid's Struct Arrays
		array_set(battle_combat_grid_a_structs[temp_battle_combat_grid_column_index], temp_battle_combat_grid_row_index, temp_battle_combat_tile_struct_a);
		array_set(battle_combat_grid_b_structs[temp_battle_combat_grid_column_index], temp_battle_combat_grid_row_index, temp_battle_combat_tile_struct_b);
		
		// Establish the Index of the Combat Grid's Available Slot
		var temp_available_slot_index = (temp_battle_combat_grid_column_index * CelestialBattleCombatGridRows) + temp_battle_combat_grid_row_index;
		
		// Add the Available Slot Index to the Column Type's Available Slots Array
		array_push(temp_column_type_available_slots_a_array, temp_available_slot_index);
		array_push(temp_column_type_available_slots_b_array, temp_available_slot_index);
		
		// Increment Combat Grid Row Index
		temp_battle_combat_grid_row_index++;
	}
	
	// Increment Combat Grid Column Index
	temp_battle_combat_grid_column_index++;
}

// Initialize Battle Combat Action Variables
battle_combat_actions = array_create(0);

// Initialize Battle Choreography Arrays
battle_choreography_actors = array_create(0);
battle_choreography_actions = array_create(0);
