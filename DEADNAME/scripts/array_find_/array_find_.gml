/// @function		array_find_dim(id, val);
/// @param			{array}	id
/// @param			{any}	val
/// @description	Searches a multidimensional array for the given value and returns the dimension
///					in which it exists, or -1 if the value is not found in the array. If the input
///					is not an array, but happens to match the search value regardless, 0 will be
///					returned instead.
///
/// @example		var my_array = [ 1, 2, 3, [ "a", "b", "c", [ ".", "!", "?" ] ] ];
///
///					draw_text(25, 25, string(array_find_dim(my_array, "b")));
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function array_find_dim(_id, _val) {
	// Return 0 if input matches single value, or -1 otherwise
	if (!is_array(_id)) {
		return ((_id == _val) - 1);
	}
	
	// Initialize recursively parsing array dimensions
	var dims = [_id],
		level = [1];
	
	// Parse array dimensions
	for (var d = 0; d < array_length(dims); d++) {
		for (var i = 0; i < array_length(dims[d]); i++) {
			// If a child array is found...
			if (is_array(dims[d][i])) {
				// Queue it for parsing and set child depth
				array_push(dims, dims[d][i]);
				array_push(level, level[d] + 1);
			} else {
				// Otherwise, check for matches
				if (dims[d][i] == _val) {
					// Return dimension if a match is found
					return level[d];
				}
			}
		}
	}
	
	// Return -1 if not found
	return -1;
}


/// @function		array_find_index(id, val);
/// @param			{array}	id
/// @param			{any}	val
/// @description	Searches an array for a value and returns the index, if found, or -1 if
///					the value does not exist in the array. If the input is not an array, but 
///					happens to match the search value regardless, 0 will be returned instead.
///
///					To search a multidimensional array, input any parent arrays before the
///					child array to be searched, e.g. `my_array[0][0]`.
///
/// @example		var my_array = [ 1, 2, 3, [ "a", "b", "c", [ ".", "!", "?" ] ] ];
///
///					draw_text(25, 25, string(array_find_index(my_array[3], "b")));
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function array_find_index(_id, _val) {
	// Return 0 if input matches single value, or -1 otherwise
	if (!is_array(_id)) {
		return ((_id == _val) - 1);
	}
	
	// Parse array
	for (var i = 0; i < array_length(_id); i++) {
		// Return index if value is found
		if (_id[i] == _val) {
			return i;
		}
	}
	
	// Otherwise return -1
	return -1;
}


/// @function		array_find_value(id, pos);
/// @param			{array}		id
/// @param			{integer}	pos
/// @description	Returns the value contained in an array at the given index position.
///					
///					To search a multidimensional array, input any parent arrays before the
///					child array to be searched, e.g. `my_array[0][0]`.
///
/// @example		var my_array = [ 1, 2, 3, [ "a", "b", "c", [ ".", "!", "?" ] ] ];
///
///					draw_text(25, 25, string(array_find_value(my_array[3], 2)));
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function array_find_value(_id, _pos) {
	return array_get(_id, _pos);
}