/// @description Insert description here
// You can write your code in this editor

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
x = interact_obj.x;
y = interact_obj.y;
sprite_index = interact_obj.sprite_index;
image_index = interact_obj.image_index;
image_xscale = interact_obj.image_xscale;
image_yscale = interact_obj.image_yscale;
image_angle = interact_obj.image_angle;

// Interact Selection
if (interact_select) {
	// Lerp Alpha to 1
	interact_select_draw_value = lerp(interact_select_draw_value, 1, global.realdeltatime * interact_select_draw_spd);
}
else {
	// Lerp Alpha to 0
	interact_select_draw_value = lerp(interact_select_draw_value, 0, global.realdeltatime * interact_select_draw_spd);
}

// Interact Outline Behaviour
if (interact_select_draw_value > 0) {
	// Debug
	if (is_undefined(ds_map_find_value(game_manager.surface_manager.interacts_outline, id))) {
		ds_map_add(game_manager.surface_manager.interacts_outline, id, interact_select_outline_color);
	}
}

interact_select_draw_value = clamp(interact_select_draw_value, 0, 1);