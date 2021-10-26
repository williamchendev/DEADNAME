/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Deltatime Calc
var temp_deltatime = global.deltatime;
if (use_realdeltatime) {
	temp_deltatime = global.realdeltatime;
}

/// Weapon Position
x = lerp(x, x_position, move_spd * temp_deltatime);
y = lerp(y, y_position, move_spd * temp_deltatime);

// Sprite Reset
image_xscale = sign(image_xscale);
image_yscale = sign(image_yscale);

// Melee Weapon Behaviour
if (!weapon_arc_start) {
	// Weapon Set Attack
	if (attack) {
		weapon_arc_start = true;
	}
}
else {
	attack = true;
	if (!weapon_arc_end) {
		weapon_arc_value = lerp(weapon_arc_value, 1, weapon_arc_forward_spd * temp_deltatime);
		if (weapon_arc_value >= 0.95) {
			weapon_arc_end = true;
			weapon_arc_pause = true;
			weapon_arc_pause_timer = weapon_arc_pause_time;
			weapon_arc_value = 1;
		}
	}
	else if (!weapon_arc_pause) {
		weapon_arc_value = lerp(weapon_arc_value, 0, weapon_arc_backward_spd * temp_deltatime);
		if (weapon_arc_value <= 0.05) {
			weapon_arc_start = false;
			weapon_arc_end = false;
			weapon_arc_value = 0;
			
			attack = false;
		}
	}
	else {
		// Weapon Arc Hit Pause Effect
		weapon_arc_damage = true;
		
		// Weapon Arc Pause Timer
		weapon_arc_pause_timer -= temp_deltatime;
		if (weapon_arc_pause_timer <= 0) {
			weapon_arc_pause = false;
		}
	}
}

// Weapon Angle
image_xscale = -1;
image_angle = weapon_rotation;
image_angle += angle_difference(image_angle, image_angle + (weapon_arc_value * 179));

image_yscale = 1;
if (abs(angle_difference(weapon_rotation, 180)) <= 90) {
	image_yscale = -1;
}

/*
image_yscale = 1;
var temp_facing_left = 1;
if (angle_difference(image_angle, 180) < 90) {
	image_yscale = -1;
	temp_facing_left = -1;
}

*/

// Sprite Behaviour
if (weapon_arc_value != 0) {
	sprite_index = weapon_sprite;
	var temp_weapon_image_index = clamp(abs(((weapon_arc_value * 2) - 1) * (sprite_get_number(weapon_sprite))), 0, sprite_get_number(weapon_sprite) - 1);
	image_index = temp_weapon_image_index;
}

if (image_index == 0) {
	sprite_index = weapon_idle_sprite;
}

