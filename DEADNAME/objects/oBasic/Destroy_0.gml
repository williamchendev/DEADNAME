/// @description Basic Light Object Destroy
// Deletes the Basic Object's index from the Lighting Manager's List

// Remove oBasic from oLighting Array
if (instance_exists(oLighting)) {
	var temp_lighting_manager = instance_find(oLighting, 0);
	if (temp_lighting_manager.visible) {
		if (ds_exists(temp_lighting_manager.basic_object_depth_list, ds_type_list)) {
			var temp_depth_instance_list_index = ds_list_find_index(temp_lighting_manager.basic_object_depth_list, id);
			if (temp_depth_instance_list_index != -1) {
				ds_list_delete(temp_lighting_manager.basic_object_depth_list, temp_depth_instance_list_index);
			}
		}
	}
}