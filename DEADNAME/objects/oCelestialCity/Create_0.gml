/// @description Default Celestial City Initialization
// Initializes the Celestial City for Celestial Simulator Behaviour and Rendering

// Inherited Celestial Render Object Initialization Behaviour
event_inherited();

// Initialize City Celestial Render Object Type
celestial_render_object_type = CelestialRenderObjectType.City;

// DEBUG
pathfinding_node_index = irandom_range(0, 4000);
