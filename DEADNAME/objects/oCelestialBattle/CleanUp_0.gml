/// @description Battle Cleanup Event
// Celestial Battle Cleanup Behaviour Event

// Increment through Battle's Combat Grid Arrays and clear all Column Arrays
var temp_battle_combat_grid_column_size = CelestialBattleCombatGridColumns;
var temp_battle_combat_grid_column_index = temp_battle_combat_grid_column_size - 1;

repeat (temp_battle_combat_grid_column_size)
{
	// Clear Battle Combat Grid's Column Arrays
	array_resize(battle_combat_grid_a[temp_battle_combat_grid_column_index], 0);
	array_resize(battle_combat_grid_b[temp_battle_combat_grid_column_index], 0);
	
	array_resize(battle_combat_grid_instances_a[temp_battle_combat_grid_column_index], 0);
	array_resize(battle_combat_grid_instances_b[temp_battle_combat_grid_column_index], 0);
	
	// Delete Battle Combat Grid's Column Arrays from Battle Combat Grid Arrays
	array_delete(battle_combat_grid_a, temp_battle_combat_grid_column_index, 1);
	array_delete(battle_combat_grid_b, temp_battle_combat_grid_column_index, 1);
	
	array_delete(battle_combat_grid_instances_a, temp_battle_combat_grid_column_index, 1);
	array_delete(battle_combat_grid_instances_b, temp_battle_combat_grid_column_index, 1);
	
	// Decrement Combat Grid Column Index
	temp_battle_combat_grid_column_index--;
}

// Clear Battle Combat Grid Arrays
array_resize(battle_combat_grid_a, 0);
array_resize(battle_combat_grid_b, 0);

array_resize(battle_combat_grid_instances_a, 0);
array_resize(battle_combat_grid_instances_b, 0);

// Clear Battle Combat Unit Arrays
array_resize(battle_supporting_units_a, 0);
array_resize(battle_supporting_units_b, 0);

array_resize(battle_combat_units, 0);

array_resize(battle_combat_units_a, 0);
array_resize(battle_combat_units_b, 0);

array_resize(battle_frontline_combat_units_a, 0);
array_resize(battle_midline_combat_units_a, 0);
array_resize(battle_backline_combat_units_a, 0);

array_resize(battle_frontline_combat_units_b, 0);
array_resize(battle_midline_combat_units_b, 0);
array_resize(battle_backline_combat_units_b, 0);

array_resize(battle_frontline_available_slots_a, 0);
array_resize(battle_midline_available_slots_a, 0);
array_resize(battle_backline_available_slots_a, 0);

array_resize(battle_frontline_available_slots_b, 0);
array_resize(battle_midline_available_slots_b, 0);
array_resize(battle_backline_available_slots_b, 0);

// Increment through Battle's Combat Action Array and delete all Combat Action Instances
var temp_battle_combat_action_count = array_length(battle_combat_actions);
var temp_battle_combat_action_index = temp_battle_combat_action_count - 1;

repeat (temp_battle_combat_action_count)
{
	// Check if Battle Combat Action Instance Exists
	battle_combat_actions[temp_battle_combat_action_index].battle_instance = noone;
	
	// Delete Battle's Combat Action Instance
	instance_destroy(battle_combat_actions[temp_battle_combat_action_index]);
	
	// Decrement Battle Combat Action Index
	temp_battle_combat_action_index--;
}

// Clear Battle Combat Action Arrays
array_resize(battle_combat_actions, 0);

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

