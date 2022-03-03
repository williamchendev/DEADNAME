/// @description Insert description here
// You can write your code in this editor

// Skip if Knockout
if (instance_exists(oKnockout)) {
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

// Draw Blood End Behaviour
if (blood_draw_end) {
	if (!instance_exists(oLighting)) {
		var temp_x_offset = -((blood_pool_value * (sprite_get_width(sprite_index) / 2)) * sign(image_xscale));
		draw_sprite_general(sprite_index, image_index, (sprite_get_width(sprite_index) / 2) - (blood_pool_value * (sprite_get_width(sprite_index) / 2)), 0, sprite_get_width(sprite_index) * blood_pool_value, sprite_get_height(sprite_index) * blood_pool_value, x + lengthdir_x(temp_x_offset, image_angle) - temp_camera_x, y + lengthdir_y(temp_x_offset, image_angle) - temp_camera_y, image_xscale, image_yscale, image_angle, image_blend, image_blend, image_blend, image_blend, image_alpha);
	}
}

// Reset Camera GUI Layer
if (temp_camera_exists) {
	surface_reset_target();
}