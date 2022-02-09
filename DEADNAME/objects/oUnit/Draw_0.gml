/// @description Unit Draw Event
// Draws the unit to the screen

// Lighting Draw Behaviour
var temp_skip_gui = false;
var temp_skip_sprite = false;
if (lit_draw_event) {
	temp_skip_gui = true;
	sprite_index = sprite_lit_index;
}
else if (normal_draw_event) {
	temp_skip_gui = true;
	sprite_index = sprite_normal_index;
}
else if (instance_exists(oLighting)) {
	temp_skip_sprite = true;
}

// Draw Unit Sprite
if (!temp_skip_sprite) {
	if (normal_draw_event) {
		// Set Normal Vector Scaling Shader
		shader_set(shd_vectortransform);
		shader_set_uniform_f(vectortransform_shader_angle, degtorad(draw_angle));
		var temp_normalscale_x = sign(draw_xscale * image_xscale) * cos(degtorad(draw_angle));
		var temp_normalscale_y = sign(draw_yscale);
		shader_set_uniform_f(vectortransform_shader_scale, temp_normalscale_x, temp_normalscale_y, 1.0);
	}

	draw_sprite_ext(sprite_index, image_index, x, y - ((sin(degtorad(draw_angle)) * (bbox_left - bbox_right)) / 2), draw_xscale * image_xscale, draw_yscale, draw_angle, draw_color, image_alpha);

	if (normal_draw_event) {
		// Reset Normal Vector Scaling Shader
		shader_reset();
	}
	
	// Check to Skip GUI
	if (temp_skip_gui) {
		return;
	}
}

// Draw Stats Variables
var temp_stats_x = x - (sin(degtorad(draw_angle)) * (hitbox_right_bottom_y_offset - hitbox_left_top_y_offset));
var temp_stats_y = y - (hitbox_right_bottom_y_offset - hitbox_left_top_y_offset) - (stats_y_offset * draw_yscale);

// Draw Unit Health and Armor Stats
if (canmove and health_show) {
	if (health_points > 0) {
		// Health Bar Variables
		var temp_health_width = health_bar_width;
		var temp_health_percent_width = (health_points / max_health_points) * temp_health_width;

		draw_set_color(health_bar_back_color_1);
		draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 3, (temp_stats_x + (temp_health_width / 2)), temp_stats_y, false);

		if (health_points < max_health_points) {
			draw_set_color(health_bar_back_color_2);
			draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 3, (temp_stats_x - (temp_health_width / 2)) + temp_health_percent_width + 1, temp_stats_y, false);
		}

		draw_set_color(health_bar_color_1);
		draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 3, (temp_stats_x - (temp_health_width / 2)) + temp_health_percent_width, temp_stats_y, false);
		draw_set_color(health_bar_color_3);
		draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 1, (temp_stats_x - (temp_health_width / 2)) + temp_health_percent_width, temp_stats_y, false);
		draw_set_color(health_bar_color_2);
		draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 2, (temp_stats_x - (temp_health_width / 2)) + temp_health_percent_width, temp_stats_y - 1, false);
		
		// Armor Bar
		if (material_inst != noone) {
			if (instance_exists(material_inst)) {
				// Armor Bar Variables
				temp_stats_y += armor_bar_yoffset;
				var temp_armor_percent_width = (armor_bar_value / material_inst.material_max_health) * temp_health_width;
				
				draw_set_color(health_bar_back_color_1);
				draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 3, (temp_stats_x + (temp_health_width / 2)), temp_stats_y, false);
				
				if (armor_bar_value < material_inst.material_max_health) {
					if (temp_armor_percent_width + 1 <= health_bar_width) {
						draw_set_color(health_bar_back_color_2);
						draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 3, (temp_stats_x - (temp_health_width / 2)) + temp_armor_percent_width + 1, temp_stats_y, false);
					}
					else {
						temp_armor_percent_width = health_bar_width;
					}
				}
				
				draw_set_color(armor_bar_color_1);
				draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 3, (temp_stats_x - (temp_health_width / 2)) + temp_armor_percent_width, temp_stats_y, false);
				draw_set_color(armor_bar_color_3);
				draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 1, (temp_stats_x - (temp_health_width / 2)) + temp_armor_percent_width, temp_stats_y, false);
				draw_set_color(armor_bar_color_2);
				draw_rectangle(temp_stats_x - (temp_health_width / 2), temp_stats_y - 2, (temp_stats_x - (temp_health_width / 2)) + temp_armor_percent_width, temp_stats_y - 1, false);
				
				draw_sprite(sMaterial_ArmorIcon, 0, temp_stats_x - (temp_health_width / 2), temp_stats_y - 2);
			}
		}
	
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