// Damage Enemy Behaviour
if (weapon_arc_damage) {
	if (place_meeting(x, y, oUnit)) {
		var temp_unit_list = ds_list_create();
		var temp_unit_num = instance_place_list(x, y, oUnit, temp_unit_list, true);
		if (temp_unit_num > 0) {
			for (var i = 0; i < ds_list_size(temp_unit_list); i++) {
				// Unit Calculation
				var temp_unit = ds_list_find_value(temp_unit_list, i);
				if (temp_unit.team_id == ignore_id) {
					continue;
				}
					
				// Unit Damage
				melee_found_hit = true;
				temp_unit.health_points -= damage;
				temp_unit.health_points = clamp(temp_unit.health_points, 0, temp_unit.max_health_points);
				if (temp_unit.health_points == 0) {
					temp_unit.death_dialogue = false;
				}
				
				// Unit Hit Position
				var temp_hit_first_pos_found = false;
				var temp_hit_first_xpos = x + lengthdir_x(sprite_get_width(weapon_sprite) * sign(image_xscale), image_angle);
				var temp_hit_first_ypos = y + lengthdir_y(sprite_get_width(weapon_sprite) * sign(image_xscale), image_angle);
				var temp_hit_last_xpos = x + lengthdir_x(sprite_get_width(weapon_sprite) * sign(image_xscale), image_angle);
				var temp_hit_last_ypos = y + lengthdir_y(sprite_get_width(weapon_sprite) * sign(image_xscale), image_angle);
				for (var q = 0; q <= sprite_get_width(weapon_sprite); q++) {
					if (collision_point(x + lengthdir_x(q * sign(image_xscale), image_angle), y + lengthdir_y(q * sign(image_xscale), image_angle), temp_unit, false, true)) {
						if (!temp_hit_first_pos_found) {
							temp_hit_first_pos_found = true;
							temp_hit_first_xpos = x + lengthdir_x(q * sign(image_xscale), image_angle);
							temp_hit_first_ypos = y + lengthdir_y(q * sign(image_xscale), image_angle);
						}
						temp_hit_last_xpos = x + lengthdir_x(q * sign(image_xscale), image_angle);
						temp_hit_last_ypos = y + lengthdir_y(q * sign(image_xscale), image_angle);
					}
				}
				var temp_hit_xpos = lerp(temp_hit_first_xpos, temp_hit_last_xpos, 0.5);
				var temp_hit_ypos = lerp(temp_hit_first_ypos, temp_hit_last_ypos, 0.5);
				
				// Blood Effect
				if (temp_unit.blood) {
					if (temp_unit.blood_effect != noone) {
						// Create and Index Blood Sticker
						var temp_unit_blood_inst = instance_create_layer(temp_hit_xpos, temp_hit_ypos, temp_unit.layers[4], temp_unit.blood_effect);
						ds_list_add(temp_unit.blood_list, temp_unit_blood_inst);
							
						// Apply Blood Sticker Settings
						temp_unit_blood_inst.unit_inst = temp_unit;
						temp_unit_blood_inst.blood_x = temp_unit.x - temp_hit_xpos;
						temp_unit_blood_inst.blood_y = temp_unit.y - temp_hit_ypos;
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
							var temp_splat_blood_inst = instance_create_layer(temp_hit_xpos, temp_hit_ypos, temp_unit.layers[4], oBloodEffect_Splatter);
							ds_list_add(temp_unit.blood_list, temp_splat_blood_inst);
							
							// Apply Blood Splat Settings
							temp_splat_blood_inst.unit_inst = temp_unit;
							temp_splat_blood_inst.blood_x = temp_unit.x - temp_hit_xpos;
							temp_splat_blood_inst.blood_y = temp_unit.y - temp_hit_ypos;
							temp_splat_blood_inst.blood_size = 0.9;
							temp_splat_blood_inst.image_blend = temp_unit.blood_color;
							
							// Create Blood Droplets
							if (!collision_point(temp_hit_xpos, temp_hit_ypos, oSolid, false, true)) {
								var temp_random_droplet_num = irandom_range(5, 12);
								for (var q = 0; q < temp_random_droplet_num; q++) {
									// Create and Index Blood Droplet
									var temp_droplet_blood_inst = instance_create_layer(temp_hit_xpos, temp_hit_ypos, temp_unit.layers[4], oBloodEffect_Droplet);
									ds_list_add(temp_unit.blood_list, temp_droplet_blood_inst);
								
									// Apply Blood Droplet Settings
									temp_droplet_blood_inst.blood_size = random_range(0.3, 1.2);
									temp_droplet_blood_inst.image_blend = temp_unit.blood_color;
									var temp_blood_droplet_direction = sign(temp_hit_xpos - x);
									if (temp_blood_droplet_direction == 0) {
										temp_blood_droplet_direction = 1;
									}
									temp_droplet_blood_inst.case_direction = (random_range(45, 15) * temp_blood_droplet_direction) + 90;
								}
							}
						}
					}
				}
			
				// Ragdoll Effect
				if (temp_unit.health_points == 0) {
					temp_unit.force_applied = true;
					temp_unit.force_x = temp_hit_xpos;
					temp_unit.force_y = temp_hit_ypos;
					temp_unit.force_xvector = cos(degtorad(weapon_rotation)) * 35;
					temp_unit.force_yvector = sin(degtorad(weapon_rotation)) * 35;
				}
				
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
					ds_list_add(hit_effect_xpos, temp_hit_xpos);
					ds_list_add(hit_effect_ypos, temp_hit_ypos);
					ds_list_add(hit_effect_xscale, temp_random_size);
					ds_list_add(hit_effect_yscale, temp_random_size);
					if (hit_effect_random_angle == -1) {
						ds_list_add(hit_effect_rotation, irandom(3) * 90);
					}
					else {
						ds_list_add(hit_effect_rotation, irandom_range(-hit_effect_random_angle, hit_effect_random_angle));
					}
				}
				
				// End weapon_arc
				if (!weapon_arc_continuous) {
					weapon_arc_value = 1;
					weapon_arc_pause = false;
					break;
				}
			}
		}
		ds_list_destroy(temp_unit_list);
		temp_unit_list = -1;
	}
	weapon_arc_damage = false;
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