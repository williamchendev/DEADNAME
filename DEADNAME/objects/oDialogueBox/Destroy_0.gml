/// @description Dialogue Box Destroy Event
// Destroys the Dialogue Box and all related Instances

// Inherited Destroy Event
event_inherited();

// Destroy Dialogue Tail Bezier Curve
instance_destroy(dialogue_tail_instance);