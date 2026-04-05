/// @description Default Celestial Satellite Initialization
// Initializes the Celestial Satellite for Celestial Simulator Behaviour and Rendering

// Inherited Celestial Render Object Initialization Behaviour
event_inherited();

// Initialize Satellite Celestial Render Object Type
celestial_render_object_type = CelestialRenderObjectType.Satellite;

// DEBUG
pathfinding_node_index = irandom_range(0, 4000);
