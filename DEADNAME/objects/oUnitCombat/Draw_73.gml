/// @description Unit Combat Draw Event
// Draws the unit & its knockout effect to the screen

// Target Cursor
var temp_draw_combat_gui = (!lit_draw_event and !normal_draw_event) or !instance_exists(oLighting);
if (temp_draw_combat_gui and canmove) {
	// Draw Player GUI
	var temp_reset_combat_cursor = true;
	if (player_input) {
		for (var i = 0; i < ds_list_size(inventory.weapons); i++) {
			// Find Indexed Weapon
			var temp_weapon_index = ds_list_find_value(inventory.weapons, i);

			// Weapon Behaviour
			if (instance_exists(temp_weapon_index)) {
				if (temp_weapon_index.equip) {
					// Weapon Aim Variables
					var temp_weapon_x = x + weapon_x;
					var temp_weapon_y = y + weapon_y;
					var temp_weapon_cursor_range = point_distance(temp_weapon_x, temp_weapon_y, cursor_x, cursor_y);
					var temp_weapon_rotation = temp_weapon_index.weapon_rotation + temp_weapon_index.recoil_angle_shift;
					
					// Weapon Aim Behaviour
					if (targeting) {
						temp_reset_combat_cursor = false;
						weapon_cursor_range = lerp(weapon_cursor_range, temp_weapon_cursor_range, weapon_cursor_range_lerp_spd * global.realdeltatime);
					}
					temp_weapon_x += lengthdir_x(weapon_cursor_range, temp_weapon_rotation);
					temp_weapon_y += lengthdir_y(weapon_cursor_range, temp_weapon_rotation);
					
					// Draw Cursor
					if (!reload) {
						draw_sprite(sCursorCrosshairIcons, 0, temp_weapon_x, temp_weapon_y);
						/*
						if (object_is_ancestor(temp_weapon_index.object_index, oFirearm) or (temp_weapon_index.object_index == oFirearm)) {
							if (temp_weapon_index.aim >= 0.95) {
								draw_sprite(sCursorCrosshairIcons, 2, temp_weapon_x, temp_weapon_y);
							}
						}
						*/
					}
				
					// Break
					break;
				}
			}
		}
	}
	
	// Reset Cursor Range
	if (temp_reset_combat_cursor) {
		weapon_cursor_range = lerp(weapon_cursor_range, weapon_cursor_ambient_range, weapon_cursor_range_lerp_spd * global.realdeltatime);
	}
}

// Knockout
if (instance_exists(oKnockout)) {
	if (health_points > 0) {
		// Draw Layers
		shader_set(shd_black);
		for (var l = 0; l < array_length_1d(layers); l++) {
			// Find Layer Elements
			var temp_layer_elements = layer_get_all_elements(layers[l]);
			for (var i = 0; i < array_length_1d(temp_layer_elements); i++) {
				// Check if Element is an Instance
				if (layer_get_element_type(temp_layer_elements[i]) == layerelementtype_instance) {
					// Draw Instance
					var temp_inst = layer_instance_get_instance(temp_layer_elements[i]);
					with (temp_inst) {
						event_perform(ev_draw, 0);
					}
				}
			}
		}
		shader_reset();
		
		// Draw Restart Text
		var temp_knockout_inst = instance_find(oKnockout, 0);
		if (temp_knockout_inst.restart_screen) {
			if (instance_exists(oCamera)) {
				var temp_camera_inst = instance_find(oCamera, 0);
				draw_sprite(sMenu_Restart_Text, 0, temp_camera_inst.x, temp_camera_inst.y);
			}
		}
	}
}

// Debug Pathing Event Inhertited
event_inherited();