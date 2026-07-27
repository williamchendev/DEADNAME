/// @description Celestial Unit Cleanup Event
// Performs the Celestial Unit's Cleanup Behaviour

// Destroy Pathfinding Path Struct
celestial_pathfinding_destroy_path(pathfinding_path);

// Destroy Remaining Combat Units
if (array_length(combat_units) > 0)
{
	// Iterate through Combat Units Array
	var temp_combat_unit_count = array_length(combat_units);
	var temp_combat_unit_index = temp_combat_unit_count - 1;
	
	repeat (temp_combat_unit_count)
	{
		// Delete Combat Unit Instance
		if (instance_exists(combat_units[temp_combat_unit_index]))
		{
			instance_destroy(combat_units[temp_combat_unit_index]);
		}
		
		// Decrement Combat Unit Index
		temp_combat_unit_index--;
	}
}

// Clear Unit Collision Check Arrays
array_resize(unit_battle_within_timed_collision_check_battles, 0);
array_resize(unit_battle_within_timed_collision_check_timers, 0);

// Clear Unit Status Effect Arrays
array_resize(status_effect_array, 0);
array_resize(status_effect_duration_array, 0);

