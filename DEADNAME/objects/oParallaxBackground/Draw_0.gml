/// @description Parallax Background Draw
// Draws the Parallax Background to the Screen

// Skip Event
if (!draw_background) {
	return;
}
draw_background = false;

// Draw Parallax Layers
for (var i = 0; i < array_length_1d(background_sprite); i++) {
	draw_sprite_ext(background_sprite[i], 0, x + background_x_offset[i], y + background_y_offset, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	draw_sprite_ext(background_sprite[i], 0, (x + background_x_offset[i]) + sprite_get_width(background_sprite[i]), y + background_y_offset, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	draw_sprite_ext(background_sprite[i], 0, (x + background_x_offset[i]) - sprite_get_width(background_sprite[i]), y + background_y_offset, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

// Darken Background
event_inherited();