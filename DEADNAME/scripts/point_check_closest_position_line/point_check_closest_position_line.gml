/// point_check_closest_position_line(point_x, point_y, line_x1, line_y1, line_x2, line_y2);
/// @description Uses a given point to check where is the closest position is on the given line
/// @param {real} point_x The x position of the point to check
/// @param {real} point_y The y position of the point to check
/// @param {real} line_x1 The first x position of the line to check
/// @param {real} line_y1 The first y position of the line to check
/// @param {real} line_x2 The second x position of the line to check
/// @param {real} line_y2 The second y position of the line to check
/// @return {array} The closest position to the given point on the given line stored as an array with 2 entries ([0] = x, [1] = y)

// Establish Variables
var temp_point_x = argument0;
var temp_point_y = argument1;
var temp_line_x1 = argument2;
var temp_line_y1 = argument3;
var temp_line_x2 = argument4;
var temp_line_y2 = argument5;

// Find Closest Point
var temp_line1_closest = true;
if (point_distance(temp_point_x, temp_point_y, temp_line_x1, temp_line_y1) > point_distance(temp_point_x, temp_point_y, temp_line_x2, temp_line_y2)) {
	temp_line1_closest = false;
}

// Check if Obtuse
var temp_length_a = point_distance(temp_point_x, temp_point_y, temp_line_x2, temp_line_y2);
var temp_length_b = point_distance(temp_point_x, temp_point_y, temp_line_x1, temp_line_y1);
var temp_length_c = point_distance(temp_line_x1, temp_line_y1, temp_line_x2, temp_line_y2);

var temp_value = (sqr(temp_length_b) + sqr(temp_length_c) - sqr(temp_length_a)) / (2 * temp_length_b * temp_length_c);
temp_value = clamp(temp_value, -0.99, 0.99);
if (is_nan(temp_value)) {
	temp_value = 0;
}
temp_value = round(arccos(temp_value));
if (temp_value >= pi / 2) {
	var temp_obtuse_return_array = noone;
	if (temp_line1_closest) {
		temp_obtuse_return_array[0] = temp_line_x1;
		temp_obtuse_return_array[1] = temp_line_y1;
	}
	else {
		temp_obtuse_return_array[0] = temp_line_x2;
		temp_obtuse_return_array[1] = temp_line_y2;
	}
	return temp_obtuse_return_array;
}

// Calculate Closest Point
var temp_edge_length = cos(temp_value) * temp_length_b;
var temp_edge_angle = point_direction(temp_line_x1, temp_line_y1, temp_line_x2, temp_line_y2);

// Return Coordinate Array
var temp_return = noone;
temp_return[0] = temp_line_x1 + lengthdir_x(temp_edge_length, temp_edge_angle);
temp_return[1] = temp_line_y1 + lengthdir_y(temp_edge_length, temp_edge_angle);
return temp_return;