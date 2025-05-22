
//
hitmarker_destroy_timer -= frame_delta;

if (hitmarker_destroy_timer <= 0)
{
	instance_destroy();
}