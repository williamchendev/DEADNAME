/// ds_list_add_instance_by_depth(id, value);
/// @description Adds a given instance to a ds list and inserts the instance based on ascending depth
/// @param {ds_list} id The given ds_list array to insert the given value
/// @param {real} value The id of the object instance to insert into the given ds_list

// Establish Variables
var temp_ds_list = argument0;
var temp_depth_inst = argument1;

// Check if no Entries
if (ds_list_size(temp_ds_list) <= 0) {
	ds_list_add(temp_ds_list, temp_depth_inst);
	return;
}

// Sort and Insert Instance by Depth
for (var i = 0; i < ds_list_size(temp_ds_list); i++) {
	var temp_list_inst = ds_list_find_value(temp_ds_list, i);
	if (temp_depth_inst.depth > temp_list_inst.depth) {
		ds_list_insert(temp_ds_list, i, temp_depth_inst);
		return;
	}
	else if (temp_depth_inst.depth == temp_list_inst.depth) {
		if (temp_depth_inst > temp_list_inst) {
			ds_list_insert(temp_ds_list, i, temp_depth_inst);
			return;
		}
	}
}
ds_list_add(temp_ds_list, temp_depth_inst);
return;