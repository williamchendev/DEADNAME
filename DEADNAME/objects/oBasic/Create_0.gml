/// @description Basic Light Object Init
// Creates the variables necessary for the Basic Lighting Object

// Catalogue oBasic in oLighting Array
if (instance_exists(oLighting)) {
	var temp_lighting_manager = instance_find(oLighting, 0);
	if (temp_lighting_manager.visible) {
		if (ds_list_find_index(temp_lighting_manager.basic_object_depth_list, id) == -1) {
			ds_list_add_instance_by_depth(temp_lighting_manager.basic_object_depth_list, id);
		}
	}
}

// Variables
basic_old_depth = depth;