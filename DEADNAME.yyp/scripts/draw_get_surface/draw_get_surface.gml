/// @function		draw_get_surface(surf);
/// @param			{surface}	surf
/// @requires		surface_write, surface_read
/// @description	Surfaces are "volatile", meaning their data can be erased from memory under 
///					certain common conditions, such as resizing or minimizing the game window.
///
///					This function will return the surface from cached memory to ensure it always
///					exists before drawing. Unlike normal `if (surface_exists(surf))` statements, 
///					`draw_get_surface` will also preserve surface contents, so you never need to 
///					regenerate the surface manually. This is especially useful when surfaces are
///					drawn to dynamically and cannot be recreated, such as for blood splatter or
///					tire tracks resulting from unique and unrepeatable player actions.
///
///					Though it might seem strange to input and return the same variable, this is
///					necessary because the input surface ID might change if the surface does not
///					exist and must be recreated.
///
/// @example		my_surf = draw_get_surface(my_surf);
///
///					draw_surface_ext(my_surf, x, y, 1.5, 1.5, 25, c_red, 0.5);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function draw_get_surface(_id) {
	
	/*
	INITIALIZATION
	*/
	
	// Get surface buffer ID
	var ar_temp = debug_get_callstack(),
		_surf = ar_temp[array_length(ar_temp) - 2];
		
	// Clear temporary array from memory
	ar_temp = 0;

	// Initialize surface buffer struct, if it doesn't exist
	if (is_undefined(variable_instance_get(id, "surf_buffers"))) {
		surf_buffers = {};
	}
	
	// Initialize new surface buffer, if it doesn't exist
	if (!variable_struct_exists(surf_buffers, _surf)) {
		variable_struct_set(surf_buffers, _surf, surface_write(_id));
	}
	
	// Initialize checking surface breaking conditions
	if (!variable_instance_exists(id, "break_win_pause")) {
		break_win_width = window_get_width();
		break_win_height = window_get_height();
		break_win_full = window_get_fullscreen();
		break_win_pause = os_is_paused();
		break_list = -1;
	}
	
	// Initialize checking broken surfaces for restoration
	if (!ds_exists(break_list, ds_type_list)) {
		break_list = ds_list_create();
	}
	
	
	/*
	WINDOW MANAGEMENT
	*/
	
	// Buffer surface if breaking condition is about to occur
	if (break_win_width != window_get_width())
	or (break_win_height != window_get_height())
	or (break_win_full != window_get_fullscreen())
	or (break_win_pause != os_is_paused()) {
		// Do not buffer surface during restore operation
		if (surface_exists(_id)) and (ds_list_find_index(break_list, _surf) == -1) {
			// Buffer surface to be restored
			variable_struct_set(surf_buffers, _surf, surface_write(_id));
			
			// Add to list of surfaces to be restored
			ds_list_add(break_list, _surf);
			
			// Return surface ID--it will break next Step
			return _id;
		}
	}
	
	
	/*
	DATA MANAGEMENT
	*/
	
	// Restore broken surfaces
	if (!surface_exists(_id)) {
		_id = surface_read(variable_struct_get(surf_buffers, _surf));
		
		// Remove surface from list to be restored
		_surf = ds_list_find_index(break_list, _surf);
		if (_surf > -1) {
			ds_list_delete(break_list, _surf);
		}
	}

	// Update values after breaking condition is over
	if (ds_list_empty(break_list)) {
		break_win_width = window_get_width();
		break_win_height = window_get_height();
		break_win_full = window_get_fullscreen();
		break_win_pause = os_is_paused();
	}
	
	// Return surface ID
	return _id;
}