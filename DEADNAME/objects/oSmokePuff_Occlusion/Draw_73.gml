/// @description Insert description here
// You can write your code in this editor

// Smoke Unit Occlusion Shadow
if (!normal_draw_event and !lit_draw_event) {
	// Create Surfaces
	if (!surface_exists(smoke_surface)) {
		smoke_surface = surface_create(sprite_get_width(colors_sprite_index), sprite_get_height(colors_sprite_index));
	}
	if (!surface_exists(occlusion_surface)) {
		occlusion_surface = surface_create(sprite_get_width(colors_sprite_index), sprite_get_height(colors_sprite_index));
	}
	if (!surface_exists(occlusion_remove_surface)) {
		occlusion_remove_surface = surface_create(sprite_get_width(colors_sprite_index), sprite_get_height(colors_sprite_index));
	}
	if (!surface_exists(smoke_final_surface)) {
		smoke_final_surface = surface_create(sprite_get_width(colors_sprite_index), sprite_get_height(colors_sprite_index));
	}
	
	// Draw Smoke Surface
	surface_set_target(smoke_surface);
	draw_clear_alpha(c_black, 0);
	shader_set(shd_black_ceilalpha);
	draw_sprite_ext(colors_sprite_index, image_index, sprite_get_width(colors_sprite_index) / 2, sprite_get_height(colors_sprite_index) / 2, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	shader_reset();
	surface_reset_target();
	
	// Draw Occlusion Map
	surface_set_target(occlusion_surface);
	draw_clear_alpha(c_black, 0);

	// Interate Through Colliding Units
	for (var i = 0; i < unit_collision_num; i++) {
		// Find Unit Instance
		var temp_unit_inst = ds_list_find_value(unit_collision_list, i);
		
		// Draw Unit to Occlusion Mask
		if (temp_unit_inst != noone) {
			// Unit Effect Lock On
			if (instance_exists(temp_unit_inst)) {
				// Unit Weapon
				var temp_weapon_inst = noone;
				for (var l = 0; l < ds_list_size(temp_unit_inst.inventory.weapons); l++) {
					// Find Indexed Weapon
					var temp_weapon_index = ds_list_find_value(temp_unit_inst.inventory.weapons, l);
					if (temp_weapon_index.equip) {
						temp_weapon_inst = temp_weapon_index;
						break;
					}
				}
		
				// Record Unit Old Position
				var temp_unit_x = temp_unit_inst.x;
				var temp_unit_y = temp_unit_inst.y;
		
				// Draw Unit
				temp_unit_inst.x = (temp_unit_inst.x - x) + (sprite_get_width(colors_sprite_index) / 2);
				temp_unit_inst.y = (temp_unit_inst.y - y) + (sprite_get_height(colors_sprite_index) / 2);
				with (temp_unit_inst) {
					// Basic Lighting Colors Draw Event
					lit_draw_event = true;
					event_perform(ev_draw, 0);
					lit_draw_event = false;
				}

				// Draw Weapon
				if (temp_weapon_inst != noone) {
					// Draw Weapon
					var temp_weapon_x = temp_weapon_inst.x;
					var temp_weapon_y = temp_weapon_inst.y;
			
					temp_weapon_inst.x -= x - (sprite_get_width(colors_sprite_index) / 2);
					temp_weapon_inst.y -= y - (sprite_get_height(colors_sprite_index) / 2);
			
					with (temp_weapon_inst) {
						// Basic Lighting Colors Draw Event
						lit_draw_event = true;
						event_perform(ev_draw, 0);
						lit_draw_event = false;
					}
			
					temp_weapon_inst.x = temp_weapon_x;
					temp_weapon_inst.y = temp_weapon_y;
				}
				
				// Draw Limbs
				for (var p = 0; p < array_length_1d(temp_unit_inst.limb); p++) {
					// Limb Offset
					temp_unit_inst.limb[p].manual_surface_offset = true;
					temp_unit_inst.limb[p].surface_x_offset = x - (sprite_get_width(colors_sprite_index) / 2);
					temp_unit_inst.limb[p].surface_y_offset = y - (sprite_get_height(colors_sprite_index) / 2);
					with (temp_unit_inst.limb[p]) {
						// Basic Lighting Colors Draw Event
						lit_draw_event = true;
						event_perform(ev_draw, 0);
						lit_draw_event = false;
					}
				}
				
				// Reset Unit Position
				temp_unit_inst.x = temp_unit_x;
				temp_unit_inst.y = temp_unit_y;
			}
		}
	}
	
	// Interate Through Colliding Corpses
	for (var i = 0; i < corpse_collision_num; i++) {
		// Find Corpse Instance
		var temp_corpse_inst = ds_list_find_value(corpse_collision_list, i);
		
		// Record Corpse Position
		var temp_corpse_x = temp_corpse_inst.x;
		var temp_corpse_y = temp_corpse_inst.y;
		
		// Offset Corpse Position
		temp_corpse_inst.x = (temp_corpse_inst.x - x) + (sprite_get_width(colors_sprite_index) / 2);
		temp_corpse_inst.y = (temp_corpse_inst.y - y) + (sprite_get_height(colors_sprite_index) / 2);
				
		// Draw Corpse
		with (temp_corpse_inst) {
			// Basic Lighting Colors Draw Event
			lit_draw_event = true;
			event_perform(ev_draw, 0);
			lit_draw_event = false;
		}
		
		// Reset Corpse Position
		temp_corpse_inst.x = temp_corpse_x;
		temp_corpse_inst.y = temp_corpse_y;
	}
	
	// Reset Surface Target
	surface_reset_target();
	
	// Draw Occlusion Remove Map
	surface_set_target(occlusion_remove_surface);
	draw_clear_alpha(c_black, 0);
	surface_reset_target();
	
	// Draw Occlusion Shadow on Smoke
	surface_set_target(smoke_final_surface);
	draw_clear_alpha(c_black, 0);
	shader_set(shd_basicocclusion);
	texture_set_stage(occlusion_map, surface_get_texture(occlusion_surface));
	texture_set_stage(occlusion_remove_map, surface_get_texture(occlusion_remove_surface));
	draw_surface(smoke_surface, 0, 0);
	shader_reset();
	surface_reset_target();
	
	// Draw Final Smoke Effect with Alpha
	draw_surface_ext(smoke_final_surface, x - (sprite_get_width(colors_sprite_index) / 2), y - (sprite_get_height(colors_sprite_index) / 2), 1, 1, 0, c_white, image_alpha);
}