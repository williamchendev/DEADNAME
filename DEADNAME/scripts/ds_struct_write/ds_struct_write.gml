/// @function		ds_struct_write(id, [pretty]);
/// @param			{struct}	id
/// @param			{boolean}	[pretty]
/// @description	Converts a struct and its contents to a string, optionally with "pretty-print"
///					to separate values by line with proper indenting.
///
///					Note that only single values, arrays, strings, and sub-structs are interpreted
///					by this function. Other data structures, like ds_map or ds_grid, are stored by
///					reference only and will be written as a numerical index rather than their 
///					actual contents. To avoid this behavior, first use the respective `ds_*_write`
///					function on these data structures so they will be included as strings which can
///					be decoded later with `ds_*_read`.
///
/// @example		var file = file_text_open_write("settings.json");
///					file_text_write_string(
///						file,
///						ds_struct_write(my_struct, true)
///					);
///					file_text_close(file);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_struct_write() {
	// Initialize variables
	var _struct = argument[0];
	var _pretty = false;
	if (argument_count > 1) {
		_pretty = argument[1];
	}
	
	// Convert struct to string
	_struct = json_stringify(_struct);
	
	// Pretty-print string, if enabled
	if (_pretty == true) {
		var indent = "",
			level = 0;
		
		// Increment characters for pretty-printing
		for (var c = 0; c <= string_length(_struct); c++) {
			switch (string_char_at(_struct, c)) {
				// Skip pretty-print while parsing string values
				case "\"": 
					c = string_pos_ext("\"", _struct, c + 1); 
					break;
				
				// Increase indent after opening brackets
				case "[":
				case "{": 
					level++; 
					indent = "\n" + string_repeat("    ", level);
					_struct = string_insert(indent, _struct, c + 1);
					c += string_length(indent);
					break;
				
				// Decrease indent after closing brackets
				case "]":
				case "}": 
					level--; 
					indent = "\n" + string_repeat("    ", level);
					_struct = string_insert(indent, _struct, c);
					c += string_length(indent);
					break;
				
				// Insert newline after comma
				case ",":
					indent = "\n" + string_repeat("    ", level);
					_struct = string_insert(indent, _struct, c + 1);
					c += string_length(indent);
			}
		}
	}
	
	// Return struct string
	return _struct;
}