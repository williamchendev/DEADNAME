/// @description Unit Combat Update Event
// The combat calculations and behaviour of the Unit

// Check Weapon Type
firearm = false;
for (var i = 0; i < ds_list_size(inventory.weapons); i++) {
	// Find Indexed Weapon
	var temp_weapon_index = ds_list_find_value(inventory.weapons, i);
	// Find Equipped Weapon
	if (temp_weapon_index.equip) {
		// Set Weapon Type
		if (temp_weapon_index.weapon_type == "firearm") {
			firearm = true;
		}
		break;
	}
}

// Facing Behaviour
if (!pathing) {
	// Set Facing Target
	if (targeting and firearm) {
		if (!reload) {
			if (sign(target_x - x) != 0) {
				// Manually Set image_xscale to face target
				image_xscale = sign(target_x - x);
				draw_set_xscale_manual = true;
			}
		}
	}
}

// Physics, Pathfinding, & Unit Behaviour Inheritance
var temp_teleport = teleport;
event_inherited();

// Check Target Valid
if (pathing) {
	// Stop Targeting if walking in other Direction
	if (targeting) {
		if (sign(target_x - x) != sign(x_velocity)) {
			targeting = false;
		}
	}
}

// Limbs
if (limb[0] != noone) {
	limb[0].layer = layers[4];
	arm_right_angle_1 = limb[0].angle_1;
	arm_right_angle_2 = limb[0].angle_2;
}
if (limb[1] != noone) {
	limb[1].layer = layers[1];
	arm_left_angle_1 = limb[1].angle_1;
	arm_left_angle_2 = limb[1].angle_2;
}

var temp_limb_ambient_animation = noone;
for (var q = 0; q < limbs; q++) {
	limb[q].visible = false;
	temp_limb_ambient_animation[q] = false;
}

// Weapons
var temp_weapon = noone;
var temp_holstered_weapon_index = 0;
for (var i = 0; i < ds_list_size(inventory.weapons); i++) {
	// Find Indexed Weapon
	var temp_weapon_index = ds_list_find_value(inventory.weapons, i);
	
	// Weapon Behaviour
	if (instance_exists(temp_weapon_index)) {
		// Teleport
		if (temp_teleport) {
			aim_ambient_x = x + (draw_xscale * image_xscale * 50);
			aim_ambient_y = y + weapon_hip_y;
	
			temp_weapon_index.phy_position_x += teleport_x;
			temp_weapon_index.phy_position_y += teleport_y;
			temp_weapon_index.x_position += teleport_x;
			temp_weapon_index.y_position += teleport_y;
			temp_weapon_index.weapon_rotation = ((sign(image_xscale) * -90) + 90) + (sign(image_xscale) * 45);
		}
		
		// Equipped and Holstered Weapon Behaviour
		if (temp_weapon_index.equip) {
			// Equip Weapon
			temp_weapon = temp_weapon_index;
		}
		else {
			// Holstered Weapon
			var temp_holstered_weapon_sign = ((temp_holstered_weapon_index mod 2) * -2) + 1;
			var temp_holstered_weapon_angle = (((temp_holstered_weapon_index + 2) div 2) * 30) * sign(image_xscale);
			temp_holstered_weapon_angle = draw_angle + 90 + (temp_holstered_weapon_sign * temp_holstered_weapon_angle);
			temp_weapon_index.weapon_yscale = sign(temp_holstered_weapon_sign * -image_xscale);
			
			// Holstered Weapon Angle
			temp_weapon_index.weapon_rotation = temp_weapon_index.weapon_rotation mod 360;
			var temp_weapon_delta_angle = angle_difference(temp_weapon_index.weapon_rotation, temp_holstered_weapon_angle);
			temp_weapon_index.weapon_rotation = temp_weapon_index.weapon_rotation - (temp_weapon_delta_angle * temp_weapon_index.lerp_spd * global.deltatime);
			
			// Holstered Weapon Position
			var temp_holster_dis = point_distance(x, y, x, lerp(bbox_top, bbox_bottom, 0.5));
			var temp_holster_dir = point_direction(x, y, x, lerp(bbox_top, bbox_bottom, 0.5));
			var temp_holster_x = x + lengthdir_x(temp_holster_dis, temp_holster_dir + draw_angle);
			var temp_holster_y = y + (lengthdir_y(temp_holster_dis, temp_holster_dir + draw_angle) * draw_yscale);
			
			if (x_velocity != 0 and y_velocity == 0) {
				var temp_holster_move_val = image_index / sprite_get_number(sprite_index);
				if (abs(x_velocity) < spd) {
					temp_holster_move_val = (image_index * 0.5) / sprite_get_number(sprite_index);
				}
				temp_holster_y += weapon_holster_ambient_move_size * sin(temp_holster_move_val * 2 * pi);
			}
			else {
				if (image_index >= (sprite_get_number(sprite_index) / 2)) {
					temp_holster_y += weapon_holster_ambient_move_size * 0.5;
				}
			}
			
			temp_weapon_index.phy_position_x = temp_holster_x;
			temp_weapon_index.phy_position_y = temp_holster_y;
			temp_weapon_index.x_position = temp_holster_x;
			temp_weapon_index.y_position = temp_holster_y;
			
			// Increment Holstered Weapon Index
			temp_holstered_weapon_index++;
		}
		
		// Weapon Default Layer and Physics
		temp_weapon_index.layer = layers[0];
		temp_weapon_index.phy_active = false;
	}
}

