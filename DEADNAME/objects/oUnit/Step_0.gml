/// @description Unit Update Event

// INPUT //
#region Movement & Input Behaviour
if (canmove)
{
	// UNIT AI WOULD GO HERE!!!!!
	
	// Weapon Aiming
	
	
	// Weapon Attacking
	if (weapon_active)
	{
		if (input_aim)
		{
			weapon_aim = true;
			weapon_aim_x = input_cursor_x;
			weapon_aim_y = input_cursor_y;
		}
		else
		{
			weapon_aim = false;
			weapon_aim_x = x + (sign(draw_xscale) * 320);
			weapon_aim_y = y - global.unit_packs[unit_pack].equipment_firearm_hip_y;
		}
	
		if (input_reload and unit_equipment_animation_state == UnitEquipmentAnimationState.Firearm)
		{
			unit_equipment_animation_state = UnitEquipmentAnimationState.FirearmReload;
			firearm_reload_hand_primary_animation_value = 0;
		}
		else if (input_attack and unit_equipment_animation_state != UnitEquipmentAnimationState.FirearmReload)
		{
			weapon_equipped.update_weapon_attack();
		}
	}
	
	// Horizontal Movement Behaviour
	var move_spd = weapon_aim ? walk_spd : run_spd;
	
	if (input_left) 
	{
		move_spd = -move_spd;
	}
	else if (!input_right)
	{
		move_spd = 0;
		x_velocity = 0;
		x = round(x);
	}
	
	x_velocity = move_spd;
	
	// Vertical Movement Behaviour
	if (input_jump_hold) 
	{
		if (grounded) 
		{
			// First Jump
			y_velocity = 0;
			y_velocity -= jump_spd;
			jump_velocity = hold_jump_spd;
			double_jump = true;
			
			// Squash and Stretch
			draw_xscale = sign(draw_xscale) * (1 - squash_stretch_jump_intensity);
			draw_yscale = 1 + squash_stretch_jump_intensity;
			
			// Reset Ground Contact
			grounded = false;
		}
		else if (input_double_jump)
		{
			// Second Jump
			if (double_jump)
			{
				y_velocity = 0;
				y_velocity -= double_jump_spd;
				jump_velocity = hold_jump_spd;
				double_jump = false;
				
				// Squash and Stretch
				draw_xscale -= sign(draw_xscale) * squash_stretch_jump_intensity;
				draw_yscale += squash_stretch_jump_intensity;
			}
		}
		else if (y_velocity < 0)
		{
			// Variable Jump Height
			y_velocity -= jump_velocity * frame_delta;
			jump_velocity *= power(jump_decay, frame_delta);
		}
	}
	
	// Jumping Down (Platforms)
	if (input_drop_down and grounded)
	{
		if (place_free(x, y + 1))
		{
			y += 2;
			y_velocity += 0.05;
			grounded = false;
		}
	}
}
else
{
	x_velocity = 0;
	y_velocity = 0;
}
#endregion

