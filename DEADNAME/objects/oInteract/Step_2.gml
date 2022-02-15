/// @description Interact Selection
// Scales the Interaction to the parent object and handles selection behaviour

// Destroy Interact Behaviour
if (interact_destroy) {
	// Destroy Object
	instance_destroy();
	active = false;
	interact_select = false;
	interact_select_draw_value = 0;
	return;
}

// Mirror Interact Object Properties
if (interact_mirror_select_obj) {
	sprite_index = interact_obj.sprite_index;
	image_index = interact_obj.image_index;
	image_xscale = interact_obj.image_xscale * interact_image_xscale;
	image_yscale = interact_obj.image_yscale * interact_image_yscale;
	image_angle = interact_obj.image_angle;

	var temp_xscale_offset = sprite_get_xoffset(sprite_index) / sprite_get_width(sprite_index);
	var temp_yscale_offset = sprite_get_yoffset(sprite_index) / sprite_get_height(sprite_index);
	temp_xscale_offset = ((temp_xscale_offset - 0.5) * 2.0) * ((sprite_get_width(sprite_index) * 0.5) * (image_xscale - interact_obj.image_xscale));
	temp_yscale_offset = ((temp_yscale_offset - 0.5) * 2.0) * ((sprite_get_height(sprite_index) * 0.5) * (image_yscale - interact_obj.image_yscale));

	if (interact_obj.phy_active) {
		x = interact_obj.phy_position_x + temp_xscale_offset;
		y = interact_obj.phy_position_y + temp_yscale_offset;
	}
	else {
		x = interact_obj.x + temp_xscale_offset;
		y = interact_obj.y + temp_yscale_offset;
	}
}

// Interact Selection
if (interact_select) {
	// Lerp Alpha to 1
	interact_select_draw_value = lerp(interact_select_draw_value, 1, global.realdeltatime * interact_select_draw_spd);
}
else {
	// Lerp Alpha to 0
	interact_select_draw_value = lerp(interact_select_draw_value, 0, global.realdeltatime * interact_select_draw_spd);
}
interact_select_draw_value = clamp(interact_select_draw_value, 0, 1);

// Interact Outline Behaviour
if (interact_select_draw_value > 0) {
	// Debug
	if (is_undefined(ds_map_find_value(game_manager.surface_manager.interacts_outline, id))) {
		ds_map_add(game_manager.surface_manager.interacts_outline, id, interact_select_outline_color);
	}
}