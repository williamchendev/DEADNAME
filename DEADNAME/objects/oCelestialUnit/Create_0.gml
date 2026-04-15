/// @description Default Celestial Unit Initialization
// Initializes the Celestial Unit for Celestial Simulator Behaviour and Rendering

// Inherited Celestial Render Object Initialization Behaviour
event_inherited();

// Initialize Unit Celestial Render Object Type
celestial_render_object_type = CelestialRenderObjectType.Unit;

// Pathfinding Variables
pathfinding_path = undefined;
pathfinding_path_index = 0;

pathfinding_position_x = 0;
pathfinding_position_y = 0;
pathfinding_position_z = 0;
pathfinding_position_elevation = 0;