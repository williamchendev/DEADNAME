/// @description Blood Update Event
// Calculates the behaviour of the Blood Effect for the Droplets

// Unit Collision Behaviour
if (blood_y <= 0) {
	if (collision_point(x, y, oUnit, false, false)) {
		if (random(1) < 0.2) {
			var temp_unit = instance_position(x, y, oUnit);
			// Blood Effect
			if (temp_unit.blood) {
				if (temp_unit.blood_effect != noone) {
					// Create and Index Blood Sticker
					var temp_unit_blood_inst = instance_create_layer(x, y, temp_unit.layers[4], temp_unit.blood_effect);
					ds_list_add(temp_unit.blood_list, temp_unit_blood_inst);
							
					// Apply Blood Sticker Settings
					temp_unit_blood_inst.unit_inst = temp_unit;
					temp_unit_blood_inst.blood_x = temp_unit.x - x;
					temp_unit_blood_inst.blood_y = temp_unit.y - y;
					temp_unit_blood_inst.blood_color = image_blend;
				}
			}
		}
		else {
			blood_y = 5;
		}
	}
}

// Ground Collision Behaviour
if (platform_free(x, y, platform_list)) {
	image_angle += case_rotation * global.deltatime;
	
	var hspd = 0;
	var vspd = 0;
	
	hspd += lengthdir_x(case_spd, case_direction) * global.deltatime;
	vspd += lengthdir_y(case_spd, case_direction) * global.deltatime;
	
	spd += gravity_spd * global.deltatime;
	hspd += lengthdir_x(spd, -90) * global.deltatime;
	vspd += lengthdir_y(spd, -90) * global.deltatime;
	
	if (!platform_free(x + hspd, y + vspd, platform_list)) {
		var temp_distance = point_distance(x, y, x + hspd, y + vspd);
		var temp_direction = point_direction(x, y, x + hspd, y + vspd);
		for (var i = 0; i < temp_distance; i++) {
			x += lengthdir_x(1, temp_direction);
			y += lengthdir_y(1, temp_direction);
			
			if (!platform_free(x, y, platform_list)) {
				break;
			}
		}
	}
	else {
		x += hspd;
		y += vspd;
	}
}
else {
	// Create Floor Splatter
	var temp_floor_splatter_inst = noone;
	if (place_meeting(x, y, oSolid)) {
		temp_floor_splatter_inst = instance_create_layer(round(x), round(y), layer_get_id("Instances"), oBloodEffect_Floor);
		var temp_solid_inst = instance_place(x, y, oSolid);
		var temp_angle = point_check_solid_surface_angle(x, y, temp_solid_inst);
		temp_floor_splatter_inst.image_angle = temp_angle;
	}
	else if (place_meeting(x, y, oPlatform)) {
		var temp_solid_inst = instance_place(x, y, oPlatform);
		temp_floor_splatter_inst = instance_create_depth(round(x), round(temp_solid_inst.y), temp_solid_inst.depth - 1, oBloodEffect_Floor);
	}
	
	if (temp_floor_splatter_inst != noone) {
		temp_floor_splatter_inst.image_blend = image_blend;
		temp_floor_splatter_inst.image_xscale = blood_size * temp_floor_splatter_inst.image_xscale;
		temp_floor_splatter_inst.image_yscale = blood_size;
	}
	
	// Destroy Self
	instance_destroy();
}

image_xscale = blood_size;
image_yscale = blood_size;