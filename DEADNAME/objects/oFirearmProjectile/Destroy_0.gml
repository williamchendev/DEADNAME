/// @description Firearm Projectile Destroy Event
// Performs Firearm Projectile Destroy Behaviour

// Alert Units & Squads
var temp_sound_radius_unit_list = ds_list_create();
var temp_sound_radius_units_num = collision_circle_list(x, y, bullet_sound_radius, oUnitAI, false, true, temp_sound_radius_unit_list, false);
			
// Interate through Sound Radius Unit List
for (var q = 0; q < temp_sound_radius_units_num; q++) {
	var temp_sound_unit = ds_list_find_value(temp_sound_radius_unit_list, q);
	if (temp_sound_unit.team_id != ignore_id) {
		// Alert Unit Squad
		var temp_squad_alerted = false;
		for (var s = 0; s < instance_number(oSquadAI); s++) {
			var temp_squad_inst = instance_find(oSquadAI, s);
			if (temp_squad_inst.squad_id == temp_sound_unit.squad_id) {
				temp_squad_alerted = true;
				temp_squad_inst.squad_alert = true;
				temp_squad_inst.squad_alert_x = bullet_alert_x;
				temp_squad_inst.squad_alert_y = bullet_alert_y;
				break;
			}
		}
					
		// Alert Unit Individual
		if (!temp_squad_alerted) {
			temp_sound_unit.sight_unit_seen = true;
			temp_sound_unit.sight_unit_seen_x = bullet_alert_x;
			temp_sound_unit.sight_unit_seen_y = bullet_alert_y;
			temp_sound_unit.alert = 1;
		}
	}
}
			
// Garbage Collection
ds_list_destroy(temp_sound_radius_unit_list);

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