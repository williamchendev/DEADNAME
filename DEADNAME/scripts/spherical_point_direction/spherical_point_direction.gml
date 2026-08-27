/// @function spherical_point_direction(vector_rx, vector_ry, vector_rz, vector_ax, vector_ay, vector_az, vector_bx, vector_by, vector_bz) ;
/// @description The the three vectors, each representing a normalized position on a sphere, this function returns an angle (in degrees) representing the orientation of the third vector from the second while using the first as a reference point.
/// @param {real} vector_rx The First Vector's X Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin, meant to be the reference for calculating the orientation of the third vector's angle from the second.
/// @param {real} vector_ry The First Vector's Y Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin, meant to be the reference for calculating the orientation of the third vector's angle from the second.
/// @param {real} vector_rz The First Vector's Z Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin, meant to be the reference for calculating the orientation of the third vector's angle from the second.
/// @param {real} vector_ax The Second Vector's X Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin.
/// @param {real} vector_ay The Second Vector's Y Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin.
/// @param {real} vector_az The Second Vector's Z Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin.
/// @param {real} vector_bx The Third Vector's X Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin.
/// @param {real} vector_by The Third Vector's Y Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin.
/// @param {real} vector_bz The Third Vector's Z Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin.
/// @return {real} Returns an angle (in degrees) representing the orientation of the third vector from the second while using the first as a reference point.
function spherical_point_direction(vector_rx, vector_ry, vector_rz, vector_ax, vector_ay, vector_az, vector_bx, vector_by, vector_bz) 
{
	// Project A onto the Tangent Plane at R
	var temp_ar_dot = vector_ax * vector_rx + vector_ay * vector_ry + vector_az * vector_rz;
	
	var temp_vector_atx = vector_ax - vector_rx * temp_ar_dot;
	var temp_vector_aty = vector_ay - vector_ry * temp_ar_dot;
	var temp_vector_atz = vector_az - vector_rz * temp_ar_dot;
	
	// Project B onto the Tangent Plane at R
	var temp_br_dot = vector_bx * vector_rx + vector_by * vector_ry + vector_bz * vector_rz;
	
	var temp_vector_btx = vector_bx - vector_rx * temp_br_dot;
	var temp_vector_bty = vector_by - vector_ry * temp_br_dot;
	var temp_vector_btz = vector_bz - vector_rz * temp_br_dot;
	
	// Normalize Tangent Vectors
	var temp_vector_at_length = max(sqrt(temp_vector_atx * temp_vector_atx + temp_vector_aty * temp_vector_aty + temp_vector_atz * temp_vector_atz), 0.0001);
	var temp_vector_bt_length = max(sqrt(temp_vector_btx * temp_vector_btx + temp_vector_bty * temp_vector_bty + temp_vector_btz * temp_vector_btz), 0.0001);
	
	temp_vector_atx /= temp_vector_at_length;
	temp_vector_aty /= temp_vector_at_length;
	temp_vector_atz /= temp_vector_at_length;
	
	temp_vector_btx /= temp_vector_bt_length;
	temp_vector_bty /= temp_vector_bt_length;
	temp_vector_btz /= temp_vector_bt_length;
	
	// Calculate the Angle between the two Tangent Vectors and return the Angle in Degrees
	var temp_angle_dot = clamp(temp_vector_atx * temp_vector_btx + temp_vector_aty * temp_vector_bty + temp_vector_atz * temp_vector_btz, -1, 1);
	var temp_angle = arccos(temp_angle_dot);
	return radtodeg(temp_angle);
}

/// @function spherical_point_direction_signed(vector_rx, vector_ry, vector_rz, vector_ax, vector_ay, vector_az, vector_bx, vector_by, vector_bz) ;
/// @description The the three vectors, each representing a normalized position on a sphere, this function returns a signed angle (in degrees) representing the orientation of the third vector from the second while using the first as a reference point.
/// @param {real} vector_rx The First Vector's X Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin, meant to be the reference for calculating the orientation of the third vector's angle from the second.
/// @param {real} vector_ry The First Vector's Y Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin, meant to be the reference for calculating the orientation of the third vector's angle from the second.
/// @param {real} vector_rz The First Vector's Z Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin, meant to be the reference for calculating the orientation of the third vector's angle from the second.
/// @param {real} vector_ax The Second Vector's X Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin.
/// @param {real} vector_ay The Second Vector's Y Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin.
/// @param {real} vector_az The Second Vector's Z Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin.
/// @param {real} vector_bx The Third Vector's X Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin.
/// @param {real} vector_by The Third Vector's Y Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin.
/// @param {real} vector_bz The Third Vector's Z Value as a Vertex in Normalized 3D Local Space from a Sphere's Origin.
/// @return {real} Returns a signed angle (in degrees) representing the orientation of the third vector from the second while using the first as a reference point.
function spherical_point_direction_signed(vector_rx, vector_ry, vector_rz, vector_ax, vector_ay, vector_az, vector_bx, vector_by, vector_bz) 
{
	// Project A onto the Tangent Plane at R
	var temp_ar_dot = vector_ax * vector_rx + vector_ay * vector_ry + vector_az * vector_rz;
	
	var temp_vector_atx = vector_ax - vector_rx * temp_ar_dot;
	var temp_vector_aty = vector_ay - vector_ry * temp_ar_dot;
	var temp_vector_atz = vector_az - vector_rz * temp_ar_dot;
	
	// Project B onto the Tangent Plane at R
	var temp_br_dot = vector_bx * vector_rx + vector_by * vector_ry + vector_bz * vector_rz;
	
	var temp_vector_btx = vector_bx - vector_rx * temp_br_dot;
	var temp_vector_bty = vector_by - vector_ry * temp_br_dot;
	var temp_vector_btz = vector_bz - vector_rz * temp_br_dot;
	
	// Normalize Tangent Vectors
	var temp_vector_at_length = max(sqrt(temp_vector_atx * temp_vector_atx + temp_vector_aty * temp_vector_aty + temp_vector_atz * temp_vector_atz), 0.0001);
	var temp_vector_bt_length = max(sqrt(temp_vector_btx * temp_vector_btx + temp_vector_bty * temp_vector_bty + temp_vector_btz * temp_vector_btz), 0.0001);
	
	temp_vector_atx /= temp_vector_at_length;
	temp_vector_aty /= temp_vector_at_length;
	temp_vector_atz /= temp_vector_at_length;
	
	temp_vector_btx /= temp_vector_bt_length;
	temp_vector_bty /= temp_vector_bt_length;
	temp_vector_btz /= temp_vector_bt_length;
	
	// Calculate the Sin Angle using Cross Product
	var temp_cross_x = temp_vector_aty * temp_vector_btz - temp_vector_atz * temp_vector_bty;
	var temp_cross_y = temp_vector_atz * temp_vector_btx - temp_vector_atx * temp_vector_btz;
	var temp_cross_z = temp_vector_atx * temp_vector_bty - temp_vector_aty * temp_vector_btx;
	
	var temp_sin_angle = vector_rx * temp_cross_x + vector_ry * temp_cross_y + vector_rz * temp_cross_z;
	
	// Calculate Cos Angle using Dot Product
	var temp_cos_angle = temp_vector_atx * temp_vector_btx + temp_vector_aty * temp_vector_bty + temp_vector_atz * temp_vector_btz;
	
	// Signed angle in degrees
	return radtodeg(arctan2(temp_sin_angle, temp_cos_angle));
}

