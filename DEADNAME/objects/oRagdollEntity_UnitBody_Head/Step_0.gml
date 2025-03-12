/// @description Ragdoll Physics & Render Culling 
// Culling Event for Ragdoll Group

// Inherit the parent event
event_inherited();

// Update Ragdoll Group Physics & Render
if (ragdoll_group != -1)
{
	ragdoll_group.left_forearm.physics_enabled = physics_enabled;
	ragdoll_group.left_upperarm.physics_enabled = physics_enabled;
	ragdoll_group.right_forearm.physics_enabled = physics_enabled;
	ragdoll_group.right_upperarm.physics_enabled = physics_enabled;
	ragdoll_group.chest.physics_enabled = physics_enabled;
	ragdoll_group.torso.physics_enabled = physics_enabled;
	ragdoll_group.left_upper_leg.physics_enabled = physics_enabled;
	ragdoll_group.left_lower_leg.physics_enabled = physics_enabled;
	ragdoll_group.right_upper_leg.physics_enabled = physics_enabled;
	ragdoll_group.right_lower_leg.physics_enabled = physics_enabled;

	ragdoll_group.left_forearm.render_enabled = render_enabled;
	ragdoll_group.left_upperarm.render_enabled = render_enabled;
	ragdoll_group.right_forearm.render_enabled = render_enabled;
	ragdoll_group.right_upperarm.render_enabled = render_enabled;
	ragdoll_group.chest.render_enabled = render_enabled;
	ragdoll_group.torso.render_enabled = render_enabled;
	ragdoll_group.left_upper_leg.render_enabled = render_enabled;
	ragdoll_group.left_lower_leg.render_enabled = render_enabled;
	ragdoll_group.right_upper_leg.render_enabled = render_enabled;
	ragdoll_group.right_lower_leg.render_enabled = render_enabled;
}
