/// @description Insert description here
// You can write your code in this editor

// Skip if Knockout
if (instance_exists(oKnockout)) {
	return;
}

// Skip Draw Event
if (blood_draw_end) {
	return;
}

// Draw Blood
var temp_x_offset = -((blood_pool_value * (sprite_get_width(sprite_index) / 2)) * sign(image_xscale));
draw_sprite_general(sprite_index, image_index, (sprite_get_width(sprite_index) / 2) - (blood_pool_value * (sprite_get_width(sprite_index) / 2)), 0, sprite_get_width(sprite_index) * blood_pool_value, sprite_get_height(sprite_index) * blood_pool_value, x + lengthdir_x(temp_x_offset, image_angle), y + lengthdir_y(temp_x_offset, image_angle), image_xscale, image_yscale, image_angle, image_blend, image_blend, image_blend, image_blend, image_alpha);