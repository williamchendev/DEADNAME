/// @description Gun Reset Event
// Resets properties of the Gun

// Reindexing Behaviour
event_inherited();

// Light Calculation
if (light_muzzle_flash_inst != noone) {
	if (instance_exists(light_muzzle_flash_inst)) {
		// Deltatime Calc
		var temp_deltatime = global.deltatime;
		if (use_realdeltatime) {
			temp_deltatime = global.realdeltatime;
		}

		// Weapon Position
		var temp_x = x + recoil_offset_x;
		var temp_y = y + recoil_offset_y;

		// Weapon Scaling & Rotation
		var temp_weapon_rotation = weapon_rotation + recoil_angle_shift;

		// Calculate Weapon Muzzle Position
		var temp_muzzle_direction = point_direction(0, 0, muzzle_x * weapon_xscale, muzzle_y * weapon_yscale);
		var temp_muzzle_distance = point_distance(0, 0, muzzle_x * weapon_xscale, muzzle_y * weapon_yscale);

		var temp_muzzle_x = temp_x + lengthdir_x(temp_muzzle_distance, temp_weapon_rotation + temp_muzzle_direction);
		var temp_muzzle_y = temp_y + lengthdir_y(temp_muzzle_distance, temp_weapon_rotation + temp_muzzle_direction);
	
		// Position Light Source at Muzzle
		light_muzzle_flash_inst.x = temp_muzzle_x;
		light_muzzle_flash_inst.y = temp_muzzle_y;
		
		// Muzzle Flash Properties
		light_muzzle_flash_inst.angle = temp_weapon_rotation;
		light_muzzle_flash_inst.intensity = clamp(light_muzzle_flash_inst.intensity - (light_muzzle_flash_spd * temp_deltatime), 0, 1);
		light_muzzle_flash_inst.range = (light_muzzle_flash_inst.intensity / light_muzzle_flash_intensity) * light_muzzle_flash_radius;
		light_muzzle_flash_inst.fov = (light_muzzle_flash_inst.intensity / light_muzzle_flash_intensity) * 270;
		
		// Destroy Muzzle Flash
		if (light_muzzle_flash_inst.intensity <= 0) {
			instance_destroy(light_muzzle_flash_inst);
			light_muzzle_flash_inst = noone;
		}
	}
	else {
		light_muzzle_flash_inst = noone;
	}
}

// Inactive Skip
if (!active) {
	return;
}

// Reset Gun Properties
aiming = false;
gun_spin = false;