/// @description Battle Init Event
// Celestial Battle Init Behaviour Event

// Initialize as Persistent Object
persistent = true;

// Initialize Battle Clock
battle_total_time = 0;

battle_round = 0;
battle_round_timer = 0;

// Initialize Battle Arrays
battle_factions = array_create(0);
battle_units = array_create(0);
battle_hostile_factions = array_create(0);
battle_allied_factions = array_create(0);
battle_land_priority_pools = array_create(0);
battle_air_priority_pools = array_create(0);
battle_sea_priority_pools = array_create(0);
battle_matchups = array_create(0);

// Celestial Body Variables
celestial_body_instance = noone;

// Pathfinding Variables
pathfinding_node_a_index = -1;
pathfinding_node_b_index = -1;

// Populate Battle Array with Default Faction
array_push(battle_factions, noone);
array_push(battle_units, array_create(0));
array_push(battle_hostile_factions, array_create(0));
array_push(battle_allied_factions, array_create(0));

// Initialize Empty Battle Priority Pools
var temp_default_faction_battle_land_priority_pool = array_create(CelestialBattlePriorityRankMax);
var temp_default_faction_battle_air_priority_pool = array_create(CelestialBattlePriorityRankMax);
var temp_default_faction_battle_sea_priority_pool = array_create(CelestialBattlePriorityRankMax);

// Iterate through Battle Priority Pools to create Empty Sub-Unit Arrays
var temp_priority_rank_index = 0;

repeat (CelestialBattlePriorityRankMax)
{
	// Create and Index Empty Priority Rank Sub-Unit Array
	array_set(temp_default_faction_battle_land_priority_pool, temp_priority_rank_index, array_create(0));
	array_set(temp_default_faction_battle_air_priority_pool, temp_priority_rank_index, array_create(0));
	array_set(temp_default_faction_battle_sea_priority_pool, temp_priority_rank_index, array_create(0));
	
	// Increment Priority Rank Index
	temp_priority_rank_index++;
}

// Index Battle Priority Pools in Battle Instance
array_push(battle_land_priority_pools, temp_default_faction_battle_land_priority_pool);
array_push(battle_air_priority_pools, temp_default_faction_battle_air_priority_pool);
array_push(battle_sea_priority_pools, temp_default_faction_battle_sea_priority_pool);
