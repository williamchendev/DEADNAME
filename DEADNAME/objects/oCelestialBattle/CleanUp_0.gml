/// @description Battle Cleanup Event
// Celestial Battle Cleanup Behaviour Event

// Incrememnt through Battle's Faction Arrays and Erase Battle's Faction Data
var temp_factions_count = array_length(battle_factions);
var temp_factions_index = temp_factions_count - 1;

repeat (temp_factions_count)
{
	// Resize and Delete Faction Units Array
	array_resize(array_get(battle_units, temp_factions_index), 0);
	array_resize(array_get(battle_hostile_factions, temp_factions_index), 0);
	array_resize(array_get(battle_allied_factions, temp_factions_index), 0);
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

array_resize(battle_hostile_factions, 0);
array_resize(battle_allied_factions, 0);

array_resize(battle_land_priority_pools, 0);
array_resize(battle_air_priority_pools, 0);
array_resize(battle_sea_priority_pools, 0);

// Incrememnt through Battle's Matchups Array and Erase Battle's Matchup Structs
var temp_battle_matchup_count = array_length(battle_matchups);
var temp_battle_matchup_index = temp_battle_matchup_count - 1;

repeat (temp_battle_matchup_count)
{
	// Delete Battle Matchup Struct
	delete battle_matchups[temp_battle_matchup_index];
	
	// Decrement Battle Matchup Index
	temp_battle_matchup_index--;
}

array_resize(battle_matchups, 0);

