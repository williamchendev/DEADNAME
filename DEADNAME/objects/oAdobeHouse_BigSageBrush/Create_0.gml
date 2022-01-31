/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Interact Settings
interact = instance_create_layer(x, y, layer, oInteract);
interact.interact_obj = id;
interact.infinite_range = true;