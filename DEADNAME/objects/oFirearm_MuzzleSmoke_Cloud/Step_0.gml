/// @description Muzzle Smoke Cloud Update Event
// Performs the Movement, Shrinking, and Transparency Decay of the Muzzle Smoke Cloud

// Smoke Cloud Movement
movement_spd *= power(movement_spd_decay, frame_delta);

x += movement_direction_h * movement_spd * frame_delta;
y += movement_direction_v * movement_spd * frame_delta;

// Smoke Cloud Rotation
image_angle += rotation_spd * movement_spd * frame_delta;

// Smoke Cloud Transparency
image_alpha -= alpha_decay * frame_delta;
image_alpha = image_alpha < 0 ? 0 : image_alpha;

// Smoke Cloud Size
size *= power(size_decay, frame_delta);

image_xscale = size;
image_yscale = size;

// Smoke Cloud Destroy Event
if (size <= 0 or image_alpha <= 0)
{
	instance_destroy();
}
