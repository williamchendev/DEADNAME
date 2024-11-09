/// platform_free(pos_x, pos_y, platform_list);
/// @description Checks if the object will collide with any platforms and solids at the given position
/// @param {number} pos_x The x position to check
/// @param {number} pos_y The y position to check
/// @param {ds_list} platform_list The ds_list of platform object id's
/// @returns {bool} returns true if location is empty of solids and the list of platform instances
function platform_free(pos_x, pos_y, platform_list) 
{
	// Check if touching a solid
	if (!place_free(pos_x, pos_y)) 
	{
		return false;
	}

	// Check if touching a platform
	for (var i = 0; i < ds_list_size(platform_list); i++) 
	{
		var temp_platform = ds_list_find_value(platform_list, i);
		
		if (!place_empty(pos_x, pos_y, temp_platform)) 
		{
			return false;
		}
	}

	return true;
}