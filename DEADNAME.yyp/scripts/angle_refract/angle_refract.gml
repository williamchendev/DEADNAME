/// @function		angle_refract(deg, mirror, outer_index, inner_index);
/// @param			{real}	deg
/// @param			{real}	mirror
/// @param			{real}	out_index
/// @param			{real}	in_index
/// @requires		angle_reflect, approx, emod
/// @description	Refractions are *sided*, meaning the resulting refraction angle depends on which 
///					direction the input angle is coming from (relative to the orientation of the mirror 
///					"line"). Angles between 0-180 degrees are considered to be *inside* the refractive 
///					surface, whereas angles between 180-360 degrees are considered to be *outside*. A 
///					mirror angle of 0 degrees is considered horizontal. 
///
///					How much an angle refracts depends on the difference between the substance it is 
///					coming from and the substance it is going into. The refractivity of a substance is 
///					called the "refraction index". 
///
///					Indices are given for both the area *outside* and *inside* the mirror "line", where, 
///					for example, an index of 1.0 is a vacuum, 1.0003 is air, 1.333 is water, and 2.42 is 
///					diamond. Mathematically, refraction index typically ranges from 1.0-3.0, no less or 
///					greater.
///					
///					In addition to controlling the *amount* of refractivity, these indices also determ-
///					ine the refraction "critical angle", at which point internal refractions will become 
///					reflections instead. Higher index equals lower critical angle, refracting sharp 
///					angles only and merely reflecting the rest (which is responsible for that diamond 
///					glitter!).
///
/// @example		var angle_in = point_direction(mouse_x, mouse_y, mirror_x, mirror_y);
///					var angle_out = angle_refract(angle_in, mirror_rot, 1, 3);
///					var dist = point_distance(mouse_x, mouse_y, mirror_x, mirror_y);
///					
///					// Draw mirror
///					draw_line(
///						mirror_x - rot_dist_x(64, mirror_rot), mirror_y - rot_dist_y(64, mirror_rot),
///						mirror_x + rot_dist_x(64, mirror_rot), mirror_y + rot_dist_y(64, mirror_rot)
///					);
///
///					// Draw angle in
///					draw_arrow(mouse_x, mouse_y, mirror_x, mirror_y, 16);
///
///					// Draw angle out
///					draw_arrow(
///						mirror_x, mirror_y, 
///						mirror_x + rot_dist_x(dist, angle_out), mirror_y + rot_dist_y(dist, angle_out),
///						16
///					);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function angle_refract(_angle_in, _angle_mirror, _index_out, _index_in) {
	// Invert angles if outer index is greater than inner index
	if (_index_out > _index_in) {
		var _index_tmp = _index_in;
		_index_in = _index_out;
		_index_out = _index_tmp;
		_angle_mirror += 180;
	}
	
	// Get reflection angle (in case of critical angle)
	var _angle_reflect = angle_reflect(_angle_in, _angle_mirror);
	
	// Normalize input angles
	_angle_in = emod(_angle_in, 360);
	_angle_mirror = emod(_angle_mirror, 360);
	
	// Get refraction "critical angle" (at which point it becomes a reflection)
	var _angle_crit = darcsin(_index_out/_index_in);
	
	// Check if angle is in mirror with different conditions based on mirror rotation
	var is_angle_in_mirror = ((_angle_in > _angle_mirror) and (_angle_in < _angle_mirror + 180));
	if (_angle_mirror > 180) {
		is_angle_in_mirror = ((_angle_in < _angle_mirror - 180) or (_angle_in > _angle_mirror));
	}

	// If angle in is inside mirror...
	if (is_angle_in_mirror) {
		// Normalize angle to critical angle range
		_angle_in -= 90 + _angle_mirror;
		
		// Normalize angle to loop around 360 to 0
		if (_angle_in < -90) {
			_angle_in += 360;
		}
		
		// If angle is inside critical angle...
		if (approx(_angle_in, _angle_crit)) {
			// Return inverted refraction angle in degrees
			return darcsin((_index_in/_index_out)*dsin(_angle_in)) + 90 + _angle_mirror; // Or -270
		} else {
			// Otherwise if outside critical angle, return reflection in degrees
			return _angle_reflect;
		}
	} else {
		// Normalize angle to mirror rotation
		_angle_in -= -90 + _angle_mirror; // Or +270
		
		// If outside mirror, return refraction angle in degrees
		return darcsin((_index_out/_index_in)*dsin(_angle_in)) - 90 + _angle_mirror;
	}
}
