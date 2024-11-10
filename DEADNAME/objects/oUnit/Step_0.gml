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
			draw_xscale = abs(draw_xscale) * sign(x_velocity);
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
		}
		else 
		{
			draw_xscale = abs(draw_xscale) * sign(hspd);
		}
	}
	
	// Grounded Physics (Vertical) Collisions
	/*
	if (platform_free(x, y + 1, platform_list)) 
	{
		y += 1;
		grounded = false;
	}
	*/
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
	
	// Airborne Physics (Horizontal) Collisions
	if (hspd != 0)
	{
		if (place_free(x + hspd, y))
		{
			x_velocity = hspd;
			draw_xscale = abs(draw_xscale) * sign(x_velocity);
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
					draw_xscale = abs(draw_xscale) * sign(x_velocity);
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
				
				grounded = true;
				double_jump = true;
				
				draw_xscale = sign(draw_xscale) * (1 + squash_stretch_jump_intensity);
				draw_yscale = 1 - squash_stretch_jump_intensity;
				break;
			}
		}
	}
}

// Animation Behaviour
if (!grounded)
{
	// Jump Animation
	unit_animation_state = UnitAnimationState.Jumping;
	image_index = ((abs(y_velocity) - jump_peak_threshold >= 0) * sign(y_velocity)) + 1;
}
else if (x_velocity != 0)
{
	unit_animation_state = UnitAnimationState.Walking;
}
else
{
	unit_animation_state = UnitAnimationState.Idle;
}

draw_xscale = lerp(draw_xscale, sign(draw_xscale), squash_stretch_reset_spd * frame_delta);
draw_yscale = lerp(draw_yscale, 1, squash_stretch_reset_spd * frame_delta);