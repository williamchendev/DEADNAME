/// @function		rot_point_x(x, y, [deg]);
/// @param			{real}	x
/// @param			{real}	y
/// @param			{real}	[deg]
/// @requires		rot_prefetch
/// @description	Returns the X component of a point the given distance away rotated by the 
///					given angle in degrees. (Center point is assumed as 0.)
///					
///					Supplying a rotation is optional. As calculating the sine and cosine of 
///					angles is costly to performance, these values are stored in memory for use 
///					with further instances of angle functions based on the same rotation. If 
///					no rotation is supplied, the previous angle's sine and cosine will be used. 
///					This is highly useful for improving performance when calculating multiple 
///					points based on the same rotation.
///
/// @example		x = 128 + rot_point_x(64, 64, image_angle);
///					y = 128 + rot_point_y(64, 64);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function rot_point_x() {
	// Calculate sine and cosine if angle is supplied
	if (argument_count > 2) {
	   rot_prefetch(argument[2]);
	}

	// Return rotated X component
	return (argument[0]*trig_cosine) + (argument[1]*trig_sine);
}


/// @function		rot_point_y(x, y, [deg]);
/// @param			{real}	x
/// @param			{real}	y
/// @param			{real}	[deg]
/// @requires		rot_prefetch
/// @description	Returns the Y component of a point the given distance away rotated by the 
///					given angle in degrees. (Center point is assumed as 0.)
///					
///					Supplying a rotation is optional. As calculating the sine and cosine of 
///					angles is costly to performance, these values are stored in memory for use 
///					with further instances of angle functions based on the same rotation. If 
///					no rotation is supplied, the previous angle's sine and cosine will be used. 
///					This is highly useful for improving performance when calculating multiple 
///					points based on the same rotation.
///
/// @example		x = 128 + rot_point_x(64, 64, image_angle);
///					y = 128 + rot_point_y(64, 64);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function rot_point_y() {
	// Calculate sine and cosine if angle is supplied
	if (argument_count > 2) {
	   rot_prefetch(argument[2]);
	}

	// Return rotated Y component
	return (argument[0]*-trig_sine) + (argument[1]*trig_cosine);
}
