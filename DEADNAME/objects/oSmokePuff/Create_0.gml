/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Movement Settings
sprite_size = random_range(0.3, 1);
sprite_size_mult = 0.995;

velocity_spd = random_range(1, 15);
velocity_min = random_range(0, 0.075);
velocity_friction_mult = random_range(0.65, 0.85);
velocity_direction = random(359);

velocity_wall_slowdown = true;

angle_rotate_spd = random_range(-25, 25);

color_transition_spd = 0.005;
color_transition_start = 35;
color_transition_end = 150;

alpha_delay_timer_spd = 0.025;
alpha_transition_spd = 0.015;
alpha_destroy_threshold = 0.05;

// Sprite Settings
colors_sprite_index = sSmokePuff_Sprite;
normals_sprite_index = sSmokePuff_NormalMap;

// Visual Settings
sprite_index = colors_sprite_index;
image_index = irandom(sprite_get_number(colors_sprite_index) - 1);
image_angle = random(359);
image_blend = make_color_rgb(color_transition_start, color_transition_start, color_transition_start);

// Variables
velocity_hit_wall = false;
alpha_delay_timer = 0;
color_transition_value = 0;