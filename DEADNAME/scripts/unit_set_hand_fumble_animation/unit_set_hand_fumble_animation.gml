/// @function unit_set_hand_fumble_animation();
/// @description Sets the duration for the unit's hand fumble animation and resets the animation properties
/// @param {number} hand_fumble_animation_duration Duration for the fumble animation measured in 1/60ths of a second (frametime)
function unit_set_hand_fumble_animation(hand_fumble_animation_duration)
{
    hand_fumble_animation_timer = hand_fumble_animation_duration;
					
	hand_fumble_animation_transition_value = 0;
	hand_fumble_animation_cycle_timer = 0;
	hand_fumble_animation_offset_ax = 0;
	hand_fumble_animation_offset_ay = 0;
	
	hand_fumble_animation_offset_x = 0;
	hand_fumble_animation_offset_y = 0;
}