/// @function		sprite_get_index(sprite, [offset]);
/// @param			{sprite}	sprite
/// @param			{real}		[offset]
/// @requires		sprite_get_speed_fps
/// @description	Every instance has a built-in `image_index` variable which tracks the animation
///					frame for the sprite assigned to `sprite_index`, adjusted for `image_speed`. But
///					many objects draw multiple sprites, each of which may have a different speed.
///					This script returns the `image_index` value for any sprite, factoring in both
///					sprite speed and delta time.
///				
///					Note that this script is based on global session time, and will always return
///					the same index at the same time for every instance of the sprite. Sometimes 
///					this synchronization is not desirable, in which case an optional offset time 
///					can also be supplied, as a value of frames.
///
/// @example		//CREATE EVENT
///					var offset = -sprite_get_index(my_sprite);
///				
///					//DRAW EVENT
///					draw_sprite(my_sprite, sprite_get_index(my_sprite, offset), x + 32, y - 32);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function sprite_get_index() {
	// Get sprite properties
	var _sprite = argument[0],
		sprite_fps = sprite_get_speed_fps(_sprite),
		sprite_num = sprite_get_number(_sprite);

	// Get index offset, if any
	var sprite_ioffset = 0;
	if (argument_count > 1) {
		sprite_ioffset = (argument[1] mod sprite_num);
	}

	// Return current sprite index based on real game time, adjusted for sprite speed
	return floor((((get_timer()*0.000001)*sprite_fps) + sprite_ioffset) mod sprite_num);
}
