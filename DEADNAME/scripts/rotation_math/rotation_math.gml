
//
function rotation_matrix_from_euler_angles(euler_angle_x, euler_angle_y, euler_angle_z)
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	// Convert Euler Angles from Degrees to Radians
	var temp_pitch = degtorad(euler_angle_x);
	var temp_yaw = degtorad(euler_angle_y);
	var temp_roll = degtorad(euler_angle_z);
	
	// Pre-calculate Sin and Cos values
	var temp_cp = cos(temp_pitch);
	var temp_sp = sin(temp_pitch);
	var temp_cy = cos(temp_yaw);
	var temp_sy = sin(temp_yaw);
	var temp_cr = cos(temp_roll);
	var temp_sr = sin(temp_roll);
	
	// Build rotation matrix (ZYX order - roll, yaw, pitch)
	var temp_rotation_matrix = array_create(16);
    
    temp_rotation_matrix[0] = temp_cy * temp_cr;
    temp_rotation_matrix[1] = temp_cy * temp_sr;
    temp_rotation_matrix[2] = -temp_sy;
    temp_rotation_matrix[3] = 0;
    
    temp_rotation_matrix[4] = temp_sp * temp_sy * temp_cr - temp_cp * temp_sr;
    temp_rotation_matrix[5] = temp_sp * temp_sy * temp_sr + temp_cp * temp_cr;
    temp_rotation_matrix[6] = temp_sp * temp_cy;
    temp_rotation_matrix[7] = 0;
    
    temp_rotation_matrix[8] = temp_cp * temp_sy * temp_cr + temp_sp * temp_sr;
    temp_rotation_matrix[9] = temp_cp * temp_sy * temp_sr - temp_sp * temp_cr;
    temp_rotation_matrix[10] = temp_cp * temp_cy;
    temp_rotation_matrix[11] = 0;
    
    temp_rotation_matrix[12] = 0;
    temp_rotation_matrix[13] = 0;
    temp_rotation_matrix[14] = 0;
    temp_rotation_matrix[15] = 1;
	
	// Return Rotation Matrix
	return temp_rotation_matrix;
}
