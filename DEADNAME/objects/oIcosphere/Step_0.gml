/// @description DEBUG MOVEMENT

if (keyboard_check(ord("A")))
{
	euler_angle_y -= eu_h_spd * frame_delta;
}
else if (keyboard_check(ord("D")))
{
	euler_angle_y += eu_h_spd * frame_delta;
}

if (keyboard_check(ord("W")))
{
	euler_angle_z += eu_v_spd * frame_delta;
}
else if (keyboard_check(ord("S")))
{
	euler_angle_z -= eu_v_spd * frame_delta;
}