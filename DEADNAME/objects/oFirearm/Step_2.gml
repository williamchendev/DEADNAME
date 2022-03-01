/// @description Firearm Update
// Calculates the behaviour of the firearm object

// Inactive Skip
if (!active) {
	return;
}

// Inherit the parent event
event_inherited();

// Deltatime Calc
var temp_deltatime = global.deltatime;
if (use_realdeltatime) {
	temp_deltatime = global.realdeltatime;
}

// Weapon Physics
if (!phy_active) {
	phy_rotation = weapon_rotation + recoil_angle_shift;
	phy_position_x = lerp(x, x_position, move_spd * temp_deltatime);
	phy_position_y = lerp(y, y_position, move_spd * temp_deltatime);
}

// Weapon Position
var temp_x = x + recoil_offset_x;
var temp_y = y + recoil_offset_y;

// Weapon Scaling & Rotation
var temp_weapon_rotation = weapon_rotation + recoil_angle_shift;

// Set Fire Mode Behaviour
if (attack and (!bolt_action or bolt_action_loaded)) {
	// Calculate Weapon Muzzle Position
	var temp_muzzle_direction = point_direction(0, 0, muzzle_x * weapon_xscale, muzzle_y * weapon_yscale);
	var temp_muzzle_distance = point_distance(0, 0, muzzle_x * weapon_xscale, muzzle_y * weapon_yscale);

	var temp_muzzle_x = temp_x + lengthdir_x(temp_muzzle_distance, temp_weapon_rotation + temp_muzzle_direction);
	var temp_muzzle_y = temp_y + lengthdir_y(temp_muzzle_distance, temp_weapon_rotation + temp_muzzle_direction);

	// Door Muzzle Clip Check
	var temp_muzzle_door_clipping = false;
	var temp_door_instance = instance_position(temp_muzzle_x, temp_muzzle_y, oDoor);
	if (temp_door_instance != noone) {
		if (!temp_door_instance.door_touched) {
			var temp_door_instance_x = temp_door_instance.x + ((sprite_get_width(temp_door_instance.end_panel_sprite) / 2) * sign(temp_x - temp_door_instance.x));
			if (sign(temp_x - temp_door_instance_x) != sign(temp_muzzle_x - temp_door_instance_x)) {
				temp_muzzle_door_clipping = true;
			}
		}
	}
	
	// Attack Variable Behaviour
	attack = false;
	if (!temp_muzzle_door_clipping) {
		if (bullets > 0) {
			if (click) {
				bursts = min(max(burst, 1), bullets);
				bursts_timer = 0;
				bullets -= bursts;
			}
			else {
				bursts_timer -= temp_deltatime;
				if (bursts_timer <= 0) {
					bursts = min(max(burst, 1), bullets);
					bursts_timer = 0;
					bullets -= bursts;
				}
			}
			bolt_action_loaded = false;
		}
	}
}
else {
	if (!click) {
		bursts_timer = 0;
	}
}

// Clear Trajectory Data
projectile_trajectory_distance = 0;
ds_list_clear(projectile_obj_x_trajectory);
ds_list_clear(projectile_obj_y_trajectory);

