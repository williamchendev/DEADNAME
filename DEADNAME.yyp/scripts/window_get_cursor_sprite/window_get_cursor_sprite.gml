/// @function		window_get_cursor_sprite();
/// @description	Returns the current sprite assigned to the cursor, if any, using consistent
///					syntax with the primary `window_get_cursor` function. If no sprite is cur-
///					rently assigned, `cr_none` will be returned instead.		
///
/// @example		if (window_get_cursor_sprite() == cr_none) {
///						window_set_cursor_sprite(spr_cursor);
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function window_get_cursor_sprite() {
	// Return cursor sprite
	if (cursor_sprite != -1) {
		return cursor_sprite;
	} else {
		// Return null cursor sprite, if unassigned
		return cr_none;
	}
}
