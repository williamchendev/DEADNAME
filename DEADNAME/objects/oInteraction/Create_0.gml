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

// Interaction Settings
interaction_object = noone;
interaction_object_name = "Scrimblorp";

interact_options = array_create(0);

interaction_horizontal_offset = 8;

// Interaction Variables
interact_menu_width = 0;
interact_menu_height = 0;

interaction_hover = false;
interaction_selected = false;

/// @DEBUG
interaction_object = find_unit_name("Charn");