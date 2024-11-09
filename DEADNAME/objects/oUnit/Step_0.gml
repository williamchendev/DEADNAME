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

// Physics
if (!grounded) 
{
	//Gravity
	grav_velocity += (grav_spd * frame_delta);
	grav_velocity *= power(grav_multiplier, frame_delta);
	grav_velocity = min(grav_velocity, max_grav_spd);
	y_velocity += (grav_velocity * frame_delta);
}
else 
{
	grav_velocity = 0;
	y = round(y);
}

// Collision & Physics Behaviour
if (x_velocity != 0)
{
	if (place_free(x + x_velocity, y))
	{
		draw_xscale = abs(draw_xscale) * sign(x_velocity);
		x += x_velocity;
		x = round(x);
	}
	else
	{
		for (var h = abs(x_velocity); h >= 0; h--)
		{
			var hspd = (sign(x_velocity) * h);
			
			if (place_free(x + hspd, y))
			{
				draw_xscale = abs(draw_xscale) * sign(x_velocity);
				x_velocity = hspd;
				x += x_velocity;
				x = round(x);
				break;
			}
		}
	}
}

if (!grounded)
{
	if (platform_free(x, y + y_velocity, platform_list))
	{
		y += y_velocity;
		y = round(y);
	}
	else
	{
		for (var v = 1; v < abs(y_velocity); v++)
		{
			var vspd = (sign(y_velocity) * v);
			
			if (!platform_free(x, y + vspd, platform_list))
			{
				y_velocity = vspd - sign(y_velocity);
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
else
{
	if (platform_free(x, y + 1, platform_list)) 
	{
		y += 1;
		grounded = false;
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