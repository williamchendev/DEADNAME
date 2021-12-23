/// @description Explosion Cleanup Event
// Clears unnecessary data used for the Explosion Object

// Clean Up Explosion Object DS List
if (ds_exists(explosion_objects, ds_type_list)) {
	ds_list_destroy(explosion_objects);
}
explosion_objects = -1;