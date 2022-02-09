/// @description Insert description here
// You can write your code in this editor

// Skip if Knockout
if (instance_exists(oKnockout)) {
	return;
}

// Skip Draw Event
if (blood_draw_end) {
	if (!instance_exists(oLighting)) {
		return;
	}
}

// Basic Draw Behaviour
var temp_x_offset = -((blood_pool_value * (sprite_get_width(sprite_index) / 2)) * sign(image_xscale));
if (!instance_exists(oLighting)) {
	// Draw Unlit Blood Pool
	draw_sprite_general(sprite_index, image_index, (sprite_get_width(sprite_index) / 2) - (blood_pool_value * (sprite_get_width(sprite_index) / 2)), 0, sprite_get_width(sprite_index) * blood_pool_value, sprite_get_height(sprite_index) * blood_pool_value, x + lengthdir_x(temp_x_offset, image_angle), y + lengthdir_y(temp_x_offset, image_angle), image_xscale, image_yscale, image_angle, image_blend, image_blend, image_blend, image_blend, image_alpha);
	return;
}
else {
	// Basic Normal/Lit Sprite Split
	if (normal_draw_event) {
		// Force Color Shader
		shader_set(shd_color_ceilalpha);
		shader_set_uniform_f(shader_forcecolor, 0.5, 0.5, 1.0);
		
		// Draw Blood
		draw_sprite_general(sprite_index, image_index, (sprite_get_width(sprite_index) / 2) - (blood_pool_value * (sprite_get_width(sprite_index) / 2)), 0, sprite_get_width(sprite_index) * blood_pool_value, sprite_get_height(sprite_index) * blood_pool_value, x + lengthdir_x(temp_x_offset, image_angle), y + lengthdir_y(temp_x_offset, image_angle), image_xscale, image_yscale, image_angle, image_blend, image_blend, image_blend, image_blend, image_alpha);
		
		// Shader Reset
		shader_reset();
	}
	else if (lit_draw_event) {
		// Set Blendmode
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
		
		// Draw Blood
		draw_sprite_general(sprite_index, image_index, (sprite_get_width(sprite_index) / 2) - (blood_pool_value * (sprite_get_width(sprite_index) / 2)), 0, sprite_get_width(sprite_index) * blood_pool_value, sprite_get_height(sprite_index) * blood_pool_value, x + lengthdir_x(temp_x_offset, image_angle), y + lengthdir_y(temp_x_offset, image_angle), image_xscale, image_yscale, image_angle, image_blend, image_blend, image_blend, image_blend, image_alpha);
		
		// Reset Blendmode
		gpu_set_blendmode(bm_normal);
	}
	return;
}