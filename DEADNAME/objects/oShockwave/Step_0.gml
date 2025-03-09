/// @description Update Shockwave
// Updates the Shockwave's Behaviour and handles Destruction upon Alpha Decay

// Update Distortion Position
x += horizontal_speed * frame_delta;
y += vertical_speed * frame_delta;

// Update Distortion Scale
image_xscale = max(image_xscale + (horizontal_scale_increment * frame_delta), 0);
image_yscale = max(image_yscale + (vertical_scale_increment * frame_delta), 0);
	
// Update Distortion Alpha Decay
image_alpha += alpha_decay * frame_delta;

// Destroy Instance on Alpha Decay
if (image_alpha < 0)
{
	instance_destroy();
}
