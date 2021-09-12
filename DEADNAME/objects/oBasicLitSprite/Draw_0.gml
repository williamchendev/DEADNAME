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
	return;
}

// Basic Draw Behaviour
if (normal_draw_event) {
	// Set Normal Vector Scaling Shader
	shader_set(shd_vectortransform);
	var temp_normalscale_x = sign(image_xscale);
	var temp_normalscale_y = sign(image_yscale);
	shader_set_uniform_f(vectortransform_shader_angle, degtorad(image_angle));
	shader_set_uniform_f(vectortransform_shader_scale, temp_normalscale_x, temp_normalscale_y, 1.0);
}

draw_self();

if (normal_draw_event) {
	// Reset Normal Vector Scaling Shader
	shader_reset();
}