// Firearm Behaviour
if (aiming) {
	aim = lerp(aim, 1, aim_spd * temp_deltatime);
	var temp_accuracy = clamp((accuracy - accuracy_peak) * (1 - aim), 0, 360 - accuracy_peak) + accuracy_peak;
	if (temp_accuracy <= accuracy_peak + 0.1) {
		aim = 1;
	}
	aim_hip_max = aim;
	
	// Bullet Trajectory
	if (projectile_obj != noone and bullets > 0) {
		// Trajectory Aiming Reticle Animation
		projectile_trajectory_draw_val += temp_deltatime * projectile_trajectory_aim_reticle_spd;
		if (projectile_trajectory_draw_val > projectile_trajectory_aim_reticle_height + projectile_trajectory_aim_reticle_space) {
			projectile_trajectory_draw_val = projectile_trajectory_draw_val mod (projectile_trajectory_aim_reticle_height + projectile_trajectory_aim_reticle_space);
		}
		
		// Calculate Weapon Muzzle Position
		var temp_muzzle_direction = point_direction(0, 0, muzzle_x * weapon_xscale, muzzle_y * weapon_yscale);
		var temp_muzzle_distance = point_distance(0, 0, muzzle_x * weapon_xscale, muzzle_y * weapon_yscale);
	
		var temp_trajectory_x = temp_x + lengthdir_x(temp_muzzle_distance, temp_weapon_rotation + temp_muzzle_direction);
		var temp_trajectory_y = temp_y + lengthdir_y(temp_muzzle_distance, temp_weapon_rotation + temp_muzzle_direction);
	
		// Check For Trajectory Collision
		var i = 0;
		var temp_trajectory_hit = false;
		var temp_trajectory_gravity = 0;
	
		ds_list_add(projectile_obj_x_trajectory, temp_trajectory_x);
		ds_list_add(projectile_obj_y_trajectory, temp_trajectory_y);
		projectile_trajectory_distance = projectile_trajectory_distance_limit;
		while (i < projectile_trajectory_distance_limit) {
			// Find Target Position
			var temp_trajectory_start_x = temp_trajectory_x;
			var temp_trajectory_start_y = temp_trajectory_y;
			var temp_trajectory_end_x = temp_trajectory_x + lengthdir_x(projectile_spd, temp_weapon_rotation);
			var temp_trajectory_end_y = temp_trajectory_y + temp_trajectory_gravity + lengthdir_y(projectile_spd, temp_weapon_rotation);
			temp_trajectory_gravity += projectile_gravity;
		
			// Trajectory Path Calculation
			var temp_trajectory_path_distance = point_distance(temp_trajectory_start_x, temp_trajectory_start_y, temp_trajectory_end_x, temp_trajectory_end_y);
			for (var q = 0; q <= temp_trajectory_path_distance; q++) {
				var temp_trajectory_lerp_val = q / temp_trajectory_path_distance;
				var temp_trajectory_mid_x = lerp(temp_trajectory_start_x, temp_trajectory_end_x, temp_trajectory_lerp_val);
				var temp_trajectory_mid_y = lerp(temp_trajectory_start_y, temp_trajectory_end_y, temp_trajectory_lerp_val);
			
				temp_trajectory_x = temp_trajectory_mid_x;
				temp_trajectory_y = temp_trajectory_mid_y;
				if (collision_point(temp_trajectory_mid_x, temp_trajectory_mid_y, oSolid, true, true)) {
					// Set Hit Event
					temp_trajectory_hit = true;
					break;
				}
			
				// Index Projectile Trajectory and Increment
				if (i mod projectile_trajectory_distance_index == 0) {
					ds_list_add(projectile_obj_x_trajectory, temp_trajectory_x);
					ds_list_add(projectile_obj_y_trajectory, temp_trajectory_y);
				}
				i++;
			}
		
			// Hit Calculation
			if (temp_trajectory_hit) {
				ds_list_add(projectile_obj_x_trajectory, temp_trajectory_x);
				ds_list_add(projectile_obj_y_trajectory, temp_trajectory_y);
				projectile_trajectory_distance = i;
				break;
			}
		}
	}
}
else {
	aim = lerp(aim, clamp(aim_hip_max - 0.4, 0, 1), (aim_spd * 0.7) * temp_deltatime);
}