// PHYSICS //
#region Collision & Physics Behaviour
if (grounded)
{
	// Disable Gravity
	grav_velocity = 0;
	y_velocity = 0;
	y = round(y);
	
	// Delta Time Adjustment
	var hspd = clamp(x_velocity * frame_delta, -max_velocity, max_velocity);
	var vspd = clamp(y_velocity * frame_delta, -max_velocity, max_velocity);
	
	// Grounded Physics (Horizontal) Collisions
	if (hspd != 0)
	{
		if (place_free(x + hspd, y)) 
		{
			// Move Unit with horizontal velocity
			x_velocity = hspd;
			x += x_velocity;
			
			// Grounded Slope Hugging Logic
			if (platform_free(x, y + 1, platform_list)) 
			{
				// Downward Slope Collision Check
				if (!place_free(x, y + slope_tolerance)) 
				{
					for (var v = slope_tolerance - 1; v >= 0; v--) 
					{
						if (place_free(x, y + v)) 
						{
							// GROUND CONTACT
							y_velocity = v;
							y += y_velocity;
							
							unit_ground_contact_behaviour();
							break;
						}
					}
				}
				else
				{
					// End Grounded Condition - Walked off side of Platform
					y += 1;
					grounded = false;
				}
			}
			else if (place_free(x, y + 1))
			{
				// Walking across Platform - Reset Ground Contact State
				ground_contact_vertical_offset = 0;
				draw_angle = 0;
			}
		}
		else if (place_free(x + hspd, y - slope_tolerance))
		{
			// Grounded Slope Hugging Logic
			for (var v = 1; v <= slope_tolerance; v++) 
			{
				// Upwards Slope Collision Check
				if (place_free(x + hspd, y - v)) 
				{
					// GROUND CONTACT
					x_velocity = hspd;
					x += x_velocity;
					
					y_velocity = -v;
					y += y_velocity;
					
					unit_ground_contact_behaviour();
					break;
				}
			}
		}
		else
		{
			// Horizontal Contact with Solid Collider
			for (var h = abs(hspd); h > 0; h--)
			{
				var temp_hspd = (sign(x_velocity) * h);
				
				if (place_free(x + temp_hspd, y))
				{
					// GROUND CONTACT
					x_velocity = temp_hspd;
					
					x += x_velocity;
					x = round(x);
					
					// End Grounded Condition - Walked off side of Platform
					if (platform_free(x, y + 1, platform_list)) 
					{
						y += 1;
						grounded = false;
					}
					
					unit_ground_contact_behaviour();
					break;
				}
			}
		}
	}
}
else
{
	// Gravity
	grav_velocity += (grav_spd * frame_delta);
	grav_velocity *= power(grav_multiplier, frame_delta);
	grav_velocity = min(grav_velocity, max_grav_spd);
	y_velocity += (grav_velocity * frame_delta);
	
	// Delta Time Adjustment
	var hspd = clamp(x_velocity * frame_delta, -max_velocity, max_velocity);
	var vspd = clamp(y_velocity * frame_delta, -max_velocity, max_velocity);
	
	// Airborne Ground Contact Reset
	ground_contact_vertical_offset = 0;
	draw_angle = 0;
	
	// Airborne Physics (Horizontal) Collisions
	if (hspd != 0)
	{
		if (place_free(x + hspd, y))
		{
			x_velocity = hspd;
			x += x_velocity;
			x = round(x);
		}
		else
		{
			for (var h = abs(hspd); h >= 0; h--)
			{
				var temp_hspd = (sign(x_velocity) * h);
				
				if (place_free(x + temp_hspd, y))
				{
					// GROUND CONTACT
					x_velocity = temp_hspd;
					x += x_velocity;
					x = round(x);
					break;
				}
			}
		}
	}
	
	// Airborne Physics (Vertical) Collisions
	if (platform_free(x, y + vspd, platform_list))
	{
		y_velocity = vspd;
		y += y_velocity;
		y = round(y);
	}
	else
	{
		for (var v = 1; v < abs(vspd); v++)
		{
			var temp_vspd = (sign(y_velocity) * v);
			
			if (!platform_free(x, y + temp_vspd, platform_list))
			{
				// GROUND CONTACT
				y_velocity = temp_vspd - sign(y_velocity);
				y += y_velocity;
				y = round(y);
				
				if (!platform_free(x, y + 1, platform_list))
				{
					grounded = true;
					double_jump = true;
					
					draw_xscale = sign(draw_xscale) * (1 + squash_stretch_jump_intensity);
					draw_yscale = 1 - squash_stretch_jump_intensity;
					
					unit_ground_contact_behaviour();
				}
				else
				{
					draw_xscale = sign(draw_xscale);
					draw_yscale = 1;
				}
				break;
			}
		}
	}
}

// Update Unit Scale & Angle
draw_xscale = lerp(draw_xscale, sign(draw_xscale), squash_stretch_reset_spd * frame_delta);
draw_yscale = lerp(draw_yscale, 1, squash_stretch_reset_spd * frame_delta);
draw_angle_value = lerp(draw_angle_value, draw_angle, slope_angle_lerp_spd * frame_delta);
#endregion

