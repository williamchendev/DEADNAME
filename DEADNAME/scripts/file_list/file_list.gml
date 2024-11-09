/// @function		file_list(dname, attr, [recurse]);
/// @param			{string}	dname
/// @param			{int|const}	attr
/// @param			{boolean}	[recurse]
/// @requires		filename_is_dir
/// @description	Scans a directory and returns the contents as a ds_list, including relative paths
///					(if any), filenames, and extensions.
///				
///					The attribute filter and recursive options can only be used on Windows. All other
///					platforms should set 'attr' to 0 and ignore the optional 'recurse' argument.		
///				
///					If the attribute filter is supported and set to fa_directory, only directories
///					will be returned. This is the only supported filter, and all other options will 
///					return a list of files instead.
///				
///					Note that for best processing speed, files without extensions are not supported 
///					by this script.
///				
///					Also note that by default, this script can only be used to scan directories within 
///					`working_directory` or elsewhere previously granted access via the  
///					`get_save_filename` function. On desktop platforms, this limitation can be removed
///					by disabling the filesystem sandbox in Game Settings.
///
/// @example		var dirs = file_list("C:\\my\\folder", fa_directory, true);
///					var files = file_list("C:\\my\\folder", 0);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function file_list() {

	/*
	INITIALIZATION
	*/

	// Initialize temporary variables for modifying archive
	var _dname = argument[0],
		_attr = argument[1],
		del_count,
		dlist = ds_list_create(),
		drec = 0,
		dxindex = 0,
		dyindex = 1,
		plength = string_length(_dname) + 1;
		
	// Enable recurse, if specified
	if (argument_count > 2) {
		if (argument[2] == true) {
			if (os_type == os_windows) {
				drec = fa_directory;
			} else {
				// Show error if recurse is enabled on an unsupported platform
				var dbg_stack = debug_get_callstack();
				show_debug_message(
					string(dbg_stack) + " WARNING: Recurse enabled, but is not supported on your operating system! " +
					"Listing root files only..."
				);
			}
		}
	}

	// Get root directory
	dlist[| 0] = _dname;


	/*
	LIST DIRECTORY CONTENTS
	*/
		
	// Get subdirectories
	while (dlist[| dxindex] != "") {
		// Add final slash to directories
		if (filename_is_dir(dlist[| dxindex])) {
			dlist[| dxindex] = dlist[| dxindex] + "\\";
		} else {
			// Prefix files in root for sorting
			if (filename_dir(dlist[| dxindex]) == _dname) {
				dlist[| dxindex] = filename_path(dlist[| dxindex]) + "?" + filename_name(dlist[| dxindex]);
			}
		
			// Skip scanning if not a directory
			dxindex++;
			continue;
		}
	
		// Find first subdirectory in current directory
		dlist[| dyindex] = file_find_first(dlist[| dxindex] + "*", drec);
	
		// Find subdirectory contents
		while (dlist[| dyindex] != "") { // Final entry will be blank--need to delete!
			// Get full path
			dlist[| dyindex] = dlist[| dxindex] + dlist[| dyindex];
				
			// Get next content
			dyindex++;
			dlist[| dyindex] = file_find_next();
		}
			
		// Continue to next subdirectory
		file_find_close();
		dxindex++;
	}

	// Sort list
	ds_list_sort(dlist, true);

	// Strip extraneous contents
	for (dyindex = ds_list_size(dlist) - 1; dyindex >= 0; dyindex--) {
		// Filter directories, if enabled
		if (_attr == fa_directory) xor (filename_is_dir(dlist[| dyindex])) {
			ds_list_delete(dlist, dyindex);
			continue;
		}
	
		// Get the length of the path to strip
		del_count = plength;
		if (string_char_at(dlist[| dyindex], plength + 1) == "?") {
			del_count++;
		}
	
		// Strip root path from files
		dlist[| dyindex] = string_delete(dlist[| dyindex], 1, del_count);
	
		// Delete null entries
		if (dlist[| dyindex] == "") {
			ds_list_delete(dlist, dyindex);
		}
	}


	/*
	FINALIZATION
	*/

	// Return directory list
	return dlist;
}
