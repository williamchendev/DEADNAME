/// @description Firearm Draw
// Draws the firearm object to the screen

// Inactive Skip
if (!active) {
	return;
}

// Lighting Draw Behaviour
var temp_draw_gui = true;
var temp_draw_sprite = true;
sprite_index = weapon_sprite;
if (instance_exists(oLighting)) {
	temp_draw_gui = false;
	if (normal_draw_event) {
		sprite_index = weapon_normal_sprite;
	}
	else if (!lit_draw_event) {
		temp_draw_gui = true;
		temp_draw_sprite = false;
	}
}

// Weapon Rotation
var temp_weapon_rotation = weapon_rotation + recoil_angle_shift;

// Weapon Position
var temp_x = x + recoil_offset_x;
var temp_y = y + recoil_offset_y;

// Calculate Weapon Range & Accuracy
var temp_muzzle_direction = point_direction(0, 0, muzzle_x * weapon_xscale, muzzle_y * weapon_yscale);
var temp_muzzle_distance = point_distance(0, 0, muzzle_x * weapon_xscale, muzzle_y * weapon_yscale);

var temp_muzzle_x = temp_x + lengthdir_x(temp_muzzle_distance, temp_weapon_rotation + temp_muzzle_direction);
var temp_muzzle_y = temp_y + lengthdir_y(temp_muzzle_distance, temp_weapon_rotation + temp_muzzle_direction);

var temp_accuracy = clamp((accuracy - accuracy_peak) * (1 - aim), 0, 360 - accuracy_peak) + accuracy_peak;

if (temp_accuracy > accuracy_peak) {
	draw_set_alpha(clamp(0.5 * power(aim, 3), 0, 0.5));
	draw_set_color(c_black);
}
else {
	draw_set_alpha(0.3);
	draw_set_color(c_white);
}

// Draw Aiming Reticules
var temp_fanlength = (pi * (range * 2)) * (temp_accuracy / 360);
var temp_fantris = floor(temp_fanlength / clamp(temp_accuracy, 1, 10));
var temp_fanseg = (temp_accuracy / temp_fantris);

/*
if (equip) {
	if (!sniper) {
		// Draw Aim Fan Reticule
		if (temp_fantris == 1) {
			var temp_fanangle = (temp_accuracy / 2);
			var temp_point1_x = temp_muzzle_x + lengthdir_x(range, temp_weapon_rotation - temp_fanangle); 
			var temp_point1_y = temp_muzzle_y + lengthdir_y(range, temp_weapon_rotation - temp_fanangle);
			var temp_point2_x = temp_muzzle_x + lengthdir_x(range, temp_weapon_rotation + temp_fanangle); 
			var temp_point2_y = temp_muzzle_y + lengthdir_y(range, temp_weapon_rotation + temp_fanangle);
			draw_triangle(temp_point1_x, temp_point1_y, temp_muzzle_x, temp_muzzle_y, temp_point2_x, temp_point2_y, false);
		}
		else {
			draw_primitive_begin(pr_trianglestrip);
			for (var i = 0; i < temp_fantris; i++) {
				var temp_fanangle = temp_weapon_rotation - (temp_accuracy / 2) + (temp_fanseg * i);
	
				draw_vertex(temp_muzzle_x + lengthdir_x(range, temp_fanangle), temp_muzzle_y + lengthdir_y(range, temp_fanangle));
				draw_vertex(temp_muzzle_x, temp_muzzle_y);
				draw_vertex(temp_muzzle_x + lengthdir_x(range, temp_fanangle + temp_fanseg), temp_muzzle_y + lengthdir_y(range, temp_fanangle + temp_fanseg));
			}
			draw_primitive_end();
		}
	}
	else {
		// Draw Line Fan Reticule
		draw_line(temp_muzzle_x, temp_muzzle_y, temp_muzzle_x + lengthdir_x(range, temp_weapon_rotation - (temp_accuracy / 2)), temp_muzzle_y + lengthdir_y(range, temp_weapon_rotation - (temp_accuracy / 2)));
		draw_line(temp_muzzle_x, temp_muzzle_y, temp_muzzle_x + lengthdir_x(range + 1, temp_weapon_rotation + (temp_accuracy / 2)), temp_muzzle_y + lengthdir_y(range + 1, temp_weapon_rotation + (temp_accuracy / 2)));
	
		for (var i = 0; i < temp_fantris; i++) {
			var temp_fanangle = temp_weapon_rotation - (temp_accuracy / 2) + (temp_fanseg * i);
			draw_line(temp_muzzle_x + lengthdir_x(range, temp_fanangle), temp_muzzle_y + lengthdir_y(range, temp_fanangle), temp_muzzle_x + lengthdir_x(range, temp_fanangle + temp_fanseg), temp_muzzle_y + lengthdir_y(range, temp_fanangle + temp_fanseg));
		}
	}
}
*/

