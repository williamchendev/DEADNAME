/// @description Insert description here
// You can write your code in this editor

//
visible = false;

//
lighting_engine_draw_sprite
(
	sprite_index,
	image_index,
	normalmap_spritepack[image_index].texture,
	specularmap_spritepack[image_index].texture,
	normalmap_spritepack[image_index].uvs,
	specularmap_spritepack[image_index].uvs,
	x,
	y + ground_contact_vertical_offset,
	draw_xscale,
	draw_yscale,
	image_angle + draw_angle_value,
	image_blend,
	image_alpha
);