/// @description Basic Light Object Draw
// Performs the Draw Event and Behaviour of the Basic Lighting Object

// Basic Normal/Lit Sprite Split
if (lit_draw_event) {
	sprite_index = lit_sprite_index;
}
else if (normal_draw_event) {
	sprite_index = normal_sprite_index;
}
else {
	return;
}

// Basic Draw Behaviour
if (normal_draw_event) {
	// Set Normal Vector Scaling Shader
	shader_set(shd_vectorcolorscale);
	shader_set_uniform_f(vectorcolorscale_shader_r, sign(image_xscale) * cos(degtorad(image_angle)));
	shader_set_uniform_f(vectorcolorscale_shader_g, sign(image_yscale) * sin(degtorad(image_angle)));
	shader_set_uniform_f(vectorcolorscale_shader_b, 1.0);
}

draw_self();

if (normal_draw_event) {
	// Reset Normal Vector Scaling Shader
	shader_reset();
}