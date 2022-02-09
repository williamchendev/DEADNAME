/// @description Melee Weapon Draw
// Draws the Melee Weapon object to the screen

// Inactive Skip
if (!active) {
	return;
}

// Inherit the parent event
event_inherited();

if (weapon_arc_value == 1) {
	image_blend = c_red;	
}
else {
	image_blend = c_white;
}

// Draws the Object
draw_self();