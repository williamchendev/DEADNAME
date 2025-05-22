/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

//
image_index = irandom_range(0, sprite_get_number(sprite_index) - 1);
image_angle = random(360);

image_alpha = 0.7;

//
size = random_range(0.8, 1.6);
size_decay = random_range(0.92, 0.98);

//
alpha_decay = 0.008;

//
rotation_spd = random_range(-3, 3);

//
movement_spd = 2.5 - size;
movement_spd_decay = random_range(0.93, 0.99);

//
movement_angle += random_range(-35, 35);

movement_direction_h = dcos(movement_angle) + random_range(-0.25, 0.25);
movement_direction_v = -dsin(movement_angle) + random_range(-0.25, 0.25);



