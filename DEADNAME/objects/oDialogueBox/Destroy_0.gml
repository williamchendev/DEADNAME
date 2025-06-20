/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

//
if (instance_exists(dialogue_tail_instance))
{
	instance_destroy(dialogue_tail_instance);
	dialogue_tail_instance = -1;
}