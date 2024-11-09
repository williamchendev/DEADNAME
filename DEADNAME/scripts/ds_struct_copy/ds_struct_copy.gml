/// @function		ds_struct_copy(id);
/// @param			{struct}	id
/// @description	Copies the contents of a given struct and returns a new struct ID. This script
///					will function recursively, also copying any structs and arrays within the root
///					struct.
///
///					If the given input is invalid, `undefined` will be returned instead.
///
///					This type of copy operation is also known as a "deep clone", meaning data is
///					truly duplicated in memory rather than merely referenced. Note that this does
///					NOT include dynamic data structures and functions! (Use methods instead to
///					support deep cloning.)
///
/// @example		my_new_struct = ds_struct_copy(my_struct);
///					
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_struct_copy(_struct) {
	// Skip if struct doesn't exist
	if (!is_struct(_struct)) {
		return undefined;
	}
	
	// Create new temporary struct
	var tmp = {};
	
	// Get first level struct data
	var key, keys = variable_struct_get_names(_struct),
		obj_root = _struct,
		tmp_root = tmp;
	
	// Recursively get other levels
	for (var k = 0; k < array_length(keys); k++) {
		// Set root
		if (!is_string(keys[k])) {
			obj_root = keys[k];
			tmp_root = keys[k + 1];
			k++;
		} else {
			// Get current key
			if (is_array(obj_root)) {
				key = obj_root[real(keys[k])];
			} else {
				key = variable_struct_get(obj_root, keys[k]);
			}
			
			// Recurse structs
			if (is_struct(key)) {
				if (is_array(tmp_root)) {
					array_push(tmp_root, {});
					array_push(keys, obj_root[real(keys[k])]);
					array_push(keys, tmp_root[real(keys[k])]);
				} else {
					variable_struct_set(tmp_root, keys[k], {});
					array_push(keys, variable_struct_get(obj_root, keys[k]));
					array_push(keys, variable_struct_get(tmp_root, keys[k]));
				}
				array_copy(keys, array_length(keys), variable_struct_get_names(key), 0, variable_struct_names_count(key));
				continue;
			}
			
			// Recurse arrays
			if (is_array(key)) {
				if (is_array(tmp_root)) {
					array_push(tmp_root, []);
					array_push(keys, obj_root[real(keys[k])]);
					array_push(keys, tmp_root[real(keys[k])]);
				} else {
					variable_struct_set(tmp_root, keys[k], []);
					array_push(keys, variable_struct_get(obj_root, keys[k]));
					array_push(keys, variable_struct_get(tmp_root, keys[k]));
				}
				for (var i = 0; i < array_length(key); i++) {
					array_push(keys, string(i));
				}
				continue;
			}
			
			// Clone methods
			if (is_method(key)) {
				if (is_array(tmp_root)) {
					array_push(tmp_root, method(tmp_root, key));
				} else {
					variable_struct_set(tmp_root, keys[k], method(tmp_root, key));
				}
				continue;
			}
			
			// Clone keys
			if (is_array(tmp_root)) {
				array_push(tmp_root, key);
			} else {
				variable_struct_set(tmp_root, keys[k], key);
			}
		}
	}
	
	// Return cloned struct
	return tmp;
}