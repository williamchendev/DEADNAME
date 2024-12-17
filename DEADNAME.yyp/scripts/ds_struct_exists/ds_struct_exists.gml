/// @function		ds_struct_exists(id, key);
/// @param			{struct}	id
/// @param			{string}	key
/// @description	Checks if a variable name (as a string) exists within the given struct and 
///					returns `true` or `false`. Unlike the built-in `variable_struct_exists` 
///					function, this script will check recursively, including any structs-within-
///					structs.
///					
///					If multiple levels of struct exist, it is possible for the same key to occur
///					multiple times with different values. To increase the speed and precision of
///					this function, you can specify which level to search by prepending the key
///					with any parent structs separated by a period. In this case, the first parent
///					specified must exist in the root struct, but deeper levels will be recursed
///					and are optional.
///						
///					Note that this script is for checking if the **contents** of a struct exist, 
///					not a struct itself.
///						
///					To get the value of the key, if found, use `ds_struct_find_value`.
///
/// @example		// Both "font" and "text.font" are acceptable and will return the same value
///					if (ds_struct_exists(my_struct, "text.font")) {
///						var my_font = ds_struct_find_value(my_struct, "text.font");
///			
///						draw_set_font(my_font);
///					}
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved
	
function ds_struct_exists(_struct, _key) {
	// Return `false` if input variable is not a struct
	if (!is_struct(_struct)) {
		return false;
	}
	
	// Check for parent structs in key
	while (string_count(".", _key) > 0) {
		// Get parent from key
		var parent = string_copy(_key, 1, string_pos(".", _key) - 1);
		
		// If parent is a struct...
		if (variable_struct_exists(_struct, parent)) {
			_struct = variable_struct_get(_struct, parent);
			
			if (is_struct(_struct)) {
				// Get the next parent or key
				_key = string_delete(_key, 1, string_pos(".", _key));
			} else {
				// Return `false` if parent is not a struct
				return false;
			}
		} else {
			// Return `false` if parent doesn't exist
			return false;
		}
	}
	
	// If struct exists, check top level for key
	if (variable_struct_exists(_struct, _key)) {
		return true;
	}
	
	// If target key was not found in top level, check for sub-structs
	var structs = 0, sub, top = variable_struct_get_names(_struct);
	for (var t = 0; t < array_length(top); t++) {
		sub = variable_struct_get(_struct, top[t]);
		if (is_struct(sub)) {
			structs[array_length(structs)] = sub;
		}
	}
	
	// Check for_key in sub-structs, if any
	for (var s = 0; s < array_length(structs); s++) {
		// Check sub-struct for key
		if (variable_struct_exists(structs[s], _key)) {
			// Clean up temporary data
			structs = 0;
			top = 0;
			
			// Return result
			return true;
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
	
	// Return `false` if key wasn't found
	return false;
}