/// @description Battle Cleanup Event
// Celestial Battle Cleanup Behaviour Event

// Clear Battle Combat Grid Arrays
array_resize(battle_combat_grid_a, 0);
array_resize(battle_combat_grid_b, 0);

array_resize(battle_combat_grid_instances_a, 0);
array_resize(battle_combat_grid_instances_b, 0);

array_resize(battle_combat_grid_a_structs, 0);
array_resize(battle_combat_grid_b_structs, 0);

// Clear Battle Unit Arrays
array_resize(battle_units, 0);

array_resize(battle_units_a, 0);
array_resize(battle_units_b, 0);

// Clear Battle Combat Unit Arrays
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

