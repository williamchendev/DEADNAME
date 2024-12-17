/// @function		approx(value, min, [max]);
/// @param			{real}	value
/// @param			{real}	min
/// @param			{real}	max
/// @description	Checks if a value is between two numbers and returns `true` or `false`.
///
///					By default, the input value will be tested plus or minus the min value, but an
///					explicit max value can also be supplied to set the exact range.
///
/// @example		if (approx(enemy.x - x, 128)) {
///						//Enemy is near player on left or right
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function approx() {
	// Get original input value
	var _val = argument[0];
	
	// Get min/max values to test, if input
	if (argument_count > 2) {
		var _min = argument[1];
		var _max = argument[2];
	} else {
		// Otherwise use defaults
		var _max = abs(argument[1]);
		var _min = -_max;
	}

	// Check if value is inside range
	if ((_val >= _min) and (_val <= _max)) {
		return true;
	}

	// Otherwise return false
	return false;
}
