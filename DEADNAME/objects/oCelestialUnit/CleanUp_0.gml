/// @description Celestial Unit Cleanup Event
// Performs the Celestial Unit's Cleanup Behaviour

// Inherited Celestial Render Object Cleanup Event
event_inherited();

// Check if Unit's Pathfinding Path Exists
if (!is_undefined(pathfinding_path))
{
	// Destroy Pathfinding Path
	ds_list_destroy(pathfinding_path);
}
