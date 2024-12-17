/// @function		sprite_get_speed_fps(sprite);
/// @param			{sprite}	sprite
/// @description	Returns the target sprite speed as defined in the sprite editor, forcing
///					the results to be interpreted as frames per-second.
///
/// @example		var speed_fps = sprite_get_speed_fps(my_sprite);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function sprite_get_speed_fps(_sprite) {
	// Convert sprite speed, if not target type
	if (sprite_get_speed_type(_sprite) != spritespeed_framespersecond) {
		return (sprite_get_speed(_sprite)*game_get_speed(gamespeed_fps));
	} else {
		// Otherwise return unconverted speed
		return sprite_get_speed(_sprite);
	}
}


/// @function		sprite_get_speed_real(sprite);
/// @param			{sprite}	sprite
/// @description	Returns the target sprite speed as defined in the sprite editor, forcing
///					the results to be interpreted as frames per-game frame.
///
/// @example		var speed_real = sprite_get_speed_real(my_sprite);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function sprite_get_speed_real(_sprite) {
	// Convert sprite speed, if not target type
	if (sprite_get_speed_type(_sprite) != spritespeed_framespergameframe) {
		return (sprite_get_speed(_sprite)/game_get_speed(gamespeed_fps));
	} else {
		// Otherwise return unconverted speed
		return sprite_get_speed(_sprite);
	}
}
