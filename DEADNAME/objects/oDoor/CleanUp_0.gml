/// @description Door Interactable CleanUp
// Cleans up unnecessary data structures of the oDoor Object

// Destroy Instances
if (instance_exists(door_solid)) {
	instance_destroy(door_solid);
}
if (instance_exists(door_material)) {
	instance_destroy(door_material);
}