/// @description Celestial Unit Cleanup Event
// Performs the Celestial Unit's Cleanup Behaviour

// Inherited Celestial Render Object Cleanup Event
event_inherited();

// Destroy Pathfinding Path Struct
celestial_pathfinding_destroy_path(pathfinding_path);
