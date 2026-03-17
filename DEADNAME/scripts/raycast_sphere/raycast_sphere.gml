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
