/// @description Insert description here
// You can write your code in this editor

// Basic Lighting Inheritance
event_inherited();

// Settings
blood_pool_spd = 0.2;

// Variables
blood_pool_value = 0.1;

// Draw Variables
image_alpha = 0.9;
image_xscale = 1;
if (random(1) > 0.5) {
	image_xscale = -1;
}
image_index = irandom(sprite_get_number(sprite_index) - 1);

// Blood Layer Behaviour
depth = 5000;
blood_draw_end = false;
if (!instance_exists(oLighting)) {
	if (collision_point(x, y, oSolid, true, true)) {
		blood_draw_end = true;
	}
}