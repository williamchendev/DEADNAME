/// @description Insert description here
// You can write your code in this editor

//
muzzle_flare_life -= muzzle_flare_decay * frame_delta;
muzzle_flare_life *= power(muzzle_flare_decay_mult, frame_delta);

if (muzzle_flare_life <= 0)
{
	instance_destroy();
	return;
}

//
point_light_intensity = lerp(muzzle_flare_end_intensity, muzzle_flare_start_intensity, muzzle_flare_life);

//
image_blend = merge_color(muzzle_flare_end_color, muzzle_flare_start_color, muzzle_flare_life);