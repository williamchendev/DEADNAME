/// @description Dialogue Interaction Init
// Creates the variables and settings of the Dialogue Interaction

// Interact Cutscene Inheritance
event_inherited();

// Dialogue Interaction Settings
interact_description = "Talk";

interact_icon_index = 1;
interact_select_outline_color = make_color_rgb(118, 66, 138);
interact_select_second_outline_color = c_white;

interact_image_xscale = 3;
interact_image_yscale = 1.5;

// Dialogue Interact Walk Settings
interact_walk = true;
interact_walk_face_xdirection = true;

interact_walk_range = true;
interact_walk_radius = 6;

interact_walk_unit_facing_distance = 64;