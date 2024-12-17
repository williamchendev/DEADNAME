/// @function		ds_struct_set(id, key, value);
/// @param			{struct}	id
/// @param			{string}	key
/// @param			{any}		value
/// @requires		ds_struct_create
/// @description	Assigns a value to the specified key within the given struct. The struct
///					must have been previously created (e.g. with `ds_struct_create`).
///						
///					If multiple levels of struct exist, it is possible for the same key to occur
///					multiple times with different values. To increase the speed and precision of
///					this function, you can specify which level to search by prepending the key
///					with any parent structs separated by a period. In this case, the first parent
///					specified must exist in the root struct, but deeper levels will be recursed
///					and are optional, provided the key already exists. If the key does not exist, 
///					any parents will be created as well in the order specified.
///					
///					To get the value of a key once set, use `ds_struct_find_value`.
///
/// @example		// Both "font" and "text.font" are acceptable and will assign the same value
///					ds_struct_set(my_struct, "text.font", fnt_Arial);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_struct_set(_struct, _key, _val) {
	// Show error if input variable is not a struct
	if (!is_struct(_struct)) {
		show_error("Invalid assignment: variable is not a _struct", false);
	}
	
	// Check for parent structs in key
	while (string_count(".", _key) > 0) {
		// Get parent from key
		var parent = string_copy(_key, 1, string_pos(".", _key) - 1);
		
		// Ensure parent struct exists
		if (!variable_struct_exists(_struct, parent)) {
			variable_struct_set(_struct, parent, ds_struct_create());
		}
		
		// Get parent struct
		_struct = variable_struct_get(_struct, parent);
		
		// If parent is a struct...
		if (is_struct(_struct)) {
			// Get the next parent or key
			_key = string_delete(_key, 1, string_pos(".", _key));
		} else {
			// Otherwise, show error if parent is not a struct
			show_error("Invalid assignment: \"" + parent + "\" is not a _struct", false);
			exit;
		}
	}
	
	// If target key exists, assign value in top level
	if (variable_struct_exists(_struct, _key)) {
		variable_struct_set(_struct, _key, _val);
		exit;
	}
	
	// If target key was not found in top level, check for sub-structs
	var parent = _struct, structs = 0, sub, top = variable_struct_get_names(_struct);
	for (var t = 0; t < array_length(top); t++) {
		sub = variable_struct_get(_struct, top[t]);
		if (is_struct(sub)) {
			structs[array_length(structs)] = sub;
		}
	}
	
	// Check for key in sub-structs, if any
	for (var s = 0; s < array_length(structs); s++) {
		// Check sub-struct for key
		if (variable_struct_exists(structs[s], _key)) {
			// Clean up temporary data
			_struct = structs[s];
			structs = 0;
			top = 0;
			
			// Assign value to key
			variable_struct_set(_struct, _key, _val);
			exit;
		}
		
		// If target key was not found, check for deeper sub-structs
		top = variable_struct_get_names(structs[s]);
		for (var t = 0; t < array_length(top); t++) {
			sub = variable_struct_get(structs[s], top[t]);
			if (is_struct(sub)) {
				structs[array_length(structs) + t] = sub;
			}
			
			// Clean up temporary data
			sub = 0;
		}
	}
	
	// Assign to top level struct if key was not found
	variable_struct_set(parent, _key, _val);
}