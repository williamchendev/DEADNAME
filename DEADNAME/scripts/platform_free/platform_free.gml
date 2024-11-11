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
	if (ds_list_find_index(platform_list, instance_place(pos_x, pos_y, oPlatform)) != -1)
	{
		return false;
	}
	
	// Not Touching Platform or Solid: Space is Free
	return true;
}