/// @description Camera Movement Event
// Self-Creating Celestial Simulator Init Behaviour Event

// Increment Celestial Simulator's Global Clocks
global_noise_time += global_noise_time_spd * frame_delta;
global_noise_time = global_noise_time mod 1;

global_hydrosphere_time += global_hydrosphere_time_spd * frame_delta;
global_hydrosphere_time = global_hydrosphere_time mod 9999999; // please don't overflow

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Check if Solar System exists and is being viewed
if (solar_system_index == -1)
{
	// Not currently viewing a Solar System - Early Return
	return;
}

// Establish Solar System from Solar Systems Array
var temp_solar_system = solar_systems[solar_system_index];

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
	var temp_camera_observing_instance_radius = 0;
	var temp_camera_observing_vector_length_offset = 600;
	
	//
	switch (camera_observing_instance.celestial_object_type)
	{
		case CelestialObjectType.Sun:
			temp_camera_observing_instance_radius = camera_observing_instance.radius;
		case CelestialObjectType.Planet:
			temp_camera_observing_instance_radius = camera_observing_instance.radius + camera_observing_instance.elevation * camera_observing_instance.ocean_elevation;
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
	
	//var temp_observing_inst_rotation_matrix = rotation_matrix_from_euler_angles(-camera_observing_instance.euler_angle_x, camera_observing_instance.euler_angle_y, -camera_observing_instance.euler_angle_z);
	//var temp_observing_inst_inverse_rotation_matrix = matrix_inverse(temp_observing_inst_rotation_matrix);
	
	// Rotate Camera Observation Vector by the Camera Observing Instance's Rotation Matrices
	var temp_observing_rotated_vector_x = temp_observing_vector_x * temp_observing_rotation_matrix[0] + temp_observing_vector_y * temp_observing_rotation_matrix[4] + temp_observing_vector_z * temp_observing_rotation_matrix[8];
	var temp_observing_rotated_vector_y = temp_observing_vector_x * temp_observing_rotation_matrix[1] + temp_observing_vector_y * temp_observing_rotation_matrix[5] + temp_observing_vector_z * temp_observing_rotation_matrix[9];
	var temp_observing_rotated_vector_z = temp_observing_vector_x * temp_observing_rotation_matrix[2] + temp_observing_vector_y * temp_observing_rotation_matrix[6] + temp_observing_vector_z * temp_observing_rotation_matrix[10];
	
	// Set Camera Position relative to Camera's Observing Instance
	camera_position_x = camera_observing_instance.x + temp_observing_rotated_vector_x * (temp_camera_observing_instance_radius + temp_camera_observing_vector_length_offset);
	camera_position_y = camera_observing_instance.y + temp_observing_rotated_vector_y * (temp_camera_observing_instance_radius + temp_camera_observing_vector_length_offset);
	camera_position_z = camera_observing_instance.z + temp_observing_rotated_vector_z * (temp_camera_observing_instance_radius + temp_camera_observing_vector_length_offset);
	
	// Build Camera Rotation Matrix from Observation Direction and Up Direction relative to the Camera Observing Instance as that the Camera is vertically aligned with the Camera Observing Instance's Poles and will horizontally wrap around the Camera Observing Instance
	camera_view_matrix = matrix_build_lookat(camera_position_x, camera_position_y, camera_position_z, camera_observing_instance.x, camera_observing_instance.y, camera_observing_instance.z, temp_observing_rotation_matrix[4], temp_observing_rotation_matrix[5], temp_observing_rotation_matrix[6]);
	//camera_view_matrix = matrix_inverse(matrix_build_lookat(0, 0, 0, -temp_observing_rotated_vector_x, temp_observing_rotated_vector_y, -temp_observing_rotated_vector_z, temp_observing_rotation_matrix[4], temp_observing_rotation_matrix[5], temp_observing_rotation_matrix[6]));
}
else
{
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
	
	// Reset Camera Observation Settings
	camera_observing_instance = noone;
	camera_observing_direction_horizontal_angle = 0;
	camera_observing_direction_vertical_angle = 0;
	
	//
	
	
	// Build Camera Rotation Matrix from Camera's Euler Angle Rotation
	//camera_view_matrix = matrix_build_lookat(camera_position_x, camera_position_y, camera_position_z, camera_position_x + 64 * dcos(camera_rotation_x), camera_position_y + 64 * dcos(camera_rotation_y), camera_position_z + 64 * dsin(camera_rotation_z), 0, 1, 0);
	
	//
	look_dir -= (window_mouse_get_x() - window_get_width() / 2) / 10;
    look_pitch -= (window_mouse_get_y() - window_get_height() / 2) / 10;
    look_pitch = clamp(look_pitch, 10, 80);

    window_mouse_set(window_get_width() / 2, window_get_height() / 2);
	
	var camera_distance = 160;
	var xto = camera_position_x;
	var yto = camera_position_y;
	var zto = camera_position_z;
	var xfrom = xto - camera_distance * dsin(look_dir);
	var yfrom = yto + camera_distance * dsin(look_pitch);
	var zfrom = zto + camera_distance * dcos(look_dir);
	
	camera_view_matrix = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 1, 0);
}

