/// @description Blood Draw Event
// Draws the Blood to the surface

// Skip if Knockout
if (instance_exists(oKnockout)) {
	return;
}

// Create Surfaces
if (!surface_exists(blood_surface)) {
	blood_surface = surface_create(sprite_get_width(blood_sprite), sprite_get_height(blood_sprite));
}
if (!surface_exists(occlusion_surface)) {
	occlusion_surface = surface_create(sprite_get_width(blood_sprite), sprite_get_height(blood_sprite));
}
if (!surface_exists(occlusion_remove_surface)) {
	occlusion_remove_surface = surface_create(sprite_get_width(blood_sprite), sprite_get_height(blood_sprite));
}

// Draw Blood Map
surface_set_target(blood_surface);
draw_clear_alpha(c_black, 0);
draw_sprite_ext(blood_sprite, image_index, sprite_get_width(blood_sprite) / 2, sprite_get_height(blood_sprite) / 2, 1, 1, image_angle, blood_color, blood_alpha);
surface_reset_target();

// Blood Behaviour
if (corpse_inst != noone) {
	// Corpse Effect Lock On
	if (instance_exists(corpse_inst)) {
		// Blood on Corpse Positioning
		var temp_blood_offset_x = blood_x;
		var temp_blood_offset_y = blood_y;
		
		var temp_blood_angle = point_direction(0, 0, temp_blood_offset_x, temp_blood_offset_y);
		var temp_blood_distance = point_distance(0, 0, temp_blood_offset_x, temp_blood_offset_y);
		x = corpse_inst.x - lengthdir_x(temp_blood_distance, temp_blood_angle + corpse_inst.image_angle);
		y = corpse_inst.y - lengthdir_y(temp_blood_distance, temp_blood_angle + corpse_inst.image_angle);
		
		// Occlusion Effect
		surface_set_target(occlusion_surface);
		draw_clear_alpha(c_black, 0);
		
		for (var i = 0; i < array_length_1d(corpse_occlusion_list); i++) {
			if (instance_exists(corpse_occlusion_list[i])) {
				var temp_corpse_x = (corpse_occlusion_list[i].x - x) + (sprite_get_width(blood_sprite) / 2);
				var temp_corpse_y = (corpse_occlusion_list[i].y - y) + (sprite_get_height(blood_sprite) / 2);
				draw_sprite_ext(corpse_occlusion_list[i].sprite_index, corpse_occlusion_list[i].image_index, temp_corpse_x, temp_corpse_y, corpse_occlusion_list[i].image_xscale, corpse_occlusion_list[i].image_yscale, corpse_occlusion_list[i].image_angle, corpse_occlusion_list[i].image_blend, corpse_occlusion_list[i].image_alpha);
			}
		}
		
		surface_reset_target();
		
		// Remove Occlusion Effect
		surface_set_target(occlusion_remove_surface);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
	}
}
else if (unit_inst != noone) {
	// Unit Effect Lock On
	if (instance_exists(unit_inst)) {
		// Draw Occlusion Map
		surface_set_target(occlusion_surface);
		draw_clear_alpha(c_black, 0);

		// Unit Variables
		var temp_weapon_inst = noone;
		var temp_unit_x_offset = 0;
		var temp_unit_y_offset = 0;
		
		// Find Blood Offset
		var temp_blood_offset_x = blood_x;
		var temp_blood_offset_y = blood_y * unit_inst.draw_yscale;
		
		// Unit Weapon
		for (var i = 0; i < ds_list_size(unit_inst.inventory.weapons); i++) {
			// Find Indexed Weapon
			var temp_weapon_index = ds_list_find_value(unit_inst.inventory.weapons, i);
			if (temp_weapon_index.equip) {
				temp_weapon_inst = temp_weapon_index;
				if (temp_weapon_index.weapon_type == "firearm") {
					// Offset Blood
					if (unit_inst.targeting or (unit_inst.reload and unit_inst.x_velocity != 0)) {
						temp_blood_offset_y -= unit_inst.limb_aim_offset_y;
					}
				}
				break;
			}
		}
		
		// Find Blood Position
		var temp_blood_angle = point_direction(0, 0, temp_blood_offset_x, temp_blood_offset_y);
		var temp_blood_distance = point_distance(0, 0, temp_blood_offset_x, temp_blood_offset_y);
		x = round(unit_inst.x - lengthdir_x(temp_blood_distance, temp_blood_angle + unit_inst.draw_angle));
		y = round(unit_inst.y - lengthdir_y(temp_blood_distance, temp_blood_angle + unit_inst.draw_angle));
		
		// Record Unit Old Position
		var temp_unit_x = unit_inst.x;
		var temp_unit_y = unit_inst.y;
		
		// Draw Unit
		unit_inst.x = (unit_inst.x - x) + (sprite_get_width(blood_sprite) / 2);
		unit_inst.y = (unit_inst.y - y) + (sprite_get_height(blood_sprite) / 2);
		with (unit_inst) {
			// Basic Lighting Colors Draw Event
			lit_draw_event = true;
			event_perform(ev_draw, 0);
			lit_draw_event = false;
		}
		
		// Draw Unit Accessories
		temp_unit_x_offset = temp_unit_x - unit_inst.x;
		temp_unit_y_offset = temp_unit_y - unit_inst.y;
		
		// Reset Unit Position
		unit_inst.x = temp_unit_x;
		unit_inst.y = temp_unit_y;
		
		surface_reset_target();
		
		// Remove Occlusion Surface
		surface_set_target(occlusion_remove_surface);
		draw_clear_alpha(c_black, 0);

		if (temp_weapon_inst != noone) {
			// Draw Weapon
			var temp_weapon_x = temp_weapon_inst.x;
			var temp_weapon_y = temp_weapon_inst.y;
			
			temp_weapon_inst.x -= temp_unit_x_offset;
			temp_weapon_inst.y -= temp_unit_y_offset;
			
			with (temp_weapon_inst) {
				// Basic Lighting Colors Draw Event
				lit_draw_event = true;
				event_perform(ev_draw, 0);
				lit_draw_event = false;
			}
			
			temp_weapon_inst.x = temp_weapon_x;
			temp_weapon_inst.y = temp_weapon_y;
	
			// Draw Limbs
			for (var i = 0; i < array_length_1d(unit_inst.limb); i++) {
				// Check Limb Depth
				if (unit_inst.limb[i].depth > unit_inst.depth) {
					continue;
				}
		
				// Limb Offset
				unit_inst.limb[i].manual_surface_offset = true;
				unit_inst.limb[i].surface_x_offset = temp_unit_x_offset;
				unit_inst.limb[i].surface_y_offset = temp_unit_y_offset;
				with (unit_inst.limb[i]) {
					// Basic Lighting Colors Draw Event
					lit_draw_event = true;
					event_perform(ev_draw, 0);
					lit_draw_event = false;
				}
			}
		}

		surface_reset_target();
	}
}

// Draw Occluded Blood
shader_set(shd_basicocclusion);
texture_set_stage(occlusion_map, surface_get_texture(occlusion_surface));
texture_set_stage(occlusion_remove_map, surface_get_texture(occlusion_remove_surface));
draw_surface(blood_surface, x - (sprite_get_width(blood_sprite) / 2), y - (sprite_get_height(blood_sprite) / 2));
shader_reset();