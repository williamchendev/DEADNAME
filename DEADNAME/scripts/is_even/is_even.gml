/// @function		is_even(n);
/// @param			{real}	n
/// @description	Returns true if a given number is even, and false if odd. Invalid inputs will
///					be returned as even.
///
/// @example		if (is_even(var_num)) {
///						show_message("I'm even!");
///					} else {
///						show_message("I'm odd!");
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function is_even(_num) {
	// If input is valid...
	if (is_real(_num)) {
		// Check and return value parity
		if ((_num mod 2) == 0) {
		    return true;
		} else {
		    return false;
		}
	} else {
		// Otherwise return even
		return true;
	}
}