// Fire Behaviour
if (bursts > 0) {
	bursts_timer -= temp_deltatime;
	if (bursts_timer <= 0) {
		// Burst Behaviour
		bursts--;
		bursts_timer = burst_delay
	
		// Projectiles
		for (var i = 0; i < projectiles; i++) {
			// Direction
			var temp_accuracy = (clamp((accuracy - accuracy_peak) * (1 - aim), 0, 360 - accuracy_peak) + accuracy_peak) / 2;
			var temp_hitscan_angle = temp_weapon_rotation + random_range(-temp_accuracy, temp_accuracy);
			
			// Position
			var temp_muzzle_direction = point_direction(0, 0, muzzle_x * weapon_xscale, muzzle_y * weapon_yscale);
			var temp_muzzle_distance = point_distance(0, 0, muzzle_x * weapon_xscale, muzzle_y * weapon_yscale) - 2;

			var temp_muzzle_x = temp_x + lengthdir_x(temp_muzzle_distance, temp_weapon_rotation + temp_muzzle_direction);
			var temp_muzzle_y = temp_y + lengthdir_y(temp_muzzle_distance, temp_weapon_rotation + temp_muzzle_direction);
			
			// Disable Door Colliders
			var temp_doors_active = noone;
			for (var l = 0; l < instance_number(oDoor); l++) {
				var temp_door_inst = instance_find(oDoor, l);
				if (instance_exists(temp_door_inst.door_solid)) {
					if (temp_door_inst.door_solid_active) {
						temp_doors_active[l] = temp_door_inst.door_solid;
						instance_deactivate_object(temp_door_inst.door_solid);
					}
				}
			}
			
			// Bullet-Object/Raycast Behaviour
			if (projectile_obj == noone) {
				// Raycast
				var temp_hit_diceroll = random(1);
				if (player_mode) {
					temp_hit_diceroll = 0;
				}
			
				var temp_collision_array_miss = noone;
				if (random(1) <= 0.5) {
					temp_collision_array_miss[0] = oMaterial;
				}
			
				var temp_raycast_data = noone;
				while (true) {
					// Raycast Variables
					var temp_collision_array = noone;
					var temp_raycast_origin_x = temp_muzzle_x;
					var temp_raycast_origin_y = temp_muzzle_y;
				
					// Close Range Raycast
					temp_collision_array = temp_collision_array_miss;
					if (temp_hit_diceroll <= close_range_hit_chance) {
						temp_collision_array = collider_array_hit;
					}
				
					temp_raycast_data = raycast_combat_line(temp_raycast_origin_x, temp_raycast_origin_y, temp_hitscan_angle, close_range_radius, temp_collision_array, ignore_id);
					if (temp_raycast_data[4] == noone) {
						temp_raycast_origin_x = temp_muzzle_x + (close_range_radius * cos(degtorad(temp_hitscan_angle)));
						temp_raycast_origin_y = temp_muzzle_y + (close_range_radius * -sin(degtorad(temp_hitscan_angle)));
					}
					else {
						break;
					}
				
					// Mid Range Raycast
					temp_collision_array = temp_collision_array_miss;
					if (temp_hit_diceroll <= mid_range_hit_chance) {
						temp_collision_array = collider_array_hit;
					}
				
					temp_raycast_data = raycast_combat_line(temp_raycast_origin_x, temp_raycast_origin_y, temp_hitscan_angle, mid_range_radius - close_range_radius, temp_collision_array, ignore_id);
					temp_raycast_data[0] += close_range_radius;
					if (temp_raycast_data[4] == noone) {
						temp_raycast_origin_x = temp_muzzle_x + (mid_range_radius * cos(degtorad(temp_hitscan_angle)));
						temp_raycast_origin_y = temp_muzzle_y + (mid_range_radius * -sin(degtorad(temp_hitscan_angle)));
					}
					else {
						break;
					}
			
					// Far Range Raycast
					temp_collision_array = temp_collision_array_miss;
					if (temp_hit_diceroll <= far_range_hit_chance) {
						temp_collision_array = collider_array_hit;
					}
				
					temp_raycast_data = raycast_combat_line(temp_raycast_origin_x, temp_raycast_origin_y, temp_hitscan_angle, far_range_radius - mid_range_radius, temp_collision_array, ignore_id);
					temp_raycast_data[0] += mid_range_radius;
					if (temp_raycast_data[4] == noone) {
						temp_raycast_origin_x = temp_muzzle_x + (far_range_radius * cos(degtorad(temp_hitscan_angle)));
						temp_raycast_origin_y = temp_muzzle_y + (far_range_radius * -sin(degtorad(temp_hitscan_angle)));
					}
					else {
						break;
					}
			
					// Sniper Range Raycast
					temp_collision_array = temp_collision_array_miss;
					if (temp_hit_diceroll <= sniper_range_hit_chance) {
						temp_collision_array = collider_array_hit;
					}
				
					temp_raycast_data = raycast_combat_line(temp_raycast_origin_x, temp_raycast_origin_y, temp_hitscan_angle, range - far_range_radius, temp_collision_array, ignore_id);
					temp_raycast_data[0] += far_range_radius;
				
					break;
				}
				
				// Raycast Flash
				ds_list_add(flash_xposition, temp_muzzle_x);
				ds_list_add(flash_yposition, temp_muzzle_y);
				
				ds_list_add(flash_direction, temp_hitscan_angle);
				ds_list_add(flash_timer, flash_delay);
			
				if (muzzle_flash_sprite != noone) {
					if (i == 0) {
						ds_list_add(flash_imageindex, random_range(0, sprite_get_number(muzzle_flash_sprite)));
					}
					else {
						ds_list_add(flash_imageindex, -1);
					}
				}
			
				// Hit Calculation
				if (temp_raycast_data[4] != noone) {
					// Check Hit Collider Object Type
					if (temp_raycast_data[3] == oUnit) {
						// Unit Calculation
						var temp_unit = temp_raycast_data[4];
						temp_unit.health_points -= damage;
						temp_unit.health_points = clamp(temp_unit.health_points, 0, temp_unit.max_health_points);
					
						// Blood Effect
						create_unit_blood(temp_unit, clamp(temp_raycast_data[1], temp_unit.bbox_left, temp_unit.bbox_right), clamp(temp_raycast_data[2], temp_unit.bbox_top, temp_unit.bbox_bottom), temp_hitscan_angle);
					
						// Instantiate Hit Effect
						if (hit_effect) {
							// Random Variables
							var temp_random_sign = random(1);
							if (temp_random_sign <= 0.5) {
								temp_random_sign = -1;
							}
							else {
								temp_random_sign = 1;
							}
							var temp_random_size = random_range(hit_effect_scale_min, hit_effect_scale_max);
					
							// Set Hit Effect Entry
							ds_list_add(hit_effect_timer, hit_effect_duration);
							ds_list_add(hit_effect_index, irandom_range(0, sprite_get_number(hit_effect_sprite) - 1));
							ds_list_add(hit_effect_sign, temp_random_sign);
							ds_list_add(hit_effect_xpos, temp_raycast_data[1]);
							ds_list_add(hit_effect_ypos, temp_raycast_data[2]);
							ds_list_add(hit_effect_xscale, temp_random_size);
							ds_list_add(hit_effect_yscale, temp_random_size);
							if (hit_effect_random_angle == -1) {
								ds_list_add(hit_effect_rotation, irandom(3) * 90);
							}
							else {
								ds_list_add(hit_effect_rotation, irandom_range(-hit_effect_random_angle, hit_effect_random_angle));
							}
						}
			
						// Ragdoll Effect
						if (temp_unit.health_points == 0) {
							temp_unit.force_applied = true;
							temp_unit.force_x = temp_raycast_data[1];
							temp_unit.force_y = temp_raycast_data[2];
							temp_unit.force_xvector = cos(degtorad(temp_hitscan_angle)) * 15;
							temp_unit.force_yvector = sin(degtorad(temp_hitscan_angle)) * 15;
						}
					}
					else if (temp_raycast_data[3] == oMaterial) {
						// Instantiate Hit Effect
						if (hit_effect) {
							// Random Variables
							var temp_random_sign = random(1);
							if (temp_random_sign <= 0.5) {
								temp_random_sign = -1;
							}
							else {
								temp_random_sign = 1;
							}
							var temp_random_size = random_range(hit_effect_scale_min, hit_effect_scale_max);
					
							// Set Hit Effect Entry
							ds_list_add(hit_effect_timer, hit_effect_duration);
							ds_list_add(hit_effect_index, irandom_range(0, sprite_get_number(hit_effect_sprite) - 1));
							ds_list_add(hit_effect_sign, temp_random_sign);
							ds_list_add(hit_effect_xpos, temp_raycast_data[1]);
							ds_list_add(hit_effect_ypos, temp_raycast_data[2]);
							ds_list_add(hit_effect_xscale, temp_random_size);
							ds_list_add(hit_effect_yscale, temp_random_size);
							if (hit_effect_random_angle == -1) {
								ds_list_add(hit_effect_rotation, irandom(3) * 90);
							}
							else {
								ds_list_add(hit_effect_rotation, irandom_range(-hit_effect_random_angle, hit_effect_random_angle));
							}
						}
					
						// Add Material Damage
						temp_raycast_data[4].material_health = max(0, temp_raycast_data[4].material_health - material_damage);
						material_add_damage(temp_raycast_data[4], material_damage_sprite, irandom(sprite_get_number(material_damage_sprite)), temp_raycast_data[1], temp_raycast_data[2], 1, 1, random(360));
					}
				}
				
				// Bullet Trail
				var temp_bullet_trail_length = temp_raycast_data[0];
				ds_list_add(flash_length, temp_bullet_trail_length);
			}
			else {
				// Bullet Object Creation
				var temp_bullet_obj = instance_create_layer(temp_muzzle_x, temp_muzzle_y, layer, projectile_obj);
				temp_bullet_obj.weapon_obj = id;
				temp_bullet_obj.ignore_id = ignore_id;
				temp_bullet_obj.bullet_spd = projectile_spd;
				temp_bullet_obj.bullet_direction = temp_hitscan_angle;
				temp_bullet_obj.bullet_gravity = projectile_gravity;
				temp_bullet_obj.bullet_realdeltatime = use_realdeltatime;
				temp_bullet_obj.bullet_alert_x = x_position;
				temp_bullet_obj.bullet_alert_y = y_position;
				
				// Raycast Flash
				ds_list_add(flash_xposition, temp_muzzle_x);
				ds_list_add(flash_yposition, temp_muzzle_y);
				
				ds_list_add(flash_direction, temp_hitscan_angle);
				ds_list_add(flash_timer, flash_delay);
			
				if (muzzle_flash_sprite != noone) {
					if (i == 0) {
						ds_list_add(flash_imageindex, random_range(0, sprite_get_number(muzzle_flash_sprite)));
					}
					else {
						ds_list_add(flash_imageindex, -1);
					}
				}
				ds_list_add(flash_length, 0);
			}
			
			// Re-enable All Door Colliders
			for (var l = 0; l < array_length_1d(temp_doors_active); l++) {
				instance_activate_object(temp_doors_active[l]);
			}
		}
		
		// Sound
		if (!silent) {
			// Index all oUnitAI objects within Firearm Sound Radius
			var temp_sound_radius_unit_list = ds_list_create();
			var temp_sound_radius_units_num = collision_circle_list(temp_x, temp_y, sound_radius, oUnitAI, false, true, temp_sound_radius_unit_list, false);
			
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
							temp_squad_inst.squad_alert_x = temp_x;
							temp_squad_inst.squad_alert_y = temp_y;
							break;
						}
					}
					
					// Alert Unit Individual
					if (!temp_squad_alerted) {
						temp_sound_unit.sight_unit_seen = true;
						temp_sound_unit.sight_unit_seen_x = temp_x;
						temp_sound_unit.sight_unit_seen_y = temp_y;
						temp_sound_unit.alert = 1;
					}
				}
			}
			
			// Garbage Collection
			ds_list_destroy(temp_sound_radius_unit_list);
		}
		
		// Bullet Cases
		if (bulletcase_obj != noone) {
			bullet_cases++;
		}
		
		// Burst End
		if (bursts <= 0) {
			// Reset Aim
			aim = 0;
	
			// Calculate Recoil
			recoil_angle_shift += recoil_angle * weapon_yscale;
			recoil_velocity = 0;
			recoil_timer = recoil_delay;
			recoil_position_direction = -180 + random_range(-recoil_direction, recoil_direction);
		}
	}
}
player_mode = false;

