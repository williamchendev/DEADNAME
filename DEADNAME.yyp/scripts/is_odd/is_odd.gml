/// @function		is_odd(n);
/// @param			{real}	n
/// @description	Returns true if a given number is odd, and false if even. Invalid inputs will
///					be returned as even.
///
/// @example		if (is_odd(var_num)) {
///						show_message("I'm odd!");
///					} else {
///						show_message("I'm even!");
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function is_odd(_num) {
	// If input is valid...
	if (is_real(_num)) {
		// Check and return value parity
		if ((_num mod 2) == 0) {
		    return false;
		} else {
		    return true;
		}
	} else {
		// Otherwise return even
		return false;
	}
}
