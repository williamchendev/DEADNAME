/// @description Unit Draw Event

// Load Animation State
switch (unit_animation_state)
{
	case UnitAnimationState.Idle:
		sprite_index = global.unit_sprite_packs[unit_sprite_pack].idle_sprite;
		break;
	case UnitAnimationState.Walking:
		sprite_index = global.unit_sprite_packs[unit_sprite_pack].walk_sprite;
		break;
	case UnitAnimationState.Jumping:
		sprite_index = global.unit_sprite_packs[unit_sprite_pack].jump_sprite;
		break;
	case UnitAnimationState.Aiming:
		sprite_index = global.unit_sprite_packs[unit_sprite_pack].aim_sprite;
		break;
	case UnitAnimationState.AimWalking:
		sprite_index = global.unit_sprite_packs[unit_sprite_pack].aim_walk_sprite;
		break;
}

//
draw_sprite_ext(sprite_index, image_index, x, y, draw_xscale, draw_yscale, image_angle, image_blend, image_alpha);