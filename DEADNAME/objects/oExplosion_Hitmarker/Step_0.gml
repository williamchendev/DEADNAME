/// @description Timer Destroy Update Event
// Destroys the Hitmarker after enough time has passed

// Life Decay
life -= frame_delta;

// Check if Hitmarker should be destroyed
if (life <= 0)
{
	// Destroy Hitmarker
	instance_destroy();
	return;
}

// Size Increase Behaviour
image_xscale += sign(image_xscale) * size_increase * frame_delta;
image_yscale += sign(image_yscale) * size_increase * frame_delta;
