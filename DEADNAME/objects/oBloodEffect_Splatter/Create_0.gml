/// @description Blood Init Event
// Creates the variables and settings of the Blood Effect for Splatters

// Settings
unit_inst = noone;
corpse_inst = noone;

blood_size = 0.6;
blood_duration = 3;

// Variables
blood_x = 0;
blood_y = 0;

blood_timer = blood_duration;

// Draw Variables
image_alpha = 0.95;
image_angle = irandom(359);
image_index = irandom(sprite_get_number(sprite_index) - 1);