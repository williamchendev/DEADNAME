/// @function		string_lower_all(str);
/// @param			{string}	str
/// @description	Converts a string to all lowercase letters. Applies to English characters A-Z
///					only.
///
///					Like the built-in `string_lower` function, but nearly 2x faster!
///
/// @example		var mystring = "HELLO, WORLD!";
///
///					draw_text(25, 25, string_lower_all(mystring));
///
///					// Result: "hello, world!"
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function string_lower_all(_str) {
	// Get ordinal range
	var ord_start = ord("A");
	var ord_end = ord("Z");
	
	// Iterate through characters in string
	for (var c = 1; c <= string_length(_str); c++) {
		// Get ordinal value of current character
		var _char = string_ord_at(_str, c);
		
		// If character is uppercase...
		if (_char >= ord_start) and (_char <= ord_end) {
			// Convert to lowercase
			_char += 32;
			_str = string_set_byte_at(_str, c, _char);
		}
	}
	
	// Return lowercase string
	return _str;
}


/// @function		string_lower_first(str);
/// @param			{string}	str
/// @description	Returns a string with the first letter of the first word lowercase (can be
///					used for camelCase, for example). Only applies to English characters A-Z.
///
/// @example		var mystring = "HELLO, WORLD!";
///
///					draw_text(25, 25, string_lower_first(mystring));
///
///					// Result: "hELLO, WORLD!"
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function string_lower_first(_str) {
	// Get first character of string
	var _char = string_letters(string_char_at(_str, 1));
	
	// If character is A-Z...
	if (_char != "") {
		// If character is uppercase...
		_char = ord(_char);
		if (_char >= ord("A")) and (_char <= ord("Z")) {
			// Convert to lowercase
			_char += 32;
		}
		
		// Return uncapitalized string
		return (chr(_char) + string_delete(_str, 1, 1));
	} else {
		// Otherwise return original string if already uncapitalized
		return _str;
	}
}


/// @function		string_lower_words(str);
/// @param			{string}	str
/// @requires		string_explode, string_implode, string_lower_first
/// @description	Returns a string with the first letter of each word uncapitalized (can be
///					used for camelCase, for example). Only applies to English characters A-Z.
///
/// @example		var mystring = "HELLO, WORLD!";
///
///					draw_text(25, 25, string_lower_words(mystring));
///
///					// Result: "hELLO, wORLD!"
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function string_lower_words(_str) {
	// Get words as array
	var _words = string_explode(_str, " ");
	
	// Convert each word to letter case
	for (var w = 0; w < array_length(_words); w++) {
		_words[w] = string_lower_first(_words[w]);
	}
	
	// Return uncapitalized string
	return string_implode(_words, " ");
	
	#region Alternate method
	/*
	// Initialize parsing string
	var _word, _words = "",
		_pos = string_pos(" ", _str);
	
	// Split and uncapitalize words
	while (_pos > 0) {
		_word = string_copy(_str, 1, _pos);
		
		_words += string_lower_first(_word);
		
		_str = string_delete(_str, 1, _pos);
		_pos = string_pos(" ", _str);
	}
	
	// Return uncapitalized string
	return _words + string_lower_first(_str);
	*/
	#endregion
}