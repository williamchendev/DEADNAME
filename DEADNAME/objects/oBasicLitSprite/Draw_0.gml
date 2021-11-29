/// @description Basic Light Object Draw
// Performs the Draw Event and Behaviour of the Basic Lighting Object

// Basic Normal/Lit Sprite Split
if (lit_draw_event) {
	sprite_index = colors_sprite_index;
}
else if (normal_draw_event) {
	sprite_index = normals_sprite_index;
}
else {
	sprite_index = colors_sprite_index;
	if (instance_exists(oLighting)) {
		return;
	}
}

// Basic Draw Behaviour
var temp_image_alpha = image_alpha;
var temp_image_blend = image_blend;
if (lit_draw_event) {
	gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
}
if (normal_draw_event) {
	// Set Normal Vector Scaling Shader
	image_alpha = 1;
	image_blend = c_white;
	shader_set(shd_vectortransform);
	var temp_normalscale_x = sign(image_xscale);
	var temp_normalscale_y = sign(image_yscale);
	shader_set_uniform_f(vectortransform_shader_angle, degtorad(image_angle));
	shader_set_uniform_f(vectortransform_shader_scale, temp_normalscale_x, temp_normalscale_y, normalmap_level);
}

draw_self();

if (lit_draw_event) {
	gpu_set_blendmode(bm_normal);
}
if (normal_draw_event) {
	// Reset Normal Vector Scaling Shader
	shader_reset();
	image_alpha = temp_image_alpha;
	image_blend = temp_image_blend;
}