/// @description Default Celestial Render Object Initialization
// Initializes the Celestial Render Object for Celestial Simulator Behaviour and Rendering

// Initialize as Persistent Object
persistent = true;

// Initialize Empty Celestial Render Object Type
celestial_render_object_type = CelestialRenderObjectType.None;

// Celestial Body Variables
celestial_body_instance = noone;

celestial_body_u_position = 0.5;
celestial_body_v_position = 0.5;

celestial_body_pathfinding_node_index = -1;