/// @function		is_empty(val);
/// @param			{any}	val
/// @requires		ds_grid_empty, string_trim
/// @description	Checks if a given value is "empty", which can be `true` or `false` depending on
///					the type of data contained in the input value. 
///
///					Some examples of "empty" data include:
///
///					`undefined`, `NaN`, `false`, 0, "0", "", [], {}, etc.
///
///					If the input value points to a data structure, buffer, etc., the structure will
///					be considered empty if no values exist inside the structure itself. Transparent
///					surfaces are also considered empty.
///
///					Note that in some cases this function may not return the expected result due to
///					the way GameMaker handles pointers. This means some types of data can share the
///					same value, and whichever one happens to be first will take priority. Also note
///					that different data types incur different performance costs to evaluate.
///
/// @example		var surf = surface_create(1280, 720);
///					var ds = ds_list_create();
///
///					if (is_empty(surf)) {
///						surface_copy(surf, 0, 0, application_surface);
///					}
///
///					if (is_empty(ds)) {
///						ds_list_add(ds, surf);
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function is_empty(_val) {
	// Undefined values
	if (is_undefined(_val)) or (is_nan(_val)) {
		return true;
	}
	
	// Strings
	if (is_string(_val)) {
		return (string_trim(_val, " .0") == "");
	}
	
	// Arrays
	if (is_array(_val)) {
		return (array_length(_val) == 0);
	}
	
	// Structs
	if (is_struct(_val)) {
		return (variable_struct_names_count(_val) == 0);
	}
	
	// Buffers
	if (buffer_exists(_val)) {
		return (buffer_get_size(_val) == 0);
	}
	
	// DS Grids
	if (ds_exists(_val, ds_type_grid)) {
		return ds_grid_empty(_val);
	}
	
	// DS Lists
	if (ds_exists(_val, ds_type_list)) {
		return ds_list_empty(_val);
	}
	
	// DS Maps
	if (ds_exists(_val, ds_type_map)) {
		return ds_map_empty(_val);
	}
	
	// DS Priority
	if (ds_exists(_val, ds_type_priority)) {
		return ds_priority_empty(_val);
	}
	
	// DS Queues
	if (ds_exists(_val, ds_type_queue)) {
		return ds_queue_empty(_val);
	}
	
	// DS Stacks
	if (ds_exists(_val, ds_type_stack)) {
		return ds_stack_empty(_val);
	}
	
	// Surfaces
	if (surface_exists(_val)) {
		// Convert surface to string via buffer
		var buf_width = surface_get_width(_val);
		var buf_height = surface_get_height(_val);
		var buf_size = ((buf_width*buf_height)*4);
		var buf_temp = buffer_create(buf_size, buffer_grow, 1);
		buffer_get_surface(buf_temp, _val, 0);
		var buf_base64 = buffer_base64_encode(buf_temp, 0, buffer_get_size(buf_temp));
		
		// Cleanup temporary buffer data
		buffer_delete(buf_temp);
		
		// Return empty if surface is fully transparent
		return (string_replace_all(buf_base64, "A", "") == "==");
	}
	
	// Other numeric values (includes boolean)
	if (is_numeric(_val)) {
		return (_val == 0);
	}
	
	// Unknown type (assume not empty)
	return false;
}