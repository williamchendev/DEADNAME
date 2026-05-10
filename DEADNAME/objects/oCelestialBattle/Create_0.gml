/// @description Battle Init Event
// Celestial Battle Init Behaviour Event

// Initialize Battle Arrays
battle_factions = array_create(0);
battle_units = array_create(0);

// Populate Battle Array with Default Faction
array_push(battle_factions, noone);
array_push(battle_units, array_create(0));

// Pathfinding Variables
pathfinding_node_a_index = -1;
pathfinding_node_b_index = -1;