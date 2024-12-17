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
		// Check if Unit is Aiming
		if (input_aim)
		{
			// Firearm Aiming Reload Interrupt Behaviour
			if (!weapon_aim and unit_equipment_animation_state == UnitEquipmentAnimationState.FirearmReload)
			{
				// Weapon Type impacts Reload Interrupt Animation
				if (global.weapon_packs[weapon_equipped.weapon_pack].weapon_type == WeaponType.BoltActionFirearm and weapon_equipped.weapon_image_index == 1 and weapon_equipped.firearm_ammo > 0)
				{
					// Bolt Action Firearm Weapon Interrupt Animation - End Reload Animation but close Bolt Action Firearm's Chamber to be ready to fire the next shot
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition;
					
					// Set Primary Hand's Firearm Animation Path - From "any arbitrary position the primary hand was positioned during the reload animation" to Firearm's Bolt Handle Open Chamber Position
					unit_set_firearm_primary_hand_animation
					(
						lerp(firearm_weapon_primary_hand_pivot_offset_ax, firearm_weapon_primary_hand_pivot_offset_bx, firearm_weapon_primary_hand_pivot_transition_value) + hand_fumble_animation_offset_x, 
						lerp(firearm_weapon_primary_hand_pivot_offset_ay, firearm_weapon_primary_hand_pivot_offset_by, firearm_weapon_primary_hand_pivot_transition_value) + hand_fumble_animation_offset_y, 
						global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_x, 
						global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_y, 
						0
					);
				}
				else
				{
					// Default Firearm Weapon Interrupt Animation - End Reload Animation
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;
					
					// Set Primary Hand's Firearm Animation Path - From "any arbitrary position the primary hand was positioned during the reload animation" to Firearm's Trigger Group Position (Inversed Path Interpolation Value)
					unit_set_firearm_primary_hand_animation
					(
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, 
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y, 
						lerp(firearm_weapon_primary_hand_pivot_offset_ax, firearm_weapon_primary_hand_pivot_offset_bx, firearm_weapon_primary_hand_pivot_transition_value) + hand_fumble_animation_offset_x, 
						lerp(firearm_weapon_primary_hand_pivot_offset_ay, firearm_weapon_primary_hand_pivot_offset_by, firearm_weapon_primary_hand_pivot_transition_value) + hand_fumble_animation_offset_y, 
						1
					);
				}
				
				// Reset Hand Fumble Animation Values
				hand_fumble_animation_offset_x = 0;
				hand_fumble_animation_offset_y = 0;
			}
			
			// Enable Unit Weapon Aim
			weapon_aim = true;
			weapon_aim_x = input_cursor_x;
			weapon_aim_y = input_cursor_y;
		}
		else
		{
			// Disable Unit Weapon Aim
			weapon_aim = false;
			weapon_aim_x = x + (sign(draw_xscale) * 320);
			weapon_aim_y = y - global.unit_packs[unit_pack].equipment_firearm_hip_y;
		}

		// Unit Weapon Operation Behaviour
		if (input_reload and unit_equipment_animation_state == UnitEquipmentAnimationState.Firearm)
		{
			// Perform Firearm Reload
			unit_equipment_animation_state = UnitEquipmentAnimationState.FirearmReload;
			
			// Reload Animation
			switch (global.weapon_packs[weapon_equipped.weapon_pack].weapon_type)
			{
				case WeaponType.BoltActionFirearm:
					// Initiate Bolt Action Reload
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition;
					
					// Weapon Primary Hand Animation: Hand reaches from Firearm's Trigger Group Position to Firearm's Closed Bolt Handle Position
					unit_set_firearm_primary_hand_animation
					(
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, 
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y, 
						global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x, 
						global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y
					);
					break;
				default:
					// Initiate Default Firearm Reload
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToUnitInventory;
					
					// Open Firearm Chamber
					weapon_equipped.open_firearm_chamber();
					
					// Weapon Primary Hand Animation Reset
					unit_set_firearm_primary_hand_animation
					(
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, 
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y, 
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, 
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y
					);
					break;
			}
			
			// Reset Primary Hand Weapon Relative Pivot Values
			firearm_weapon_primary_hand_pivot_transition_value = 0;
			
			// Reset Primary Hand Unit Inventory Pivot Values
			firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = 0;
		}
		else if (input_attack and weapon_active)
		{
			// Weapon Attack Behaviour
			switch(global.weapon_packs[weapon_equipped.weapon_pack].weapon_type)
			{
				// Firearm Attack Behaviours
				case WeaponType.DefaultFirearm:
				case WeaponType.BoltActionFirearm:
					// Unit cannot attack with their Firearm if they are performing their Firearm's reload animation
					if (unit_equipment_animation_state != UnitEquipmentAnimationState.FirearmReload)
					{
						// Unit must finish their Firearm's recoil animation cycle to attack again with their Firearm
						if (firearm_weapon_primary_hand_pivot_transition_value <= animation_asymptotic_tolerance and firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value <= animation_asymptotic_tolerance)
						{
							// Weapon Attack Behaviour - Attack with Firearm
							var temp_weapon_attack = weapon_equipped.update_weapon_attack();
							
							// Weapon Attack Unit Behaviour
							if (temp_weapon_attack)
							{
								if (global.weapon_packs[weapon_equipped.weapon_pack].weapon_type == WeaponType.BoltActionFirearm and weapon_equipped.firearm_ammo > 0)
								{
									// Bolt Action Recharge Animation
									unit_equipment_animation_state = UnitEquipmentAnimationState.FirearmReload;
									
									// Bolt Action Reload
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition;
									
									// Weapon Primary Hand Animation: Hand reaches from current position to firearm bolt handle
									unit_set_firearm_primary_hand_animation
									(
										global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, 
										global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y, 
										global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x, 
										global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y, 
										0
									);
								}
							}
						}
					}
					break;
				// Default Weapon Attack Behaviour
				default:
					break;
			}
		}
	}
	
	// Horizontal Movement Behaviour
	var move_spd = weapon_aim || unit_equipment_animation_state == UnitEquipmentAnimationState.FirearmReload ? walk_spd : run_spd;
	
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
					for (var v = 1; v <= slope_tolerance; v++) 
					{
						if (!place_free(x, y + v)) 
						{
							// GROUND CONTACT
							y_velocity = v - 1;
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
			x_velocity = 0;
			
			for (var h = 1; h <= abs(hspd); h++)
			{
				var temp_hspd = (sign(hspd) * h);
				
				if (!place_free(x + temp_hspd, y))
				{
					// GROUND CONTACT
					x_velocity = (sign(hspd) * (h - 1));
				
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
				var temp_hspd = (sign(hspd) * h);
				
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
			var temp_vspd = (sign(vspd) * v);
			
			if (!platform_free(x, y + temp_vspd, platform_list))
			{
				// GROUND CONTACT
				y_velocity = temp_vspd - sign(vspd);
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
		// Update Firearm Recoil Behaviour & Attack Delay Timers
		case WeaponType.DefaultFirearm:
		case WeaponType.BoltActionFirearm:
			weapon_equipped.update_weapon_behaviour(firearm_recoil_recovery_spd, firearm_recoil_angle_recovery_spd);
			break;
		// Update Default Weapon Behaviour
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
	// Set Unit's Horizontal Scale to match the direction it is facing while moving
	draw_xscale = abs(draw_xscale) * sign(x_velocity);
}
	
if (grounded)
{
	// Walking or Idle Animation
	switch (unit_equipment_animation_state)
	{
		case UnitEquipmentAnimationState.Firearm:
			// Operating Firearm Movement Animations
			var temp_unit_aimed_animation = weapon_aim and firearm_weapon_hip_pivot_to_aim_pivot_transition_value >= 0.5;
			temp_unit_animation_state = x_velocity != 0 ? (temp_unit_aimed_animation ? UnitAnimationState.AimWalking : UnitAnimationState.Walking) : (temp_unit_aimed_animation ? UnitAnimationState.Aiming : UnitAnimationState.Idle);
			break;
		case UnitEquipmentAnimationState.FirearmReload:
			// Reloading Firearm Movement Animations
			switch (unit_firearm_reload_animation_state)
			{
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
					temp_unit_animation_state = x_velocity != 0 ? UnitAnimationState.AimWalking : UnitAnimationState.Aiming;
					break;
				default:
					var temp_unit_aimed_animation = firearm_weapon_hip_pivot_to_aim_pivot_transition_value >= 0.5;
					temp_unit_animation_state = x_velocity != 0 ? UnitAnimationState.AimWalking : (temp_unit_aimed_animation ? UnitAnimationState.Aiming : UnitAnimationState.Idle);
					break;
			}
			break;
		default:
			// Default Unholstered Movement Animations
			temp_unit_animation_state = x_velocity != 0 ? UnitAnimationState.Walking : UnitAnimationState.Idle;
			break;
	}
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
	// Set Animation State
	unit_animation_state = temp_unit_animation_state;
	
	// Set Animation State Properties
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
	case UnitEquipmentAnimationState.FirearmReload:
		// Firearm Reload Behaviour
		switch (unit_firearm_reload_animation_state)
		{
			case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
			case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
			case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
			case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
			case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
				// Bolt Action Reload Events - Primary Hand operates Firearm's Bolt Handle sliding it backwards or forwards to open or close Firearm's Chamber
				firearm_weapon_hip_pivot_to_aim_pivot_transition_value = lerp(firearm_weapon_hip_pivot_to_aim_pivot_transition_value, 1, firearm_aiming_hip_transition_spd * frame_delta);
				
				// Firearm must have finished its recoil animation cycle to perform Bolt Action Firearm's reload animation
				if (weapon_equipped.firearm_recoil_recovery_delay <= 0 and weapon_equipped.firearm_attack_delay <= 0)
				{
					// Update Unit's Primary Hand Path Animation - Fast Hand Speed for opening and closing the Firearm's Bolt Handle
					firearm_weapon_primary_hand_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_transition_value, 1, hand_fast_movement_spd * frame_delta);
					
					// Firearm must be aimed and Unit must have finished their Primary Hand's Path Animation to perform next Animation Event
					if (firearm_weapon_hip_pivot_to_aim_pivot_transition_value >= 1 - animation_asymptotic_tolerance and firearm_weapon_primary_hand_pivot_transition_value >= 1 - animation_asymptotic_tolerance)
					{
						switch (unit_firearm_reload_animation_state)
						{
							case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
								// Bolt Action Firearm's Chamber is Opened (The Bolt Handle has been pulled backwards for the animation displayed between shots) - Begin pushing the Firearm's Bolt Handle forward to recharge for the next shot
								unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle;
								
								// Open Firearm Chamber
								weapon_equipped.open_firearm_chamber();
								
								// Set Primary Hand's Firearm Animation Path - From Firearm's Opened Bolt Position to Firearm's Closed Bolt Position
								unit_set_firearm_primary_hand_animation
								(
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_x, 
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_y,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y,
									0
								);
								break;
							case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
								// Bolt Action Firearm's Chamber is Opened (The Bolt Handle has been pulled backwards for a reload animation) - Begin moving primary hand to Unit's Inventory to grab individual ammo rounds
								unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToUnitInventory;
								
								// Reset Primary Hand Animation's Path Interpolation Value to begin next animation (Inversed Path Interpolation Value) 
								firearm_weapon_primary_hand_pivot_transition_value = 1;
								
								// Open Firearm Chamber
								weapon_equipped.open_firearm_chamber();
								break;
							case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
							case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
							case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
							default:
								// End Bolt Action Reload Animation
								if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle)
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_End;
								}
								else
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;
								}
							
								// Close Firearm Chamber
								weapon_equipped.close_firearm_chamber();
								
								// Set Primary Hand's Firearm Animation Path - From Firearm's Closed Bolt Position to Firearm's Trigger Group (Inversed Path Interpolation Value)
								unit_set_firearm_primary_hand_animation
								(
									global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, 
									global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y,
									1
								);
								break;
						}
					}
				}
				break;
			case UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
			case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
			case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
			case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
				// Bolt Action Reload Events - Primary Hand moves from ambient position to operate Firearm's Bolt Handle
				firearm_weapon_hip_pivot_to_aim_pivot_transition_value = lerp(firearm_weapon_hip_pivot_to_aim_pivot_transition_value, 1, firearm_aiming_hip_transition_spd * frame_delta);
				
				// Firearm must have finished its recoil animation cycle to perform Bolt Action Firearm's reload animation
				if (weapon_equipped.firearm_recoil_recovery_delay <= 0 and weapon_equipped.firearm_attack_delay <= 0)
				{
					// Update Unit's Primary Hand Path Animation - Default Hand Speed
					firearm_weapon_primary_hand_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_transition_value, 1, hand_default_movement_spd * frame_delta);
					
					// Firearm must be aimed and Unit must have finished their Primary Hand's Path Animation to perform next Animation Event
					if (firearm_weapon_hip_pivot_to_aim_pivot_transition_value >= 1 - animation_asymptotic_tolerance and firearm_weapon_primary_hand_pivot_transition_value >= 1 - animation_asymptotic_tolerance)
					{
						firearm_weapon_hip_pivot_to_aim_pivot_transition_value = 1;
						
						switch (unit_firearm_reload_animation_state)
						{
							case UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
							case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
								// Bolt Action Primary Hand Animation for grabbing the Bolt Handle BACKWARDS to open the Firearm's Chamber
								if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition)
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle;
								}
								else
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle;
								}
								
								// Set Primary Hand's Firearm Animation Path - From Firearm's Open Bolt Position to Firearm's Closed Bolt Position
								unit_set_firearm_primary_hand_animation
								(
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x, 
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_x,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_y,
									0
								);
								break;
							case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
							case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
								// Bolt Action Primary Hand Animation for grabbing the Bolt Handle FORWARD to close the Firearm's Chamber
								if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition)
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle;
								}
								else
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle;
								}
								
								// Set Primary Hand's Firearm Animation Path - From Firearm's Closed Bolt Position to Firearm's Open Bolt Position
								unit_set_firearm_primary_hand_animation
								(
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_x, 
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_y,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y,
									0
								);
								break;
						}
					}
				}
				break;
			case UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToUnitInventory:
				// Rest Gun at hip pivot
				firearm_weapon_hip_pivot_to_aim_pivot_transition_value = lerp(firearm_weapon_hip_pivot_to_aim_pivot_transition_value, 0, firearm_aiming_hip_transition_spd * frame_delta);
				firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value, 1, hand_default_movement_spd * frame_delta);
				
				// Progress to next Reload Animation State
				if (firearm_weapon_hip_pivot_to_aim_pivot_transition_value <= animation_asymptotic_tolerance and firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value >= (1 - animation_asymptotic_tolerance))
				{
					// Set Hand Fumble Animation
					unit_set_hand_fumble_animation(30);
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_InventoryHandFumbleAnimation;
					
					// Reset Transition Values
					firearm_weapon_hip_pivot_to_aim_pivot_transition_value = 0;
					firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = 1;
				}
				break;
			case UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToFirearmReloadPosition:
				// Move Hand to Reload Firearm
				firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value, 0, hand_default_movement_spd * frame_delta);
				
				if (firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value <= animation_asymptotic_tolerance)
				{
					// Set to either Magazine Insert Animation State or Reload Individual Rounds Animation State
					unit_firearm_reload_animation_state = global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_individual_rounds ? UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadPosition : UnitFirearmReloadAnimationState.ReloadMagazine_MagazineInsertAnimation;
					firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = 0;
				}
				break;
			case UnitFirearmReloadAnimationState.ReloadMagazine_MagazineInsertAnimation:
			case UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadPosition:
				// Move Hand to Reload Firearm
				firearm_weapon_primary_hand_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_transition_value, 1, hand_default_movement_spd * frame_delta);
				
				if (firearm_weapon_primary_hand_pivot_transition_value >= 1 - animation_asymptotic_tolerance)
				{
					// Set Hand Fumble Animation
					unit_set_hand_fumble_animation(20);
					
					switch (unit_firearm_reload_animation_state)
					{
						case UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadPosition:
							unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadIndividualRounds_IndividualRoundHandFumbleAnimation;
							break;
						case UnitFirearmReloadAnimationState.ReloadMagazine_MagazineInsertAnimation:
						default:
							unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadMagazine_MagazineHandFumbleAnimation;
							break;
					}
					
					// Reset Primary Hand Animation's Path Interpolation Value to begin next animation (Inversed Path Interpolation Value)
					firearm_weapon_primary_hand_pivot_transition_value = 1;
				}
				break;
			case UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadOffsetPosition:
				// Move Hand to Reload Individual Rounds into Firearm from Reload Offset Position - Extremely Fast Reload Animation
				firearm_weapon_primary_hand_pivot_transition_value *= power(0.5, frame_delta);
				
				if (firearm_weapon_primary_hand_pivot_transition_value <= animation_asymptotic_tolerance)
				{
					// Primary Hand is positioned at Firearm's Reload Offset Position - Begin the animation to load another round into Firearm
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadPosition;
					
					// Reset Primary Hand Animation's Path Interpolation Value to begin next animation
					firearm_weapon_primary_hand_pivot_transition_value = 0;
				}
				break;
			case UnitFirearmReloadAnimationState.Reload_InventoryHandFumbleAnimation:
			case UnitFirearmReloadAnimationState.ReloadMagazine_MagazineHandFumbleAnimation:
			case UnitFirearmReloadAnimationState.ReloadIndividualRounds_IndividualRoundHandFumbleAnimation:
				// Hand Fumble Animation Transition
				hand_fumble_animation_transition_value = lerp(hand_fumble_animation_transition_value, 0, hand_fumble_animation_travel_spd * frame_delta);
				
				if (hand_fumble_animation_transition_value <= animation_asymptotic_tolerance)
				{
					// Hand Fumble Animation Repeat Timer
					hand_fumble_animation_cycle_timer -= frame_delta;
					
					if (hand_fumble_animation_cycle_timer <= 0)
					{
						// Reset Hand Fumble Animation to next position
						hand_fumble_animation_transition_value = 1;
						
						hand_fumble_animation_cycle_timer = random_range(hand_fumble_animation_delay_min, hand_fumble_animation_delay_max);
						
						hand_fumble_animation_offset_ax = hand_fumble_animation_offset_bx;
						hand_fumble_animation_offset_ay = hand_fumble_animation_offset_by;
						
						hand_fumble_animation_offset_bx = random_range(-hand_fumble_animation_travel_size, hand_fumble_animation_travel_size);
						hand_fumble_animation_offset_by = random_range(-hand_fumble_animation_travel_size, hand_fumble_animation_travel_size);
					}
				}
				
				// Update Primary Hand Fumble Position
				hand_fumble_animation_offset_x = lerp(hand_fumble_animation_offset_bx, hand_fumble_animation_offset_ax, hand_fumble_animation_transition_value);
				hand_fumble_animation_offset_y = lerp(hand_fumble_animation_offset_by, hand_fumble_animation_offset_ay, hand_fumble_animation_transition_value);
				
				// Hand Fumble Timer
				hand_fumble_animation_timer -= frame_delta;
				
				if (hand_fumble_animation_timer <= 0)
				{
					// Hand Fumble Finished Behaviour
					hand_fumble_animation_offset_x = 0;
					hand_fumble_animation_offset_y = 0;
					
					// Hand Fumble Animation End Conditions
					if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.Reload_InventoryHandFumbleAnimation)
					{
						// Hand Grabs Item from Inventory
						unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToFirearmReloadPosition;
						limb_primary_arm.set_held_item(UnitHeldItem.FAL_Magazine); // DEBUG!!!
						//limb_primary_arm.set_held_item(UnitHeldItem.DebugHeldItem);
						
						// Configure Primary Hand Pivots to perform Magazine Animation
						unit_set_firearm_primary_hand_animation
						(
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_x + global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_offset_x, 
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_y + global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_offset_y,
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_x,
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_y,
							0
						);
					}
					else if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.ReloadMagazine_MagazineHandFumbleAnimation)
					{
						// End Reload Animation
						unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;
						
						// Magazine is loaded into Firearm 
						weapon_equipped.reload_firearm();
						limb_primary_arm.set_held_item();
						
						// Close Firearm Chamber
						weapon_equipped.close_firearm_chamber();
						
						// Set Primary Hand's Firearm Animation Path - From Firearm's Magazine Reload Position to Firearm's Hand Trigger Position (Inversed Path Interpolation Value)
						unit_set_firearm_primary_hand_animation
						(
							global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x,
							global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y,
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_x,
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_y,
							1
						);
					}
					else if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.ReloadIndividualRounds_IndividualRoundHandFumbleAnimation)
					{
						// Reload Firearm with One Round
						weapon_equipped.reload_firearm(1);
						
						// Check if Firearm is finished being reloaded
						if (weapon_equipped.firearm_ammo < global.weapon_packs[weapon_equipped.weapon_pack].firearm_max_ammo_capacity)
						{
							// Firearm is not finished being reloaded - Begin reloading another round
							unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadOffsetPosition;
						}
						else
						{
							// Firearm is finished being reloaded - Move hand to close Bolt Action Chamber
							unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition;
						
							// Reset Primary Hand's Held Item
							limb_primary_arm.set_held_item();
							
							// Set Primary Hand's Firearm Animation Path - From Firearm's Reload Position to Firearm's Open Bolt Position
							unit_set_firearm_primary_hand_animation
							(
								global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_x, 
								global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_y,
								global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_x,
								global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_y,
								0
							);
						}
					}
				}
				break;
			case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_End:
			case UnitFirearmReloadAnimationState.Reload_End:
			default:
				// Reload Animation Reset Behaviour
				limb_primary_arm.set_held_item();
				
				// Reset Unit Equipment State to Firearm
				unit_equipment_animation_state = UnitEquipmentAnimationState.Firearm;
				
				// Reset Hand Fumble Animation Values
				hand_fumble_animation_offset_x = 0;
				hand_fumble_animation_offset_y = 0;
				break;
		}
	case UnitEquipmentAnimationState.Firearm:
		// Firearm Animation States
		var temp_firearm_reload = unit_equipment_animation_state == UnitEquipmentAnimationState.FirearmReload;
		var temp_firearm_is_aimed = weapon_aim and !temp_firearm_reload;
	
		// Update Facing Direction
		draw_xscale = temp_firearm_is_aimed ? (abs(draw_xscale) * ((weapon_aim_x - x >= 0) ? 1 : -1)) : draw_xscale;
		var temp_firearm_facing_sign = sign(draw_xscale);
		animation_speed_direction = 1;
		
		// Pre-calc Unit's Slope Rotation
		rot_prefetch(draw_angle_value);
	
		// Firearm Reload Animation
		var temp_firearm_ambient_angle;
		
		var temp_firearm_primary_hand_horizontal_offset = lerp(global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, firearm_weapon_primary_hand_pivot_offset_bx, firearm_weapon_primary_hand_pivot_transition_value);
		var temp_firearm_primary_hand_vertical_offset = lerp(global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y, firearm_weapon_primary_hand_pivot_offset_by, firearm_weapon_primary_hand_pivot_transition_value);
		
		var temp_firearm_offhand_hand_horizontal_offset = global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_offhand_x;
		var temp_firearm_offhand_hand_vertical_offset = global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_offhand_y;
		
		// Firearm Operation Behaviour
		if (temp_firearm_reload)
		{
			// Reload Animation Weapon Ambient Angle
			switch (unit_firearm_reload_animation_state)
			{
				case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
				case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
				case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_End:
					// Reset Primary Hand to Firearm Operation Position - Reload Interrupt Hand Movement is Fast
					firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value, 0, hand_fast_movement_spd * frame_delta);
					
					// Refresh Facing Direction - Reload Interrupt Allows Firearm Aiming
					temp_firearm_is_aimed = weapon_aim;
					draw_xscale = temp_firearm_is_aimed ? (abs(draw_xscale) * ((weapon_aim_x - x >= 0) ? 1 : -1)) : draw_xscale;
					temp_firearm_facing_sign = sign(draw_xscale);
					
					// Walk Backwards while Aiming
					animation_speed_direction = ((x_velocity != 0) and (sign(x_velocity) != temp_firearm_facing_sign)) ? -1 : 1;
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
					// Point firearm at Weapon Angle previously held before reloading
					temp_firearm_ambient_angle = draw_xscale < 0 ? 180 - weapon_equipped.weapon_old_angle : weapon_equipped.weapon_old_angle;
					break;
				default:
					// Point firearm at Reload Safety Angle
					temp_firearm_ambient_angle = (draw_xscale < 0 ? 180 + draw_angle_value : draw_angle_value) + (firearm_reload_safety_angle * temp_firearm_facing_sign);
					break;
			}
			
			// Update Unit Equipment Inventory Position
			unit_equipment_inventory_position_x = x + (rot_point_x(global.unit_packs[unit_pack].equipment_inventory_x * draw_xscale, global.unit_packs[unit_pack].equipment_inventory_y));
			unit_equipment_inventory_position_y = y + ground_contact_vertical_offset + (rot_point_y(global.unit_packs[unit_pack].equipment_inventory_x * draw_xscale, global.unit_packs[unit_pack].equipment_inventory_y) * draw_yscale);
			
			// Update Primary Hand Position
			temp_firearm_primary_hand_horizontal_offset = lerp(firearm_weapon_primary_hand_pivot_offset_ax, firearm_weapon_primary_hand_pivot_offset_bx, firearm_weapon_primary_hand_pivot_transition_value);
			temp_firearm_primary_hand_vertical_offset = lerp(firearm_weapon_primary_hand_pivot_offset_ay, firearm_weapon_primary_hand_pivot_offset_by, firearm_weapon_primary_hand_pivot_transition_value);
		}
		else
		{
			// Reset Primary Hand to Firearm Operation Position
			firearm_weapon_primary_hand_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_transition_value, 0, hand_default_movement_spd * frame_delta);
			firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value, 0, hand_default_movement_spd * frame_delta);
			
			// Firearm Aiming & Holstered Operation Behaviour
			if (temp_firearm_is_aimed)
			{
				// Move firearm to aiming pivot
				firearm_weapon_hip_pivot_to_aim_pivot_transition_value = lerp(firearm_weapon_hip_pivot_to_aim_pivot_transition_value, 1, firearm_aiming_aim_transition_spd * frame_delta);
				
				// Walk Backwards while Aiming
				animation_speed_direction = ((x_velocity != 0) and (sign(x_velocity) != temp_firearm_facing_sign)) ? -1 : 1;
				
				// Update Old Weapon Angle
				weapon_equipped.weapon_old_angle = draw_xscale < 0 ? 180 - weapon_equipped.weapon_angle : weapon_equipped.weapon_angle;
			}
			else
			{
				// Rest Gun at hip pivot
				firearm_weapon_hip_pivot_to_aim_pivot_transition_value = lerp(firearm_weapon_hip_pivot_to_aim_pivot_transition_value, 0, firearm_aiming_hip_transition_spd * frame_delta);
				
				// Point firearm at Idle Safety Angle if Idle, point firearm at Moving Safety Angle if Moving
				temp_firearm_ambient_angle = (draw_xscale < 0 ? 180 + draw_angle_value : draw_angle_value) + ((x_velocity == 0) ? (firearm_idle_safety_angle * temp_firearm_facing_sign) : (firearm_moving_safety_angle * temp_firearm_facing_sign));
			}
		}
		
		// Update Unit's Weapon Offset
		var temp_firearm_horizontal_offset = lerp(global.unit_packs[unit_pack].equipment_firearm_hip_x, global.unit_packs[unit_pack].equipment_firearm_aim_x, firearm_weapon_hip_pivot_to_aim_pivot_transition_value) * draw_xscale;
		var temp_firearm_vertical_offset = lerp(global.unit_packs[unit_pack].equipment_firearm_hip_y, global.unit_packs[unit_pack].equipment_firearm_aim_y, firearm_weapon_hip_pivot_to_aim_pivot_transition_value) * draw_yscale;
		
		// Update Unit Weapon Bob
		switch (unit_animation_state)
		{
			case UnitAnimationState.Idle:
			case UnitAnimationState.Walking:
			case UnitAnimationState.AimWalking:
				temp_firearm_vertical_offset += dsin((((floor(draw_image_index + (limb_animation_double_cycle * draw_image_index_length))) / (draw_image_index_length * 2)) + weapon_bobbing_animation_percent_offset) * 360) * weapon_vertical_bobbing_height;
				break;
			default:
				break;
		}
		
		// Update Weapon Recoil
		temp_firearm_horizontal_offset += weapon_equipped.weapon_horizontal_recoil * temp_firearm_facing_sign;
		temp_firearm_vertical_offset += weapon_equipped.weapon_vertical_recoil;
		
		// Update Weapon Position
		var temp_firearm_x = x + rot_point_x(temp_firearm_horizontal_offset, temp_firearm_vertical_offset);
		var temp_firearm_y = y + ground_contact_vertical_offset + rot_point_y(temp_firearm_horizontal_offset, temp_firearm_vertical_offset);
		
		// Update Limb Pivots
		limb_primary_arm.limb_xscale = temp_firearm_facing_sign;
		limb_secondary_arm.limb_xscale = temp_firearm_facing_sign;
		
		var temp_left_arm_anchor_offset_x = limb_primary_arm.anchor_offset_x * draw_xscale;
		var temp_left_arm_anchor_offset_y = limb_primary_arm.anchor_offset_y * draw_yscale;
		
		limb_primary_arm.limb_pivot_ax = x + rot_point_x(temp_left_arm_anchor_offset_x, temp_left_arm_anchor_offset_y);
		limb_primary_arm.limb_pivot_ay = y + ground_contact_vertical_offset + rot_point_y(temp_left_arm_anchor_offset_x, temp_left_arm_anchor_offset_y);
		
		var temp_right_arm_anchor_offset_x = limb_secondary_arm.anchor_offset_x * draw_xscale;
		var temp_right_arm_anchor_offset_y = limb_secondary_arm.anchor_offset_y * draw_yscale;
		
		limb_secondary_arm.limb_pivot_ax = x + rot_point_x(temp_right_arm_anchor_offset_x, temp_right_arm_anchor_offset_y);
		limb_secondary_arm.limb_pivot_ay = y + ground_contact_vertical_offset + rot_point_y(temp_right_arm_anchor_offset_x, temp_right_arm_anchor_offset_y);
		
		// Update Weapon's Angle
		var temp_firearm_angle_difference = angle_difference(weapon_equipped.weapon_angle, temp_firearm_is_aimed ? point_direction(temp_firearm_x, temp_firearm_y, weapon_aim_x, weapon_aim_y) : temp_firearm_ambient_angle);
		var temp_firearm_angle = (weapon_equipped.weapon_angle - (temp_firearm_angle_difference * firearm_aiming_angle_transition_spd * frame_delta)) mod 360;
		temp_firearm_angle = temp_firearm_angle < 0 ? temp_firearm_angle + 360 : temp_firearm_angle;
		
		// Update Weapon Position & Angle Physics
		weapon_equipped.update_weapon_physics(temp_firearm_x, temp_firearm_y, temp_firearm_angle, temp_firearm_facing_sign);
		
		// Update Weapon Limb Targets
		temp_firearm_primary_hand_vertical_offset *= weapon_equipped.weapon_facing_sign;
		temp_firearm_offhand_hand_vertical_offset *= weapon_equipped.weapon_facing_sign;
		
		rot_prefetch((weapon_equipped.weapon_angle + (weapon_equipped.weapon_angle_recoil * weapon_equipped.weapon_facing_sign)) mod 360);
		
		var temp_firearm_primary_hand_target_x = weapon_equipped.weapon_x + rot_point_x(temp_firearm_primary_hand_horizontal_offset, temp_firearm_primary_hand_vertical_offset);
		var temp_firearm_primary_hand_target_y = weapon_equipped.weapon_y + rot_point_y(temp_firearm_primary_hand_horizontal_offset, temp_firearm_primary_hand_vertical_offset);
		
		if (temp_firearm_reload)
		{
			temp_firearm_primary_hand_target_x = lerp(temp_firearm_primary_hand_target_x, unit_equipment_inventory_position_x, firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value) + hand_fumble_animation_offset_x;
			temp_firearm_primary_hand_target_y = lerp(temp_firearm_primary_hand_target_y, unit_equipment_inventory_position_y, firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value) + hand_fumble_animation_offset_y;
		}
		
		limb_primary_arm.update_target(temp_firearm_primary_hand_target_x, temp_firearm_primary_hand_target_y);
		
		var temp_firearm_offhand_hand_target_x = weapon_equipped.weapon_x + rot_point_x(temp_firearm_offhand_hand_horizontal_offset, temp_firearm_offhand_hand_vertical_offset);
		var temp_firearm_offhand_hand_target_y = weapon_equipped.weapon_y + rot_point_y(temp_firearm_offhand_hand_horizontal_offset, temp_firearm_offhand_hand_vertical_offset);
		
		limb_secondary_arm.update_target(temp_firearm_offhand_hand_target_x, temp_firearm_offhand_hand_target_y);
		break;
	default:
		// Reset Animation Speed Direction
		animation_speed_direction = 1;
		
		// Update Limb Anchor Trig Values
		rot_prefetch(draw_angle_value);
		limb_primary_arm.anchor_trig_sine = trig_sine;
		limb_primary_arm.anchor_trig_cosine = trig_cosine;
		limb_secondary_arm.anchor_trig_sine = trig_sine;
		limb_secondary_arm.anchor_trig_cosine = trig_cosine;
		
		// Update Non-Weapon Unit Animations
		var temp_animation_percentage;
		
		switch (unit_animation_state)
		{
			case UnitAnimationState.Idle:
				temp_animation_percentage = (floor(draw_image_index + (limb_animation_double_cycle * draw_image_index_length))) / (draw_image_index_length * 2);
				limb_primary_arm.update_idle_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, temp_animation_percentage);
				limb_secondary_arm.update_idle_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, temp_animation_percentage);
				break;
			case UnitAnimationState.Walking:
			case UnitAnimationState.AimWalking:
				temp_animation_percentage = floor(draw_image_index) / draw_image_index_length;
				var temp_walk_animation_percentage = (floor(draw_image_index + (limb_animation_double_cycle * draw_image_index_length))) / (draw_image_index_length * 2);
				limb_primary_arm.update_walk_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, temp_animation_percentage, temp_walk_animation_percentage);
				limb_secondary_arm.update_walk_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, temp_animation_percentage, temp_walk_animation_percentage);
				break;
			case UnitAnimationState.Jumping:
				limb_primary_arm.update_jump_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale);
				limb_secondary_arm.update_jump_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale);
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