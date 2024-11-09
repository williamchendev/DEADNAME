/// @function		surface_write(surf);
/// @param			{surface}	surf
/// @description	Returns a surface as a base64-encoded string. Use `surface_read` to convert
///					back into a surface. Especially useful for save files and networking.
///
/// @example		ini_open(working_directory + "save.dat");
///					ini_write_string("data", "screenshot", surface_write(application_surface));
///					ini_close();
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function surface_write(_surf) {
	// Calculate surface buffer size
	var buf_width = surface_get_width(_surf);
	var buf_height = surface_get_height(_surf);
	var buf_size = ((buf_width*buf_height)*4);
	
	// Create buffer from surface
	var buf_temp = buffer_create(buf_size, buffer_grow, 1);
	buffer_get_surface(buf_temp, _surf, 0);
	var buf_comp = buffer_compress(buf_temp, 0, buffer_get_size(buf_temp));
	
	// Convert buffer to base64
	var buf_base64 = buffer_base64_encode(buf_comp, 0, buffer_get_size(buf_comp));
	
	// Cleanup temp data
	buffer_delete(buf_temp);
	buffer_delete(buf_comp);
	
	// Return buffer string with resolution information
	return string(buf_width) + "x" + string(buf_height) + "x" + buf_base64;
}