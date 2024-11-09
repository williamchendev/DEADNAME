/// @function		array_write(id, [pretty]);
/// @param			{array}		id
/// @param			{boolean}	[pretty]
/// @description	Converts an array of any dimensions to a string, optionally with "pretty-print"
///					to separate values by line with proper indenting.
///
///					Note that all array contents will be treated as strings. If the array contains 
///					pointers to other types of data, the pointer will be written literally rather 
///					than writing the contents of the data itself. The exception to this rule is
///					sub-arrays and structs, which will be preserved.
///
/// @example		var file = file_text_open_write("save.dat");
///					file_text_write_string(file, array_write(my_array, true));
///					file_text_close(file);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function array_write() {
	// Initialize variables
	var _id = argument[0];
	var _pretty = false;
	if (argument_count > 1) {
		_pretty = argument[1];
	}
	
	// Convert array to string
	_id = json_stringify(_id);
	
	// Pretty-print string, if enabled
	if (_pretty == true) {
		var indent = "",
			level = 0;
		
		// Increment characters for pretty-printing
		for (var c = 0; c <= string_length(_id); c++) {
			switch (string_char_at(_id, c)) {
				// Skip pretty-print while parsing string values
				case "\"": 
					c = string_pos_ext("\"", _id, c + 1); 
					break;
				
				// Increase indent after opening brackets
				case "[":
				case "{": 
					level++; 
					indent = "\n" + string_repeat("    ", level);
					_id = string_insert(indent, _id, c + 1);
					c += string_length(indent);
					break;
				
				// Decrease indent after closing brackets
				case "]":
				case "}": 
					level--; 
					indent = "\n" + string_repeat("    ", level);
					_id = string_insert(indent, _id, c);
					c += string_length(indent);
					break;
				
				// Insert newline after comma
				case ",":
					indent = "\n" + string_repeat("    ", level);
					_id = string_insert(indent, _id, c + 1);
					c += string_length(indent);
			}
		}
	}
	
	// Return array string
	return _id;
}
