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
	// Direction vector of the line
    var temp_dx = second_point_x - first_point_x;
    var temp_dy = second_point_y - first_point_y;

    // Vector from P1 to P3
    var temp_vx = x_position - first_point_x;
    var temp_vy = y_position - first_point_y;

    // Compute the projection scalar (dot(v, d) / dot(d, d))
    var temp_projection_scalar = dot_product(temp_vx, temp_vy, temp_dx, temp_dy) / dot_product(temp_dx, temp_dy, temp_dx, temp_dy);
	temp_projection_scalar = clamp(temp_projection_scalar, 0, 1);

    // Closest point on the line
    var temp_return =
	{
	    return_x: first_point_x + temp_projection_scalar * temp_dx,
	    return_y: first_point_y + temp_projection_scalar * temp_dy
	};
	
	return temp_return;
}
