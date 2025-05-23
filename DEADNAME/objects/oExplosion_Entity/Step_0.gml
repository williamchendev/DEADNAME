/// @description Insert description here
// You can write your code in this editor

// Life Decay
life *= power(life_decay_mult, frame_delta);
life -= life_decay * frame_delta;

if (life <= 0)
{
	instance_destroy();
}

//
image_xscale = (1.0 - life) * size;
image_yscale = (1.0 - life) * size;
