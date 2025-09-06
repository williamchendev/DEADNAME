/// @function unit_set_firearm_hand_animation();
/// @description Sets the path and path interpolation of a unit's hand animation relative to their firearm
/// @param {number} primary_hand_path_start_x Start Coordinate's X value of the unit's hand firearm animation (relative to their firearm)
/// @param {number} primary_hand_path_start_y Start Coordinate's Y value of the unit's hand firearm animation (relative to their firearm)
/// @param {number} primary_hand_path_end_x End Coordinate's X value of the unit's hand firearm animation (relative to their firearm)
/// @param {number} primary_hand_path_end_y End Coordinate's Y value of the unit's hand firearm animation (relative to their firearm)
/// @param {number} path_interpolation The interpolation value of the unit's hand between the two path coordinates
function unit_set_firearm_hand_animation(hand_path_start_x, hand_path_start_y, hand_path_end_x, hand_path_end_y, path_interpolation = undefined)
{
    firearm_weapon_hand_pivot_offset_ax = hand_path_start_x;
	firearm_weapon_hand_pivot_offset_ay = hand_path_start_y;
	firearm_weapon_hand_pivot_offset_bx = hand_path_end_x;
	firearm_weapon_hand_pivot_offset_by = hand_path_end_y;
	
	if (!is_undefined(path_interpolation))
	{
	    firearm_weapon_hand_pivot_transition_value = path_interpolation;
	}
}