// Flash
for (var f = ds_list_size(flash_timer) - 1; f >= 0; f--) {
	var temp_flash_timer = ds_list_find_value(flash_timer, f);
	temp_flash_timer -= temp_deltatime;
	if (temp_flash_timer <= 0) {
		if (!instance_exists(oKnockout)) {
			ds_list_delete(flash_timer, f);
			ds_list_delete(flash_length, f);
			ds_list_delete(flash_direction, f);
			ds_list_delete(flash_xposition, f);
			ds_list_delete(flash_yposition, f);
			ds_list_delete(flash_imageindex, f);
			continue;
		}
		else {
			temp_flash_timer = 0;
		}
	}
	ds_list_set(flash_timer, f, temp_flash_timer);
}

// Recoil
if (recoil_timer > 0) {
	recoil_timer -= temp_deltatime;
	recoil_velocity += recoil_spd * temp_deltatime;
	recoil_offset_x += lengthdir_x(recoil_velocity, recoil_position_direction + temp_weapon_rotation) * temp_deltatime;
	recoil_offset_y += lengthdir_y(recoil_velocity, recoil_position_direction + temp_weapon_rotation) * temp_deltatime;
	
	var temp_recoil_distance = point_distance(recoil_offset_x, recoil_offset_y, 0, 0);
	if (temp_recoil_distance > recoil_clamp) {
		recoil_offset_x = lengthdir_x(recoil_clamp, recoil_position_direction + temp_weapon_rotation);
		recoil_offset_y = lengthdir_y(recoil_clamp, recoil_position_direction + temp_weapon_rotation);
	}
}
else {
	aiming = true;
	recoil_angle_shift = lerp(recoil_angle_shift, 0, angle_adjust_spd * temp_deltatime);
	recoil_offset_x = lerp(recoil_offset_x, 0, lerp_spd * temp_deltatime);
	recoil_offset_y = lerp(recoil_offset_y, 0, lerp_spd * temp_deltatime);
}

