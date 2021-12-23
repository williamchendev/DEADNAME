/// @description Explosion Update Event
// Calculates when all Explosion Objects are uninstantiated and destroys self

// Explosion Object Array Check
if (ds_list_size(explosion_objects) > 0) {
	// Check if Explosion related game objects are destroyed
	for (var i = ds_list_size(explosion_objects) - 1; i >= 0; i--) {
		var temp_explosion_inst = ds_list_find_value(explosion_objects, i);
		if (temp_explosion_inst != noone) {
			if (instance_exists(temp_explosion_inst)) {
				continue;
			}
		}
		ds_list_delete(explosion_objects, i);
	}
}
else {
	// Destroy Self
	explosion_objects_empty = true;
	ds_list_destroy(explosion_objects);
	explosion_objects = -1;
	instance_destroy();
}