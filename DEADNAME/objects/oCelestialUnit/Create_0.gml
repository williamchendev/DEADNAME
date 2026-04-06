/// @description Default Celestial Unit Initialization
// Initializes the Celestial Unit for Celestial Simulator Behaviour and Rendering

// Inherited Celestial Render Object Initialization Behaviour
event_inherited();

// Initialize Unit Celestial Render Object Type
celestial_render_object_type = CelestialRenderObjectType.Unit;

// Pathfinding Variables
pathfinding_path = undefined;
pathfinding_path_index = -1;

pathfinding_path_node_index_a = -1;
pathfinding_path_node_index_b = -1;
pathfinding_path_node_progress = 0;

// DEBUG
pathfinding_node_index = irandom_range(0, 4000);

// Pathfinding Movement Functions
unit_pathfinding_set_path = function(path)
{
	// Check if Path Exists
	if (is_undefined(path))
	{
		// Early Return
		return
	}
	
	// Check if Path is Valid
	if (ds_list_size(path) == 0)
	{
		// Destroy Pathfinding Path
		ds_list_destroy(path);
		
		// Early Return
		return
	}
	
	// Set Up Pathfinding Path Node Indexes
	if (is_undefined(pathfinding_path))
	{
		// Reset Path Index
		pathfinding_path_index = 0;
		
		// Reset Pathfinding Path Progress
		pathfinding_path_node_progress = 0;
		
		// Reset Pathfinding Node Indexes
		pathfinding_path_node_index_a = ds_list_find_value(path, 0);
		pathfinding_path_node_index_b = ds_list_find_value(path, 1);
		
		// Check if Pathfinding Node Indexes are the Same
		/*
		if (pathfinding_path_node_index_a == pathfinding_path_node_index_b)
		{
			// Destroy Pathfinding Paths
			ds_list_destroy(path);
			
			if (!is_undefined(pathfinding_path))
			{
				ds_list_destroy(pathfinding_path);
			}
			
			// Set Pathfinding Path
			pathfinding_path = undefined;
			
			// Reset Path Index
			pathfinding_path_index = 0;
			
			// Early Return
			return
		}
		*/
	}
	/*
	else if (pathfinding_path_node_index_a == ds_list_find_value(path, 0))
	{
		// Reset Path Index
		pathfinding_path_index = -1;
		
		// Flip Pathfinding Path Progress
		pathfinding_path_node_progress = 1 - pathfinding_path_node_progress;
		
		// Flip Pathfinding Node Indexes
		var temp_pathfinding_path_node_index = pathfinding_path_node_index_a;
		pathfinding_path_node_index_a = pathfinding_path_node_index_b;
		pathfinding_path_node_index_b = temp_pathfinding_path_node_index;
	}
	*/
	else
	{
		// Reset Path Index
		pathfinding_path_index = 0;
	}
	
	// Destroy Pathfinding Path
	if (!is_undefined(pathfinding_path))
	{
		ds_list_destroy(pathfinding_path);
	}
	
	// Set Pathfinding Path
	pathfinding_path = path;
}
