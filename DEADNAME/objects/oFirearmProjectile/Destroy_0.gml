/// @description Firearm Projectile Destroy Event
// Destroys the Firearm Projectile

// Weapon Behaviour
if (weapon_obj != noone) {
	if (instance_exists(weapon_obj)) {
		// Instantiate Hit Effect
		if (weapon_obj.hit_effect) {
			// Random Variables
			var temp_random_sign = random(1);
			if (temp_random_sign <= 0.5) {
				temp_random_sign = -1;
			}
			else {
				temp_random_sign = 1;
			}
			var temp_random_size = random_range(weapon_obj.hit_effect_scale_min, weapon_obj.hit_effect_scale_max);
					
			// Set Hit Effect Entry
			ds_list_add(weapon_obj.hit_effect_timer, weapon_obj.hit_effect_duration);
			ds_list_add(weapon_obj.hit_effect_index, irandom_range(0, sprite_get_number(weapon_obj.hit_effect_sprite) - 1));
			ds_list_add(weapon_obj.hit_effect_sign, temp_random_sign);
			ds_list_add(weapon_obj.hit_effect_xpos, x);
			ds_list_add(weapon_obj.hit_effect_ypos, y);
			ds_list_add(weapon_obj.hit_effect_xscale, temp_random_size);
			ds_list_add(weapon_obj.hit_effect_yscale, temp_random_size);
			if (weapon_obj.hit_effect_random_angle == -1) {
				ds_list_add(weapon_obj.hit_effect_rotation, irandom(3) * 90);
			}
			else {
				ds_list_add(weapon_obj.hit_effect_rotation, irandom_range(-weapon_obj.hit_effect_random_angle, weapon_obj.hit_effect_random_angle));
			}
		}
	}
}