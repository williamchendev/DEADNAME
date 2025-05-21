/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

//
image_index = irandom_range(0, sprite_get_number(sprite_index) - 1);
image_angle = random(360);

image_alpha = 0.7;

//
movement_spd = 1;
movement_spd_decay = random_range(0.92, 0.97);

movement_direction_h += random_range(-1, 1);
movement_direction_v += random_range(-1, 1);

//
size = random_range(0.5, 1.3);

size_decay = random_range(0.9, 0.98);