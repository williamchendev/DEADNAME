function random_sphere_vector() 
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	// uniform spherical distribution
	var temp_phi = random_range(0, 2 * pi);
	var temp_theta = arccos(random_range(-1, 1));
	
	var temp_x = sin(temp_theta) * cos(temp_phi);
	var temp_y = sin(temp_theta) * sin(temp_phi);
	var temp_z = cos(temp_theta);
	
	//
	return [ temp_x, temp_y, temp_z ];
}