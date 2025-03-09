/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Instantiate Smoke Particle
flame_entity = instance_create_depth(x, y - 6, depth, oFlameEntity_Small);
flame_entity.dynamic_movement = true;
