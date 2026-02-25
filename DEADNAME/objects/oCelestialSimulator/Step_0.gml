/// @description Camera Movement Event
// Self-Creating Celestial Simulator Init Behaviour Event

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Increment Celestial Simulator's Global Clocks
global_noise_time += global_noise_time_spd * frame_delta;
global_noise_time = global_noise_time mod 1;

global_hydrosphere_time += global_hydrosphere_time_spd * frame_delta;
global_hydrosphere_time = global_hydrosphere_time mod 9999999; // please don't overflow

/*
var temp_camera_move_spd = 2;

if (keyboard_check(ord("A")))
{
	camera_position_x -= temp_camera_move_spd * frame_delta;
}
else if (keyboard_check(ord("D")))
{
	camera_position_x += temp_camera_move_spd * frame_delta;
}

if (keyboard_check(ord("W")))
{
	camera_position_z += temp_camera_move_spd * frame_delta;
}
else if (keyboard_check(ord("S")))
{
	camera_position_z -= temp_camera_move_spd * frame_delta;
}

if (keyboard_check(vk_space))
{
	camera_position_y += temp_camera_move_spd * frame_delta;
}
else if (keyboard_check(vk_lcontrol))
{
	camera_position_y -= temp_camera_move_spd * frame_delta;
}

//
var temp_camera_rotate_spd = 2;

if (keyboard_check(ord("Q")))
{
	camera_rotation_y -= temp_camera_rotate_spd * frame_delta;
}
else if (keyboard_check(ord("E")))
{
	camera_rotation_y += temp_camera_rotate_spd * frame_delta;
}

if (keyboard_check(ord("R")))
{
	camera_rotation_z -= temp_camera_rotate_spd * frame_delta;
}
else if (keyboard_check(ord("F")))
{
	camera_rotation_z += temp_camera_rotate_spd * frame_delta;
}

if (keyboard_check(ord("T")))
{
	camera_rotation_x -= temp_camera_rotate_spd * frame_delta;
}
else if (keyboard_check(ord("Y")))
{
	camera_rotation_x += temp_camera_rotate_spd * frame_delta;
}
*/

