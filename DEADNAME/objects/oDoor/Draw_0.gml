/// @description Door Interactable Draw
// Draws the oDoor Object to the screen

// Door Variables
var temp_draw_val_1 = cos(door_value * 0.5 * pi);
var temp_draw_val_2 = sin(door_value * 0.5 * pi);

// Basic Draw Behaviour
if (instance_exists(oLighting)) {
	// Lighting Manager Variables
	var temp_lighting_manager = instance_find(oLighting, 0);
	var temp_lighting_x = temp_lighting_manager.x;
	var temp_lighting_y = temp_lighting_manager.y;
	
	// Basic Normal/Lit Sprite Split
	if (normal_draw_event) {
		// Draw Door Normal Map
		var temp_door_normal_x = (clamp(door_value, -1, 1) / 2.0) + 1.0;
		if (sign(door_value) <= 0) {
			temp_door_normal_x = 1 - temp_door_normal_x;
		}
		shader_set(shd_color_ceilalpha);
		shader_set_uniform_f(shader_forcecolor, temp_door_normal_x, 0.5, 1.0);
		draw_sprite_ext(panel_sprite, panel_image_index, x - (sign(door_value) * (sprite_get_width(end_panel_sprite) / 2)), y, temp_draw_val_2, 1, 0, door_color, 1);
		shader_set_uniform_f(shader_forcecolor, temp_door_normal_x, 0.5, 1.0);
		draw_sprite_ext(end_panel_sprite, panel_image_index, x + (temp_draw_val_2 * sprite_get_width(panel_sprite)) - (door_value * (sprite_get_width(end_panel_sprite) / 2)), y, temp_draw_val_1, 1, 0, door_color, 1);
		shader_reset();
		
		// Draw Door Material Normal Map
		if (door_material_active) {
			with (door_material) {
				var temp_material_x = x;
				var temp_material_y = y;
				x = other.door_material_x - temp_lighting_x;
				y = other.door_material_y - temp_lighting_y;
			
				// Draw Material
				skip_draw_event = false;
				normal_draw_event = true;
				event_perform(ev_draw, 0);
				normal_draw_event = false;
				skip_draw_event = true;
			
				x = temp_material_x;
				y = temp_material_y;
			}
		}
	}
	else if (lit_draw_event) {
		// Draw Door Sprite
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
		draw_sprite_ext(panel_sprite, panel_image_index, x - (sign(door_value) * (sprite_get_width(end_panel_sprite) / 2)), y, temp_draw_val_2, 1, 0, door_color, 1);
		draw_sprite_ext(end_panel_sprite, panel_image_index, x + (temp_draw_val_2 * sprite_get_width(panel_sprite)) - (door_value * (sprite_get_width(end_panel_sprite) / 2)), y, temp_draw_val_1, 1, 0, door_color, 1);
		gpu_set_blendmode(bm_normal);
		
		// Draw Door Material Sprite
		if (door_material_active) {
			with (door_material) {
				var temp_material_x = x;
				var temp_material_y = y;
				x = other.door_material_x - temp_lighting_x;
				y = other.door_material_y - temp_lighting_y;
			
				// Draw Material
				skip_draw_event = false;
				lit_draw_event = true;
				event_perform(ev_draw, 0);
				lit_draw_event = false;
				skip_draw_event = true;
			
				x = temp_material_x;
				y = temp_material_y;
			}
		}
	}
	return;
}
else {
	// Draw Door Sprites
	draw_sprite_ext(panel_sprite, panel_image_index, x - (sign(door_value) * (sprite_get_width(end_panel_sprite) / 2)), y, temp_draw_val_2, 1, 0, door_color, 1);
	draw_sprite_ext(end_panel_sprite, panel_image_index, x + (temp_draw_val_2 * sprite_get_width(panel_sprite)) - (door_value * (sprite_get_width(end_panel_sprite) / 2)), y, temp_draw_val_1, 1, 0, door_color, 1);
	
	// Draw Material
	event_perform_object(door_material, ev_draw, 0);
}