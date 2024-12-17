/// @function		array_fill(id, [val]);
/// @param			{array}	id
/// @param			{any}	[val]
/// @description	Finds the longest dimension of a multidimensional array and fills all other
///					dimensions to match the same length, optionally assigning a default value
///					to any new cells created. If a custom value is not specified, 0 will be used
///					by default.
///
///					Can be useful for parsing arrays where the parser must assume a certain size
///					for all dimensions of an array. However, note that this function fills array
///					**length** only. Sub-dimensions can still be non-uniform in **depth**, which
///					cannot be solved by this function, as doing so would result in data loss.
///
/// @example		array_fill(my_array);
///					array_fill(my_array, -1);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function array_fill() {
	// Initialize variables
	var _id = argument[0];
	var _val = 0;
	if (argument_count > 1) {
		_val = argument[1];
	}
	
	// Initialize recursively parsing array size
	var dims = [_id],
		size = 0;
	
	// Parse array dimensions
	for (var d = 0; d < array_length(dims); d++) {
		for (var i = 0; i < array_length(dims[d]); i++) {
			// If a child array is found...
			if (is_array(dims[d][i])) {
				// Queue it for parsing length
				array_push(dims, dims[d][i]);
			}
		}
		
		// Get longest dimension
		size = max(size, array_length(dims[d]));
	}
	
	// Resize all dimensions to match longest dimension
	for (var d = 0; d < array_length(dims); d++) {
		var len = array_length(dims[d]);
		for (var i = 0; i < (size - len); i++) {
			// Fill array with default value
			dims[d][@ len + i] = _val;
		}
	}
}
