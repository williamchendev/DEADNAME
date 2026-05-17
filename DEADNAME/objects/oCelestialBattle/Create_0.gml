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
battle_matchups = array_create(0);

// Populate Battle Array with Default Faction
array_push(battle_factions, noone);
array_push(battle_units, array_create(0));

// Celestial Body Variables
celestial_body_instance = noone;

// Pathfinding Variables
pathfinding_node_a_index = -1;
pathfinding_node_b_index = -1;
