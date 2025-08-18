/// @description Interaction Init Event
// Initializes the Interaction Instance's Settings and Variables

// Disable Object Rendering
sprite_index = -1;
visible = false;

// Interaction Lighting Engine UI Object Type & Depth
object_type = LightingEngineUIObjectType.Interaction;
object_depth = LightingEngineUIObjectType.Interaction;

// Default Lighting Engine UI Object Initialization Behaviour
event_inherited();

// Interaction Settings
interaction_object = noone;
interaction_object_name = "ERROR - INTERACTION OBJECT NAME NULL";

interact_options = noone;

interaction_horizontal_offset = 9;

// Interaction Triangle Settings
interaction_option_triangle_angle = -15;
interaction_option_triangle_radius = 4;
interaction_option_triangle_horizontal_offset = 6;
interaction_option_triangle_vertical_offset = 0;

interaction_option_triangle_rotate_range = 30;
interaction_option_triangle_rotate_spd = 2;

interaction_option_breath_padding = 2;
interaction_option_animation_speed = 0.01;

// Interaction Variables
interact_menu_width = 0;
interact_menu_height = 0;

interaction_hover = false;
interaction_selected = false;

interaction_option_index = 0;

interaction_option_animation_value = 0;

// Triangle Variables
interaction_option_triangle_draw_angle = 0;

tri_x_1 = 0;
tri_y_1 = 0;
tri_x_2 = 0;
tri_y_2 = 0;
tri_x_3 = 0;
tri_y_3 = 0;
