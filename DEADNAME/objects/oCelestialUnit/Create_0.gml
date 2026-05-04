/// @description Default Celestial Unit Initialization
// Initializes the Celestial Unit for Celestial Simulator Behaviour and Rendering

// Inherited Celestial Sub Object Initialization Behaviour
event_inherited();

// Initialize Unit Celestial Sub Object Type
celestial_sub_object_type = CelestialSubObjectType.Unit;

// Pathfinding Variables
pathfinding_path = undefined;
pathfinding_path_index = 0;

pathfinding_position_x = 0;
pathfinding_position_y = 0;
pathfinding_position_z = 0;
pathfinding_position_elevation = 0;

// Behaviour Variables
unit_behaviour = CelestialUnitBehaviour.None;

unit_behaviour_target_instance = noone;
unit_behaviour_target_node_index = -1;