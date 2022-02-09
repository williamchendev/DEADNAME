/// @description Interact Walk Position
// Controls the position to walk to for the Interaction to play

// Inherit the parent event
event_inherited();

// Set Walk Position
if (!interact_destroy) {
	interact_walk_x = interact_obj.x + (sign(interact_obj.image_xscale) * interact_walk_unit_facing_distance);
	interact_walk_y = interact_obj.y;
}