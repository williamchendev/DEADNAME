/// @description Celestial Unit Cleanup Event
// Performs the Celestial Unit's Cleanup Behaviour

// Destroy Pathfinding Path Struct
celestial_pathfinding_destroy_path(pathfinding_path);

// Destroy Remaining Sub-Units
if (array_length(sub_units) > 0)
{
	// Iterate through Sub-Units Array
	var temp_sub_unit_count = array_length(sub_units);
	var temp_sub_unit_index = temp_sub_unit_count - 1;
	
	repeat (temp_sub_unit_count)
	{
		// Delete Sub Unit Instance
		if (instance_exists(sub_units[temp_sub_unit_index]))
		{
			instance_destroy(sub_units[temp_sub_unit_index]);
		}
		
		// Decrement Sub-Unit Index
		temp_sub_unit_index--;
	}
}

