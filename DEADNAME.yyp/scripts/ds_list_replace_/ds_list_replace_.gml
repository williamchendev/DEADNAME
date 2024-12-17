/// @function		ds_list_replace_list(id, oldlist, newlist);
/// @param			{ds_list}	id
/// @param			{ds_list}	oldlist
/// @param			{ds_list}	newlist
/// @description	Replaces a ds_list previously added to another ds_list with the **contents** of 
///					a new ds_list.
///				
///					Warning: because data structures are referenced by numerical values, this script
///					may not behave as you expect! If a numerical entry in the parent ds_list happens
///					to match the value of a child ds_list, there is no guarantee which value will be
///					replaced!
///				
///					Intended only for use with JSON functions. Normally, adding one data structure 
///					to another simply stores a **reference** to the data structure, therefore this
///					function is necessary to flag the list value as a data structure itself so its
///					contents are written to the JSON file.
///
/// @example		my_list = ds_list_create();
///					my_other_list = ds_list_create();
///					my_new_list = ds_list_create();
///				
///					ds_list_add_list(my_list, my_other_list);
///				
///					ds_list_replace_list(my_list, my_other_list, my_new_list);		
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_list_replace_list(_list, _list_old, _list_new) {
	// Get list index to replace
	var ds_index = ds_list_find_index(_list, _list_old);

	// Replace the input ds_list in the parent ds_list
	ds_list_replace(_list, ds_index, _list_new);
	ds_list_mark_as_list(_list, ds_index);
}


/// @function		ds_list_replace_map(id, oldmap, newmap);
/// @param			{ds_list}	id
/// @param			{ds_map}	oldmap
/// @param			{ds_map}	newmap
/// @description	Replaces a ds_map previously added to a parent ds_list with the **contents** of 
///					a new ds_map.
///					
///					Warning: because data structures are referenced by numerical values, this script
///					may not behave as you expect! If a numerical entry in the parent ds_list happens
///					to match the value of a child ds_map, there is no guarantee which value will be
///					replaced!
///					
///					Intended only for use with JSON functions. Normally, adding one data structure 
///					to another simply stores a **reference** to the data structure, therefore this
///					function is necessary to flag the list value as a data structure itself so its
///					contents are written to the JSON file.
///
/// @example		my_list = ds_list_create();
///					my_map = ds_map_create();
///					my_new_map = ds_map_create();
///					
///					ds_list_add_map(my_list, my_map);
///					
///					ds_list_replace_map(my_list, my_map, my_new_map);	
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_list_replace_map(_list, _map_old, _map_new) {
	// Get list index to replace
	var ds_index = ds_list_find_index(_list, _map_old);

	// Replace the input ds_map in the parent ds_list
	ds_list_replace(_list, ds_index, _map_new);
	ds_list_mark_as_map(_list, ds_list_size(_list) - 1);
}
