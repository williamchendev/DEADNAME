/// @function rotation_matrix_from_euler_angles(euler_angle_x, euler_angle_y, euler_angle_z);
/// @description Converts a set of Euler angles to the corresponding rotation matrix
/// @param {real} euler_angle_x The x-axis euler rotation angle in degrees
/// @param {real} euler_angle_y The y-axis euler rotation angle in degrees
/// @param {real} euler_angle_z The z-axis euler rotation angle in degrees
/// @return {array} Returns an array 16 indexes long corresponding to a 4x4 rotation matrix
function rotation_matrix_from_euler_angles(euler_angle_x, euler_angle_y, euler_angle_z)
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	// Convert Euler Angles from Degrees to Radians
	var temp_roll = degtorad(euler_angle_x);
	var temp_pitch = degtorad(euler_angle_y);
	var temp_yaw = degtorad(euler_angle_z);
	
	// Pre-calculate Sin and Cos values
	var temp_cr = cos(temp_roll);
	var temp_sr = sin(temp_roll);
	var temp_cp = cos(temp_pitch);
	var temp_sp = sin(temp_pitch);
	var temp_cy = cos(temp_yaw);
	var temp_sy = sin(temp_yaw);
	
	// Build rotation matrix (ZXY order - roll, yaw, pitch)
	var temp_rotation_matrix = array_create(16);
    
    temp_rotation_matrix[0] = temp_cy * temp_cp - temp_sr * temp_sy * temp_sp;
    temp_rotation_matrix[1] = temp_sy * temp_cp + temp_sr * temp_sp * temp_cy;
    temp_rotation_matrix[2] = -temp_sp * temp_cr;
    temp_rotation_matrix[3] = 0;
    
    temp_rotation_matrix[4] = -temp_sy * temp_cr;
    temp_rotation_matrix[5] = temp_cr * temp_cy;
    temp_rotation_matrix[6] = temp_sr;
    temp_rotation_matrix[7] = 0;
    
    temp_rotation_matrix[8] = temp_sp * temp_cy + temp_sr * temp_sy * temp_cp;
    temp_rotation_matrix[9] = temp_sp * temp_sy - temp_sr * temp_cy * temp_cp;
    temp_rotation_matrix[10] = temp_cr * temp_cp;
    temp_rotation_matrix[11] = 0;
    
    temp_rotation_matrix[12] = 0;
    temp_rotation_matrix[13] = 0;
    temp_rotation_matrix[14] = 0;
    temp_rotation_matrix[15] = 1;
	
	// Return Rotation Matrix
	return temp_rotation_matrix;
}

/// @function euler_angles_from_rotation_matrix(rotation_matrix);
/// @description Converts a 4x4 rotation matrix (ZXY order) into Euler Angles
/// @param {array} rotation_matrix 16-length array (4x4 matrix)
/// @return {array} [x, y, z] Euler angles in degrees
function euler_angles_from_rotation_matrix(rotation_matrix)
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	//
	var temp_pitch;
	var temp_yaw;
	
	// Extract Roll
	var temp_sr = clamp(rotation_matrix[6], -1, 1);
	var temp_roll = arcsin(temp_sr);
	
	// Check for gimbal lock
	var temp_cr = cos(temp_roll);
	
	if (abs(temp_cr) > 0.00001)
	{
		// Standard case
		temp_pitch = arctan2(-rotation_matrix[2], rotation_matrix[10]);
		temp_yaw   = arctan2(-rotation_matrix[4], rotation_matrix[5]);
	}
	else
	{
		// Gimbal lock case
		temp_pitch = 0;
		temp_yaw = arctan2(rotation_matrix[1], rotation_matrix[0]);
	}
	
	return [ radtodeg(temp_roll), radtodeg(temp_pitch), radtodeg(temp_yaw) ];
}
