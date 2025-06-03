/// @description Dialogue Box Init Event
// Initializes the Dialogue Box's Settings and Variables

//
object_type = LightingEngineUIObjectType.Dialogue;
object_depth = 1;

// Default Lighting Engine UI Object Initialization Behaviour
event_inherited();

// Dialogue Box Settings
dialogue_text = "LETS FUCKING GO FUCK OFF FUCK OFF FUCK OFF!!";

dialogue_unit = noone;
dialogue_unit_padding = 7;

// Dialogue Box Variables
dialogue_text_value = 0;

dialogue_box_animation_value = 0;
dialogue_box_breath_value = 0;

// Trigonometry Variables
trig_sine = 0;
trig_cosine = 1;

// @DEBUG
dialogue_unit = instance_find(oUnit, 0);
