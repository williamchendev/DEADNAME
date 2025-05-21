/// @description Insert description here
// You can write your code in this editor

movement_spd *= power(movement_spd_decay, frame_delta);

x += movement_direction_h * movement_spd * frame_delta;
y += movement_direction_v * movement_spd * frame_delta;

//
size *= power(size_decay, frame_delta);

image_xscale = size;
image_yscale = size;

if (size <= 0)
{
	lighting_engine_remove_object(id);
}