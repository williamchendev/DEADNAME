/// @function		ds_list_combine(id, source, [pos]);
/// @param			{ds_list}	id
/// @param			{ds_list}	source
/// @param			{integer}	[pos]
/// @description	Copies the values of one ds_list into another ds_list. Unlike ds_list_copy,
///					ds_list_combine does not clear the list of existing values.
///					
///					By default, this script will insert new values at the end of the list. A
///					different position can be optionally supplied instead, ranging from 0 to 
///					ds_list_size(id).
///					
///					Both lists must have already been created before running this script.
///
/// @example		my_list = ds_list_create();
///					my_list[| 0] = "Hello, ";
///	
///					my_other_list = ds_list_create();
///					my_other_list[| 0] = "world!";
///	
///					ds_list_combine(my_list, my_other_list);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_list_combine() {	
	// Get input data structures
	var _list = argument[0],
		_map  = argument[1];

	// Ensure source and target data structures exist
	if (ds_exists(_list, ds_type_list)) and (ds_exists(_map, ds_type_list)) {
		// Initialize temporary variables for processing lists
		var ds_pos = ds_list_size(_list),
			ds_yindex;
		
		// Insert at other list position, if specified
		if (argument_count > 2) {
			ds_pos = clamp(argument[2], 0, ds_pos);
		}

		// Add the source ds_list to the target ds_list
		for (ds_yindex = 0; ds_yindex < ds_list_size(_map); ds_yindex++) {
			ds_list_insert(_list, ds_pos, ds_list_find_value(_map, ds_yindex));
			ds_pos++;
		}
	}
}