// Draw Firearm GUI & Visual Effects
draw_set_color(c_white);
if (temp_draw_gui) {
	// Draw the Attack
	if (ds_list_size(flash_timer) > 0 and attack_show) {
		// Check Shader
		var temp_shader = shader_current();
		if (temp_shader != -1) {
			shader_reset();
		}
	
		// Individual Bullet Flashes
		for (var f = ds_list_size(flash_timer) - 1; f >= 0; f--) {
			// Flash Variables
			var temp_flash_timer = ds_list_find_value(flash_timer, f);
			var temp_flash_length = ds_list_find_value(flash_length, f);
			var temp_flash_direction = ds_list_find_value(flash_direction, f);
			var temp_flash_xposition = ds_list_find_value(flash_xposition, f);
			var temp_flash_yposition = ds_list_find_value(flash_yposition, f);
			var temp_flash_imageindex = ds_list_find_value(flash_imageindex, f);
	
			// Check Draw Mode
			if (temp_shader == -1) {
				// Draw Bullet Trail
				draw_set_alpha(0.4 * (1 - power(((flash_delay - temp_flash_timer) / flash_delay), 2)));
				if (bullet_path_line_width == 1) {
					draw_line(temp_flash_xposition, temp_flash_yposition, temp_flash_xposition + lengthdir_x(temp_flash_length, temp_flash_direction), temp_flash_yposition + lengthdir_y(temp_flash_length, temp_flash_direction));
				}
				else {
					draw_line_width(temp_flash_xposition, temp_flash_yposition, temp_flash_xposition + lengthdir_x(temp_flash_length, temp_flash_direction), temp_flash_yposition + lengthdir_y(temp_flash_length, temp_flash_direction), bullet_path_line_width);
				}
	
				// Draw Bullet Trail Muzzle Flash
				draw_set_alpha(1);
				if (muzzle_flash_sprite != noone) {
					if (temp_flash_imageindex != -1) {
						draw_sprite_ext(muzzle_flash_sprite, temp_flash_imageindex, temp_flash_xposition, temp_flash_yposition, 1, (1 - power(((flash_delay - temp_flash_timer) / flash_delay), 3)) * weapon_yscale, temp_flash_direction, c_white, 1);
					}
				}
			}
			else {
				// Draw Knockout
				draw_set_alpha(1);
				draw_set_color(c_black);
				if (muzzle_flash_sprite != noone) {
					if (temp_flash_imageindex != -1) {
						draw_sprite_ext(muzzle_flash_sprite, temp_flash_imageindex, temp_muzzle_x, temp_muzzle_y, 1, (1 - power(((flash_delay - temp_flash_timer) / flash_delay), 3)) * weapon_yscale, temp_flash_direction, c_black, 1);
					}
				}
				/*
				draw_line(temp_flash_xposition, temp_flash_yposition, temp_flash_xposition + lengthdir_x(temp_flash_length, temp_flash_direction), temp_flash_yposition + lengthdir_y(temp_flash_length, temp_flash_direction));
				*/
				draw_sprite_ext(sImpact_Blood, knockout_hit_effect_index, temp_flash_xposition + lengthdir_x(temp_flash_length + knockout_hit_effect_offset, temp_flash_direction), temp_flash_yposition + lengthdir_y(temp_flash_length + knockout_hit_effect_offset, temp_flash_direction), knockout_hit_effect_xscale, knockout_hit_effect_yscale, temp_flash_direction, c_white, 1);
			}
		
			// Reset Shader
			if (temp_shader != -1) {
				shader_set(temp_shader);
			}
		}
	}
	
	// Draw Firearm Projectile Trajectory
	if (aiming) {
		if (projectile_obj != noone) {
			// Draw Settings
			draw_set_alpha(1);
		
			// Draw Trajectory Arc
			var i = projectile_trajectory_draw_val;
			while (i < projectile_trajectory_distance) {
				// Find Trajectory Reticle Indexes
				var temp_trajectory_pos1_index = clamp((i / projectile_trajectory_distance), 0, 1);
				var temp_trajectory_pos2_index = clamp(((i + projectile_trajectory_aim_reticle_height) / projectile_trajectory_distance), 0, 1);
				temp_trajectory_pos1_index = temp_trajectory_pos1_index * (ds_list_size(projectile_obj_x_trajectory) - 1);
				temp_trajectory_pos2_index = temp_trajectory_pos2_index * (ds_list_size(projectile_obj_x_trajectory) - 1);
			
				// Create Reticle Partition Line Coordinates
				var temp_trajectory_x1 = lerp(ds_list_find_value(projectile_obj_x_trajectory, floor(temp_trajectory_pos1_index)), ds_list_find_value(projectile_obj_x_trajectory, ceil(temp_trajectory_pos1_index)), temp_trajectory_pos1_index mod 1);
				var temp_trajectory_y1 = lerp(ds_list_find_value(projectile_obj_y_trajectory, floor(temp_trajectory_pos1_index)), ds_list_find_value(projectile_obj_y_trajectory, ceil(temp_trajectory_pos1_index)), temp_trajectory_pos1_index mod 1);
				var temp_trajectory_x2 = lerp(ds_list_find_value(projectile_obj_x_trajectory, floor(temp_trajectory_pos2_index)), ds_list_find_value(projectile_obj_x_trajectory, ceil(temp_trajectory_pos2_index)), temp_trajectory_pos2_index mod 1);
				var temp_trajectory_y2 = lerp(ds_list_find_value(projectile_obj_y_trajectory, floor(temp_trajectory_pos2_index)), ds_list_find_value(projectile_obj_y_trajectory, ceil(temp_trajectory_pos2_index)), temp_trajectory_pos2_index mod 1);
			
				// Draw Partition Line Background
				draw_set_color(c_black);
				draw_line_width(temp_trajectory_x1, temp_trajectory_y1, temp_trajectory_x2, temp_trajectory_y2, projectile_trajectory_aim_reticle_width);
			
				// Draw Partition Line Front
				var temp_trajectory_front_space_direction = point_direction(temp_trajectory_x1, temp_trajectory_y1, temp_trajectory_x2, temp_trajectory_y2);
				temp_trajectory_x1 += lengthdir_x(1, temp_trajectory_front_space_direction);
				temp_trajectory_y1 += lengthdir_y(1, temp_trajectory_front_space_direction);
				temp_trajectory_x2 -= lengthdir_x(1, temp_trajectory_front_space_direction);
				temp_trajectory_y2 -= lengthdir_y(1, temp_trajectory_front_space_direction);
			
				draw_line_width(temp_trajectory_x1, temp_trajectory_y1, temp_trajectory_x2, temp_trajectory_y2, projectile_trajectory_aim_reticle_width + 2);
				draw_set_color(c_white);
				draw_line_width(temp_trajectory_x1, temp_trajectory_y1, temp_trajectory_x2, temp_trajectory_y2, projectile_trajectory_aim_reticle_width);
			
				// Increment
				i += projectile_trajectory_aim_reticle_height + projectile_trajectory_aim_reticle_space;
			}
		}
	}
}

