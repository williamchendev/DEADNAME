/// @function		string_upper_all(str);
/// @param			{string}	str
/// @description	Converts a string to all uppercase letters. Applies to English characters A-Z
///					only.
///
///					Like the built-in `string_upper` function, but nearly 2x faster!
///
/// @example		var mystring = "hello, world!";
///
///					draw_text(25, 25, string_upper_all(mystring));
///
///					// Result: "HELLO, WORLD!"
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function string_upper_all(_str) {
	// Get ordinal range
	var ord_start = ord("a");
	var ord_end = ord("z");
	
	// Iterate through characters in string
	for (var c = 1; c <= string_length(_str); c++) {
		// Get ordinal value of current character
		var _char = string_ord_at(_str, c);
		
		// If character is lowercase...
		if (_char >= ord_start) and (_char <= ord_end) {
			// Convert to uppercase
			_char -= 32;
			_str = string_set_byte_at(_str, c, _char);
		}
	}
	
	// Return uppercase string
	return _str;
}


/// @function		string_upper_first(str);
/// @param			{string}	str
/// @description	Returns a string with the first letter of the first word capitalized. Only
///					applies to English characters A-Z.
///
/// @example		var mystring = "hello, world!";
///
///					draw_text(25, 25, string_upper_first(mystring));
///
///					// Result: "Hello, world!"
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function string_upper_first(_str) {
	// Get first character of string
	var _char = string_letters(string_char_at(_str, 1));
	
	// If character is A-Z...
	if (_char != "") {
		// If character is lowercase...
		_char = ord(_char);
		if (_char >= ord("a")) and (_char <= ord("z")) {
			// Convert to uppercase
			_char -= 32;
		}
		
		// Return capitalized string
		return (chr(_char) + string_delete(_str, 1, 1));
	} else {
		// Otherwise return original string if already capitalized
		return _str;
	}
}


/// @function		string_upper_words(str);
/// @param			{string}	str
/// @requires		string_explode, string_implode, string_upper_first
/// @description	Returns a string with the first letter of each word capitalized. Only applies
///					to English characters A-Z.
///
/// @example		var mystring = "hello, world!";
///
///					draw_text(25, 25, string_upper_words(mystring));
///
///					// Result: "Hello, World!"
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function string_upper_words(_str) {
	// Get words as array
	var _words = string_explode(_str, " ");
	
	// Convert each word to capital case
	for (var w = 0; w < array_length(_words); w++) {
		_words[w] = string_upper_first(_words[w]);
	}
	
	// Return capitalized string
	return string_implode(_words, " ");
	
	#region Alternate method
	/*
	// Initialize parsing string
	var _word, _words = "",
		_pos = string_pos(" ", _str);
	
	// Split and capitalize words
	while (_pos > 0) {
		_word = string_copy(_str, 1, _pos);
		
		_words += string_upper_first(_word);
		
		_str = string_delete(_str, 1, _pos);
		_pos = string_pos(" ", _str);
	}
	
	// Return capitalized string
	return _words + string_upper_first(_str);
	*/
	#endregion
}