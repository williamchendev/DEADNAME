/// @description Insert description here
// Performs calculations necessary for the Unit's behaviour

// Movement (Player Input)
if (canmove) {
	// Horizontal Movement
	var temp_spd = spd;
	if (firearm) {
		if (key_aim_press or reload) {
			temp_spd = walk_spd;
		}
	}
	
	if (key_left) {
		x_velocity = -temp_spd;
	}
	else if (key_right) {
		x_velocity = temp_spd;
	}
	else {
		x_velocity = 0;
		x = round(x);
	}
	
	// Vertical Movement (Jumping)
	if (key_jump) {
		if (!platform_free(x, y + 1, platform_list)) {
			// First Jump
			y_velocity = 0;
			y_velocity -= jump_spd;
			jump_velocity = hold_jump_spd;
			double_jump = true;
			
			// Squash and Stretch
			draw_xscale = 1 - squash_stretch;
			draw_yscale = 1 + squash_stretch;
		}
		else if (key_jump_press) {
			// Second Jump
			if (double_jump) {
				y_velocity = 0;
				y_velocity -= double_jump_spd;
				jump_velocity = hold_jump_spd;
				double_jump = false;
				
				// Squash and Stretch
				draw_xscale -= squash_stretch;
				draw_yscale += squash_stretch;
			}
		}
		else if (y_velocity < 0) {
			// Variable Jump Height
			y_velocity -= jump_velocity * global.deltatime;
			jump_velocity *= power(jump_decay, global.deltatime);
		}
	}
	
	// Jumping Down (Platforms)
	if (key_down_press) {
		if (place_free(x, y + 1) and !platform_free(x, y + 1, platform_list)) {
			y += 2;
			y_velocity += 0.05;
		}
	}
}

// Physics
if (platform_free(x, y + 1, platform_list)) {
	//Gravity
	grav_velocity += (grav_spd * global.deltatime);
	grav_velocity *= power(grav_multiplier, global.deltatime);
	grav_velocity = min(grav_velocity, max_grav_spd);
	y_velocity += (grav_velocity * global.deltatime);
}
else {
	grav_velocity = 0;
	y = round(y);
}
	
// Delta Time
var temp_x_velocity = x_velocity * global.deltatime;
var temp_y_velocity = y_velocity * global.deltatime;

var hspd = 0;
if (temp_x_velocity != 0) {
	// Horizontal Collisions
	if (place_free(x + temp_x_velocity, y)) {
		// Move Unit with horizontal velocity
		hspd += temp_x_velocity;
		
		// Downward Slope collision check
		if (temp_y_velocity == 0) {
			if (!place_free(x + temp_x_velocity, y + slope_tolerance)) {
				var prev_slope_y = 0;
				for (var i = 0.5; i <= abs(slope_tolerance); i += 0.5) {
					if (!place_free(x + temp_x_velocity, y + (sign(slope_tolerance) * i))) {
						y += sign(slope_tolerance) * prev_slope_y;
						break;
					}
					prev_slope_y = i;
				}
			}
		}
	}
	else {
		// Upward Slope collision check
		if (!place_free(x, y + 1) && place_free(x + temp_x_velocity, y - slope_tolerance)) {
			for (var i = 0; i <= abs(slope_tolerance); i += 0.5) {
				if (place_free(x + temp_x_velocity, y - (sign(slope_tolerance) * i))) {
					hspd += temp_x_velocity;
					y -= sign(slope_tolerance) * i;
					break;
				}
			}
		}
		else {
			// Stop Unit momentum with Collision
			for (var i = abs(temp_x_velocity); i > 0; i -= 0.5) {
				if (place_free(x + (i * sign(x_velocity)), y)) {
					hspd += i * sign(x_velocity);
					break;
				}
			}
			x_velocity = 0;
		}
	}
}

var vspd = 0;
if (temp_y_velocity != 0) {
	// Vertical Collisions
	if (platform_free(x, y + temp_y_velocity, platform_list)) {
		vspd += temp_y_velocity;
	}
	else {
		for (var i = abs(temp_y_velocity); i > 0; i -= 0.5) {
			if (platform_free(x, y + (i * sign(y_velocity)), platform_list)) {
				vspd += i * sign(y_velocity);
				break;
			}
		}
		
		// Squash and Stretch
		if (y_velocity > 0) {
			draw_xscale = 1 + squash_stretch;
			draw_yscale = 1 - squash_stretch;
		}

		y_velocity = 0;
	}
}

x += hspd;
y += vspd;

// Animation
var anim_spd_sign = 1;
draw_xscale = lerp(draw_xscale, 1, scale_reset_spd * global.deltatime);
draw_yscale = lerp(draw_yscale, 1, scale_reset_spd * global.deltatime);

if (x_velocity != 0) {
	// Set Sprite facing direction
	image_xscale = sign(x_velocity);
}

if (!platform_free(x, y + 1, platform_list)) {
	// Set Unit ground Animation
	if (x_velocity != 0) {
		if (!firearm or (!key_aim_press and !reload)) {
			sprite_index = walk_animation;
		}
		else if (canmove) {
			sprite_index = aim_walk_animation;
			if (image_xscale != sign(x_velocity)) {
				anim_spd_sign = -1;
			}
		}
	}
	else {
		if (firearm and (key_aim_press or bolt_action_load) and canmove and (!reload or bolt_action_load)) {
			sprite_index = aim_animation;
		}
		else {
			sprite_index = idle_animation;
		}
	}
	
	// Set Unit Image Index
	draw_index += (animation_spd * anim_spd_sign) * global.deltatime;
	while (draw_index > sprite_get_number(sprite_index)) {
		draw_index -= sprite_get_number(sprite_index);
	}
	while (draw_index < 0) {
		draw_index += sprite_get_number(sprite_index);
	}
	image_index = clamp(floor(draw_index), 0, sprite_get_number(sprite_index) - 1);
	
	// Slope Angles
	var slope_solid_obj = collision_line(x, y, x, y + 5, oSolid, false, false);
	if (slope_solid_obj != noone) {
		slope_angle = lerp(slope_angle, slope_solid_obj.image_angle, slope_angle_lerp_spd * global.deltatime);
		slope_offset = 0;
		if (slope_solid_obj.image_angle != 0) {
			slope_offset = slope_tolerance;
		}
	}
	else {
		slope_angle = lerp(slope_angle, 0, slope_angle_lerp_spd * global.deltatime);
		slope_offset = 0;
	}
}
else {
	// Set Jump Animation
	sprite_index = jump_animation;
	sprite_lit_index = jump_animation;
	sprite_normal_index = jump_normals;
	
	image_index = ((abs(y_velocity) - jump_peak_threshold >= 0) * sign(y_velocity)) + 1;
	
	// Slope Angles
	slope_angle = lerp(slope_angle, 0, slope_angle_lerp_spd * global.deltatime);
	slope_offset = 0;
}






