/// @description Dialogue Box Destroy Event
// Destroys the Dialogue Box and all related Instances

// Inherited Destroy Event
event_inherited();

// Check if Dialogue Tail Exists
if (instance_exists(dialogue_tail_instance))
{
	// Destroy Dialogue Tail Object
	instance_destroy(dialogue_tail_instance);
	dialogue_tail_instance = -1;
}
