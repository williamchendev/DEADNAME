/// @function		ds_grid_insert_col(id, col, [value]);
/// @param			{ds_grid}		id
/// @param			{integer}		col
/// @param			{real|string}	[value]
/// @description	Adds a new column to a ds_grid at the given index, shifting any columns 
///					that follow. Optionally also sets a value for empty new cells in the grid
///					(default value is 0).
///
///					When complete, `ds_grid_width` will be increased by 1.
///
/// @example		ds_grid_insert_col(my_grid, ds_grid_width(my_grid) - 2);
///					ds_grid_insert_col(my_grid, ds_grid_width(my_grid) - 2, -1);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_grid_insert_col() {
	// Get data structure
	var _grid = argument[0],
		_col  = argument[1];

	// Get data structure dimensions
	var ds_height = ds_grid_height(_grid) - 1;
	var ds_width = ds_grid_width(_grid);

	// Resize ds_grid to make room for new column
	ds_grid_resize(_grid, ds_width + 1, ds_height + 1);

	// Insert column, if inside data structure range
	if (ds_width > _col) {
		// Shift other columns
		ds_grid_set_grid_region(_grid, _grid, _col, 0, ds_width, ds_height, _col + 1, 0);
	}

	// Set default value, if specified
	var _val = 0;
	if (argument_count > 2) {
		_val = argument[2];
	}

	ds_grid_set_region(_grid, _col, 0, _col, ds_height, _val);
}


/// @function		ds_grid_insert_row(id, row, [value]);
/// @param			{ds_grid}		id
/// @param			{integer}		row
/// @param			{real|string}	[value]
/// @description	Adds a new row to a ds_grid at the given index, shifting any rows that 
///					follow. Optionally also sets a value for empty new cells in the grid
///					(default value is 0).
///
///					When complete, `ds_grid_height` will be increased by 1.
///
/// @example		ds_grid_insert_row(my_grid, ds_grid_height(my_grid) - 2);
///					ds_grid_insert_row(my_grid, ds_grid_height(my_grid) - 2, -1);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_grid_insert_row() {
	// Get data structure
	var _grid = argument[0],
		_row  = argument[1];

	// Get data structure dimensions
	var ds_height = ds_grid_height(_grid);
	var ds_width = ds_grid_width(_grid) - 1;

	// Resize ds_grid to make room for new row
	ds_grid_resize(_grid, ds_width + 1, ds_height + 1);

	// Insert row, if inside data structure range
	if (ds_height > _row) {
		//Shift other rows
		ds_grid_set_grid_region(_grid, _grid, 0, _row, ds_width, ds_height, 0, _row + 1);
	}

	// Set default value, if specified
	var _val = 0;
	if (argument_count > 2) {
		_val = argument[2];
	}

	ds_grid_set_region(_grid, 0, _row, ds_width, _row, _val);
}
