/// @description Default Celestial Unit Initialization
// Initializes the Celestial Unit for Celestial Simulator Behaviour and Rendering

// Inherited Celestial Render Object Initialization Behaviour
event_inherited();

// Initialize Unit Celestial Render Object Type
celestial_render_object_type = CelestialRenderObjectType.Unit;

// Pathfinding Variables
pathfinding_path = undefined;
pathfinding_path_index = -1;
pathfinding_path_node_progress = 0;

pathfinding_position_x = 0;
pathfinding_position_y = 0;
pathfinding_position_z = 0;
pathfinding_position_elevation = 0;

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
	
	// Destroy Pathfinding Path
	if (!is_undefined(pathfinding_path))
	{
		ds_list_destroy(pathfinding_path);
	}
	
	// Set Pathfinding Path
	pathfinding_path = path;
	
	// Reset Path Index
	pathfinding_path_index = 0;
	
	// Reset Pathfinding Path Progress
	pathfinding_path_node_progress = 0;
}