// WEAPON //
if (weapon_active)
{
	switch (global.weapon_packs[weapon_equipped.weapon_pack].weapon_type)
	{
		case WeaponType.DefaultFirearm:
			weapon_equipped.update_weapon_behaviour(firearm_recoil_recovery_spd, firearm_recoil_angle_recovery_spd);
			break;
		default:
			weapon_equipped.update_weapon_behaviour();
			break;
	}
}

// ANIMATION //
#region Animation Behaviour
var temp_unit_animation_state = UnitAnimationState.Idle;

if (x_velocity != 0)
{
	draw_xscale = abs(draw_xscale) * sign(x_velocity);
}
	
if (grounded)
{
	// Walking or Idle Animation
	temp_unit_animation_state = x_velocity != 0 ? (weapon_aim ? UnitAnimationState.AimWalking : UnitAnimationState.Walking) : (weapon_aim ? UnitAnimationState.Aiming : UnitAnimationState.Idle);
}
else 
{
	// Jump Animation
	temp_unit_animation_state = UnitAnimationState.Jumping;
	image_index = ((abs(y_velocity) - jump_peak_threshold >= 0) * sign(y_velocity)) + 1;
}

// Load Animation State
if (unit_animation_state != temp_unit_animation_state)
{
	unit_animation_state = temp_unit_animation_state;
	
	switch (unit_animation_state)
	{
		case UnitAnimationState.Idle:
			sprite_index = global.unit_packs[unit_pack].idle_sprite;
			normalmap_index = global.unit_packs[unit_pack].idle_normalmap;
			draw_image_index_length = 4;
			break;
		case UnitAnimationState.Walking:
			sprite_index = global.unit_packs[unit_pack].walk_sprite;
			normalmap_index = global.unit_packs[unit_pack].walk_normalmap;
			draw_image_index_length = 5;
			break;
		case UnitAnimationState.Jumping:
			sprite_index = global.unit_packs[unit_pack].jump_sprite;
			normalmap_index = global.unit_packs[unit_pack].jump_normalmap;
			draw_image_index_length = -1;
			break;
		case UnitAnimationState.Aiming:
			sprite_index = global.unit_packs[unit_pack].aim_sprite;
			normalmap_index = global.unit_packs[unit_pack].aim_normalmap;
			image_index = 0;
			draw_image_index = 0;
			draw_image_index_length = -1;
			break;
		case UnitAnimationState.AimWalking:
			sprite_index = global.unit_packs[unit_pack].aim_walk_sprite;
			normalmap_index = global.unit_packs[unit_pack].aim_walk_normalmap;
			draw_image_index_length = 5;
			break;
	}
}
#endregion

