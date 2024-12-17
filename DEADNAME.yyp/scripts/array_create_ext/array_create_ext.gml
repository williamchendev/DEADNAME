/// @function		array_create_ext(size_x, size_y, [size_z], [size_w], ..., value);
/// @param			{integer}	size_x
/// @param			{integer}	size_y
/// @param			{integer}	[size_z]
/// @param			{integer}	[size_w]
/// @param			{integer}	...
/// @param			{any}		value
/// @description	Returns an array of multiple dimensions and assigns a default value to the 
///					lowest level cells.
///
///					At least two dimensions and a default value must be supplied. Additional
///					arguments will be interpreted as dimension sizes preferentially, with the
///					last argument always being the default value.
///
/// @example		my_2d_array = array_create_ext(5, 10, 0);
///
///					my_3d_array = array_create_ext(5, 10, 3, pi);
///
///					my_4d_array = array_create_ext(5, 10, 3, 6, "init");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function array_create_ext() {
	// Stringify default value
	var val = argument[argument_count - 1];
	if (!is_string(val)) {
		if (frac(val) == 0) {
			val = string(val) + ".0";
		} else {
			val = string(val);
		}
	} else {
		val = "\"" + val + "\"";
	}
	
	// Create lowest level array
	var ar_child = "";
	repeat (argument[argument_count - 2] - 1) {
		ar_child = ar_child + val + ",";
	}
	ar_child = ar_child + val;
	
	// Create parent arrays
	for (var arg = (argument_count - 3); arg >= 0; arg--) {
		var ar_parent = "";
		repeat (argument[arg] - 1) {
			ar_parent = ar_parent + "[" + ar_child + "],";
		}
		ar_parent = ar_parent + "[" + ar_child + "]";
		
		ar_child = ar_parent;
	}
	
	// Create root array
	var ar_root = "[" + ar_parent + "]";
	
	// Return generated array
	return json_parse(ar_root);
}
