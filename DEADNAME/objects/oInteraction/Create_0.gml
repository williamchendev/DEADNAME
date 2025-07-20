/// @description Dialogue Box Init Event
// Initializes the Dialogue Box's Settings and Variables

//
sprite_index = -1;
visible = false;

// Dialogue Box's Lighting Engine UI Object Type & Depth
object_type = LightingEngineUIObjectType.Interaction;
object_depth = LightingEngineUIObjectType.Interaction;

// Default Lighting Engine UI Object Initialization Behaviour
event_inherited();

//
interaction_object = noone;

interaction_hover = false;
interaction_selected = false;

/// @DEBUG
interaction_object = find_unit_name("Charn");