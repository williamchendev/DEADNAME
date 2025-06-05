/// @description Ragdoll Fade Update Event
// Applies the Ragdoll's Fade Effect to the given Ragdoll Group

// Check if Ragdoll Group exists
if (ragdoll_group == -1)
{
	instance_destroy();
	return;
}

// Ragdoll Fade Delay Timer Behaviour
if (fade_delay > 0)
{
	fade_delay -= frame_delta;
	return;
}

// Ragdoll Fade Effect Timer Behaviour
fade_timer -= frame_delta;
var temp_fade_value = clamp(fade_timer / fade_life, 0, 1);

// Ragdoll Fade Color Interpolation Effect Behaviour
var temp_fade_color = merge_color(end_color, start_color, temp_fade_value);

ragdoll_group.head.image_blend = temp_fade_color;
ragdoll_group.left_forearm.image_blend = temp_fade_color;
ragdoll_group.left_upperarm.image_blend = temp_fade_color;
ragdoll_group.right_forearm.image_blend = temp_fade_color;
ragdoll_group.right_upperarm.image_blend = temp_fade_color;
ragdoll_group.chest.image_blend = temp_fade_color;
ragdoll_group.torso.image_blend = temp_fade_color;
ragdoll_group.left_upper_leg.image_blend = temp_fade_color;
ragdoll_group.left_lower_leg.image_blend = temp_fade_color;
ragdoll_group.right_upper_leg.image_blend = temp_fade_color;
ragdoll_group.right_lower_leg.image_blend = temp_fade_color;

// Ragdoll Fade Object Destroy Behaviour
if (fade_timer <= 0)
{
	instance_destroy();
}