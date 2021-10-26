/// @description Blood Destroy Event
// Cleans up unused data and unindexes the blood

// Unindex Blood Sticker
if (unit_inst != noone) {
	if (instance_exists(unit_inst)) {
		// Remove Index
		var temp_blood_index = ds_list_find_index(unit_inst.blood_list, id);
		if (temp_blood_index >= 0) {
			ds_list_delete(unit_inst.blood_list, temp_blood_index);
		}
	}
}