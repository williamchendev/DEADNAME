/// @function		round_to(value, multiple);
/// @param			{real}	value
/// @param			{real}	multiple
/// @requires		is_even
/// @description	Rounds to a multiple of the specified number (rather than to the nearest whole)
///					and returns the result. Unlike normal rounding, rounding to fractional values 
///					is supported.
///
///					Note that this script uses "banker's rounding", meaning if a value is exactly
///					half the multiplier, it will round to the nearest **even** number.
///
///					Also note that the multiplier should **always** be positive. The value to round 
///					can be either positive or negative.
///
/// @example		score = round_to(score, 10);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function round_to(_num, _multi) {
	// Temporarily treat all input values as positive
	var val = abs(_num);

	// Get the difference between the value and the multiple
	var val_diff = (val mod _multi);

	// Get cutoff point for rounding to multiplier
	var val_multi = (_multi*0.5);

	// Round down to nearest multiplier
	if (val_diff < val_multi) {
		return (val - val_diff)*sign(_num);
	}

	// Round to nearest even multiplier
	if (val_diff == val_multi) {
		if (is_even(val - val_diff)) {
			// Round down, if even
			return (val - val_diff)*sign(_num);
		} else {
			// Otherwise, round up to even
			return (val + (_multi - val_diff))*sign(_num);
		}
	}

	// Round up to nearest multiplier
	if (val_diff > val_multi) {
		return (val + (_multi - val_diff))*sign(_num);
	}
}
