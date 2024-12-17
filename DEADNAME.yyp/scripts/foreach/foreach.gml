/// @description	Iterates through a given subject and returns the value of each item to a custom
///					variable, which can be used to perform operations on each item in the subject.
///
///					Similar to a standard `for` loop, but with a more convenient syntax that short-
///					cuts common loop operations. `foreach` supports iterating specific data types,
///					including strings, arrays, all data structure types, objects, and integers.
///
///					If it is necessary to know the current index of each iteration, a "key" custom 
///					variable can also be supplied **before** the custom value variable. The index
///					will then be stored in the key for future reference.
///
///					Value and key variables **must** be input as strings, but will be referenced in
///					custom code by their literal names instead.
///
///					Syntax is as follows: 
///
///					foreach (DATA as "VALUE") call {
///						VALUE
///					}
///
///					Or:
///
///					foreach (DATA as "KEY" of "VALUE") call {
///						KEY
///						VALUE
///					};
///
///					Note that `as`, `of`, and `call` are special keywords for this function. Also
///					note that the closing parenthesis comes **before** the `call` statement.
///
///					In the case of multidimensional arrays, only the dimension provided will be
///					iterated. Any sub-dimensions will be returned in the custom value variable and
///					can be handled in custom code.
///
///					Note that in some cases this function may not return the expected result due to
///					the way GameMaker handles pointers. This means some types of data can share the
///					same value, and whichever one happens to be first will take priority.
///
/// @example		var my_array = ["a", "b", "c"];
///					var my_list = ds_list_create();
///
///					// Add each item in the example array to the example list
///					foreach (my_array as "letter") call {
///						ds_list_add(my_list, letter);
///					};
///
///					// Add each item in the example list to the example array
///					foreach (my_list as "index" of "letter") call {
///						my_array[index] = letter;
///					};
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function for_length() {
	// Initialize macros
	#macro foreach for (var i = 0; i < for_length(i, 
	#macro as ), 
	#macro of ,
	#macro call ; i++) 

	// Initialize arguments
	var _i = argument[0],
		_subject = argument[1],
		_length = 0;
	
	// Iterate strings
	if (is_string(_subject)) {
		// Get subject length
		_length = string_length(_subject);
		
		// Set loop variables
		if (_i < _length) {
			if (argument_count < 4) {
				variable_instance_set(id, argument[2], string_char_at(_subject, _i + 1));	// Value
			} else {
				// Value
				variable_instance_set(id, argument[2], _i);									// Key
				variable_instance_set(id, argument[3], string_char_at(_subject, _i + 1));	// Value
			}
		}
		
		// Return length
		return _length;
	}
	
	// Iterate arrays
	if (is_array(_subject)) {
		// Get subject length
		_length = array_length(_subject);
		
		// Set loop variables
		if (_i < _length) {
			// Set loop variables
			if (argument_count < 4) {
				variable_instance_set(id, argument[2], _subject[_i]);	// Value
			} else {
				// Value
				variable_instance_set(id, argument[2], _i);				// Key
				variable_instance_set(id, argument[3], _subject[_i]);	// Value
			}
		}
		
		// Return length
		return _length;
	}
	
	// Iterate DS Grids
	if (ds_exists(_subject, ds_type_grid)) {
		// Get grid dimensions
		var ds_width = ds_grid_width(_subject);
		var ds_height = ds_grid_height(_subject);
		
		// Get grid index
		var ds_row = (_i div ds_width);
		var ds_col = (_i mod ds_width);
		
		// Get subject length
		_length = (ds_width*ds_height);
		
		// Set loop variables
		if (_i < _length) {
			if (argument_count < 4) {
				variable_instance_set(id, argument[2], _subject[# ds_col, ds_row]);	// Value
			} else {
				// Value
				variable_instance_set(id, argument[2], _i);							// Key
				variable_instance_set(id, argument[3], _subject[# ds_col, ds_row]);	// Value
			}
		}
		
		// Return length
		return _length;
	}
	
	// Iterate DS Lists
	if (ds_exists(_subject, ds_type_list)) {
		// Get subject length
		_length = ds_list_size(_subject);
		
		// Set loop variables
		if (_i < _length) {
			if (argument_count < 4) {
				variable_instance_set(id, argument[2], _subject[| _i]);	// Value
			} else {
				// Value
				variable_instance_set(id, argument[2], _i);				// Key
				variable_instance_set(id, argument[3], _subject[| _i]);	// Value
			}
		}
		
		// Return length
		return _length;
	}
	
	// Iterate DS Maps
	if (ds_exists(_subject, ds_type_map)) {
		// Get map key
		if (_i == 0) {
			for_ds_map_key = ds_map_find_first(_subject);
		} else {
			for_ds_map_key = ds_map_find_next(_subject, for_ds_map_key);
		}
		
		// Get subject length
		_length = ds_map_size(_subject);
		
		// Set loop variables
		if (_i < _length) {
			if (argument_count < 4) {
				variable_instance_set(id, argument[2], _subject[? for_ds_map_key]);	// Value
			} else {
				// Value
				variable_instance_set(id, argument[2], _i);							// Key
				variable_instance_set(id, argument[3], _subject[? for_ds_map_key]);	// Value
			}
		}
		
		// Return length
		return _length;
	}
	
	// Iterate DS Priority
	if (ds_exists(_subject, ds_type_priority)) {
		// Get subject length
		_length = ds_priority_size(_subject) + _i;
		
		// Set loop variables
		if (_i < _length) {
			// Set loop variables
			if (argument_count < 4) {
				variable_instance_set(id, argument[2], ds_priority_delete_max(_subject));	// Value
			} else {
				// Value
				variable_instance_set(id, argument[2], _i);									// Key
				variable_instance_set(id, argument[3], ds_priority_delete_max(_subject));	// Value
			}
		}
		
		// Return length
		return _length;
	}
	
	// Iterate DS Queue
	if (ds_exists(_subject, ds_type_queue)) {
		// Get subject length
		_length = ds_queue_size(_subject) + _i;
		
		// Set loop variables
		if (_i < _length) {
			// Set loop variables
			if (argument_count < 4) {
				variable_instance_set(id, argument[2], ds_queue_dequeue(_subject));	// Value
			} else {
				// Value
				variable_instance_set(id, argument[2], _i);							// Key
				variable_instance_set(id, argument[3], ds_queue_dequeue(_subject));	// Value
			}
		}
		
		// Return length
		return _length;
	}
	
	// Iterate DS Stacks
	if (ds_exists(_subject, ds_type_stack)) {
		// Get subject length
		_length = ds_stack_size(_subject) + _i;
		
		// Set loop variables
		if (_i < _length) {
			// Set loop variables
			if (argument_count < 4) {
				variable_instance_set(id, argument[2], ds_stack_pop(_subject));	// Value
			} else {
				// Value
				variable_instance_set(id, argument[2], _i);						// Key
				variable_instance_set(id, argument[3], ds_stack_pop(_subject));	// Value
			}
		}
		
		// Return length
		return _length;
	}
	
	// Iterate objects
	if (object_exists(_subject)) {
		// Get subject length
		_length = instance_number(_subject);
		
		// Set loop variables
		if (_i < _length) {
			// Set loop variables
			if (argument_count < 4) {
				variable_instance_set(id, argument[2], instance_find(_subject, _i)); // Value
			} else {
				// Value
				variable_instance_set(id, argument[2], _i);							 // Key
				variable_instance_set(id, argument[3], instance_find(_subject, _i)); // Value
			}
		}
		
		// Return length
		return _length;
	}
	
	// Other numeric values
	if (is_real(_subject)) {
		// Set loop variables
		if (_i < _subject) {
			if (argument_count < 4) {
				variable_instance_set(id, argument[2], _i);	// Value
			} else {
				// Value
				variable_instance_set(id, argument[2], _i);	// Key
				variable_instance_set(id, argument[3], _i);	// Value
			}
		}
		
		// Return length
		return _subject;
	}
}