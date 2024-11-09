/// @function		rot_vec_x(x1, y1, x2, y2, [deg]);
/// @param			{real}	x1
/// @param			{real}	y1
/// @param			{real}	x2
/// @param			{real}	y2
/// @param			{real}	[deg]
/// @requires		rot_prefetch
/// @description	Returns the X component of a point the given distance away from the given
///					center point and rotated by the given angle in degrees (or in other words,
///					the X component of the tip of a rotated line).
///					
///					Supplying a rotation is optional. As calculating the sine and cosine of 
///					angles is costly to performance, these values are stored in memory for use 
///					with further instances of angle functions based on the same rotation. If 
///					no rotation is supplied, the previous angle's sine and cosine will be used. 
///					This is highly useful for improving performance when calculating multiple 
///					points based on the same rotation.
///
/// @example		x = rot_vec_x(128, 128, 64, 64, image_angle);
///					y = rot_vec_y(128, 128, 64, 64);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function rot_vec_x() {
	// Calculate sine and cosine if angle is supplied
	if (argument_count > 4) {
	   rot_prefetch(argument[4]);
	}

	// Return rotated X component
	return argument[0] + (argument[2]*trig_cosine) + (argument[3]*trig_sine);

	// Null Y argument
	argument[1] = 0;
}


/// @function		rot_vec_y(x1, y1, x2, y2, [deg]);
/// @param			{real}	x1
/// @param			{real}	y1
/// @param			{real}	x2
/// @param			{real}	y2
/// @param			{real}	[deg]
/// @requires		rot_prefetch
/// @description	Returns the Y component of a point the given distance away from the given
///					center point and rotated by the given angle in degrees (or in other words,
///					the Y component of the tip of a rotated line).
///					
///					Supplying a rotation is optional. As calculating the sine and cosine of 
///					angles is costly to performance, these values are stored in memory for use 
///					with further instances of angle functions based on the same rotation. If 
///					no rotation is supplied, the previous angle's sine and cosine will be used. 
///					This is highly useful for improving performance when calculating multiple 
///					points based on the same rotation.
///
/// @example		x = rot_vec_x(128, 128, 64, 64, image_angle);
///					y = rot_vec_y(128, 128, 64, 64);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function rot_vec_y() {
	// Calculate sine and cosine if angle is supplied
	if (argument_count > 4) {
	   rot_prefetch(argument[4]);
	}

	// Return rotated Y component
	return argument[1] + (argument[2]*-trig_sine) + (argument[3]*trig_cosine);

	// Null X argument
	argument[0] = 0;
}
