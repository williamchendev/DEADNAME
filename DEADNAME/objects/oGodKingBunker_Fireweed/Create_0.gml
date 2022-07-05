/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Sprite Settings
colors_sprite_index = sGodKingBunker_Fireweed;
normals_sprite_index = sGodKingBunker_Fireweed_NormalMap;

// Movement Settings
lerp_spd = 0.1;

// Animation Settings
image_speed = 0;
image_index = irandom(sprite_get_number(sGodKingBunker_Fireweed) - 1);
if (random(1.0) < 0.5) {
	image_xscale = -1;
}

// Wind Settings
wind_spd = 0.007;
wind_direction = 52;
wind_angle_intensity = 20;
wind_yscale_intensity = 0.1;

// Movement Variables
plant_angle = random_range(-5, 5);
plant_yscale = 1;

// Wind Variables
wind_timer = (((x - 32) + y) mod 400) / 400;