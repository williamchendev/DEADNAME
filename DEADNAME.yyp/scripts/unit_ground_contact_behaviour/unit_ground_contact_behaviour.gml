
//
function unit_ground_contact_behaviour()
{
	// Ground Contact Behaviour
	if (ds_list_find_index(platform_list, collision_point(x, y + 1, oPlatform, false, true)) != -1)
	{
		// Contact with Platform
		ground_contact_vertical_offset = 0;
		draw_angle = 0;
	}
	else
	{
		// Raycast to Solid Collider
		for (var i = 0; i < slope_raycast_distance; i++)
		{
			var temp_solid_rot_inst = collision_point(x, y + i, oSolid, false, true);
			
			if (temp_solid_rot_inst != noone)
			{
				ground_contact_vertical_offset = i;
				draw_angle = point_check_solid_surface_angle(x, y + i, temp_solid_rot_inst);
				return;
			}
		}
	}
}
