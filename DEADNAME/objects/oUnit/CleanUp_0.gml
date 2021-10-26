/// @description Unit Clean Up Event
// Cleans up the variables and DS Structures of the Unit on the Unit's Destroy Event

// Clear Platform Indexing List
if (ds_exists(platform_list, ds_type_list)) {
	ds_list_destroy(platform_list);
}
platform_list = -1;

// Clear Blood Indexing List
if (ds_exists(blood_list, ds_type_list)) {
	ds_list_destroy(blood_list);
}
blood_list = -1;

// Clear Universal Physics Object
instance_destroy(universal_physics_object);

// Clear instance from Game Manager instantiated unit objects
if (instance_exists(game_manager)) {
	ds_list_delete(game_manager.instantiated_units, ds_list_find_index(game_manager.instantiated_units, id));
}