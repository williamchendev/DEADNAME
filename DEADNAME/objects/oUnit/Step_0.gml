/// @description Unit Update Event

// Movement & Input Behaviour
if (canmove)
{
	// Horizontal Movement Behaviour
	var move_spd = run_spd;
	
	// PUT WALKING HERE!!!
	
	if (move_left) 
	{
		move_spd = -move_spd;
	}
	else if (!move_right) 
	{
		move_spd = 0;
		x_velocity = 0;
		x = round(x);
	}
	
	x_velocity = move_spd;
	
	// Vertical Movement Behaviour
	if (move_jump_hold) 
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
		else if (move_double_jump) 
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
	if (move_drop_down && grounded) 
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

// Collision & Physics Behaviour
if (grounded)
{
	// Disable Gravity
	grav_velocity = 0;
	y_velocity = 0;
	y = round(y);
	
	// Delta Time Adjustment
	var hspd = x_velocity * frame_delta;
	var vspd = y_velocity * frame_delta;
	
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
	var hspd = x_velocity * frame_delta;
	var vspd = y_velocity * frame_delta;
	
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

// Animation Behaviour
if (x_velocity != 0)
{
	draw_xscale = abs(draw_xscale) * sign(x_velocity);
}
	
if (grounded)
{
	if (x_velocity != 0)
	{
		unit_animation_state = UnitAnimationState.Walking;
	}
	else
	{
		unit_animation_state = UnitAnimationState.Idle;
	}
}
else 
{
	// Jump Animation
	unit_animation_state = UnitAnimationState.Jumping;
}

draw_xscale = lerp(draw_xscale, sign(draw_xscale), squash_stretch_reset_spd * frame_delta);
draw_yscale = lerp(draw_yscale, 1, squash_stretch_reset_spd * frame_delta);

draw_angle_value = lerp(draw_angle_value, draw_angle, slope_angle_lerp_spd * frame_delta);

// Load Animation State
switch (unit_animation_state)
{
	case UnitAnimationState.Idle:
		sprite_index = global.unit_sprite_packs[unit_sprite_pack].idle_sprite;
		draw_image_index_length = 4;
		break;
	case UnitAnimationState.Walking:
		sprite_index = global.unit_sprite_packs[unit_sprite_pack].walk_sprite;
		draw_image_index_length = 5;
		break;
	case UnitAnimationState.Jumping:
		sprite_index = global.unit_sprite_packs[unit_sprite_pack].jump_sprite;
		image_index = ((abs(y_velocity) - jump_peak_threshold >= 0) * sign(y_velocity)) + 1;
		draw_image_index_length = -1;
		break;
	case UnitAnimationState.Aiming:
		sprite_index = global.unit_sprite_packs[unit_sprite_pack].aim_sprite;
		image_index = 0;
		draw_image_index_length = -1;
		break;
	case UnitAnimationState.AimWalking:
		sprite_index = global.unit_sprite_packs[unit_sprite_pack].aim_walk_sprite;
		draw_image_index_length = 5;
		break;
}

if (draw_image_index_length != -1)
{
	draw_image_index += (animation_speed * animation_speed_direction) * frame_delta;
	
	if (draw_image_index >= draw_image_index_length)
	{
		limb_animation_double_cycle = !limb_animation_double_cycle;
	}
	
	draw_image_index = draw_image_index mod draw_image_index_length;
	image_index = floor(draw_image_index);
}

// Limb Animation Behaviour
switch (unit_equipment_animation_state)
{
	case UnitEquipmentAnimationState.Firearm:
		limb_left_arm.update_pivot(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, draw_angle_value);
		limb_right_arm.update_pivot(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, draw_angle_value);
		break;
	default:
		
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