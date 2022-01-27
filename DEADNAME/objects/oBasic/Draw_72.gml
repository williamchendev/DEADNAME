/// @description Basic Light Object Update
// Updates the oBasic Object's indexed depth in the Lighting Manager's List

// Reindex oBasic Object in Lighting Manager Basic Depth ArrayList
if (basic_old_depth != depth or basic_reindex_depth) {
	if (instance_exists(oLighting)) {
		// Remove oBasic from oLighting Array
		var temp_lighting_manager = instance_find(oLighting, 0);
		if (temp_lighting_manager.visible) {
			// Reindex Background Layer Basic Depth
			var temp_depth_instance_list_index = ds_list_find_index(temp_lighting_manager.basic_object_depth_list, id);
			if (temp_depth_instance_list_index != -1) {
				ds_list_delete(temp_lighting_manager.basic_object_depth_list, temp_depth_instance_list_index);
				ds_list_add_instance_by_depth(temp_lighting_manager.basic_object_depth_list, id);
			}
			else {
				ds_list_add_instance_by_depth(temp_lighting_manager.basic_object_depth_list, id);
			}
		}
	}
	basic_old_depth = depth;
	basic_reindex_depth = false;
}