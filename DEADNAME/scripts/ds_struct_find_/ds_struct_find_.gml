/// @function		ds_struct_find_first(id);
/// @param			{struct}	id
/// @description	Returns the name of the first key in the given struct, as a string. Further  
///					searches can then be performed with `ds_struct_find_next`. 
///
///					If the struct is empty, `undefined` will be returned instead.
///
///					Note that because structs are a non-ordered data format, data may be returned 
///					in a different order than originally declared in code. Changes to the struct
///					may also change the order in which data is returned with this function.
///
/// @example		var key = ds_struct_find_first(my_struct);
///					var val = true;
///
///					variable_struct_set(my_struct, key, val);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_struct_find_first(_struct) {
	// Return first key in the struct, if valid
	if (is_struct(_struct)) {
		_struct = variable_struct_get_names(_struct);
		if (array_length(_struct) > 0) {
			return _struct[0];
		}
	}
	
	// Otherwise return null
	return undefined;
}



/// @function		ds_struct_find_last(id);
/// @param			{struct}	id
/// @description	Returns the name of the last key in the given struct, as a string. Further  
///					searches can then be performed with `ds_struct_find_previous`. 
///
///					If the struct is empty, `undefined` will be returned instead.
///
///					Note that because structs are a non-ordered data format, data may be returned 
///					in a different order than originally declared in code. Changes to the struct
///					may also change the order in which data is returned with this function.
///
/// @example		var key = ds_struct_find_last(my_struct);
///					var val = true;
///
///					variable_struct_set(my_struct, key, val);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_struct_find_last(_struct) {
	// Return last key in the struct, if valid
	if (is_struct(_struct)) {
		_struct = variable_struct_get_names(_struct);
		if (array_length(_struct) > 0) {
			return _struct[array_length(_struct) - 1];
		}
	}
	
	// Otherwise return null
	return undefined;
}



/// @function		ds_struct_find_next(id, key);
/// @param			{struct}	id
/// @param			{string}	key
/// @requires		array_find_index
/// @description	Returns the name of the next key in the given struct, as a string. Search will
///					begin from the given key (for example, as returned by `ds_struct_find_first`).
///
///					If the struct is empty or no further key exists, `undefined` will be returned
///					instead.
///
///					Note that because structs are a non-ordered data format, data may be returned 
///					in a different order than originally declared in code. Changes to the struct
///					may also change the order in which data is returned with this function.
///
/// @example		var key = ds_struct_find_first(my_struct);
///					
///					key = ds_struct_find_next(my_struct, key);
///					var val = true;
///
///					variable_struct_set(my_struct, key, val);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_struct_find_next(_struct, _key) {
	// Return next key in the struct, if valid
	if (is_struct(_struct)) {
		if (variable_struct_exists(_struct, _key)) {
			_struct = variable_struct_get_names(_struct);
			_key = array_find_index(_struct, _key);
			
			if (_key < (array_length(_struct) - 1)) {
				return _struct[_key + 1];
			}
		}
	}
	
	// Otherwise return null
	return undefined;
}



/// @function		ds_struct_find_previous(id, key);
/// @param			{struct}	id
/// @param			{string}	key
/// @requires		array_find_index
/// @description	Returns the name of the previous key in the given struct, as a string. Search 
///					begins from the given key (for example, as returned by `ds_struct_find_last`).
///
///					If the struct is empty or no further key exists, `undefined` will be returned
///					instead.
///
///					Note that because structs are a non-ordered data format, data may be returned 
///					in a different order than originally declared in code. Changes to the struct
///					may also change the order in which data is returned with this function.
///
/// @example		var key = ds_struct_find_last(my_struct);
///					
///					key = ds_struct_find_previous(my_struct, key);
///					var val = true;
///
///					variable_struct_set(my_struct, key, val);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_struct_find_previous(_struct, _key) {
	// Return previous key in the struct, if valid
	if (is_struct(_struct)) {
		if (variable_struct_exists(_struct, _key)) {
			_struct = variable_struct_get_names(_struct);
			_key = array_find_index(_struct, _key);
			
			if (_key > 0) {
				return _struct[_key - 1];
			}
		}
	}
	
	// Otherwise return null
	return undefined;
}



/// @function		ds_struct_find_index(id, key);
/// @param			{struct}	id
/// @param			{string}	key
/// @description	Checks if a variable name (as a string) exists within the given struct and 
///					returns the index of the parent struct. The result can then be used with
///					standard struct accessors. Naturally, this is primarily useful for checking 
///					recursively, including any structs-within-structs.
///						
///					If multiple levels of struct exist, it is possible for the same key to occur
///					multiple times with different values. To increase the speed and precision of
///					this function, you can specify which level to search by prepending the key
///					with any parent structs separated by a period. In this case, the first parent
///					specified must exist in the root struct, but deeper levels will be recursed
///					and are optional.
///						
///					If the specified key doesn't exist, `-1` will be returned instead. To detect
///					whether the key exists first, use `ds_struct_exists`.
///
/// @example		var struct_text = ds_struct_find_index(my_struct, "font");
///		
///					draw_set_font(struct_text.font);
///					draw_set_color(struct_text.color);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved
	
function ds_struct_find_index(_struct, _key) {
	// Return -1 if input variable is not a struct
	if (!is_struct(_struct)) {
		return -1;
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
				// Return `-1` if parent is not a struct
				return undefined;
			}
		} else {
			// Return `-1` if parent doesn't exist
			return undefined;
		}
	}
	
	// If struct exists, check top level for key
	if (variable_struct_exists(_struct, _key)) {
		return _struct;
	}
	
	// If target key was not found in top level, check for sub-structs
	var structs = 0, sub, top = variable_struct_get_names(_struct);
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
			
			// Return key parent struct
			return _struct;
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
	
	// Return `-1` if key wasn't found
	return -1;
}


/// @function		ds_struct_find_value(id, key);
/// @param			{struct}	id
/// @param			{string}	key
/// @description	Checks if a variable name (as a string) exists within the given struct and 
///					returns the value. Unlike the built-in `variable_struct_get` function, this
///					script will check recursively, including any structs-within-structs.
///						
///					If multiple levels of struct exist, it is possible for the same key to occur
///					multiple times with different values. To increase the speed and precision of
///					this function, you can specify which level to search by prepending the key
///					with any parent structs separated by a period. In this case, the first parent
///					specified must exist in the root struct, but deeper levels will be recursed
///					and are optional.
///						
///					If the specified key doesn't exist, `undefined` will be returned instead. To 
///					determine whether the key exists first, use `ds_struct_exists`.
///
/// @example		// Both "font" and "text.font" are acceptable and will return the same value
///					if (ds_struct_exists(my_struct, "text.font")) {
///						var my_font = ds_struct_find_value(my_struct, "text.font");
///					
///						draw_set_font(my_font);
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved
	
function ds_struct_find_value(_struct, _key) {
	// Return `undefined` if input variable is not a struct
	if (!is_struct(_struct)) {
		return undefined;
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
				// Return `undefined` if parent is not a struct
				return undefined;
			}
		} else {
			// Return `undefined` if parent doesn't exist
			return undefined;
		}
	}
	
	// If struct exists, check top level for key
	if (variable_struct_exists(_struct, _key)) {
		return variable_struct_get(_struct, _key);
	}
	
	// If target key was not found in top level, check for sub-structs
	var structs = 0, sub, top = variable_struct_get_names(_struct);
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
			
			// Return key value
			return variable_struct_get(_struct, _key);
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
	
	// Return `undefined` if key wasn't found
	return undefined;
}

