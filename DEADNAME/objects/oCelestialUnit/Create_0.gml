/// @description Default Celestial Unit Initialization
// Initializes the Celestial Unit for Celestial Simulator Behaviour and Rendering

// Inherited Celestial Render Object Initialization Behaviour
event_inherited();

// Initialize Unit Celestial Render Object Type
celestial_render_object_type = CelestialRenderObjectType.Unit;

// Celestial Body Pathfinding Variables
celestial_body_pathfinding_lerp_node_index_a = -1;
celestial_body_pathfinding_lerp_node_index_b = -1;
celestial_body_pathfinding_lerp_node_value = 0;
