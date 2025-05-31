/// @description Unlit Impact Hitmarker Update Event
// Updates the Impact Hitmarker's Behaviour

// Hitmarker Destroy Timer Behaviour
hitmarker_destroy_timer -= frame_delta;

if (hitmarker_destroy_timer <= 0)
{
	instance_destroy();
}
