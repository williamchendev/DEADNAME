/// @description Unlit Impact Hitmarker Update Event
// Updates the Impact Hitmarker's Behaviour

// Hitmarker Trail Behaviour
trail_multiplier = power(hitmarker_destroy_timer / hitmarker_life, 1.25);

// Hitmarker Destroy Timer Behaviour
hitmarker_destroy_timer -= frame_delta;

if (hitmarker_destroy_timer <= 0)
{
	instance_destroy();
}
