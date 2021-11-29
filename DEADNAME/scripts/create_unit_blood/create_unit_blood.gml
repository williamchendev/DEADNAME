/// create_unit_blood(unit_id,blood_x,blood_y,blood_direction);
/// @description Creates a Unit Object's Blood Effect from given variables
/// @param {real} unit_id
/// @param {real} blood_x
/// @param {real} blood_y
/// @param {real} blood_direction

// Establish Variables
var temp_unit = argument0;
var temp_blood_x = argument1;
var temp_blood_y = argument2;
var temp_blood_direction = argument3;

// Create Blood Effect
if (temp_unit.blood) {
	if (temp_unit.blood_effect != noone) {
		// Create and Index Blood Sticker
		var temp_unit_blood_inst = instance_create_layer(temp_blood_x, temp_blood_y, temp_unit.layers[4], temp_unit.blood_effect);
		ds_list_add(temp_unit.blood_list, temp_unit_blood_inst);
							
		// Apply Blood Sticker Settings
		temp_unit_blood_inst.unit_inst = temp_unit;
		temp_unit_blood_inst.blood_x = temp_unit.x - temp_blood_x;
		temp_unit_blood_inst.blood_y = temp_unit.y - temp_blood_y;
		temp_unit_blood_inst.blood_color = temp_unit.blood_color;
							
		// Check for Blood Splat
		var temp_blood_splat_exists = false;
		for (var q = ds_list_size(temp_unit.blood_list) - 1; q >= 0; q--) {
			var temp_blood_sticker_valid = false;
			var temp_blood_sticker_inst = ds_list_find_value(temp_unit.blood_list, q);
			if (temp_blood_sticker_inst != noone) {
				if (instance_exists(temp_blood_sticker_inst)) {
					temp_blood_sticker_valid = true;
					if (temp_blood_sticker_inst.object_index == oBloodEffect_Splatter) {
						temp_blood_splat_exists = true;
						break;
					}
				}
			}
			if (!temp_blood_sticker_valid) {
				ds_list_delete(temp_unit.blood_list, q);
			}
		}

		// Blood Splat
		if (!temp_blood_splat_exists) {
			// Create and Index Blood Splat
			var temp_splat_blood_inst = instance_create_layer(temp_blood_x, temp_blood_y, temp_unit.layers[4], oBloodEffect_Splatter);
			ds_list_add(temp_unit.blood_list, temp_splat_blood_inst);
							
			// Apply Blood Splat Settings
			temp_splat_blood_inst.unit_inst = temp_unit;
			temp_splat_blood_inst.blood_x = temp_unit.x - temp_blood_x;
			temp_splat_blood_inst.blood_y = temp_unit.y - temp_blood_y;
			temp_splat_blood_inst.blood_size = 0.6;
			temp_splat_blood_inst.image_blend = temp_unit.blood_color;
							
			// Create Blood Droplets
			if (!collision_point(temp_blood_x, temp_blood_y, oSolid, false, true)) {
				var temp_random_droplet_num = irandom_range(3, 12);
				for (var q = 0; q < temp_random_droplet_num; q++) {
					// Create and Index Blood Droplet
					var temp_droplet_blood_inst = instance_create_layer(temp_blood_x, temp_blood_y, temp_unit.layers[4], oBloodEffect_Droplet);
					ds_list_add(temp_unit.blood_list, temp_droplet_blood_inst);
								
					// Apply Blood Droplet Settings
					temp_droplet_blood_inst.blood_size = random_range(0.3, 1.2);
					temp_droplet_blood_inst.image_blend = temp_unit.blood_color;
					var temp_blood_droplet_direction = sign(temp_blood_x - x);
					if (temp_blood_droplet_direction == 0) {
						temp_blood_droplet_direction = 1;
					}
					temp_droplet_blood_inst.case_direction = temp_blood_direction + random_range(-30, 30);
				}
			}
		}
	}
}