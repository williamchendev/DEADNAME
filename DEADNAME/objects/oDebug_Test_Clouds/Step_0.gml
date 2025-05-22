/// @description Insert description here
// You can write your code in this editor

movement_spd *= power(movement_spd_decay, frame_delta);

x += movement_direction_h * movement_spd * frame_delta;
y += movement_direction_v * movement_spd * frame_delta;

//
image_angle += rotation_spd * movement_spd * frame_delta;

//
image_alpha -= alpha_decay * frame_delta;
image_alpha = image_alpha < 0 ? 0 : image_alpha;

//
size *= power(size_decay, frame_delta);

image_xscale = size;
image_yscale = size;

if (size <= 0)
{
	instance_destroy();
}
