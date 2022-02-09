/// @description Description Text
// Draws the Interaction's Description when selected

if (interact_mirror_select_obj) {
	event_inherited();
	return;
}

// Interact Description Behaviour
if (interact_select_draw_value > 0) {
	if (interact_description_show) {
		// Draw Variables
		var temp_desc_x = round(lerp(interact_inventory_obj_bbox_left, interact_inventory_obj_bbox_right, 0.5));
		var temp_desc_y = round(interact_inventory_obj_bbox_top + interact_description_yoffset);
		
		// Set Font Properties
		draw_set_font(interact_description_font);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_alpha(interact_select_draw_value);
		
		// Draw Text
		draw_text_outline(temp_desc_x, temp_desc_y, c_white, c_black, interact_description);
		
		// Reset Draw Properties
		draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_alpha(1);
	}
}
interact_description_show = false;