// Draw Firearm Sprite
if (temp_draw_sprite) {
	// Break Action Behaviour
	if (break_action) {
		if (image_index > 0) {
			// Break Action Vector Settings
			var temp_break_action_angle = temp_weapon_rotation + ((break_action_angle_val * break_action_angle) * sign(weapon_yscale));
			var temp_break_action_distance = point_distance(0, 0, break_action_pivot_x * weapon_xscale, break_action_pivot_y * weapon_yscale);
			var temp_break_action_direction = point_direction(0, 0, break_action_pivot_x * weapon_xscale, break_action_pivot_y * weapon_yscale);
			var temp_break_action_pivot_x = temp_x + lengthdir_x(temp_break_action_distance, temp_weapon_rotation + temp_break_action_direction);
			var temp_break_action_pivot_y = temp_y + lengthdir_y(temp_break_action_distance, temp_weapon_rotation + temp_break_action_direction);
			
			// Normal Draw Event Settings
			var temp_break_action_sprite = break_action_sprite;
			if (normal_draw_event) { 
				temp_break_action_sprite = break_action_normal_sprite;
				shader_set(shd_vectortransform);
				shader_set_uniform_f(vectortransform_shader_angle, degtorad(temp_break_action_angle));
				var temp_normalscale_x = sign(weapon_xscale);
				var temp_normalscale_y = sign(weapon_yscale);
				shader_set_uniform_f(vectortransform_shader_scale, temp_normalscale_x, temp_normalscale_y, 1.0);
			}
			
			// Draw Break Action
			draw_sprite_ext(temp_break_action_sprite, 0, temp_break_action_pivot_x, temp_break_action_pivot_y, weapon_xscale, weapon_yscale, temp_break_action_angle, c_white, 1);
			
			if (normal_draw_event) {
				shader_reset();
			}
		}
	}

	// Gun Spin Behaviour
	if (gun_spin) {
		// Find Hand Position
		var temp_limb_distance = point_distance(0, 0, arm_x[0] * weapon_xscale, arm_y[0] * weapon_yscale);
		var temp_limb_direction = point_direction(0, 0, arm_x[0] * weapon_xscale, arm_y[0] * weapon_yscale);
		temp_x = temp_x + lengthdir_x(temp_limb_distance, temp_limb_direction + weapon_rotation + recoil_angle_shift);
		temp_y = temp_y + lengthdir_y(temp_limb_distance, temp_limb_direction + weapon_rotation + recoil_angle_shift);
		
		// Offset Position by Spin Angle
		temp_weapon_rotation += gun_spin_angle;
		temp_x -= lengthdir_x(temp_limb_distance, temp_limb_direction + weapon_rotation + recoil_angle_shift + gun_spin_angle);
		temp_y -= lengthdir_y(temp_limb_distance, temp_limb_direction + weapon_rotation + recoil_angle_shift + gun_spin_angle);
	}
	
	// Set Normal Vector Scaling Shader
	if (normal_draw_event) {
		shader_set(shd_vectortransform);
		shader_set_uniform_f(vectortransform_shader_angle, degtorad(temp_weapon_rotation));
		var temp_normalscale_x = sign(weapon_xscale);
		var temp_normalscale_y = sign(weapon_yscale);
		shader_set_uniform_f(vectortransform_shader_scale, temp_normalscale_x, temp_normalscale_y, 1.0);
	}

	// Draw the Firearm
	draw_sprite_ext(sprite_index, image_index, temp_x, temp_y, weapon_xscale, weapon_yscale, temp_weapon_rotation, c_white, 1);

	// Reset Normal Vector Scaling Shader
	if (normal_draw_event) {
		shader_reset();
	}
}

