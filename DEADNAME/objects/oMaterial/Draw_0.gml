/// @description Material Draw
// Draws the Material with lighting data to screen

// Skip Draw Event
if (skip_draw_event) {
	return;
}

// Basic Normal/Lit Sprite Split
sprite_index = material_sprite;
if (instance_exists(oLighting)) {
	if (lit_draw_event) {
		// Draw Material Backing Sprite
		draw_sprite_ext(material_sprite, image_index, x, y, image_xscale, 1, 0, c_dkgray, image_alpha);
	}
	else if (normal_draw_event) {
		// Draw Material Backing NormalMap
		shader_set(shd_color_ceilalpha);
		shader_set_uniform_f(shader_forcecolor, 0.5, 0.5, 1.0);
		draw_sprite_ext(material_sprite, image_index, x, y, image_xscale, 1, 0, image_blend, image_alpha);
		shader_reset();
		return;
	}
	else {
		// Skip Draw Event
		return;
	}
}
else {
	// Draw Material Backing Sprite
	draw_sprite_ext(material_sprite, image_index, x, y, image_xscale, 1, 0, c_dkgray, image_alpha);
}

// Create Surface
if (!surface_exists(material_surface)) {
	material_surface = surface_create(sprite_get_width(sprite_index), sprite_get_height(sprite_index));
}

// Instantiate New Surface
surface_set_target(material_surface);
draw_clear_alpha(c_black, 0);
var temp_mat_x = sprite_get_xoffset(sprite_index);
if (sign(image_xscale) == -1) {
	temp_mat_x = sprite_get_width(sprite_index) - sprite_get_xoffset(sprite_index);
}
draw_sprite_ext(sprite_index, image_index, temp_mat_x, sprite_get_yoffset(sprite_index), image_xscale, 1, 0, image_blend, image_alpha);
surface_reset_target();

// Draw Surface
shader_set(shd_subtract_alpha);
texture_set_stage(material_alpha_tex, surface_get_texture(material_dmg_surface));
draw_surface(material_surface, x - temp_mat_x, y - sprite_get_yoffset(sprite_index));
shader_reset();