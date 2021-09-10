/// @description Unit Draw Event
// Draws the unit to the screen

// Lighting Draw Behaviour
if (lit_draw_event) {
	sprite_index = sprite_lit_index;
}
else if (normal_draw_event) {
	sprite_index = sprite_normal_index;
}
else if (instance_exists(oLighting)) {
	return;
}

// Draw Unit Sprite
if (normal_draw_event) {
	// Set Normal Vector Scaling Shader
	shader_set(shd_vectorcolorscale);
	shader_set_uniform_f(vectorcolorscale_shader_r, sign(draw_xscale * image_xscale) * cos(degtorad(draw_angle)));
	shader_set_uniform_f(vectorcolorscale_shader_g, sign(draw_yscale) * sin(degtorad(draw_angle)));
	shader_set_uniform_f(vectorcolorscale_shader_b, 1.0);
}

draw_sprite_ext(sprite_index, image_index, x, y - ((sin(degtorad(draw_angle)) * (bbox_left - bbox_right)) / 2), draw_xscale * image_xscale, draw_yscale, draw_angle, draw_color, image_alpha);

if (normal_draw_event) {
	// Reset Normal Vector Scaling Shader
	shader_reset();
}

// Draw Stats Variables
var temp_stats_x = x - (sin(degtorad(draw_angle)) * (hitbox_right_bottom_y_offset - hitbox_left_top_y_offset));
var temp_stats_y = y - (hitbox_right_bottom_y_offset - hitbox_left_top_y_offset) - (stats_y_offset * draw_yscale);

// Draw Health Bar
if (canmove and health_show) {
	if (health_points > 0) {
		var temp_health_width = 48;
		var temp_health_percent_width = (health_points / max_health_points) * temp_health_width;
		
		var health_color_1 = make_color_rgb(209, 19, 54);
		var health_color_2 = make_color_rgb(181, 24, 52);
		var health_color_3 = make_color_rgb(150, 30, 52);

		var health_color_4 = make_color_rgb(92, 25, 37);
		var health_color_5 = make_color_rgb(222, 213, 215);

		draw_set_color(health_color_4);
		draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 3, (temp_stats_x + (temp_health_width / 2)), temp_stats_y, false);

		if (health_points < max_health_points) {
			draw_set_color(health_color_5);
			draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 3, (temp_stats_x - (temp_health_width / 2)) + temp_health_percent_width + 1, temp_stats_y, false);
		}

		draw_set_color(health_color_1);
		draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 3, (temp_stats_x - (temp_health_width / 2)) + temp_health_percent_width, temp_stats_y, false);
		draw_set_color(health_color_3);
		draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 1, (temp_stats_x - (temp_health_width / 2)) + temp_health_percent_width, temp_stats_y, false);
		draw_set_color(health_color_2);
		draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 2, (temp_stats_x - (temp_health_width / 2)) + temp_health_percent_width, temp_stats_y - 1, false);
	
		// Debug
		/*
		draw_set_font(fHeartBit);
		draw_set_halign(fa_center);
		drawTextOutline(temp_stats_x, temp_stats_y - 10, c_white, c_black, "[" +string(health_points) + "]");
		draw_set_halign(fa_left);
		*/
	}
}

// Debug
if (!global.debug) {
	return;
}

// Draw Hitbox
draw_set_alpha(0.3);
draw_set_color(c_black);

draw_rectangle(x + hitbox_left_top_x_offset, y + hitbox_left_top_y_offset, x + hitbox_right_bottom_x_offset, y + hitbox_right_bottom_y_offset, false);

draw_set_alpha(1);
draw_set_color(c_white);