/// @description Arm Draw
// Draws the Arm Effect to the Screen

// Lighting Calc Arm Behaviour
var temp_arm_sprite_index = limb_sprite;
if (instance_exists(oLighting)) {
	// Find Lighting Surface Offset
	var temp_lighting_manager_inst = instance_find(oLighting, 0);
	surface_x_offset = temp_lighting_manager_inst.x;
	surface_y_offset = temp_lighting_manager_inst.y;
	
	// Switch Lighting Sprites
	if (normal_draw_event) {
		temp_arm_sprite_index = limb_normal_sprite;
	}
	else if (!lit_draw_event) {
		return;
	}
}

// Draw Unit Sprite
if (temp_arm_sprite_index == noone) {
	var temp_offset = 0;
	if (limb_direction < 0) {
		temp_offset = -1;
	}

	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_line_width(limb_anchor_x + temp_offset - surface_x_offset, limb_anchor_y - surface_y_offset, point1_x + temp_offset - surface_x_offset, point1_y - surface_y_offset, 2);
	draw_line_width(point1_x + temp_offset - surface_x_offset, point1_y - surface_y_offset, point2_x + temp_offset - surface_x_offset, point2_y - surface_y_offset, 2);
	
	draw_set_alpha(1);
	draw_set_color(c_red);
	draw_point(limb_anchor_x + temp_offset - surface_x_offset, limb_anchor_y - surface_y_offset);
	
	draw_set_alpha(1);
	draw_set_color(c_white);
}
else {
	var temp_dis_1 = (point_distance(limb_anchor_x, limb_anchor_y, point1_x, point1_y) + 2) / sprite_get_height(limb_sprite);
	var temp_angle_1 = (point_direction(limb_anchor_x, limb_anchor_y, point1_x, point1_y) + 180) - (limb_direction * 90);
	
	var temp_dis_2 = (point_distance(point1_x, point1_y, point2_x, point2_y) + 2) / sprite_get_height(limb_sprite);
	var temp_angle_2 = (point_direction(point1_x, point1_y, point2_x, point2_y) + 180) - (limb_direction * 90);
	
	// Draw Sprite Arms Behaviour
	if (normal_draw_event) {
		// Set Normal Vector Scaling Shader
		shader_set(shd_vectortransform);
		
		// Draw Shoulder & Arm
		var temp_normalscale_x = sign(temp_dis_1 * limb_direction);
		shader_set_uniform_f(vectortransform_shader_scale, temp_normalscale_x, 1.0, 1.0);
		shader_set_uniform_f(vectortransform_shader_angle, degtorad(temp_angle_1 - 90));
		draw_sprite_ext(temp_arm_sprite_index, 0, limb_anchor_x - surface_x_offset, limb_anchor_y - surface_y_offset, -1, temp_dis_1 * limb_direction, temp_angle_1, c_white, 1); 
		
		// Draw Forearm & Hand
		temp_normalscale_x = sign(temp_dis_2 * limb_direction);
		shader_set_uniform_f(vectortransform_shader_scale, temp_normalscale_x, 1.0, 1.0);
		shader_set_uniform_f(vectortransform_shader_angle, degtorad(temp_angle_2 - 90));
		draw_sprite_ext(temp_arm_sprite_index, 1, point1_x - surface_x_offset, point1_y - surface_y_offset, -1, temp_dis_2 * limb_direction, temp_angle_2, c_white, 1);
		
		// Reset Normal Vector Scaling Shader
		shader_reset();
	}
	else {
		// Draw Arms Normally
		draw_sprite_ext(temp_arm_sprite_index, 0, limb_anchor_x - surface_x_offset, limb_anchor_y - surface_y_offset, -1, temp_dis_1 * limb_direction, temp_angle_1, c_white, 1); 
		draw_sprite_ext(temp_arm_sprite_index, 1, point1_x - surface_x_offset, point1_y - surface_y_offset, -1, temp_dis_2 * limb_direction, temp_angle_2, c_white, 1); 
	}
}

// Reset Surface Variables
surface_x_offset = 0;
surface_y_offset = 0;