if (keyboard_check(vk_escape))
{
	game_end();
}

// Create Perspective Camera Projection Matrix
camera_projection_matrix = matrix_build_projection_perspective_fov(-camera_fov, -GameManager.game_width / GameManager.game_height, camera_z_near, camera_z_far);
//camera_set_proj_mat(camera_get_default(), camera_projection_matrix); // THIS WORKS!!!

/*

// Calculate Inverse of Camera's Projection Matrix
var temp_inverse_projection_matrix = matrix_inverse(camera_projection_matrix);

//
//var temp_camera_view_matrix_euler_angles = euler_angles_from_rotation_matrix(camera_view_matrix)
//var temp_camera_raycast_rotation_matrix = matrix_inverse(rotation_matrix_from_euler_angles(-temp_camera_view_matrix_euler_angles[0], temp_camera_view_matrix_euler_angles[1], -temp_camera_view_matrix_euler_angles[2])); // THIS WORKS
//var temp_camera_raycast_rotation_matrix = matrix_inverse(rotation_matrix_from_euler_angles(-temp_camera_view_matrix_euler_angles[0], temp_camera_view_matrix_euler_angles[1], -temp_camera_view_matrix_euler_angles[2]));
var temp_camera_raycast_rotation_matrix = matrix_inverse(camera_view_matrix);
//var temp_camera_raycast_rotation_matrix = matrix_inverse(matrix_build_lookat(0, 0, 0, temp_observing_rotated_vector_x, -temp_observing_rotated_vector_y, temp_observing_rotated_vector_z, -temp_observing_rotation_matrix[4], -temp_observing_rotation_matrix[5], -temp_observing_rotation_matrix[6]));

// Calculate Horizontal & Vertical Normalized Device Coordinates of Cursor
var temp_camera_cursor_ndc_x = (GameManager.cursor_x / GameManager.game_width) * 2 - 1;
var temp_camera_cursor_ndc_y = (GameManager.cursor_y / GameManager.game_height) * 2 - 1;
var temp_camera_cursor_ndc_z = -1;
var temp_camera_cursor_ndc_w = 1;

// Create Cursor's Clip Space Position from the inverse of the Camera's Projection Matrix & Cursor's Normalized Device Coordinates
var temp_camera_cursor_clip_space_x = temp_camera_cursor_ndc_x * temp_inverse_projection_matrix[0] + temp_camera_cursor_ndc_y * temp_inverse_projection_matrix[1] + temp_camera_cursor_ndc_z * temp_inverse_projection_matrix[2] + temp_camera_cursor_ndc_w * temp_inverse_projection_matrix[3];
var temp_camera_cursor_clip_space_y = temp_camera_cursor_ndc_x * temp_inverse_projection_matrix[4] + temp_camera_cursor_ndc_y * temp_inverse_projection_matrix[5] + temp_camera_cursor_ndc_z * temp_inverse_projection_matrix[6] + temp_camera_cursor_ndc_w * temp_inverse_projection_matrix[7];

// Calculate Camera Cursor View Raycast Vector
var temp_camera_cursor_raycast_view_x = temp_camera_cursor_clip_space_x;
var temp_camera_cursor_raycast_view_y = temp_camera_cursor_clip_space_y;
var temp_camera_cursor_raycast_view_z = 1;

// Rotate Camera's Cursor View Raycast Vector around Camera's Rotation Matrix to create Camera's Cursor Raycast World Vector
var temp_camera_cursor_raycast_vector_x = temp_camera_cursor_raycast_view_x * temp_camera_raycast_rotation_matrix[0] + temp_camera_cursor_raycast_view_y * temp_camera_raycast_rotation_matrix[1] + temp_camera_cursor_raycast_view_z * temp_camera_raycast_rotation_matrix[2];
var temp_camera_cursor_raycast_vector_y = temp_camera_cursor_raycast_view_x * temp_camera_raycast_rotation_matrix[4] + temp_camera_cursor_raycast_view_y * temp_camera_raycast_rotation_matrix[5] + temp_camera_cursor_raycast_view_z * temp_camera_raycast_rotation_matrix[6];
var temp_camera_cursor_raycast_vector_z = temp_camera_cursor_raycast_view_x * temp_camera_raycast_rotation_matrix[8] + temp_camera_cursor_raycast_view_y * temp_camera_raycast_rotation_matrix[9] + temp_camera_cursor_raycast_view_z * temp_camera_raycast_rotation_matrix[10];

// 
var temp_camera_cursor_raycast_vector_magnitude = sqrt(dot_product_3d(temp_camera_cursor_raycast_vector_x, temp_camera_cursor_raycast_vector_y, temp_camera_cursor_raycast_vector_z, temp_camera_cursor_raycast_vector_x, temp_camera_cursor_raycast_vector_y, temp_camera_cursor_raycast_vector_z));

//
temp_camera_cursor_raycast_vector_x /= temp_camera_cursor_raycast_vector_magnitude;
temp_camera_cursor_raycast_vector_y /= temp_camera_cursor_raycast_vector_magnitude;
temp_camera_cursor_raycast_vector_z /= temp_camera_cursor_raycast_vector_magnitude;

//
var temp_click_behaviour = mouse_check_button(mb_left);
var temp_action_behaviour = mouse_check_button(mb_right);

//
if (temp_click_behaviour or temp_action_behaviour)
{
	//
	var temp_selection_inst = noone;
	var temp_selection_position = undefined;
	
	// Iterate through Solar System's Celestial Objects to check Cursor Raycast Selection
	var temp_celestial_object_index = 0;
	
	repeat (array_length(temp_solar_system))
	{
		// Find Celestial Object Instance within Solar System at Index
		var temp_celestial_object_instance = temp_solar_system[temp_celestial_object_index];
		
		//
		var temp_celestial_object_radius = 0;
		var temp_celestial_object_select = false;
		
		// Celestial Object Type Cursor Raycast Behaviour
		switch (temp_celestial_object_instance.celestial_object_type)
		{
			case CelestialObjectType.Planet:
				// Spherical Object Selection
				temp_celestial_object_radius = temp_celestial_object_instance.radius + temp_celestial_object_instance.elevation * temp_celestial_object_instance.ocean_elevation;
				temp_celestial_object_select = true;
				break;
			default:
				// Skip Celestial Object Cursor Raycast Behaviour
				break;
		}
		
		//
		if (!temp_celestial_object_select)
		{
			// Increment Celestial Object Index
			temp_celestial_object_index++;
			continue;
		}
		
		// 
		var temp_planet_raycast = raycast_sphere
		(
			camera_position_x, 
			camera_position_y, 
			camera_position_z, 
			temp_camera_cursor_raycast_vector_x, 
			temp_camera_cursor_raycast_vector_y, 
			temp_camera_cursor_raycast_vector_z, 
			temp_celestial_object_instance.x, 
			temp_celestial_object_instance.y, 
			temp_celestial_object_instance.z, 
			temp_celestial_object_instance.radius
		);
		
		//
		if (!is_undefined(temp_planet_raycast))
		{
			//
			if (is_undefined(temp_selection_position) or temp_planet_raycast[3] < temp_selection_position[3])
			{
				//
				temp_selection_inst = temp_celestial_object_instance;
				temp_selection_position = temp_planet_raycast;
			}
		}
		
		// Increment Celestial Object Index
		temp_celestial_object_index++;
	}
	
	//
	if (!is_undefined(temp_selection_position))
	{
		CelestialSimulator.sun_thing.x = temp_selection_position[0];
		CelestialSimulator.sun_thing.y = temp_selection_position[1];
		CelestialSimulator.sun_thing.z = temp_selection_position[2];
	}
	show_debug_message(is_undefined(temp_selection_position) ? "undefined" : $"celestial_id:{temp_selection_inst.celestial_id} {temp_selection_position}");
	show_debug_message($"[{temp_camera_cursor_raycast_vector_x}, {temp_camera_cursor_raycast_vector_y}, {temp_camera_cursor_raycast_vector_z}]");
}
*/