// LIMBS //
#region Limb Animation Behaviour
switch (unit_equipment_animation_state)
{
	case UnitEquipmentAnimationState.Firearm:
	case UnitEquipmentAnimationState.FirearmReload:
		// Firearm Animation States
		var temp_firearm_reload = unit_equipment_animation_state == UnitEquipmentAnimationState.FirearmReload;
		var temp_firearm_is_aimed = weapon_aim and !temp_firearm_reload;
	
		// Update Facing Direction
		draw_xscale = temp_firearm_is_aimed ? (abs(draw_xscale) * ((weapon_aim_x - x >= 0) ? 1 : -1)) : draw_xscale;
		var temp_weapon_facing_sign = sign(draw_xscale);
		animation_speed_direction = 1;
	
		// Firearm Reload Animation
		var temp_weapon_ambient_angle;
		
		if (temp_firearm_reload)
		{
			// Firearm Reload Behaviour
			switch (unit_firearm_reload_animation_state)
			{
				case UnitFirearmReloadAnimationState.Reload_End:
				default:
					unit_firearm_reload_animation_state = UnitEquipmentAnimationState.Firearm;
					break;
			}
			
			// Point firearm at Reload Safety Angle
			temp_weapon_ambient_angle = (draw_xscale < 0 ? 180 + draw_angle_value : draw_angle_value) + (firearm_reload_safety_angle * temp_weapon_facing_sign);
		}
		else
		{
			if (temp_firearm_is_aimed)
			{
				// Move firearm to aiming pivot
				firearm_aim_transition_value = lerp(firearm_aim_transition_value, 1, firearm_aiming_aim_transition_spd * frame_delta);
				
				// Walk Backwards while Aiming
				animation_speed_direction = ((x_velocity != 0) and (sign(x_velocity) != temp_weapon_facing_sign)) ? -1 : 1;
			}
			else
			{
				// Rest Gun at hip pivot
				firearm_aim_transition_value = lerp(firearm_aim_transition_value, 0, firearm_aiming_hip_transition_spd * frame_delta);
				
				// Point firearm at Idle Safety Angle if Idle, point firearm at Moving Safety Angle if Moving
				temp_weapon_ambient_angle = (draw_xscale < 0 ? 180 + draw_angle_value : draw_angle_value) + ((x_velocity == 0) ? (firearm_idle_safety_angle * temp_weapon_facing_sign) : (firearm_moving_safety_angle * temp_weapon_facing_sign));
			}
		}
		
		// Update Unit's Weapon Offset
		var temp_weapon_horizontal_offset = lerp(global.unit_packs[unit_pack].equipment_firearm_hip_x, global.unit_packs[unit_pack].equipment_firearm_aim_x, firearm_aim_transition_value) * draw_xscale;
		var temp_weapon_vertical_offset = lerp(global.unit_packs[unit_pack].equipment_firearm_hip_y, global.unit_packs[unit_pack].equipment_firearm_aim_y, firearm_aim_transition_value) * draw_yscale;
		
		// Update Unit Weapon Bob
		switch (unit_animation_state)
		{
			case UnitAnimationState.Idle:
			case UnitAnimationState.Walking:
			case UnitAnimationState.AimWalking:
				temp_weapon_vertical_offset += dsin((((floor(draw_image_index + (limb_animation_double_cycle * draw_image_index_length))) / (draw_image_index_length * 2)) + weapon_bobbing_animation_percent_offset) * 360) * weapon_vertical_bobbing_height;
				break;
			default:
				break;
		}
		
		// Update Weapon Recoil
		temp_weapon_horizontal_offset += weapon_equipped.weapon_horizontal_recoil * temp_weapon_facing_sign;
		temp_weapon_vertical_offset += weapon_equipped.weapon_vertical_recoil;
		
		// Update Weapon Position
		rot_prefetch(draw_angle_value);
		var temp_weapon_x = x + rot_point_x(temp_weapon_horizontal_offset, temp_weapon_vertical_offset);
		var temp_weapon_y = y + ground_contact_vertical_offset + rot_point_y(temp_weapon_horizontal_offset, temp_weapon_vertical_offset);
		
		// Update Limb Pivots
		limb_left_arm.limb_xscale = temp_weapon_facing_sign;
		limb_right_arm.limb_xscale = temp_weapon_facing_sign;
		
		var temp_left_arm_anchor_offset_x = limb_left_arm.anchor_offset_x * draw_xscale;
		var temp_left_arm_anchor_offset_y = limb_left_arm.anchor_offset_y * draw_yscale;
		
		limb_left_arm.limb_pivot_ax = x + rot_point_x(temp_left_arm_anchor_offset_x, temp_left_arm_anchor_offset_y);
		limb_left_arm.limb_pivot_ay = y + ground_contact_vertical_offset + rot_point_y(temp_left_arm_anchor_offset_x, temp_left_arm_anchor_offset_y);
		
		var temp_right_arm_anchor_offset_x = limb_right_arm.anchor_offset_x * draw_xscale;
		var temp_right_arm_anchor_offset_y = limb_right_arm.anchor_offset_y * draw_yscale;
		
		limb_right_arm.limb_pivot_ax = x + rot_point_x(temp_right_arm_anchor_offset_x, temp_right_arm_anchor_offset_y);
		limb_right_arm.limb_pivot_ay = y + ground_contact_vertical_offset + rot_point_y(temp_right_arm_anchor_offset_x, temp_right_arm_anchor_offset_y);
		
		// Update Weapon's Angle
		var temp_weapon_angle = (weapon_equipped.weapon_angle - (angle_difference(weapon_equipped.weapon_angle, temp_firearm_is_aimed ? point_direction(temp_weapon_x, temp_weapon_y, weapon_aim_x, weapon_aim_y) : temp_weapon_ambient_angle) * firearm_aiming_angle_transition_spd * frame_delta)) mod 360;
		temp_weapon_angle = temp_weapon_angle < 0 ? temp_weapon_angle + 360 : temp_weapon_angle;
		
		// Update Weapon Position & Angle Physics
		weapon_equipped.update_weapon_physics(temp_weapon_x, temp_weapon_y, temp_weapon_angle, temp_weapon_facing_sign);
		
		// Update Weapon Limb Targets
		var temp_weapon_primary_hand_horizontal_offset = global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x;
		var temp_weapon_primary_hand_vertical_offset = global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y * weapon_equipped.weapon_facing_sign;
		
		var temp_weapon_offhand_hand_horizontal_offset = global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_offhand_x;
		var temp_weapon_offhand_hand_vertical_offset = global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_offhand_y * weapon_equipped.weapon_facing_sign;
		
		rot_prefetch((weapon_equipped.weapon_angle + (weapon_equipped.weapon_angle_recoil * weapon_equipped.weapon_facing_sign)) mod 360);
		
		var temp_weapon_primary_hand_target_x = rot_point_x(temp_weapon_primary_hand_horizontal_offset, temp_weapon_primary_hand_vertical_offset);
		var temp_weapon_primary_hand_target_y = rot_point_y(temp_weapon_primary_hand_horizontal_offset, temp_weapon_primary_hand_vertical_offset);
		
		var temp_weapon_offhand_hand_target_x = rot_point_x(temp_weapon_offhand_hand_horizontal_offset, temp_weapon_offhand_hand_vertical_offset);
		var temp_weapon_offhand_hand_target_y = rot_point_y(temp_weapon_offhand_hand_horizontal_offset, temp_weapon_offhand_hand_vertical_offset);
		
		limb_left_arm.update_target(weapon_equipped.weapon_x + temp_weapon_primary_hand_target_x, weapon_equipped.weapon_y + temp_weapon_primary_hand_target_y);
		limb_right_arm.update_target(weapon_equipped.weapon_x + temp_weapon_offhand_hand_target_x, weapon_equipped.weapon_y + temp_weapon_offhand_hand_target_y);
		break;
	default:
		// Reset Animation Speed Direction
		animation_speed_direction = 1;
		
		// Update Non-Weapon Unit Animations
		switch (unit_animation_state)
		{
			case UnitAnimationState.Idle:
				var temp_animation_percentage = (floor(draw_image_index + (limb_animation_double_cycle * draw_image_index_length))) / (draw_image_index_length * 2);
				limb_left_arm.update_idle_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, draw_angle_value, temp_animation_percentage);
				limb_right_arm.update_idle_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, draw_angle_value, temp_animation_percentage);
				break;
			case UnitAnimationState.Walking:
				var temp_animation_percentage = floor(draw_image_index) / draw_image_index_length;
				var temp_walk_animation_percentage = (floor(draw_image_index + (limb_animation_double_cycle * draw_image_index_length))) / (draw_image_index_length * 2);
				limb_left_arm.update_walk_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, draw_angle_value, temp_animation_percentage, temp_walk_animation_percentage);
				limb_right_arm.update_walk_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, draw_angle_value, temp_animation_percentage, temp_walk_animation_percentage);
				break;
			case UnitAnimationState.Jumping:
				limb_left_arm.update_jump_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, draw_angle_value);
				limb_right_arm.update_jump_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, draw_angle_value);
				break;
		}
		break;
}
#endregion

// Update Image Index
if (draw_image_index_length != -1)
{
	draw_image_index += (animation_speed * animation_speed_direction) * frame_delta;
	
	if (draw_image_index >= draw_image_index_length)
	{
		limb_animation_double_cycle = !limb_animation_double_cycle;
		draw_image_index = draw_image_index mod draw_image_index_length;
	}
	
	image_index = floor(draw_image_index);
}