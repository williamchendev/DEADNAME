/// @function unit_set_firearm_primary_hand_animation();
/// @description Sets the path and path interpolation of a unit's primary hand animation relative to their firearm
/// @param {number} primary_hand_path_start_x Start Coordinate's X value of the unit's primary hand firearm animation (relative to their firearm)
/// @param {number} primary_hand_path_start_y Start Coordinate's Y value of the unit's primary hand firearm animation (relative to their firearm)
/// @param {number} primary_hand_path_end_x End Coordinate's X value of the unit's primary hand firearm animation (relative to their firearm)
/// @param {number} primary_hand_path_end_y End Coordinate's Y value of the unit's primary hand firearm animation (relative to their firearm)
/// @param {number} path_interpolation The interpolation value of the unit's primary hand between the two path coordinates
function unit_set_firearm_primary_hand_animation(primary_hand_path_start_x, primary_hand_path_start_y, primary_hand_path_end_x, primary_hand_path_end_y, path_interpolation = undefined)
{
    firearm_weapon_primary_hand_pivot_offset_ax = primary_hand_path_start_x;
	firearm_weapon_primary_hand_pivot_offset_ay = primary_hand_path_start_y;
	firearm_weapon_primary_hand_pivot_offset_bx = primary_hand_path_end_x;
	firearm_weapon_primary_hand_pivot_offset_by = primary_hand_path_end_y;
	
	if (!is_undefined(path_interpolation))
	{
	    firearm_weapon_primary_hand_pivot_transition_value = path_interpolation;
	}
}