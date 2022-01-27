/// @description Basic Simple Lit Entity Draw
// Draws the Basic Simple Lit Entity to Screen

// Basic Draw Behaviour
if (!instance_exists(oLighting)) {
	// Unlit Draw Sprite
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	return;
}
else {
	// Basic Normal/Lit Sprite Split
	if (normal_draw_event) {
		shader_set(shd_color_ceilalpha);
		shader_set_uniform_f(shader_forcecolor, 0.5, 0.5, 1.0);
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		shader_reset();
	}
	else if (lit_draw_event) {
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		gpu_set_blendmode(bm_normal);
	}
	return;
}
