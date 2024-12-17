/// @function		string_implode(array, [delim]);
/// @param			{array}		array
/// @param			{string}	[delim]
/// @description	Combines the contents of a 1D array into a string, optionally separated by a 
///					delimeter character (or substring).
///
///					Note that all array contents will be treated as strings. If the array contains 
///					pointers to other types of data, the pointer will be written literally rather 
///					than writing the contents of the data itself.
///
/// @example		var notes = ["do", "re", "mi", "fa", "so", "la", "ti", "do"];
///
///					notes = string_implode(notes, "|");
///
///					draw_text(x, y, notes);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function string_implode() {
	// Initialize arguments
	var _ar = argument[0],
		_delim = "",
		_str = "";
	if (argument_count > 1) {
		_delim = argument[1];
	}
	
	// Combine array values into string
	if (array_length(_ar) > 1) {
		for (var i = 0; i < array_length(_ar); i++) {
			_str = _str + string(_ar[i]) + _delim;
		}
	} else {
		// Skip delimeter if only one array value exists
		if (array_length(_ar) > 0) {
			_str = string(_ar[0]);
		}
	}
	
	// Return merged string
	return _str;
}