// Solar System's Camera Observation Behaviour
if (instance_exists(camera_observing_instance))
{
	//
	var temp_camera_move_spd = 2;
	
	if (keyboard_check(ord("A")))
	{
		camera_observing_direction_horizontal_angle -= temp_camera_move_spd * frame_delta;
	}
	else if (keyboard_check(ord("D")))
	{
		camera_observing_direction_horizontal_angle += temp_camera_move_spd * frame_delta;
	}
	
	if (keyboard_check(ord("W")))
	{
		camera_observing_direction_vertical_angle += temp_camera_move_spd * frame_delta;
	}
	else if (keyboard_check(ord("S")))
	{
		camera_observing_direction_vertical_angle -= temp_camera_move_spd * frame_delta;
	}
	
	//
	var temp_camera_observing_vector_length = 0;
	
	//
	switch (camera_observing_instance.celestial_object_type)
	{
		case CelestialObjectType.Sun:
		case CelestialObjectType.Planet:
			temp_camera_observing_vector_length = camera_observing_instance.radius + camera_observing_instance.elevation + 5;
			break;
		default:
			break;
	}
	
	// Apply Horizontal Wrap and Vertical Clamp to Camera Observing Polar Direction Angles
	camera_observing_direction_horizontal_angle = ((camera_observing_direction_horizontal_angle mod 360) + 360) mod 360;
	camera_observing_direction_vertical_angle = clamp(camera_observing_direction_vertical_angle, -89.5, 89.5);
	
	// Calculate Camera Observation Vector from Camera Observing Polar Direction Angles
	var temp_observing_vector_x = dcos(camera_observing_direction_vertical_angle) * dcos(camera_observing_direction_horizontal_angle);
	var temp_observing_vector_y = dsin(camera_observing_direction_vertical_angle);
	var temp_observing_vector_z = dcos(camera_observing_direction_vertical_angle) * dsin(camera_observing_direction_horizontal_angle);
	
	// Calculate Camera Observing Instance's Rotation Matrices
	var temp_observing_rotation_matrix = rotation_matrix_from_euler_angles(camera_observing_instance.euler_angle_x, camera_observing_instance.euler_angle_y, camera_observing_instance.euler_angle_z);
	
	var temp_observing_inst_rotation_matrix = rotation_matrix_from_euler_angles(-camera_observing_instance.euler_angle_x, camera_observing_instance.euler_angle_y, -camera_observing_instance.euler_angle_z);
	var temp_observing_inst_inverse_rotation_matrix = matrix_inverse(temp_observing_inst_rotation_matrix);
	
	// Rotate Camera Observation Vector by the Camera Observing Instance's Rotation Matrices
	var temp_observing_rotated_vector_x = temp_observing_vector_x * temp_observing_inst_inverse_rotation_matrix[0] + temp_observing_vector_y * temp_observing_inst_inverse_rotation_matrix[1] + temp_observing_vector_z * temp_observing_inst_inverse_rotation_matrix[2];
	var temp_observing_rotated_vector_y = temp_observing_vector_x * temp_observing_inst_inverse_rotation_matrix[4] + temp_observing_vector_y * temp_observing_inst_inverse_rotation_matrix[5] + temp_observing_vector_z * temp_observing_inst_inverse_rotation_matrix[6];
	var temp_observing_rotated_vector_z = temp_observing_vector_x * temp_observing_inst_inverse_rotation_matrix[8] + temp_observing_vector_y * temp_observing_inst_inverse_rotation_matrix[9] + temp_observing_vector_z * temp_observing_inst_inverse_rotation_matrix[10];
	
	// Set Camera Position relative to Camera's Observing Instance
	camera_position_x = camera_observing_instance.x + temp_observing_rotated_vector_x * temp_camera_observing_vector_length;
	camera_position_y = camera_observing_instance.y + temp_observing_rotated_vector_y * temp_camera_observing_vector_length;
	camera_position_z = camera_observing_instance.z + temp_observing_rotated_vector_z * temp_camera_observing_vector_length;
	
	// Build Camera Rotation Matrix from Observation Direction and Up Direction relative to the Camera Observing Instance as that the Camera is vertically aligned with the Camera Observing Instance's Poles and will horizontally wrap around the Camera Observing Instance
	camera_rotation_matrix = matrix_inverse(matrix_build_lookat(0, 0, 0, -temp_observing_rotated_vector_x, temp_observing_rotated_vector_y, -temp_observing_rotated_vector_z, temp_observing_rotation_matrix[4], temp_observing_rotation_matrix[5], temp_observing_rotation_matrix[6]));
}
else
{
	//
	camera_observing_instance = noone;
	camera_observing_direction_horizontal_angle = 0;
	camera_observing_direction_vertical_angle = 0;
	
	// Build Camera Rotation Matrix from Camera's Euler Angle Rotation
	camera_rotation_matrix = rotation_matrix_from_euler_angles(camera_rotation_x mod 360, camera_rotation_y mod 360, camera_rotation_z mod 360);
}

// Establish Camera Vectors from Camera's Rotation Matrix
var temp_camera_right_vector_magnitude = sqrt(dot_product_3d(camera_rotation_matrix[0], camera_rotation_matrix[1], camera_rotation_matrix[2], camera_rotation_matrix[0], camera_rotation_matrix[1], camera_rotation_matrix[2]));
var temp_camera_right_vector_normalized = [ camera_rotation_matrix[0] / temp_camera_right_vector_magnitude, camera_rotation_matrix[1] / temp_camera_right_vector_magnitude, camera_rotation_matrix[2] / temp_camera_right_vector_magnitude ];

var temp_camera_up_vector_magnitude = sqrt(dot_product_3d(camera_rotation_matrix[4], camera_rotation_matrix[5], camera_rotation_matrix[6], camera_rotation_matrix[4], camera_rotation_matrix[5], camera_rotation_matrix[6]));
var temp_camera_up_vector_normalized = [ camera_rotation_matrix[4] / temp_camera_up_vector_magnitude, camera_rotation_matrix[5] / temp_camera_up_vector_magnitude, camera_rotation_matrix[6] / temp_camera_up_vector_magnitude ];

var temp_camera_forward_vector_magnitude = sqrt(dot_product_3d(camera_rotation_matrix[8], camera_rotation_matrix[9], camera_rotation_matrix[10], camera_rotation_matrix[8], camera_rotation_matrix[9], camera_rotation_matrix[10]));
var temp_camera_forward_vector_normalized = [ camera_rotation_matrix[8] / temp_camera_forward_vector_magnitude, camera_rotation_matrix[9] / temp_camera_forward_vector_magnitude, camera_rotation_matrix[10] / temp_camera_forward_vector_magnitude ];

// Set
camera_right_vector = temp_camera_right_vector_normalized;
camera_up_vector = temp_camera_up_vector_normalized;
camera_forward_vector = temp_camera_forward_vector_normalized;