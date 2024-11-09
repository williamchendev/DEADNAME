/// @function		ds_struct_read(str);
/// @param			{string}	str
/// @description	Converts a string previously written with `ds_struct_write` back into a struct,
///					including any sub-structs it may contain.
///
/// @example		var file = file_text_open_read("settings.json");
///					my_struct = ds_struct_read(file_text_read_string(file));
///					file_text_close(file);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_struct_read(_str) {
	// Return the decoded struct
	return json_parse(_str);
}