/// @function		ds_struct_destroy(id);
/// @param			{struct}	id
/// @description	Destroys a struct, freeing its data from memory.
///	
///					Note that running this script is not strictly necessary, as structs will typically
///					be purged automatically when all references to them are removed. However, it is
///					good practice to manually remove structs when they are no longer needed to keep
///					memory usage optimized.
///
/// @example		ds_struct_destroy(my_struct);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved
	
function ds_struct_destroy(_struct) {
	// Destroy the struct
	if (is_struct(_struct)) {
		delete _struct;
	}
}