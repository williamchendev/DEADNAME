/// @description Insert description here
// You can write your code in this editor

// Smoke Size Behaviour
image_xscale = sprite_size;
image_yscale = sprite_size;
sprite_size *= power(sprite_size_mult, global.deltatime);

// Movement Behaviour
x += lengthdir_x(velocity_spd, velocity_direction) * global.deltatime;
y += lengthdir_y(velocity_spd, velocity_direction) * global.deltatime;
velocity_spd *= power(velocity_friction_mult, global.deltatime);
velocity_spd = max(velocity_spd, velocity_min);

if (velocity_wall_slowdown) {
	if (!velocity_hit_wall) {
		if (position_meeting(x, y, oSolid)) {
			velocity_spd = 0;
			velocity_hit_wall = true;
		}
	}
}

// Angle Rotate Behaviour
image_angle += angle_rotate_spd * global.deltatime;
angle_rotate_spd *= power(velocity_friction_mult, global.deltatime);

// Smoke Color Behaviour
var temp_color_value = lerp(color_transition_start, color_transition_end, color_transition_value);
image_blend = make_color_rgb(temp_color_value, temp_color_value, temp_color_value);
color_transition_value = lerp(color_transition_value, 1, color_transition_spd * global.deltatime);

// Smoke Alpha Behaviour
normalmap_level = clamp(1.5 - alpha_delay_timer, 0, 1);
alpha_delay_timer = lerp(alpha_delay_timer, 1.5, alpha_delay_timer_spd * global.deltatime);
if (alpha_delay_timer >= 0.99) {
	image_alpha = lerp(image_alpha, 0, alpha_transition_spd * global.deltatime);
	if (image_alpha <= alpha_destroy_threshold) {
		instance_destroy();
	}
}