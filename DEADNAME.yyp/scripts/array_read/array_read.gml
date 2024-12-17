/// @function		array_read(str);
/// @param			{string}	str
/// @description	Converts a string previously created by `array_write` into an array and returns
///					the result.
///
///					Note that all array contents will be treated as strings. If the array contains 
///					pointers to other types of data, the pointer will be read literally rather than
///					reading the contents of the data itself.
///
/// @example		var file = file_text_open_read("save.dat");
///					my_array = array_read(file_text_read_string(file));
///					file_text_close(file);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function array_read(_str) {
	return json_parse(_str);
}
