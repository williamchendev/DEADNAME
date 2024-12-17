/// @function		window_set_cursor_sprite(sprite);
/// @param			{sprite}	sprite
/// @description	Assigns a sprite to the cursor using consistent syntax with the primary 
///					`window_set_cursor` function. Note that the sprite origin point will be used
///					as the cursor hotspot.
///
///					While it is not required, it is highly recommended to include `obj_server_gmlp` 
///					in the project when using this script. The `obj_server_gmlp` object will handle 
///					automatically switching between system and sprite cursor types, as well as
///					provide additional mouse coordinate and visibility variables.
///
///					To disable the cursor sprite, use `cr_none`. (If `obj_server_gmlp` is present, 
///					`cr_none` will be ignored, and you should use `mouse_visible = false` to hide
///					the cursor, or `window_set_cursor(cr_default)` to restore the system cursor
///					instead.)
///
/// @example		window_set_cursor_sprite(spr_cursor);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function window_set_cursor_sprite(_sprite) {
	// Assign cursor sprite
	if (_sprite != cr_none) {
		cursor_sprite = _sprite;
	} else {
		// Assign null cursor sprite, if specified
		cursor_sprite = -1;
	}
}
