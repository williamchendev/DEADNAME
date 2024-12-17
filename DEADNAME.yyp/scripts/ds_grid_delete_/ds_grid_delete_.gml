/// @function		ds_grid_delete_col(id, col);
/// @param			{ds_grid}	id
/// @param			{integer}	col
/// @description	Removes a column from the specified ds_grid while preserving other data.
///
///					When complete, `ds_grid_width` will be reduced by 1. For this reason, a 
///					column should only be deleted when there are at least two columns in the 
///					grid, otherwise the entire grid will be destroyed.
///
/// @example		ds_grid_delete_col(my_grid, 1);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_grid_delete_col(_grid, _col) {
	// Get data structure dimensions
	var ds_height = ds_grid_height(_grid) - 1; 
	var ds_width = ds_grid_width(_grid) - 1; 

	// Remove column from data structure
	if (ds_width > 0) {
		// If not the last column, shift other data back
		if (_col < ds_width) {
			ds_grid_set_grid_region(_grid, _grid, _col + 1, 0, ds_width, ds_height, _col, 0);
		}
   
		// Remove the last column
		ds_grid_resize(_grid, max(1, ds_width), ds_height + 1);
	} else {
		// If the last column, destroy ds_grid
		ds_grid_destroy(_grid);
	}
}


/// @function		ds_grid_delete_row(id, row);
/// @param			{ds_grid}	id
/// @param			{integer}	row
/// @description	Removes a row from the specified ds_grid while preserving other data.
///
///					When complete, `ds_grid_height` will be reduced by 1. For this reason, a 
///					row should only be deleted when there are at least two rows in the grid,
///					otherwise the entire grid will be destroyed.
///
/// @example		ds_grid_delete_row(my_grid, 1);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_grid_delete_row(_grid, _row) {
	// Get data structure dimensions
	var ds_height = ds_grid_height(_grid) - 1; 
	var ds_width = ds_grid_width(_grid) - 1; 

	// Remove row from data structure
	if (ds_height > 0) {
		// If not the last row, shift other data up
		if (_row < ds_height) {
			ds_grid_set_grid_region(_grid, _grid, 0, _row + 1, ds_width, ds_height, 0, _row);
		}
   
		// Remove the last row
		ds_grid_resize(_grid, ds_width + 1, max(1, ds_height));   
	} else {
		// If the last row, destroy ds_grid
		ds_grid_destroy(_grid);
	}
}