// Draw Debug Firearm Stats
if (global.debug and draw_debug) {
	// Draw Reset Color
	draw_set_alpha(1);
	draw_set_color(c_white);
	
	// Draw Firearm Debug Ranges
	draw_point(temp_muzzle_x, temp_muzzle_y);
	draw_circle(temp_muzzle_x, temp_muzzle_y, close_range_radius, true);
	draw_circle(temp_muzzle_x, temp_muzzle_y, mid_range_radius, true);
	draw_circle(temp_muzzle_x, temp_muzzle_y, far_range_radius, true);
	
	// Draw Firearm Debug Range Hitchances
	draw_set_font(fNormalFont);
	var temp_debug_range_text_offset = 3;
	draw_text_outline(temp_muzzle_x + temp_debug_range_text_offset, temp_muzzle_y, c_white, c_black, string(round(close_range_hit_chance * 100)) + "%");
	draw_text_outline(temp_muzzle_x + close_range_radius + temp_debug_range_text_offset, temp_muzzle_y, c_white, c_black, string(round(mid_range_hit_chance * 100)) + "%");
	draw_text_outline(temp_muzzle_x + mid_range_radius + temp_debug_range_text_offset, temp_muzzle_y, c_white, c_black, string(round(far_range_hit_chance * 100)) + "%");
	draw_text_outline(temp_muzzle_x + far_range_radius + temp_debug_range_text_offset, temp_muzzle_y, c_white, c_black, string(round(sniper_range_hit_chance * 100)) + "%");
}

// Reset Draw Event
draw_set_alpha(1);
draw_set_color(c_white);