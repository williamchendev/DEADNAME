/// @description Dialogue Box Init Event
// Initializes the Dialogue Box's Settings and Variables

// Dialogue Box's Lighting Engine UI Object Type & Depth
object_type = LightingEngineUIObjectType.Dialogue;
object_depth = 1;

// Default Lighting Engine UI Object Initialization Behaviour
event_inherited();

// Cutscene Settings
cutscene_instance = noone;

// Dialogue Box Settings
dialogue_unit = noone;
dialogue_text = "I need ZYRTEC allergy tablets (TM)! >w<";

dialogue_box_instance_following = noone;
dialogue_box_instance_following_chain_max = 20;
dialogue_box_instance_following_separation = 6;
dialogue_box_instance_chain_vertical_offset = 0;

// Triangle Settings
dialogue_triangle_angle = -15;
dialogue_triangle_radius = 4;
dialogue_triangle_offset = -2;

dialogue_triangle_rotate_range = 30;
dialogue_triangle_rotate_spd = 2;

// Dialogue Box Variables
dialogue_text_value = 0;

dialogue_tail = true;

dialogue_box_animation_value = 0;
dialogue_box_breath_value = 0;

dialogue_triangle_draw_angle = 0;

// Fade Destroy Variables
dialogue_fade = false;
dialogue_fade_timer = dialogue_fade_duration;

// Triangle Variables
dialogue_triangle = false;

tri_x_1 = 0;
tri_y_1 = 0;
tri_x_2 = 0;
tri_y_2 = 0;
tri_x_3 = 0;
tri_y_3 = 0;

// Trigonometry Variables
trig_sine = 0;
trig_cosine = 1;

// @DEBUG
dialogue_unit = find_unit_name("Mel");
