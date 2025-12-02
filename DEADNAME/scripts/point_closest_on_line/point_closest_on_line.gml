/// @function point_closest_on_line(x_position, y_position, first_point_x, first_point_y, second_point_x, second_point_y);
/// @description Finds the closest coordinate on a line segment created from the given coordinates from the given position
/// @param {number} x_position The X position to check for the closest coordinate to
/// @param {number} y_position The Y position to check for the closest coordinate to
/// @param {number} first_point_x The X position of the first coordinate in a line segment to find the closest coordinate to
/// @param {number} first_point_y The Y position of the first coordinate in a line segment to find the closest coordinate to
/// @param {number} second_point_x The X position of the second coordinate in a line segment to find the closest coordinate to
/// @param {number} second_point_y The Y position of the second coordinate in a line segment to find the closest coordinate to
/// @returns {struct} A struct with the X coordinate [struct.return_x] and Y coordinate [struct.return_y]
function point_closest_on_line(x_position, y_position, first_point_x, first_point_y, second_point_x, second_point_y) 
{
	// Add to Compiler
	gml_pragma("forceinline");
	
	// Direction vector of the line
	var temp_dx = second_point_x - first_point_x;
	var temp_dy = second_point_y - first_point_y;
	
	// Vector from P1 to P3
	var temp_vx = x_position - first_point_x;
	var temp_vy = y_position - first_point_y;
	
	// Compute the projection scalar (dot(v, d) / dot(d, d))
	var temp_projection_scalar = dot_product(temp_vx, temp_vy, temp_dx, temp_dy);
	temp_projection_scalar = clamp(temp_projection_scalar, 0, 1);
	
	// Closest point on the line
	var temp_return =
	{
		return_x: first_point_x + temp_projection_scalar * temp_dx,
		return_y: first_point_y + temp_projection_scalar * temp_dy
	};
	
	return temp_return;
}

/// @function point_closest_on_line_3d(x_position, y_position, z_position, first_point_x, first_point_y, first_point_z, second_point_x, second_point_y, second_point_z);
/// @description Finds the closest coordinate on a line segment created from the given coordinates from the given position
/// @param {number} x_position The X position to check for the closest coordinate to
/// @param {number} y_position The Y position to check for the closest coordinate to
/// @param {number} z_position The Z position to check for the closest coordinate to
/// @param {number} first_point_x The X position of the first coordinate in a line segment to find the closest coordinate to
/// @param {number} first_point_y The Y position of the first coordinate in a line segment to find the closest coordinate to
/// @param {number} first_point_z The Z position of the first coordinate in a line segment to find the closest coordinate to
/// @param {number} second_point_x The X position of the second coordinate in a line segment to find the closest coordinate to
/// @param {number} second_point_y The Y position of the second coordinate in a line segment to find the closest coordinate to
/// @param {number} second_point_z The Z position of the second coordinate in a line segment to find the closest coordinate to
/// @returns {struct} A struct with the X coordinate [struct.return_x], Y coordinate [struct.return_y], and Z coordinate [struct.return_z]
function point_closest_on_line_3d(x_position, y_position, z_position, first_point_x, first_point_y, first_point_z, second_point_x, second_point_y, second_point_z) 
{
	// Add to Compiler
	gml_pragma("forceinline");
	
	// Direction vector of the line
	var temp_dx = second_point_x - first_point_x;
	var temp_dy = second_point_y - first_point_y;
	var temp_dz = second_point_z - first_point_z;
	
	// Vector from P1 to P3
	var temp_vx = x_position - first_point_x;
	var temp_vy = y_position - first_point_y;
	var temp_vz = z_position - first_point_z;
	
	// Compute the projection scalar (dot(v, d) / dot(d, d))
	var temp_projection_scalar = dot_product_3d(temp_vx, temp_vy, temp_vz, temp_dx, temp_dy, temp_dz);
	temp_projection_scalar = clamp(temp_projection_scalar, 0, 1);
	
	// Closest point on the line
	var temp_return =
	{
		return_x: first_point_x + temp_projection_scalar * temp_dx,
		return_y: first_point_y + temp_projection_scalar * temp_dy,
		return_z: first_point_z + temp_projection_scalar * temp_dz
	};
	
	return temp_return;
}
