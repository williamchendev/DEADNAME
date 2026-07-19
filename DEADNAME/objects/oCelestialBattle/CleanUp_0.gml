/// @description Battle Cleanup Event
// Celestial Battle Cleanup Behaviour Event

// Increment through Battle's Choreography Actors Array and Erase Battle's Choreography Actors Structs
var temp_battle_choreography_actors_count = array_length(battle_choreography_actors);
var temp_battle_choreography_actors_index = temp_battle_choreography_actors_count - 1;

repeat (temp_battle_choreography_actors_count)
{
	// Delete Battle Choreography Actors Struct
	delete battle_choreography_actors[temp_battle_choreography_actors_index];
	
	// Decrement Battle Choreography Actors Index
	temp_battle_choreography_actors_index--;
}

array_resize(battle_choreography_actors, 0);

// Clear Battle Choreography Actors Battle Column Sizes Array
array_resize(battle_choreography_actors_battle_column_sizes, 0);

// Increment through Battle's Choreography Actions Array and Erase Battle's Choreography Actions Structs
var temp_battle_choreography_actions_count = array_length(battle_choreography_actions);
var temp_battle_choreography_actions_index = temp_battle_choreography_actions_count - 1;

repeat (temp_battle_choreography_actions_count)
{
	// Delete Battle Choreography Actions Struct
	delete battle_choreography_actions[temp_battle_choreography_actions_index];
	
	// Decrement Battle Choreography Actions Index
	temp_battle_choreography_actions_index--;
}

array_resize(battle_choreography_actions, 0);

// Destroy Celestial Battle's DS Map
if (battle_choreography_actors_map != -1)
{
	ds_map_destroy(battle_choreography_actors_map);
	battle_choreography_actors_map = -1;
}

// Increment through Battle's Faction Arrays and Erase Battle's Faction Data
var temp_factions_count = array_length(battle_factions);
var temp_factions_index = temp_factions_count - 1;

repeat (temp_factions_count)
{
	// Resize and Delete Faction Units Array
	array_resize(array_get(battle_units, temp_factions_index), 0);
	array_delete(battle_units, temp_factions_index, 1);
	
	// Find Faction Priority Pools
	var temp_faction_land_priority_pool = array_get(battle_land_priority_pools, temp_factions_index);
	var temp_faction_air_priority_pool = array_get(battle_air_priority_pools, temp_factions_index);
	var temp_faction_sea_priority_pool = array_get(battle_sea_priority_pools, temp_factions_index);
	
	// Empty Priority Pools
	var temp_priority_rank_index = 0;
	
	repeat (CelestialBattlePriorityRankMax)
	{
		// Empty Priority Rank Sub-Unit Array
		array_resize(array_get(temp_faction_land_priority_pool, temp_priority_rank_index), 0);
		array_resize(array_get(temp_faction_air_priority_pool, temp_priority_rank_index), 0);
		array_resize(array_get(temp_faction_sea_priority_pool, temp_priority_rank_index), 0);
		
		// Increment Priority Rank Index
		temp_priority_rank_index++;
	}
	
	// Delete Unused Faction Priority Pools
	array_resize(temp_faction_land_priority_pool, 0);
	array_resize(temp_faction_air_priority_pool, 0);
	array_resize(temp_faction_sea_priority_pool, 0);
	
	// Decrement Factions Index
	temp_factions_index--;
}

array_resize(battle_factions, 0);
array_resize(battle_units, 0);

array_resize(battle_land_priority_pools, 0);
array_resize(battle_air_priority_pools, 0);
array_resize(battle_sea_priority_pools, 0);

