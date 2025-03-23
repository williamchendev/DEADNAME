
for (var i = 0; i < 200; i++)
{
	// Remove Previous Path
	if (!is_undefined(debug_path))
	{
		ds_list_destroy(debug_path);
		debug_path = -1;
	}

	// Set New Debug Path Coordinates
	var debug_path_start_x = irandom_range(-2000, 2000);
	var debug_path_start_y = irandom_range(-2000, 2000);
	
	var debug_path_end_x = irandom_range(-2000, 2000);
	var debug_path_end_y = irandom_range(-2000, 2000);
	
	// Recalculate Path
	debug_path = pathfinding_get_path(debug_path_start_x, debug_path_start_y, debug_path_end_x, debug_path_end_y);
}


/*
// Print Out Path Details
show_debug_message("// Path Details");

if (!is_undefined(debug_path))
{
	for (var temp_path_index = 0; temp_path_index < ds_list_size(debug_path); temp_path_index++)
	{
		// Find Path Point
		var temp_path_point = ds_list_find_value(debug_path, temp_path_index);
		
		// Print Path Details
		show_debug_message(string(temp_path_point));
	}
}

show_debug_message("");






