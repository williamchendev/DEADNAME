/// @description Material Damage Surf
// Calculates the Material's damage surface

// Basic Lighting Inheritance
event_inherited();

// Create Surface
if (!surface_exists(material_dmg_surface)) {
	material_dmg_surface = surface_create(sprite_get_width(material_sprite), sprite_get_height(material_sprite));
}

// Reset Material Damage Surface
surface_set_target(material_dmg_surface);
draw_clear_alpha(c_black, 0);

// Index Damage to Material Damage Surface
if (material_damage > 0) {
	for (var i = 0; i < material_damage; i++) {
		// Material Damage Variables
		var temp_dmg_sprite = ds_list_find_value(material_damage_sprite_index, i);
		var temp_dmg_image = ds_list_find_value(material_damage_image_index, i);
		var temp_x_pos = sprite_get_xoffset(material_sprite);
		if (sign(image_xscale) == -1) {
			temp_x_pos = sprite_get_width(material_sprite) - sprite_get_xoffset(material_sprite);
		}
		var temp_dmg_x = (ds_list_find_value(material_damage_x, i) * image_xscale) + temp_x_pos;
		var temp_dmg_y = (ds_list_find_value(material_damage_y, i) + sprite_get_yoffset(material_sprite));
		var temp_dmg_x_scale = ds_list_find_value(material_damage_x_scale, i) * image_xscale;
		var temp_dmg_y_scale = ds_list_find_value(material_damage_y_scale, i);
		var temp_dmg_angle = ds_list_find_value(material_damage_angle, i) * sign(image_xscale);
		
		draw_sprite_ext(temp_dmg_sprite, temp_dmg_image, temp_dmg_x, temp_dmg_y, temp_dmg_x_scale, temp_dmg_y_scale, temp_dmg_angle, c_white, 1);
	}
}

// Reset Surface Target
surface_reset_target();

// Init Material Damage Buffer
if (material_buffer != noone) {
	buffer_delete(material_buffer);
}
material_buffer = buffer_create(4 * sprite_get_width(material_sprite) * sprite_get_height(material_sprite), buffer_fixed, 1);
buffer_get_surface(material_buffer, material_dmg_surface, 0, 0, 0);