/// @function		string_trim(str, [filter]);
/// @param			{string}	str
/// @param			{string}	[filter]
/// @description	Removes spaces from either side of the string and returns the trimmed result.
///
///					If a filter is supplied, **any** character in the filter string will be trimmed
///					instead. (To also trim spaces, include a space in the filter string.)
///
/// @example		var notes = "  +[do, re, mi, fa, so, la, ti, do]    %   ";
///
///					notes = string_trim(notes, " []+%");
///
///					draw_text(x, y, notes);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function string_trim() {
	// Initialize arguments
	var _str = argument[0],
		_filter = " ";
	if (argument_count > 1) {
		_filter = argument[1];
	}
	
	// Trim left side
	var tstart = 1;
	while ((string_pos(string_char_at(_str, tstart), _filter) > 0) and (tstart < string_length(_str))) {
		tstart++;
	}
	
	// Trim right side
	var tend = string_length(_str);
	while ((string_pos(string_char_at(_str, tend), _filter) > 0) and (tend > 0)) {
		tend--;
	}
	
	// Return trimmed string
	return string_copy(_str, tstart, max(0, tend - tstart + 1));
}


/// @function		string_trim_left(str, [filter]);
/// @param			{string}	str
/// @param			{string}	[filter]
/// @description	Removes spaces from the left side of the string and returns the trimmed result.
///
///					If a filter is supplied, **any** character in the filter string will be trimmed
///					instead. (To also trim spaces, include a space in the filter string.)
///
/// @example		var notes = "  +[do, re, mi, fa, so, la, ti, do]    %   ";
///
///					notes = string_trim_left(notes, " [+");
///
///					draw_text(x, y, notes);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function string_trim_left() {
	// Initialize arguments
	var _str = argument[0],
		_filter = " ";
	if (argument_count > 1) {
		_filter = argument[1];
	}
	var tend = string_length(_str);
	
	// Trim left side
	var tstart = 1;
	while (string_pos(string_char_at(_str, tstart), _filter) > 0) {
		tstart++;
	}
	
	// Return trimmed string
	return string_copy(_str, tstart, tend - tstart + 1);
}


/// @function		string_trim_right(str, [filter]);
/// @param			{string}	str
/// @param			{string}	[filter]
/// @description	Removes spaces from the right side of the string and returns the trimmed result.
///
///					If a filter is supplied, **any** character in the filter string will be trimmed
///					instead. (To also trim spaces, include a space in the filter string.)
///
/// @example		var notes = "  +[do, re, mi, fa, so, la, ti, do]    %   ";
///
///					notes = string_trim_right(notes, " ]%");
///
///					draw_text(x, y, notes);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function string_trim_right() {
	// Initialize arguments
	var _str = argument[0],
		_filter = " ";
	if (argument_count > 1) {
		_filter = argument[1];
	}
	var tstart = 1;
	
	// Trim right side
	var tend = string_length(_str);
	while (string_pos(string_char_at(_str, tend), _filter) > 0) {
		tend--;
	}
	
	// Return trimmed string
	return string_copy(_str, tstart, tend - tstart + 1);
}