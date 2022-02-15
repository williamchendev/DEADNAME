/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Destroy Self
var temp_interact_exists = false;
if (interact != noone) {
	if (instance_exists(interact)) {
		temp_interact_exists = true;
	}
}

if (!temp_interact_exists) {
	image_alpha -= destroy_alpha_decay * global.deltatime;
	if (image_alpha <= 0) {
		instance_destroy();
	}
	image_alpha = clamp(image_alpha, 0, 1);
}