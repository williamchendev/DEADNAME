/// @function		array_depth(id);
/// @param			{array}	id
/// @description	Returns the number of dimensions contained in an array. If the input value
///					is not an array, 0 will be returned instead.
///
///					Note that array dimensions are not required to have uniform depth. This
///					function returns the **deepest** dimension contained within an array.
///
/// @example		var my_array = [ 1, 2, 3, [ "a", "b", "c", [ ".", "!", "?" ] ] ];
///
///					draw_text(25, 25, string(array_depth(my_array)));
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function array_depth(_id) {
	// Return 0 if input is a single value
	if (!is_array(_id)) {
		return 0;
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
			}
		}
	}
	
	// Get deepest level
	array_sort(level, false);
	level = level[0];
	
	// Return deepest level
	return level;
}