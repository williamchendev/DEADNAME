/// @description Explosion Impact Update Event
// Calculates the Explosion Impact Behaviour and visual effect

// Explosion Impact Size Behaviour
sprite_size = clamp(sprite_size, 0, 1);
image_xscale = sprite_size;
image_yscale = sprite_size;
if (size_shrink) {
	sprite_size *= power(sprite_size_shrink_mult, global.deltatime);
}
else {
	sprite_size *= power(sprite_size_grow_mult, global.deltatime);
	if (sprite_size >= 1) {
		size_shrink = true;
	}
}

// Explosion Impact Alpha Behaviour
normalmap_level = clamp(1 - alpha_delay_timer, 0, 1);
explosion_pointlight.intensity = clamp(1.5 - alpha_delay_timer, 0, 1);
alpha_delay_timer = lerp(alpha_delay_timer, 1.5, alpha_delay_timer_spd * global.deltatime);
if (alpha_delay_timer >= 0.99) {
	image_alpha = lerp(image_alpha, 0, alpha_transition_spd * global.deltatime);
	if (image_alpha <= alpha_destroy_threshold) {
		instance_destroy(explosion_pointlight);
		instance_destroy();
	}
}