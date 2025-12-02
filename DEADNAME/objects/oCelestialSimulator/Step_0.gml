/// @description Camera Movement Event
// Self-Creating Celestial Simulator Init Behaviour Event

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

//
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

// Build Camera Rotation Matrix from Camera's Euler Angle Rotation
camera_rotation_matrix = rotation_matrix_from_euler_angles(camera_rotation_x mod 360, camera_rotation_y mod 360, camera_rotation_z mod 360);