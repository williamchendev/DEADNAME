/// @function		string_explode(str, delim, [limit]);
/// @param			{string}	str
/// @param			{string}	delim
/// @param			{integer}	[limit]
/// @requires		string_trim
/// @description	Splits a string into a 1D array, using a delimeter character (or substring) to
///					separate contents. The delimeter will not be included in the resulting strings.
///					
///					If a limit value is supplied, only that number of delimeter matches will be made,
///					and the final value in the array will contain the remainder of the unsplit string.
///					To exclude the remainder from the array, input the limit value as negative.
///
///					Note that the resulting strings will automatically be trimmed, meaning you do
///					not need to include spaces in the delimeter string (unless space itself is the
///					delimeter). Spaces will automatically be removed.
///
/// @example		var notes = "do | re | mi | fa | so | la | ti | do";
///
///					notes = string_explode(notes, "|");
///
///					draw_text(x, y, notes[0]);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function string_explode() {
	// Initialize arguments
	var _ar = array_create(1),
		_str = argument[0],
		_delim = argument[1],
		_limit = string_count(_delim, _str),
		_include = true;
	if (argument_count > 2) {
		_include = !((argument[2] < 0) and (abs(argument[2]) <= _limit));
		_limit = clamp(abs(argument[2]), 1, _limit);
	}
	
	// Return array if delimeter doesn't exist in string
	if (string_count(_delim, _str) == 0) {
		_ar[0] = _str;
		return _ar;
	}
	
	// Get first string value as array
	var pos_current = 1,
		pos_next = string_pos(_delim, _str);
	_ar[0] = string_trim(string_copy(_str, pos_current, pos_next - pos_current));
		
	// Split additional string values into array
	for (var d = 1; d < _limit; d++) {
		// Update string parse position
		pos_current = pos_next + 1;
		pos_next = string_pos_ext(_delim, _str, pos_current);
		
		// Split string
		_ar[d] = string_trim(string_copy(_str, pos_current, pos_next - pos_current));
	}
	
	// Include remainder, if enabled
	if (_include == true) {
		// Update string parse position
		pos_current = pos_next + 1;
		pos_next = string_length(_str) + 1;
		
		// Split string
		_ar[array_length(_ar)] = string_trim(string_copy(_str, pos_current, pos_next - pos_current));
	}
	
	// Return string array
	return _ar;
}