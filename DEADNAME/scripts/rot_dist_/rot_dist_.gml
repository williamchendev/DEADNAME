/// @function		rot_dist_x(dist, [deg]);
/// @param			{real}	dist
/// @param			{real}	[deg]
/// @requires		rot_prefetch
/// @desecription	Returns the X component of a point the given distance away rotated by the 
///					given angle in degrees. (Center point is assumed as 0.)
///					
///					Supplying a rotation is optional. As calculating the sine and cosine of 
///					angles is costly to performance, these values are stored in memory for use 
///					with further instances of angle functions based on the same rotation. If 
///					no rotation is supplied, the previous angle's sine and cosine will be used. 
///					This is highly useful for improving performance when calculating multiple 
///					points based on the same rotation.
///
/// @example		x = 128 + rot_dist_x(64, image_angle);
///					y = 128 + rot_dist_y(64);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function rot_dist_x() {
	// Calculate sine and cosine if angle is supplied
	if (argument_count > 1) {
	   rot_prefetch(argument[1]);
	}

	// Return rotated X component
	return (argument[0]*trig_cosine);
}


/// @function		rot_dist_y(dist, [deg]);
/// @param			{real}	dist
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
/// @example		x = 128 + rot_dist_x(64, image_angle);
///					y = 128 + rot_dist_y(64);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function rot_dist_y() {
	// Calculate sine and cosine if angle is supplied
	if (argument_count > 1) {
	   rot_prefetch(argument[1]);
	}

	// Return rotated Y component
	return (argument[0]*-trig_sine);
}
