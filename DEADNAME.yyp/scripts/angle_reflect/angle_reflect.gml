/// @function		angle_reflect(deg, mirror);
/// @param			{real}	deg
/// @param			{real}	mirror
/// @description	Returns an angle in degrees reflected from a mirror "line" with the given
///					angle in degrees. A mirror angle of 0 degrees is considered horizontal.
///
/// @example		var angle_in = point_direction(mouse_x, mouse_y, mirror_x, mirror_y);
///					var angle_out = angle_reflect(angle_in, mirror_rot);
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

function angle_reflect(_angle_in, _angle_mirror) {
	// Return the mirrored angle
	return ((_angle_mirror*2) - _angle_in);
}