// Gun Spin Behaviour
if (gun_spin) {
	gun_spin_angle += (360 * temp_deltatime * gun_spin_spd) * sign(weapon_yscale);
	gun_spin_timer += temp_deltatime * gun_spin_spd;
}

// Break Action Behaviour
if (break_action) {
	if (image_index == 0) {
		break_action_angle_val = 0;
	}
	else {
		break_action_angle_val = lerp(break_action_angle_val, 1, angle_adjust_spd * temp_deltatime);
	}
}

// Bullet Cases
if (bullet_cases != 0) {
	if (!gun_spin_reload or gun_spin) {
		if (!bolt_action or (!bolt_action_loaded and image_index > 0)) {
			if (!break_action or (image_index > 0)) {
				for (var c = 0; c < bullet_cases; c++) {
					var temp_eject_direction = point_direction(0, 0, case_eject_x * weapon_xscale, case_eject_y * weapon_yscale);
					var temp_eject_distance = point_distance(0, 0, case_eject_x * weapon_xscale, case_eject_y * weapon_yscale);
		
					var temp_eject_x = x + recoil_offset_x + lengthdir_x(temp_eject_distance, temp_weapon_rotation + temp_eject_direction);
					var temp_eject_y = y + recoil_offset_y + lengthdir_y(temp_eject_distance, temp_weapon_rotation + temp_eject_direction);
		
					var temp_case = instance_create_depth(temp_eject_x, temp_eject_y, layer_get_depth(layer), bulletcase_obj);
					temp_case.case_direction = (weapon_rotation + ((-90 * weapon_yscale) - 180)) + (random_range(0, case_direction) * weapon_yscale);
					if (gun_spin_reload) {
						temp_case.case_direction = 270 + random_range(-10, 10);
					}
					temp_case.image_xscale = weapon_yscale;
					
					with (temp_case) {
						case_direction = degtorad(case_direction);
						physics_apply_impulse(x, y, cos(case_direction) * other.case_spd, -sin(case_direction) * other.case_spd);
						physics_apply_angular_impulse(sign(image_xscale) * other.case_angle_spd);
					}
				}
				bullet_cases = 0;
			}
		}
	}
}

