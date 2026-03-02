function raycast_sphere(ray_origin_x, ray_origin_y, ray_origin_z, ray_direction_x, ray_direction_y, ray_direction_z, sphere_x, sphere_y, sphere_z, sphere_radius) 
{
	// Offset vector from sphere center to ray origin
	var temp_offset_x = ray_origin_x - sphere_x;
	var temp_offset_y = ray_origin_y - sphere_y;
	var temp_offset_z = ray_origin_z - sphere_z;
	
	// Calculate Quadratic Coefficients
	var temp_a = dot_product_3d(ray_direction_x, ray_direction_y, ray_direction_z, ray_direction_x, ray_direction_y, ray_direction_z);
	var temp_b = 2.0 * dot_product_3d(temp_offset_x, temp_offset_y, temp_offset_z, ray_direction_x, ray_direction_y, ray_direction_z);
	var temp_c = dot_product_3d(temp_offset_x, temp_offset_y, temp_offset_z, temp_offset_x, temp_offset_y, temp_offset_z) - sphere_radius * sphere_radius;
	var temp_d = temp_b * temp_b - 4.0 * temp_a * temp_c;
	
	// Check if Raycast produced no Intersection with the Sphere
	if (temp_d < 0)
	{
		return undefined;
	}
	
	// Calculate Sphere Discriminant's square root
	var temp_d_sqrt = sqrt(temp_d);
	
	// Check for nearest Positive T intesection value
	var temp_t = (-temp_b - temp_d_sqrt) / (2 * temp_a);
	
	if (temp_t < 0)
	{
		temp_t = (-temp_b + temp_d_sqrt) / (2 * temp_a);
		
		if (temp_t < 0)
		{
			// Both intersections are behind the ray
			return undefined;
		}
	}
	
	// Calculate Intersection's Position
	var temp_interection_x = ray_origin_x + temp_t * ray_direction_x;
	var temp_interection_y = ray_origin_y + temp_t * ray_direction_y;
	var temp_interection_z = ray_origin_z + temp_t * ray_direction_z;
	
	// Return Intersection's Position & Distance to Origin Array
	return [ temp_interection_x, temp_interection_y, temp_interection_z, temp_t ];
}

/// @description convert_2d_to_3d(x, y, view_mat, proj_mat)
/// @param x
/// @param y
/// @param view_mat
/// @param proj_mat
function screen_to_world(x, y, view_mat, proj_mat) {
	/*
	Transforms a 2D coordinate (in window space) to a 3D vector.
	Returns an array of the following format:
	[dx, dy, dz, ox, oy, oz]
	where [dx, dy, dz] is the direction vector and [ox, oy, oz] is the origin of the ray.

	Works for both orthographic and perspective projections.

	Script created by TheSnidr
	(slightly modified by @dragonitespam)
	*/
	var _x = x;
	var _y = y;
	var V = view_mat;
	var P = proj_mat;

	var mx = 2 * (_x / window_get_width() - .5) / P[0];
	var my = 2 * (_y / window_get_height() - .5) / P[5];
	var camX = - (V[12] * V[0] + V[13] * V[1] + V[14] * V[2]);
	var camY = - (V[12] * V[4] + V[13] * V[5] + V[14] * V[6]);
	var camZ = - (V[12] * V[8] + V[13] * V[9] + V[14] * V[10]);

	if (P[15] == 0)
	{    //This is a perspective projection
	    return [V[2]  + mx * V[0] + my * V[1],
	            V[6]  + mx * V[4] + my * V[5],
	            V[10] + mx * V[8] + my * V[9],
	            camX,
	            camY,
	            camZ];
	}
	else
	{    //This is an ortho projection
	    return [V[2],
	            V[6],
	            V[10],
	            camX + mx * V[0] + my * V[1],
	            camY + mx * V[4] + my * V[5],
	            camZ + mx * V[8] + my * V[9]];
	}


}