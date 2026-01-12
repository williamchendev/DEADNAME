function haversine_distance_uv(first_u, first_v, second_u, second_v, radius) 
{
	// Add to Compiler
	gml_pragma("forceinline");
	
	// Convert uv to latitude & longitude in radians
	var temp_lon_1 = (first_u - 0.5) * 2 * pi;
	var temp_lat_1 = (first_v - 0.5) * pi;
	
	var temp_lon_2 = (second_u - 0.5) * 2 * pi;
	var temp_lat_2 = (second_v - 0.5) * pi;
	
	// Find UV Distance
	var temp_lon_distance = temp_lon_2 - temp_lon_1;
	var temp_lon_distance = (temp_lon_distance + pi) mod (2 * pi) - pi;
	var temp_lat_distance = temp_lat_2 - temp_lat_1;
	
	// Great Circle distance from first coordinate to second coordinate
	var temp_a = sqr(sin(temp_lat_distance * 0.5)) + cos(temp_lat_1) * cos(temp_lat_2) * sqr(sin(temp_lon_distance * 0.5));
	var temp_c = 2 * arctan2(sqrt(temp_a), sqrt(1 - temp_a));
	
	// Return Distance
	return temp_c * radius;
}

function haversine_distance_uv_offset(u, v, bearing, distance, sphere_radius)
{
	// Add to Compiler
	gml_pragma("forceinline");
	
	// Convert uv to latitude & longitude in radians
	var temp_lat = lerp(-pi * 0.5, pi * 0.5, v);
	var temp_lon = lerp(-pi, pi, u);
	
	// Establish distance and bearing from given uv coordinates to create uv offset
	var temp_angular_distance = distance / sphere_radius;
	var temp_bearing = degtorad(bearing);
	
	// Find Great Circle distance from original coordinate to offset
	var temp_sin_lat = sin(temp_lat);
	var temp_cos_lat = cos(temp_lat);
	var temp_sin_angular_distance = sin(temp_angular_distance);
	var temp_cos_angular_distance = cos(temp_angular_distance);
	
	var temp_new_lat = arcsin(temp_sin_lat * temp_cos_angular_distance + temp_cos_lat * temp_sin_angular_distance * cos(temp_bearing));
	var temp_new_lon = temp_lon + arctan2(sin(temp_bearing) * temp_sin_angular_distance * temp_cos_lat, temp_cos_angular_distance - temp_sin_lat * sin(temp_new_lat));
	
	// Normalize longitude between negative pi and pi
	temp_new_lon = (temp_new_lon + pi mod 2 * pi) - pi;
	
	// Convert offset to uv using Inverse Lerp function
	var temp_u = inverse_lerp(-pi, pi, temp_new_lon, false);
	var temp_v = inverse_lerp(-pi * 0.5, pi * 0.5, temp_new_lat, false);
	
	// Return offset
	return [ temp_u - u, temp_v - v ];
}
