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

/// @function platform_raycast(pos_x, pos_y, distance, angle);
/// @description Raycasts from the given point, distance, and angle to any Platforms and Solids using the same collision logic as platform_free();
/// @param {number} pos_x The x position to project the Raycast from
/// @param {number} pos_y The y position to project the Raycast from
/// @param {number} distance The distance of the Raycast
/// @param {number} angle The angle of the Raycast
/// @returns {struct} returns a struct containing a boolean if a collision occured [struct.collision], and the x and y coordinates of the collision and/or end of the Raycast [struct.collision_x] [struct.collision_y]
function platform_raycast(pos_x, pos_y, distance, angle = 270)
{
	// Normalize Angle
	angle = angle mod 360;
	
	if (angle < 0)
	{
		angle += 360;
	}
	
	// Calculate Angle
	var temp_cos = 1;
	var temp_sin = 0;
	
	switch (angle)
	{
		case 0:
		case 360:
			break;
		case 90:
			temp_cos = 0;
			temp_sin = 1;
			break;
		case 180:
			temp_cos = -1;
			temp_sin = 0;
			break;
		case 270:
			temp_cos = 0;
			temp_sin = -1;
			break;
		default:
			temp_cos = cos(degtorad(angle));
			temp_sin = sin(degtorad(angle));
			break;
	}
	
	// Check for Platform Instance
	var temp_platform_collision_inst_list = ds_list_create();
	var temp_platform_collision_inst_num = collision_line_list(pos_x, pos_y, pos_x + (temp_cos * distance), pos_y - (temp_sin * distance), oPlatform, false, true, temp_platform_collision_inst_list, true);
	
	// Iterate through Distance
	var temp_collision_exists = false;
	var temp_collision_x = pos_x + (temp_cos * distance);
	var temp_collision_y = pos_y - (temp_sin * distance);
	
	for (var i = 0; i <= distance; i++)
	{
		// Check each point along Raycast
		var temp_iterating_collision_point_x = pos_x + (temp_cos * i);
		var temp_iterating_collision_point_y = pos_y - (temp_sin * i);
		
		// Solid Raycast Collision Check
		if (collision_point(temp_iterating_collision_point_x, temp_iterating_collision_point_y, oSolid, false, true))
		{
			temp_collision_exists = true;
			temp_collision_x = temp_iterating_collision_point_x;
			temp_collision_y = temp_iterating_collision_point_y;
			break;
		}
		
		// Passthrough Platform Raycast Collision Check
		if (temp_sin < 0)
		{
			// Establish Variables
			var temp_platform_collision_valid = false;
			
			// Iterate through Platforms List
			for (var temp_platform_index = ds_list_size(temp_platform_collision_inst_list) - 1; temp_platform_index >= 0; temp_platform_index--)
			{
				// Find Platform & Test Collision at Point projected from Raycast
				var temp_platform = ds_list_find_value(temp_platform_collision_inst_list, temp_platform_index);
				var temp_collision = collision_point(temp_iterating_collision_point_x, temp_iterating_collision_point_y, temp_platform, false, true);
				
				// Check if Collision is Valid
				if (temp_collision) 
				{
					if (pos_y <= temp_platform.y + 1)
					{
						// Valid Collision for Passthrough Platform - Early Return with Collision Coordinates
						temp_platform_collision_valid = true;
						break;
					}
					else
					{
						// Invalid Collision for Passthrough Platform - Remove Platform from DS List
						ds_list_delete(temp_platform_collision_inst_list, temp_platform_index);
						continue;
					}
				}
			}
			
			// Early Return
			if (temp_platform_collision_valid)
			{
				temp_collision_exists = true;
				temp_collision_x = temp_iterating_collision_point_x;
				temp_collision_y = temp_iterating_collision_point_y;
				break;
			}
		}
	}
	
	// Destroy Collisions DS List
	ds_list_destroy(temp_platform_collision_inst_list);
	
	// Return Collision Position
	return { collision: temp_collision_exists, collision_x: temp_collision_x, collision_y: temp_collision_y };
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