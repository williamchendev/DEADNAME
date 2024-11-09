/// @description SELF-CREATING OBJECT
//  SELF-CREATING GML+ MANAGER OBJECT

/*
MOUSE CURSOR STATE
*/

#region Update cursor state for next Step

// System cursor
if (window_get_cursor() != cr_none) {
	gmlp.mouse.cursor.wprevious = window_get_cursor();
	
	//Hide sprite cursor
	if (gmlp.mouse.cursor.sprevious != -1) {
		cursor_sprite = -1;
		gmlp.mouse.cursor.sprevious = -1;
	}
}

// Sprite cursor
if (cursor_sprite != -1) {
	gmlp.mouse.cursor.sprevious = cursor_sprite;
	
	//Hide system cursor
	if (gmlp.mouse.cursor.wprevious != cr_none) {
		window_set_cursor(cr_none);
		gmlp.mouse.cursor.wprevious = cr_none;
	}
}
#endregion

#region Update cursor visibility

// Show mouse when visible
if (gmlp.mouse.visible) {
	// System cursor
	if (window_get_cursor() == cr_none) {
		if (gmlp.mouse.cursor.wprevious != cr_none) {
			window_set_cursor(gmlp.mouse.cursor.wprevious);
		}
	}
		
	// Sprite cursor
	if (cursor_sprite == -1) {
		if (gmlp.mouse.cursor.sprevious != -1) {
			cursor_sprite = gmlp.mouse.cursor.sprevious;
		}
	}

// Hide mouse when invisible
} else {
	// System cursor
	if (window_get_cursor() != cr_none) {
		window_set_cursor(cr_none);
	}
	
	// Sprite cursor
	if (cursor_sprite != -1) {
		cursor_sprite = -1;
	}
}
#endregion