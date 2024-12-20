/// @function platform_free(pos_x, pos_y, platform_list);
/// @description Checks if the object will collide with any platforms and solids at the given position
/// @param {number} pos_x The x position to check
/// @param {number} pos_y The y position to check
/// @param {ds_list} platform_list The ds_list of platform object id's
/// @param {bool} precise Enables Precise Collisions (Can check collisions on platforms that overlap with each other)
/// @returns {bool} returns true if location is empty of solids and the list of platform instances
function platform_free(pos_x, pos_y, platform_list, precise = false) 
{
	// Check if touching a solid
	if (!place_free(pos_x, pos_y)) 
	{
		return false;
	}

	// Check if touching a platform
	return precise ? platform_free_precise(pos_x, pos_y, platform_list) : platform_free_unprecise(pos_x, pos_y, platform_list);
}

function platform_free_precise(pos_x, pos_y, platform_list) 
{
	// Check for Platform Instance
	var temp_platform_collision_inst_list = ds_list_create();
	var temp_platform_collision_inst_num = instance_place_list(pos_x, pos_y, oPlatform, temp_platform_collision_inst_list, false);
	
	// Check if touching a platform
	var i = 0;
	
	repeat(temp_platform_collision_inst_num)
	{
		var temp_platform_collision_inst = ds_list_find_value(temp_platform_collision_inst_list, i);
		
		if (ds_list_find_index(platform_list, temp_platform_collision_inst) != -1)
		{
			if (pos_y >= temp_platform_collision_inst.y + 1)
			{
				// Touching Platform: Space is not Free
				ds_list_destroy(temp_platform_collision_inst_list);
				return false;
			}
		}
		
		i++;
	}
	
	// Not Touching Platform or Solid: Space is Free
	ds_list_destroy(temp_platform_collision_inst_list);
	return true;
}

function platform_free_unprecise(pos_x, pos_y, platform_list) 
{
	// Check for Platform Instance
	var temp_platform_collision_inst = collision_rectangle((bbox_left - x) + pos_x, pos_y - 5, (bbox_right - x) + pos_x, pos_y, oPlatform, true, true);

	// Check if touching a platform
	if (temp_platform_collision_inst == noone)
	{
		return true;
	}
	else if (ds_list_find_index(platform_list, temp_platform_collision_inst) != -1)
	{
		return false;
	}
	
	// Not Touching Platform or Solid: Space is Free
	return true;
}