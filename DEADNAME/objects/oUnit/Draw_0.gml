/// @description Unit Draw Event

//
surface_set_target(LightingEngine.diffuse_color_surface);

//
limb_secondary_arm.render_behaviour();

//
draw_sprite_ext(sprite_index, image_index, x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, image_angle + draw_angle_value, image_blend, image_alpha);

// 
if (weapon_active)
{
	weapon_equipped.render_behaviour();
}

// 
limb_primary_arm.render_behaviour();

//
surface_reset_target();