/// @description Insert description here
// You can write your code in this editor

if (ds_list_size(explosion_objects) > 0) {
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
	explosion_objects_empty = true;
	ds_list_destroy(explosion_objects);
	explosion_objects = -1;
	instance_destroy();
}