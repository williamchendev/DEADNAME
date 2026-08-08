/// @description Celestial Unit Cleanup Event
// Performs the Celestial Unit's Cleanup Behaviour

// Destroy Pathfinding Path Struct
celestial_pathfinding_destroy_path(pathfinding_path);

// Destroy Combat Units
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

// Destroy Frontline Combat Unit Arrays
var temp_frontline_combat_unit_types_count = array_length(frontline_combat_unit_type);
var temp_frontline_combat_unit_types_index = temp_frontline_combat_unit_types_count - 1;

repeat (temp_frontline_combat_unit_types_count)
{
	// Clear Frontline Combat Unit Instances Array
	array_resize(array_get(frontline_combat_unit_instances, temp_frontline_combat_unit_types_index), 0);
	
	// Decrement Frontline Combat Unit Type Index
	temp_frontline_combat_unit_types_index--;
}

array_resize(frontline_combat_unit_type, 0);
array_resize(frontline_combat_unit_count, 0);
array_resize(frontline_combat_unit_unengaged_count, 0);
array_resize(frontline_combat_unit_engaged, 0);
array_resize(frontline_combat_unit_unengaged, 0);

// Destroy Midline Combat Unit Arrays
var temp_midline_combat_unit_types_count = array_length(midline_combat_unit_type);
var temp_midline_combat_unit_types_index = temp_midline_combat_unit_types_count - 1;

repeat (temp_midline_combat_unit_types_count)
{
	// Clear Midline Combat Unit Instances Array
	array_resize(array_get(midline_combat_unit_instances, temp_midline_combat_unit_types_index), 0);
	
	// Decrement Midline Combat Unit Type Index
	temp_midline_combat_unit_types_index--;
}

array_resize(midline_combat_unit_type, 0);
array_resize(midline_combat_unit_count, 0);
array_resize(midline_combat_unit_unengaged_count, 0);
array_resize(midline_combat_unit_engaged, 0);
array_resize(midline_combat_unit_unengaged, 0);

// Destroy Backline Combat Unit Arrays
var temp_backline_combat_unit_types_count = array_length(backline_combat_unit_type);
var temp_backline_combat_unit_types_index = temp_backline_combat_unit_types_count - 1;

repeat (temp_backline_combat_unit_types_count)
{
	// Clear Backline Combat Unit Instances Array
	array_resize(array_get(backline_combat_unit_instances, temp_backline_combat_unit_types_index), 0);
	
	// Decrement Backline Combat Unit Type Index
	temp_backline_combat_unit_types_index--;
}

array_resize(backline_combat_unit_type, 0);
array_resize(backline_combat_unit_count, 0);
array_resize(backline_combat_unit_unengaged_count, 0);
array_resize(backline_combat_unit_engaged, 0);
array_resize(backline_combat_unit_unengaged, 0);

// Clear Unit Collision Check Arrays
array_resize(unit_battle_within_timed_collision_check_battles, 0);
array_resize(unit_battle_within_timed_collision_check_timers, 0);

// Clear Unit Status Effect Arrays
array_resize(status_effect_array, 0);
array_resize(status_effect_duration_array, 0);

