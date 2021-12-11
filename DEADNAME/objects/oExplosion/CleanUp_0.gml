/// @description Insert description here
// You can write your code in this editor

// Clean Up Explosion Object DS List
if (ds_exists(explosion_objects, ds_type_list)) {
	ds_list_destroy(explosion_objects);
}
explosion_objects = -1;