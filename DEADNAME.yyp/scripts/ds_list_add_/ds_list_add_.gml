/// @function		ds_list_add_list(id, source);
/// @param			{ds_list}	id
/// @param			{ds_list}	source
/// @description	Adds the **contents** of a previously-created ds_list to the specified ds_list.
///
///					Intended only for use with JSON functions. Normally, adding one data structure 
///					to another simply stores a **reference** to the data structure, therefore this
///					function is necessary to flag the list value as a data structure itself so its
///					contents are written to the JSON file.
///				
///					As JSON data is unordered by nature, there is no need to input an index at which 
///					to insert the new list.
///
/// @example		my_list = ds_list_create();
///					my_other_list = ds_list_create();
///	
///					ds_list_add_list(my_list, my_other_list);
///	
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_list_add_list(_list, _list_new) {
	// Add the input ds_list to the parent ds_list
	ds_list_add(_list, _list_new);
	ds_list_mark_as_list(_list, ds_list_size(_list) - 1);
}


/// @function		ds_list_add_map(id, source);
/// @param			{ds_list}	id
/// @param			{ds_map}	source
/// @description	Adds the **contents** of a previously-created ds_map to the specified ds_list.
///
///					Intended only for use with JSON functions. Normally, adding one data structure 
///					to another simply stores a **reference** to the data structure, therefore this
///					function is necessary to flag the list value as a data structure itself so its
///					contents are written to the JSON file.
///					
///					As JSON data is unordered by nature, there is no need to input an index at which 
///					to insert the new list.
///
/// @example		my_list = ds_list_create();
///					my_map = ds_map_create();
///					
///					ds_list_add_map(my_list, my_map);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_list_add_map(_list, _map) {
	// Add the input ds_map to the parent ds_list
	ds_list_add(_list, _map);
	ds_list_mark_as_map(_list, ds_list_size(_list) - 1);
}
