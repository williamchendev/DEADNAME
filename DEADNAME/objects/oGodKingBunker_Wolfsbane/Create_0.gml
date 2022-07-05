/// @description Wolfsbane Init Event
// Creates the Settings and Variables of the Wolfsbane Plant

// Inherit the parent event
event_inherited();

// Sprite Settings
colors_sprite_index = sGodKingBunker_Wolfsbane;
normals_sprite_index = sGodKingBunker_Wolfsbane_NormalMap;

// Movement Settings
lerp_spd = 0.05;

// Animation Settings
image_speed = 0;
image_index = irandom(sprite_get_number(sGodKingBunker_Wolfsbane) - 1);
if (random(1.0) < 0.5) {
	image_xscale = -1;
}

// Wind Settings
wind_spd = 0.007;
wind_direction = 52;
wind_angle_intensity = 30;
wind_yscale_intensity = 0.2;

// Movement Variables
plant_angle = random_range(-5, 5);
plant_yscale = 1;

// Wind Variables
wind_timer = ((x + y) mod 400) / 400;