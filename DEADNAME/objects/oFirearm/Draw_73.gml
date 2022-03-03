/// @description Firearm Weapon Draw End
// Draws the Firearm Weapon Effects to the screen

// Inactive Skip
if (!active) {
	return;
}

// Camera GUI Layer
var temp_camera_x = 0;
var temp_camera_y = 0;
var temp_camera_exists = instance_exists(oCamera);
if (temp_camera_exists) {
	var temp_camera_inst = instance_find(oCamera, 0);
	temp_camera_x = temp_camera_inst.x;
	temp_camera_y = temp_camera_inst.y;
	surface_set_target(temp_camera_inst.gui_surface);
}

// Draw Hit Effect
if (ds_list_size(hit_effect_timer) > 0) {
	for (var i = 0; i < ds_list_size(hit_effect_timer); i++) {
		// Establish Hit Effect Variables
		var temp_hit_fx_index = ds_list_find_value(hit_effect_index, i);
		var temp_hit_fx_sign = ds_list_find_value(hit_effect_sign, i);
		var temp_hit_fx_x = ds_list_find_value(hit_effect_xpos, i);
		var temp_hit_fx_y = ds_list_find_value(hit_effect_ypos, i);
		var temp_hit_fx_xscale = ds_list_find_value(hit_effect_xscale, i);
		var temp_hit_fx_yscale = ds_list_find_value(hit_effect_yscale, i);
		var temp_hit_fx_angle = ds_list_find_value(hit_effect_rotation, i);
		
		// Draw Hit Effect
		draw_sprite_ext(hit_effect_sprite, temp_hit_fx_index, temp_hit_fx_x + temp_hit_fx_sign - temp_camera_x, temp_hit_fx_y + temp_hit_fx_sign - temp_camera_y, temp_hit_fx_xscale * temp_hit_fx_sign, temp_hit_fx_yscale, temp_hit_fx_angle, c_black, 1);
		draw_sprite_ext(hit_effect_sprite, temp_hit_fx_index, temp_hit_fx_x - temp_camera_x, temp_hit_fx_y - temp_camera_y, temp_hit_fx_xscale * temp_hit_fx_sign, temp_hit_fx_yscale, temp_hit_fx_angle, c_white, 1);
	}
}

// Reset Camera GUI Layer
if (temp_camera_exists) {
	surface_reset_target();
}