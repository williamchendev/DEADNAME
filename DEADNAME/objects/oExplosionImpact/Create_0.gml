/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Light Settings
explosion_pointlight = instance_create_depth(x, y, depth, oPointLight);
explosion_pointlight.range = 160;
explosion_pointlight.intensity = 1.0;
explosion_pointlight.color = c_white;

// Movement Settings
sprite_size = 0.25;
sprite_size_grow_mult = 1.75;
sprite_size_shrink_mult = 0.995;

alpha_delay_timer_spd = 0.15;
alpha_transition_spd = 0.5;
alpha_destroy_threshold = 0.05;

// Sprite Settings
colors_sprite_index = sExplosionImpact_Medium_Sprite1;
normals_sprite_index = sExplosionImpact_Medium_NormalMap1;

// Visual Settings
sprite_index = colors_sprite_index;
image_angle = random(359);

image_alpha = 1.0;
image_xscale = sprite_size;
image_yscale = sprite_size;

// Variables
size_shrink = false;
alpha_delay_timer = 0;