// Weapon Hit Effect Calculation
if (ds_list_size(hit_effect_timer) > 0) {
	for (var l = ds_list_size(hit_effect_timer) - 1; l >= 0; l--) {
		// Calculate Hit Effect Duration
		var temp_hit_fx_time = ds_list_find_value(hit_effect_timer, l);
		temp_hit_fx_time -= temp_deltatime;
		ds_list_replace(hit_effect_timer, l, temp_hit_fx_time);
		
		// Delete Hit Effect Index
		if (temp_hit_fx_time <= 0) {
			ds_list_delete(hit_effect_timer, l);
			ds_list_delete(hit_effect_index, l);
			ds_list_delete(hit_effect_sign, l);
			ds_list_delete(hit_effect_xpos, l);
			ds_list_delete(hit_effect_ypos, l);
			ds_list_delete(hit_effect_xscale, l);
			ds_list_delete(hit_effect_yscale, l);
			ds_list_delete(hit_effect_rotation, l);
		}
	}
}

// Knockout Hit Effect
if (instance_exists(oKnockout)) {
	knockout_hit_effect_offset += temp_deltatime;
	knockout_hit_effect_xscale += temp_deltatime * 0.1;
	knockout_hit_effect_yscale -= temp_deltatime * 0.05;
	if (knockout_hit_effect_index == -1) {
		knockout_hit_effect_index = irandom_range(0, sprite_get_number(sImpact_Blood));
		knockout_hit_effect_xscale = 0.8;
		knockout_hit_effect_yscale = 1;
		if (random_range(0, 1) <= 0.5) {
			knockout_hit_effect_yscale = -1;
		}
		knockout_hit_effect_yscale *= random_range(0.7, 1);
		knockout_hit_effect_sign = sign(knockout_hit_effect_yscale);
	}
}
else {
	knockout_hit_effect_index = -1;
	knockout_hit_effect_offset = 0;
}