// Equipped Weapon & Combat Unit Behaviour
layer = layers[2];
var temp_default_behaviour = false;
if (temp_weapon == noone) {
	// Disarmed Default Behaviour
	temp_default_behaviour = true;
}
else if (temp_weapon.weapon_type == "melee") {
	// Weapon, Body, & Arm Layers
	layer = layers[1];
	temp_weapon.layer = layers[3];
	limb[0].layer = layers[2];
	limb[1].layer = layers[4];
	
	// Melee Weapon Behaviour
	var temp_melee_swing_value = (temp_weapon.weapon_arc_value * (1 + limb_melee_arm_swing_length_mult)) - 1;
	if (!temp_weapon.attack) {
		// Non Attack Mode
		if (key_fire_press) {
			temp_weapon.attack = canmove;
			temp_weapon.ignore_id = team_id;
		}
		else if (key_aim_press) {
		
		}
	}
	else {
		limb[1].layer = layers[3];
		temp_weapon.layer = layers[4];
	}
	
	// Melee Weapon Pivot
	var temp_weapon_x = 0;
	var temp_weapon_y = 0;
	var temp_arm_length = 0;
	for (var l = 0; l < array_length_1d(limb_x); l++) {
		temp_weapon_x += limb_x[l];
	}
	temp_weapon_x = temp_weapon_x / l;
	for (var l = 0; l < array_length_1d(limb_y); l++) {
		temp_weapon_y += limb_y[l];
	}
	temp_weapon_y = temp_weapon_y / l;
	for (var l = 0; l < array_length_1d(limb); l++) {
		temp_arm_length += limb[l].limb_length;
	}
	temp_arm_length = round((temp_arm_length / l) * limb_melee_arm_length_mult);
	
	var temp_melee_weapon_pivot_distance = point_distance(0, 0, temp_weapon_x + weapon_melee_x, temp_weapon_y + weapon_melee_y);
	var temp_melee_weapon_pivot_direction = point_direction(0, 0, temp_weapon_x + weapon_melee_x, temp_weapon_y + weapon_melee_y);
	temp_weapon_x = lengthdir_x(temp_melee_weapon_pivot_distance, temp_melee_weapon_pivot_direction + draw_angle);
	temp_weapon_y = lengthdir_y(temp_melee_weapon_pivot_distance, temp_melee_weapon_pivot_direction + draw_angle);
	
	// Arm Offset Variables
	var temp_limb_run_move_offset_x = 0;
	if (x_velocity != 0) {
		// Limb Offsets
		temp_limb_run_move_offset_x = (sign(x_velocity) * spd);
	}
	else {
		// Face Targeting Direction
		if (targeting) {
			image_xscale = sign(target_x - x);
			if (image_xscale == 0) {
				image_xscale = 1;
			}
		}
	}
	
	// Melee Weapon Rotation
	var temp_weapon_rotation = 0;
	aim_ambient_x = lerp(aim_ambient_x, x + temp_weapon_x + (draw_xscale * image_xscale * 50), temp_weapon.lerp_spd * global.deltatime);
	aim_ambient_y = lerp(aim_ambient_y, y + temp_weapon_y, temp_weapon.lerp_spd * global.deltatime);
	if (!targeting) {
		// Ambient Aiming
		temp_weapon_rotation = point_direction(x + temp_weapon_x, y + temp_weapon_y, aim_ambient_x, aim_ambient_y);
	}
	else {
		temp_weapon_rotation = point_direction(x + temp_weapon_x, y + temp_weapon_y, target_x, target_y);
	}
	temp_weapon.image_xscale = sign(temp_melee_swing_value);
	//temp_arm_length = (1.5 - ((abs(angle_difference(temp_weapon_rotation, 90)) / 180) * 0.5)) * temp_arm_length;
	
	// Melee Weapon Rotation/Positioning Lerp Behaviour
	weapon_x = lerp(weapon_x, temp_weapon_x, temp_weapon.lerp_spd * global.deltatime);
	weapon_y = lerp(weapon_y, temp_weapon_y, temp_weapon.lerp_spd * global.deltatime);
	
	temp_weapon.weapon_rotation = temp_weapon.weapon_rotation mod 360;
	var temp_weapon_delta_angle = angle_difference(temp_weapon.weapon_rotation, temp_weapon_rotation);
	temp_weapon.weapon_rotation = temp_weapon.weapon_rotation - (temp_weapon_delta_angle * temp_weapon.lerp_spd * global.deltatime);
		
	var temp_weapon_distance = point_distance(0, 0, (draw_xscale * image_xscale * weapon_x), (draw_yscale * image_yscale * weapon_y));
	var temp_weapon_direction = point_direction(0, 0, (draw_xscale * image_xscale * weapon_x), (draw_yscale * image_yscale * weapon_y));
	temp_weapon.x_position = x + lengthdir_x(temp_weapon_distance, temp_weapon_direction + draw_angle) + temp_limb_run_move_offset_x;
	temp_weapon.y_position = y + lengthdir_y(temp_weapon_distance, temp_weapon_direction + draw_angle) - ((sin(degtorad(draw_angle)) * (bbox_left - bbox_right)) / 2);
	
	temp_weapon.x_position += lengthdir_x(temp_arm_length * temp_melee_swing_value, temp_weapon.weapon_rotation);
	temp_weapon.y_position += lengthdir_y(temp_arm_length * temp_melee_swing_value, temp_weapon.weapon_rotation);
	
	// Check Weapon & Arm Facing Down
	var temp_arms_down_facing = 90 - (abs(angle_difference(temp_weapon.weapon_rotation, 90)));
	if (abs(temp_arms_down_facing) <= 1) {
		temp_arms_down_facing = 1;
	}
	temp_arms_down_facing = sign(temp_arms_down_facing);
	
	// Screen Shake
	if (player_input and canmove) {
		if (temp_weapon.melee_found_hit) {
			camera_screen_shake = true;
			camera_screen_shake_timer = 1;
		}
		else {
			camera_screen_shake = false;
		}
	}
	temp_weapon.melee_found_hit = false;

	// Establish Arm Variables
	var temp_arm_direction = 0;
	if (sign(image_xscale) < 0) {
		temp_arm_direction = 1;
		limb[0].limb_sprite = limb_sprite[0];
		limb[1].limb_sprite = limb_sprite[1];
		limb[0].limb_normal_sprite = limb_normal_sprite[0];
		limb[1].limb_normal_sprite = limb_normal_sprite[1];
	}
	else {
		limb[0].limb_sprite = limb_sprite[1];
		limb[1].limb_sprite = limb_sprite[0];
		limb[0].limb_normal_sprite = limb_normal_sprite[1];
		limb[1].limb_normal_sprite = limb_normal_sprite[0];
	}
	var temp_arm_x_offset = sign(x_velocity);
		
	// Set Arm Position Backarm
	limb[0].visible = true;
	limb[0].limb_direction = sign(image_xscale) * temp_arms_down_facing;
		
	var temp_limb_anchor_distance = point_distance(0, 0, (draw_xscale * image_xscale * limb_x[0]) + temp_arm_x_offset, (draw_yscale * image_yscale * limb_y[0]));
	var temp_limb_anchor_direction = point_direction(0, 0, (draw_xscale * image_xscale * limb_x[0]) + temp_arm_x_offset, (draw_yscale * image_yscale * limb_y[0]));
	limb[0].limb_anchor_x = x + lengthdir_x(temp_limb_anchor_distance, draw_angle + temp_limb_anchor_direction);
	limb[0].limb_anchor_y = y + lengthdir_y(temp_limb_anchor_distance, draw_angle + temp_limb_anchor_direction) - ((sin(degtorad(draw_angle)) * (bbox_left - bbox_right)) / 2);
		
	var temp_limb_distance = point_distance(0, 0, temp_weapon.arm_x[0], temp_weapon.arm_y[0] * sign(image_xscale));
	var temp_limb_direction = point_direction(0, 0, temp_weapon.arm_x[0], temp_weapon.arm_y[0] * sign(image_xscale));
	limb[0].limb_target_x = temp_weapon.x + temp_weapon.recoil_offset_x + lengthdir_x(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift) + temp_limb_run_move_offset_x;
	limb[0].limb_target_y = temp_weapon.y + temp_weapon.recoil_offset_y + lengthdir_y(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
		
	if (action != noone) {
		limb[0].limb_target_x = action_target_x;
		limb[0].limb_target_y = action_target_y;
	}
		
	// Set Arm Position Frontarm
	if (limbs > 1) {
		limb[1].visible = true;
		limb[1].limb_direction = -sign(image_xscale) * temp_arms_down_facing;
			
		var temp_limb_anchor_distance = point_distance(0, 0, (draw_xscale * image_xscale * limb_x[1]) + temp_arm_x_offset, (draw_yscale * image_yscale * limb_y[1]));
		var temp_limb_anchor_direction = point_direction(0, 0, (draw_xscale * image_xscale * limb_x[1]) + temp_arm_x_offset, (draw_yscale * image_yscale * limb_y[1]));
		limb[1].limb_anchor_x = x + lengthdir_x(temp_limb_anchor_distance, draw_angle + temp_limb_anchor_direction);
		limb[1].limb_anchor_y = y + lengthdir_y(temp_limb_anchor_distance, draw_angle + temp_limb_anchor_direction) - ((sin(degtorad(draw_angle)) * (bbox_left - bbox_right)) / 2);
			
		var temp_limb_distance = point_distance(0, 0, temp_weapon.arm_x[1], temp_weapon.arm_y[1] * sign(image_xscale));
		var temp_limb_direction = point_direction(0, 0, temp_weapon.arm_x[1], temp_weapon.arm_y[1] * sign(image_xscale));
			
		if (temp_weapon.swap_action_hand) {
			limb[1].limb_target_x = temp_weapon.x + temp_weapon.recoil_offset_x + lengthdir_x(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift) + temp_limb_run_move_offset_x;
			limb[1].limb_target_y = temp_weapon.y + temp_weapon.recoil_offset_y + lengthdir_y(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
		}
		else {
			// Ambient Arms BROKEN FIX PLEASE
			temp_limb_ambient_animation[1] = true;
		}
	}
}
else if (temp_weapon.weapon_type == "firearm") {
	// Firearm AI Behaviour
	if (ai_behaviour) {
		// Reloading
		if (temp_weapon.bullets <= 0) {
			key_fire_press = false;
			key_reload_press = true;
			if (temp_weapon.reload_individual_rounds) {
				key_aim_press = false;
				key_fire_press = false;
				targeting = false;
			}
		}
		else if (!squad_aim) {
			// Check Aiming
			if (key_aim_press) {
				// Types of Ai Aiming Behaviour
				if (temp_weapon.click) {
					// Compare Aim Threshold
					if (temp_weapon.aim > target_aim_threshold) {
						// Click Attack
						key_fire_press = true;
					}
				}
				else {
					// Hold Attack
					if (sight_unit_nearest != noone) {
						if (instance_exists(sight_unit_nearest)) {
							// Check if Full Auto Weapon Angle is in Valid Threshold
							var temp_sight_unit_height = sight_unit_nearest.hitbox_right_bottom_y_offset - sight_unit_nearest.hitbox_left_top_y_offset;
							var temp_weapon_aim_target_angle = point_direction(temp_weapon.x + temp_weapon.recoil_offset_x, temp_weapon.y + temp_weapon.recoil_offset_y, sight_unit_nearest.x, sight_unit_nearest.y - (temp_sight_unit_height / 2));
							if (abs(angle_difference(temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift, temp_weapon_aim_target_angle)) < temp_weapon.accuracy * (1 - target_aim_fullauto_threshold)) {
								// Set Attack
								key_fire_press = true;
							}
						}
					}
				}
			}
		}
	}
	
	// Bolt Action Behaviour
	if (!bolt_action_load and temp_weapon.bolt_action) {
		if (!temp_weapon.bolt_action_loaded) {
			if (!reload and (temp_weapon.bullets > 0) and (temp_weapon.recoil_timer <= 0)) {
				// Bolt Action Load Behaviour Settings
				reload = true;
				bolt_action_load = true;
				bolt_action_reload = false;
			
				// Bolt Action Load Animation Settings
				action = "boltaction";
				action_travel = true;
				action_travel_timer = 0;
				action_index = 0;
				action_target_x = limb[0].limb_target_x;
				action_target_y = limb[0].limb_target_y;
				if (!temp_weapon.swap_action_hand) {
					action_target_x = limb[1].limb_target_x;
					action_target_y = limb[1].limb_target_y;
				}
				action_timer = 30 / (action_spd / 0.15);
			}
		}
	}
		
	// Weapon Behaviour
	if (!reload) {
		if (key_fire_press) {
			// Fire Weapon
			temp_weapon.attack = canmove;
			temp_weapon.ignore_id = team_id;
			
			// Old Target Coordinates
			old_target_angle = temp_weapon.weapon_rotation;
			if (image_xscale < 0) {
				old_target_angle = 180 - old_target_angle;
			}
		}
		else if (key_reload_press) {
			// Reload Weapon
			if (!(temp_weapon.reload_individual_rounds and (key_fire_press or key_aim_press))) {
				if (object_is_ancestor(temp_weapon.object_index, oFirearm)) {
					var temp_ammo = count_item_inventory(inventory, temp_weapon.weapon_ammo_id);
					if ((temp_ammo > 0) and (!temp_weapon.reload_individual_rounds or (temp_weapon.bullets < temp_weapon.bullets_max)) ) {
						// Set Variables
						reload = true;
						action = "reload";
						action_travel = true;
						action_travel_timer = 0;
						action_index = 0;
						action_timer = 30 / (action_spd / 0.15);
						action_target_x = limb[0].limb_target_x;
						action_target_y = limb[0].limb_target_y;
						
						// Single Handed Weapon Skip Inventory
						if (!temp_weapon.swap_action_hand) {
							action_target_x = limb[1].limb_target_x;
							action_target_y = limb[1].limb_target_y;
						}
						
						// Gun Spin Reload
						if (temp_weapon.gun_spin_reload) {
							action_index = -1;
							temp_weapon.gun_spin_angle = 0;
							temp_weapon.gun_spin_timer = 0;
						}
						
						// Set Gun Reload Animation
						bolt_action_reload = false;
						if (temp_weapon.image_index == 0) {
							temp_weapon.image_index = 1;
							if (temp_weapon.magazine_obj != noone) {
								var temp_mag_distance = point_distance(0, 0, temp_weapon.reload_x, temp_weapon.reload_y * sign(image_xscale));
								var temp_mag_direction = point_direction(0, 0, temp_weapon.reload_x, temp_weapon.reload_y * sign(image_xscale));
								var temp_mag_x = temp_weapon.x_position + temp_weapon.recoil_offset_x + lengthdir_x(temp_mag_distance, temp_mag_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
								var temp_mag_y = temp_weapon.y_position + temp_weapon.recoil_offset_y + lengthdir_y(temp_mag_distance, temp_mag_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
								var temp_mag = instance_create_depth(temp_mag_x, temp_mag_y, layer_get_depth(temp_weapon.layer) - 5, temp_weapon.magazine_obj);
								with (temp_mag) {
									if (!place_free(temp_mag_x + sign(other.image_xscale * (sprite_get_bbox_right(sprite_index) - sprite_get_xoffset(sprite_index))), temp_mag_y)) {
										instance_destroy();
									}
									else {
										physics_apply_angular_impulse(random_range(-5, 5));
									}
								}
							}
							else if (temp_weapon.bolt_action) {
								temp_weapon.image_index = 0;
								bolt_action_load = true;
								bolt_action_reload = true;
							}
						}
					}
				}
			}
		}
	}
		
	// Set Body, Weapon, & Arm Layers
	temp_weapon.layer = layers[3];
	limb[0].layer = layers[4];
	limb[1].layer = layers[1];
	
	// Aiming Behaviour
	temp_weapon.aiming = false;
	temp_weapon.weapon_yscale = sign(image_xscale);
	temp_weapon.weapon_rotation = (temp_weapon.weapon_rotation + 36000) mod 360;
	aim_ambient_x = lerp(aim_ambient_x, x + (draw_xscale * image_xscale * 50), temp_weapon.lerp_spd * global.deltatime);
	aim_ambient_y = lerp(aim_ambient_y, y + weapon_hip_y, temp_weapon.lerp_spd * global.deltatime);
	
	// Player Weapon Setting
	if (player_input) {
		temp_weapon.player_mode = true;
	}
	
	// Reload Behaviour
	if (reload) {
		// Reset Weapon Aim
		temp_weapon.aim = 0;
		
		// Reload Gun Animation & Behaviour
		var temp_time = 0;
		var temp_hand_x = 0;
		var temp_hand_y = 0;
		if (bolt_action_load) {
			// Bolt Action Behaviour
			switch (action_index) {
				case 0:
					// Hand Reaches to Bolt
					var temp_limb_distance = point_distance(0, 0, temp_weapon.bolt_action_start_x, temp_weapon.bolt_action_start_y * sign(image_xscale));
					var temp_limb_direction = point_direction(0, 0, temp_weapon.bolt_action_start_x, temp_weapon.bolt_action_start_y * sign(image_xscale));
					temp_hand_x = temp_weapon.x_position + temp_weapon.recoil_offset_x + lengthdir_x(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					temp_hand_y = temp_weapon.y_position + temp_weapon.recoil_offset_y + lengthdir_y(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					//temp_time = 20 / (action_spd / 0.15);
					break;
				case 1:
					// Hand Pulls Bolt Back
					temp_weapon.image_index = 1;
					var temp_limb_distance = point_distance(0, 0, temp_weapon.bolt_action_end_x, temp_weapon.bolt_action_end_y * sign(image_xscale));
					var temp_limb_direction = point_direction(0, 0, temp_weapon.bolt_action_end_x, temp_weapon.bolt_action_end_y * sign(image_xscale));
					temp_hand_x = temp_weapon.x_position + temp_weapon.recoil_offset_x + lengthdir_x(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					temp_hand_y = temp_weapon.y_position + temp_weapon.recoil_offset_y + lengthdir_y(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					//temp_time = 20 / (action_spd / 0.15);
					break;
				case 2:
					// Hand Moves Bolt Forward
					temp_weapon.image_index = 1;
					var temp_limb_distance = point_distance(0, 0, temp_weapon.bolt_action_start_x, temp_weapon.bolt_action_start_y * sign(image_xscale));
					var temp_limb_direction = point_direction(0, 0, temp_weapon.bolt_action_start_x, temp_weapon.bolt_action_start_y * sign(image_xscale));
					temp_hand_x = temp_weapon.x_position + temp_weapon.recoil_offset_x + lengthdir_x(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					temp_hand_y = temp_weapon.y_position + temp_weapon.recoil_offset_y + lengthdir_y(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					
					// Bolt Action Reload Behaviour
					temp_weapon.bolt_action_loaded = true;
					if (bolt_action_reload) {
						action_index = 0;
						bolt_action_load = false;
						event_perform(ev_step, 0);
						return;
					}
					break;
				case 3:
					// Move Hand Back to Default Position
					temp_weapon.image_index = 0;
					var temp_limb_distance = point_distance(0, 0, temp_weapon.arm_x[0], temp_weapon.arm_y[0] * sign(image_xscale));
					var temp_limb_direction = point_direction(0, 0, temp_weapon.arm_x[0], temp_weapon.arm_y[0] * sign(image_xscale));
					temp_hand_x = temp_weapon.x_position + temp_weapon.recoil_offset_x + lengthdir_x(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					temp_hand_y = temp_weapon.y_position + temp_weapon.recoil_offset_y + lengthdir_y(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					break;
				default:
					// Set Bolt Action Loaded to True
					temp_weapon.image_index = 0;
					bolt_action_load = false;
					reload = false;
					action = noone;
					break;
			}
			
			// Set Gun Tilt
			var temp_weapon_target_angle = degtorad((old_target_angle + 36000) mod 360);
			temp_weapon_target_angle = point_direction(0, 0, cos(temp_weapon_target_angle) * sign(image_xscale), -sin(temp_weapon_target_angle));
			var temp_weapon_delta_angle = angle_difference(temp_weapon.weapon_rotation, temp_weapon_target_angle);
			temp_weapon.weapon_rotation = temp_weapon.weapon_rotation - (temp_weapon_delta_angle * temp_weapon.lerp_spd * global.deltatime);
			
			// Reset Behaviour Variables
			temp_weapon.aiming = true;
			targeting = true;
			key_aim_press = true;
		}
		else {
			// Typical Reload Animation
			switch (action_index) {
				case -1:
					// Gun Spin Reload
					temp_weapon.gun_spin = true;
					action = noone;
					action_timer = 200;
					action_anim_timer = 200;
					
					// Move to next Action
					temp_hand_x = limb[1].limb_target_x;
					temp_hand_y = limb[1].limb_target_y;
					if (temp_weapon.gun_spin_timer >= temp_weapon.gun_spin_reload_spin_times) {
						action = "reload";
						action_travel = true;
						action_travel_timer = 0;
						action_timer = 0;
						action_anim_timer = 0;
						action_index = 0;
						
						action_target_x = limb[1].limb_target_x;
						action_target_y = limb[1].limb_target_y;
					}
					break;
				case 0:
					// Hand Reaches Inventory Position
					var temp_inventory_distance = point_distance(0, 0, (draw_xscale * image_xscale * inventory_x), (draw_yscale * image_yscale * inventory_y));
					var temp_inventory_direction = point_direction(0, 0, (draw_xscale * image_xscale * inventory_x), (draw_yscale * image_yscale * inventory_y));
					temp_hand_x = x + lengthdir_x(temp_inventory_distance, temp_inventory_direction + draw_angle);
					temp_hand_y = y + lengthdir_y(temp_inventory_distance, temp_inventory_direction + draw_angle);
					break;
				case 1:
					// Hand Reaches Above Gun Reload Position
					var temp_limb_distance = point_distance(0, 0, temp_weapon.reload_x, (temp_weapon.reload_y + temp_weapon.reload_offset_y) * sign(image_xscale));
					var temp_limb_direction = point_direction(0, 0, temp_weapon.reload_x, (temp_weapon.reload_y + temp_weapon.reload_offset_y) * sign(image_xscale));
					temp_hand_x = temp_weapon.x_position + temp_weapon.recoil_offset_x + lengthdir_x(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					temp_hand_y = temp_weapon.y_position + temp_weapon.recoil_offset_y + lengthdir_y(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					temp_time = 20 / (action_spd / 0.15);
					break;
				case 2:
					// Hand Reaches into Gun Mechanism Position
					var temp_limb_distance = point_distance(0, 0, temp_weapon.reload_x, temp_weapon.reload_y * sign(image_xscale));
					var temp_limb_direction = point_direction(0, 0, temp_weapon.reload_x, temp_weapon.reload_y * sign(image_xscale));
					temp_hand_x = temp_weapon.x_position + temp_weapon.recoil_offset_x + lengthdir_x(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					temp_hand_y = temp_weapon.y_position + temp_weapon.recoil_offset_y + lengthdir_y(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					break;
				case 3:
					// Gun Reloads Behaviour
					if (temp_weapon.image_index == 1) {
						if (temp_weapon.reload_individual_rounds) {
							// Weapon Reload Individual Rounds
							if (object_is_ancestor(temp_weapon.object_index, oFirearm)) {
								var temp_ammo = count_item_inventory(inventory, temp_weapon.weapon_ammo_id);
								if (temp_ammo > 0) {
									if (temp_weapon.bullets < temp_weapon.bullets_max) {
										temp_weapon.bullets++;
										remove_item_inventory(inventory, temp_weapon.weapon_ammo_id, 1);
									}
									if (temp_weapon.bullets < temp_weapon.bullets_max) {
										action_index = 1;
										action_target_x += sign(draw_xscale * image_xscale) * -4;
										action_target_y += 4;
										action_timer = 1;
										action_anim_timer = 6;
									}
									else {
										temp_weapon.image_index = 0;
									}
								}
								else if (temp_weapon.bullets > 0) {
									temp_weapon.image_index = 0;
								}
							}
						}
						else {
							// Weapon Set Reloaded
							if (object_is_ancestor(temp_weapon.object_index, oFirearm)) {
								var temp_ammo = count_item_inventory(inventory, temp_weapon.weapon_ammo_id);
								if (temp_ammo > 0) {
									temp_weapon.bullets = temp_weapon.bullets_max;
									remove_item_inventory(inventory, temp_weapon.weapon_ammo_id, 1);
									temp_weapon.image_index = 0;
								}
							}
						}
					}
					
					// Hand Returns to Default Position
					if (!temp_weapon.swap_action_hand) {
						// Single Handed Weapon Return Position
						var temp_limb_distance = point_distance(0, 0, temp_weapon.arm_x[1], temp_weapon.arm_y[1] * sign(image_xscale));
						var temp_limb_direction = point_direction(0, 0, temp_weapon.arm_x[1], temp_weapon.arm_y[1] * sign(image_xscale));
						temp_hand_x = temp_weapon.x_position + temp_weapon.recoil_offset_x + lengthdir_x(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
						temp_hand_y = temp_weapon.y_position + temp_weapon.recoil_offset_y + lengthdir_y(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					}
					else {
						// Double Handed Weapon Return Position
						var temp_limb_distance = point_distance(0, 0, temp_weapon.arm_x[0], temp_weapon.arm_y[0] * sign(image_xscale));
						var temp_limb_direction = point_direction(0, 0, temp_weapon.arm_x[0], temp_weapon.arm_y[0] * sign(image_xscale));
						temp_hand_x = temp_weapon.x_position + temp_weapon.recoil_offset_x + lengthdir_x(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
						temp_hand_y = temp_weapon.y_position + temp_weapon.recoil_offset_y + lengthdir_y(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
					}
					break;
				default:
					// Set Old Angle
					old_target_angle = 0;
					
					// Set Reload to False
					bolt_action_load = false;
					reload = false;
					action = noone;
					break;
			}
			
			// Set Gun Tilt
			var temp_weapon_target_angle = ((sign(image_xscale) * -90) + 90) + (sign(image_xscale) * 20);
			var temp_weapon_delta_angle = angle_difference(temp_weapon.weapon_rotation, temp_weapon_target_angle);
			temp_weapon.weapon_rotation = temp_weapon.weapon_rotation - (temp_weapon_delta_angle * temp_weapon.lerp_spd * global.deltatime);
		}
			
		// Move Hands
		if (!action_travel) {
			action_timer -= global.deltatime;
			action_anim_timer -= global.deltatime;
			action_target_x = temp_hand_x + action_target_x_offset;
			action_target_y = temp_hand_y + action_target_y_offset;
			if (action_anim_timer < 0) {
				if (random(1) > 0.35) {
					action_timer += 0.5;
				}
				action_target_x_offset += random_range(-1, 1);
				action_target_y_offset += random_range(-1, 1);
				action_anim_timer = 6;
			}
			if (action_timer < 0) {
				action_index++;
				action_timer = temp_time;
				
				action_travel = true;
				action_travel_timer = 0;
			}
		}
		else {
			var temp_action_travel_dis = point_distance(action_target_x, action_target_y, temp_hand_x, temp_hand_y);
			action_travel_timer += (action_travel_spd / temp_action_travel_dis) * global.deltatime;
			action_travel_timer = clamp(action_travel_timer, 0, 1);
			action_target_x = lerp(action_target_x, temp_hand_x, action_travel_timer);
			action_target_y = lerp(action_target_y, temp_hand_y, action_travel_timer);
			if (point_distance(action_target_x, action_target_y, temp_hand_x, temp_hand_y) < limb_action_radius) {
				action_travel = false;
				action_target_x = temp_hand_x;
				action_target_y = temp_hand_y;
				action_target_x_offset = 0;
				action_target_y_offset = 0;
			}
		}
		/*
		var temp_action_target_dis = point_distance(action_target_x, action_target_y, temp_hand_x, temp_hand_y);
		show_debug_message(temp_action_target_dis);
		if (temp_action_target_dis < limb_action_radius) {
			action_timer -= global.deltatime;
			action_anim_timer -= global.deltatime;
			if (action_anim_timer < 0) {
				action_target_x += random_range(-1, 1);
				action_target_y += random_range(-1, 1);
				action_anim_timer = 6;
			}
			if (action_timer < 0) {
				action_index++;
				action_timer = temp_time;
			}
		}
		else {
			action_target_x = lerp(action_target_x, temp_hand_x, action_spd * global.deltatime);
			action_target_y = lerp(action_target_y, temp_hand_y, action_spd * global.deltatime);
			temp_action_target_dis = point_distance(action_target_x, action_target_y, temp_hand_x, temp_hand_y);
			if (temp_action_target_dis < limb_action_radius) {
				action_target_x = lerp(action_target_x, temp_hand_x, 0.8);
				action_target_y = lerp(action_target_y, temp_hand_y, 0.8);
			}
		}
		*/
		
		// Repeat Event & Exit
		if (!reload) {
			event_perform(ev_step, 0);
			return;
		}
		
		// Animation Cancel Behaviour
		if (!bolt_action_load) {
			if (!ai_behaviour) {
				if (temp_weapon.reload_individual_rounds and (key_fire_press or key_aim_press)) {
					reload = false;
					action = noone;
					temp_weapon.image_index = 0;
					return;
				}
			}
			
			// Reset Behaviour Variables
			targeting = false;
			key_aim_press = false;
		}
	}
	else if (targeting) {
		// Targeting Behaviour
		if (key_aim_press) {
			temp_weapon.aiming = true;
		}
		var temp_weapon_target_angle = point_direction(x + weapon_x, y + weapon_y, target_x, target_y);
		var temp_weapon_delta_angle = angle_difference(temp_weapon.weapon_rotation, temp_weapon_target_angle);
		temp_weapon.weapon_rotation = temp_weapon.weapon_rotation - (temp_weapon_delta_angle * temp_weapon.lerp_spd * global.deltatime);
	}
	else {
		// Ambient Aiming
		temp_weapon.weapon_rotation = temp_weapon.weapon_rotation - (angle_difference(temp_weapon.weapon_rotation, slope_angle + point_direction(x + weapon_x, y + weapon_y, aim_ambient_x, aim_ambient_y)) * temp_weapon.lerp_spd * global.deltatime);
	}
		
	// Move Weapon Position and Rotation
	var temp_weapon_x = weapon_hip_x;
	var temp_weapon_y = weapon_hip_y;
	if (targeting) {
		temp_weapon_x = weapon_aim_x;
		temp_weapon_y = weapon_aim_y;
	}
	else if (!reload) {
		weapon_ambient_move_val += (weapon_ambient_move_spd * global.deltatime);
		weapon_ambient_move_val = weapon_ambient_move_val mod 1;
		temp_weapon_x += weapon_ambient_move_size * cos(weapon_ambient_move_val * 2 * pi);
		temp_weapon_y += weapon_ambient_move_size * sin(weapon_ambient_move_val * 2 * pi);
	}
		
	var temp_limb_aim_offset_y = 0;
	if (key_aim_press) {
		if (y_velocity == 0) {
			temp_limb_aim_offset_y = limb_aim_offset_y;
		}
	}
	else {
		if (x_velocity != 0) {
			if ((y_velocity == 0) and reload) {
				temp_limb_aim_offset_y = limb_aim_offset_y;
			}
		}
	}
		
	weapon_x = lerp(weapon_x, temp_weapon_x, temp_weapon.lerp_spd * global.deltatime);
	weapon_y = lerp(weapon_y, temp_weapon_y, temp_weapon.lerp_spd * global.deltatime);
		
	var temp_weapon_distance = point_distance(0, 0, (draw_xscale * image_xscale * weapon_x), (draw_yscale * image_yscale * weapon_y));
	var temp_weapon_direction = point_direction(0, 0, (draw_xscale * image_xscale * weapon_x), (draw_yscale * image_yscale * weapon_y));
	temp_weapon.x_position = x + lengthdir_x(temp_weapon_distance, temp_weapon_direction + draw_angle);
	temp_weapon.y_position = y + lengthdir_y(temp_weapon_distance, temp_weapon_direction + draw_angle) - ((sin(degtorad(draw_angle)) * (bbox_left - bbox_right)) / 2);
	temp_weapon.phy_position_x += x_velocity * global.deltatime;
	
	// Establish Arm Variables
	var temp_arm_direction = 0;
	if (sign(image_xscale) < 0) {
		temp_arm_direction = 1;
		limb[0].limb_sprite = limb_sprite[0];
		limb[1].limb_sprite = limb_sprite[1];
		limb[0].limb_normal_sprite = limb_normal_sprite[0];
		limb[1].limb_normal_sprite = limb_normal_sprite[1];
	}
	else {
		limb[0].limb_sprite = limb_sprite[1];
		limb[1].limb_sprite = limb_sprite[0];
		limb[0].limb_normal_sprite = limb_normal_sprite[1];
		limb[1].limb_normal_sprite = limb_normal_sprite[0];
	}
	var temp_arm_x_offset = sign(x_velocity);
		
	// Set Arm Position Backarm
	limb[0].visible = true;
	limb[0].limb_direction = sign(image_xscale);
		
	var temp_limb_anchor_distance = point_distance(0, 0, (draw_xscale * image_xscale * limb_x[0]) + temp_arm_x_offset, (draw_yscale * image_yscale * limb_y[0]));
	var temp_limb_anchor_direction = point_direction(0, 0, (draw_xscale * image_xscale * limb_x[0]) + temp_arm_x_offset, (draw_yscale * image_yscale * limb_y[0]));
	limb[0].limb_anchor_x = x + lengthdir_x(temp_limb_anchor_distance, draw_angle + temp_limb_anchor_direction);
	limb[0].limb_anchor_y = y + lengthdir_y(temp_limb_anchor_distance, draw_angle + temp_limb_anchor_direction) + temp_limb_aim_offset_y - ((sin(degtorad(draw_angle)) * (bbox_left - bbox_right)) / 2);
		
	var temp_limb_distance = point_distance(0, 0, temp_weapon.arm_x[0], temp_weapon.arm_y[0] * sign(image_xscale));
	var temp_limb_direction = point_direction(0, 0, temp_weapon.arm_x[0], temp_weapon.arm_y[0] * sign(image_xscale));
	limb[0].limb_target_x = temp_weapon.phy_position_x + temp_weapon.recoil_offset_x + lengthdir_x(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
	limb[0].limb_target_y = temp_weapon.phy_position_y + temp_weapon.recoil_offset_y + lengthdir_y(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
		
	if (temp_weapon.swap_action_hand) {
		if (action != noone) {
			limb[0].limb_target_x = action_target_x;
			limb[0].limb_target_y = action_target_y;
		}
	}
		
	// Set Arm Position Frontarm
	if (limbs > 1) {
		limb[1].visible = true;
		limb[1].limb_direction = sign(image_xscale);
			
		var temp_limb_anchor_distance = point_distance(0, 0, (draw_xscale * image_xscale * limb_x[1]) + temp_arm_x_offset, (draw_yscale * image_yscale * limb_y[1]));
		var temp_limb_anchor_direction = point_direction(0, 0, (draw_xscale * image_xscale * limb_x[1]) + temp_arm_x_offset, (draw_yscale * image_yscale * limb_y[1]));
		limb[1].limb_anchor_x = x + lengthdir_x(temp_limb_anchor_distance, draw_angle + temp_limb_anchor_direction);
		limb[1].limb_anchor_y = y + lengthdir_y(temp_limb_anchor_distance, draw_angle + temp_limb_anchor_direction) + temp_limb_aim_offset_y - ((sin(degtorad(draw_angle)) * (bbox_left - bbox_right)) / 2);
			
		var temp_limb_distance = point_distance(0, 0, temp_weapon.arm_x[1], temp_weapon.arm_y[1] * sign(image_xscale));
		var temp_limb_direction = point_direction(0, 0, temp_weapon.arm_x[1], temp_weapon.arm_y[1] * sign(image_xscale));
		limb[1].limb_target_x = temp_weapon.phy_position_x + temp_weapon.recoil_offset_x + lengthdir_x(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
		limb[1].limb_target_y = temp_weapon.phy_position_y + temp_weapon.recoil_offset_y + lengthdir_y(temp_limb_distance, temp_limb_direction + temp_weapon.weapon_rotation + temp_weapon.recoil_angle_shift);
		
		if (!temp_weapon.swap_action_hand) {
			// Single Handed Weapon Alternate Hand Animation
			if (action != noone) {
				limb[1].limb_target_x = action_target_x;
				limb[1].limb_target_y = action_target_y;
				if (reload and (action_index < 3)) {
					limb[1].limb_direction = -sign(image_xscale);
				}
			}
		}
	}
}
else {
	// Invalid Weapon Equipped Default Behaviour
	temp_default_behaviour = true;
}

// Default Combat Animation Behaviour
if (temp_default_behaviour) {
	// Disarmed Behaviour
	var temp_arm_x_offset = sign(x_velocity);
	if (limbs > 0) {
		// Layer Settings
		limb[0].visible = true;
		limb[0].layer = layers[4];
		limb[0].limb_sprite = limb_sprite[1];
		limb[0].limb_normal_sprite = limb_normal_sprite[1];
		limb[0].limb_direction = sign(image_xscale);
		if (sign(image_xscale) < 0) {
			limb[0].limb_sprite = limb_sprite[0];
			limb[0].limb_normal_sprite = limb_normal_sprite[0];
		}
		
		// Limb Animation
		temp_limb_ambient_animation[0] = true;
		var temp_limb_anchor_distance = point_distance(0, 0, (draw_xscale * image_xscale * limb_x[0]) + temp_arm_x_offset, (draw_yscale * image_yscale * limb_y[0]));
		var temp_limb_anchor_direction = point_direction(0, 0, (draw_xscale * image_xscale * limb_x[0]) + temp_arm_x_offset, (draw_yscale * image_yscale * limb_y[0]));
		limb[0].limb_anchor_x = x + lengthdir_x(temp_limb_anchor_distance, draw_angle + temp_limb_anchor_direction);
		limb[0].limb_anchor_y = y + lengthdir_y(temp_limb_anchor_distance, draw_angle + temp_limb_anchor_direction) - ((sin(degtorad(draw_angle)) * (bbox_left - bbox_right)) / 2);
	}
	if (limbs > 1) {
		// Layer Settings
		limb[1].visible = true;
		limb[1].layer = layers[1];
		limb[1].limb_sprite = limb_sprite[0];
		limb[1].limb_normal_sprite = limb_normal_sprite[0];
		limb[1].limb_direction = sign(image_xscale);
		if (sign(image_xscale) < 0) {
			limb[1].limb_sprite = limb_sprite[1];
			limb[1].limb_normal_sprite = limb_normal_sprite[1];
		}
		
		// Limb Animation
		temp_limb_ambient_animation[1] = true;
		var temp_limb_anchor_distance = point_distance(0, 0, (draw_xscale * image_xscale * limb_x[1]) + temp_arm_x_offset, (draw_yscale * image_yscale * limb_y[1]));
		var temp_limb_anchor_direction = point_direction(0, 0, (draw_xscale * image_xscale * limb_x[1]) + temp_arm_x_offset, (draw_yscale * image_yscale * limb_y[1]));
		limb[1].limb_anchor_x = x + lengthdir_x(temp_limb_anchor_distance, draw_angle + temp_limb_anchor_direction);
		limb[1].limb_anchor_y = y + lengthdir_y(temp_limb_anchor_distance, draw_angle + temp_limb_anchor_direction) - ((sin(degtorad(draw_angle)) * (bbox_left - bbox_right)) / 2);
	}
}

// Ambient Arm Behaviour
if (temp_limb_ambient_animation != noone) {
	// Ambient Arm Settings
	var temp_limb_ambient_move = false;
	var temp_limb_ambient_angle_offset = 0;
	var temp_limb_target_length_offset = limb_ambient_idle_length_offset;
	var temp_limb_ambient_rotate_radius = limb_ambient_idle_rotate_radius;
	if (x_velocity != 0 or y_velocity != 0) {
		temp_limb_ambient_move = true;
		temp_limb_ambient_angle_offset = limb_ambient_move_angle_offset;
		temp_limb_target_length_offset = limb_ambient_move_length_offset;
		limb_ambient_anim_val = image_index / sprite_get_number(sprite_index);
	}
	else {
		// Ambient Arm Calculate Rotation
		limb_ambient_anim_val += limb_ambient_anim_spd * global.deltatime;
		if (limb_ambient_anim_val >= 1) {
			limb_ambient_anim_val = limb_ambient_anim_val mod 1;
		}
	}
	
	// Set Ambient Arm Rotation
	for (var i = 0; i < array_length_1d(temp_limb_ambient_animation); i++) {
		if (temp_limb_ambient_animation[i]) {
			// Calculate Ambient Limb Target
			var temp_limb_target_x = limb[i].limb_anchor_x;
			var temp_limb_target_y = limb[i].limb_anchor_y;
			var temp_limb_target_angle = 270 + ((limb_angle[i] + temp_limb_ambient_angle_offset) * sign(image_xscale));
			var temp_limb_target_length = (limb[i].limb_length - (temp_limb_ambient_rotate_radius + (temp_limb_target_length_offset * limb[i].limb_length))) * abs(draw_yscale);
			temp_limb_target_x += lengthdir_x(temp_limb_target_length, temp_limb_target_angle + draw_angle) * abs(draw_xscale);
			temp_limb_target_y += lengthdir_y(temp_limb_target_length, temp_limb_target_angle + draw_angle);
			if (!temp_limb_ambient_move) {
				temp_limb_target_x += lengthdir_x(temp_limb_ambient_rotate_radius, -(limb_ambient_anim_val + (i / array_length_1d(temp_limb_ambient_animation))) * 360 * sign(image_xscale));
				temp_limb_target_y += lengthdir_y(temp_limb_ambient_rotate_radius, -(limb_ambient_anim_val + (i / array_length_1d(temp_limb_ambient_animation))) * 360 * sign(image_xscale));
			}
			else {
				temp_limb_target_x += lengthdir_x(limb_ambient_move_width, (limb_ambient_anim_val + (i / array_length_1d(temp_limb_ambient_animation))) * 360 * sign(image_xscale));
				temp_limb_target_y += limb_ambient_anim_val * limb_ambient_move_height;
			}
			
			// Set Limb Targets
			limb[i].limb_target_x = temp_limb_target_x;
			limb[i].limb_target_y = temp_limb_target_y;
		}
	}
}

// Knockout
if (knockout) {
	if (!knockout_active) {
		// Activate Knockout
		if (health_points <= 0) {
			knockout_active = true;
			
			// Disable Movement
			game_manager.time_spd = 0.07;
			for (var u = 0; u < instance_number(oUnitCombat); u++) {
				var temp_combat_unit = instance_find(oUnitCombat, u);
				temp_combat_unit.canmove = false;
			}
			if (!instance_exists(oKnockout)) {
				var temp_knockout_inst = instance_create_depth(x, y, -6000, oKnockout);
				if (!can_die) {
					temp_knockout_inst.restart_screen = true;
				}
			}
		}
	}
	else {
		knockout_timer -= (global.realdeltatime / 60);
		if (knockout_timer <= 0) {
			if (!can_die and !key_reload_press) {
				knockout_timer = 0.001;
				game_manager.time_spd = 0;
			}
			else {
				knockout = false;
				knockout_active = false;
				game_manager.time_spd = 1;
				for (var u = 0; u < instance_number(oUnitCombat); u++) {
					var temp_combat_unit = instance_find(oUnitCombat, u);
					temp_combat_unit.canmove = true;
				}
				if (instance_exists(oKnockout)) {
					instance_destroy(oKnockout);
				}
			}
		}
		knockout_timer = max(knockout_timer, 0);
	}
}

// Death Behaviour
if (health_points <= 0) {
	var temp_destroy_check = false;
	if (knockout) {
		if (knockout_timer <= 0) {
			temp_destroy_check = true;
		}
	}
	else {
		temp_destroy_check = true;
	}
	
	if (temp_destroy_check) {
		// Destroy Unit Object
		instance_destroy();
		
		// Restart Room
		if (!can_die) {
			ds_list_destroy(game_manager.instantiated_units);
			game_manager.instantiated_units = ds_list_create();
			room_restart();
		}
	}
}

// Reset Combat Action Variables
squad_key_fire_press = key_fire_press;
squad_key_aim_press = key_aim_press;

key_fire_press = false;
key_aim_press = false;
key_reload_press = false;