/// @function		ds_grid_empty(id);
/// @param			{ds_grid}	id
/// @description	Checks whether the specified ds_grid is empty and returns `true` or `false`.
///
///					Note that this function does **not** check whether or not the grid exists, and
///					checking a non-existant grid will throw an error.
///
/// @example		var ds = ds_grid_create(1, 0);
///
///					if (ds_grid_empty(ds)) {
///						ds_grid_insert_row(ds, 0, "init");
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_grid_empty(_id) {
	return ((ds_grid_width(_id) == 0) or (ds_grid_height(_id) == 0));
}