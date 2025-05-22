/// @description Muzzle Flare Update Event
// Updates the Muzzle Flare's Decay, Color, and Intensity Behaviours

// Muzzle Flare Life Decay
muzzle_flare_life -= muzzle_flare_decay * frame_delta;
muzzle_flare_life *= power(muzzle_flare_decay_mult, frame_delta);

if (muzzle_flare_life <= 0)
{
	instance_destroy();
	return;
}

// Muzzle Flare Light Intensity
point_light_intensity = lerp(muzzle_flare_end_intensity, muzzle_flare_start_intensity, muzzle_flare_life);

// Muzzle Flare Light Color
image_blend = merge_color(muzzle_flare_end_color, muzzle_flare_start_color, muzzle_flare_life);
