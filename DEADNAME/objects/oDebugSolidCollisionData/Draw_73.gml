/// @description Insert description here
// You can write your code in this editor

var temp_solid_inst = instance_position(mouse_room_x(), mouse_room_y(), oSolid);
if (temp_solid_inst != noone) {
	if (instance_exists(temp_solid_inst)) {
		var temp_sprite_index = temp_solid_inst.sprite_index;
		var temp_object_x_scale = temp_solid_inst.image_xscale;
		var temp_object_y_scale = temp_solid_inst.image_yscale;
		var temp_object_angle = temp_solid_inst.image_angle;

		var temp_bbox_left = sprite_get_bbox_left(temp_sprite_index) * temp_object_x_scale;
		var temp_bbox_right = (sprite_get_bbox_right(temp_sprite_index) + 1) * temp_object_x_scale;
		var temp_bbox_top = sprite_get_bbox_top(temp_sprite_index) * temp_object_y_scale;
		var temp_bbox_bottom = sprite_get_bbox_bottom(temp_sprite_index) * temp_object_y_scale;
	
		temp_bbox_left -= sprite_get_xoffset(temp_sprite_index) * temp_object_x_scale;
		temp_bbox_bottom -= sprite_get_yoffset(temp_sprite_index) * temp_object_y_scale;
		temp_bbox_right -= sprite_get_xoffset(temp_sprite_index) * temp_object_x_scale;
		temp_bbox_top -= sprite_get_yoffset(temp_sprite_index) * temp_object_y_scale;
	
		var temp_point1_dis = point_distance(0, 0, temp_bbox_left, temp_bbox_top);
		var temp_point1_angle = point_direction(0, 0, temp_bbox_left, temp_bbox_top);
		var temp_point2_dis = point_distance(0, 0, temp_bbox_right, temp_bbox_top);
		var temp_point2_angle = point_direction(0, 0, temp_bbox_right, temp_bbox_top);
		var temp_point3_dis = point_distance(0, 0, temp_bbox_right, temp_bbox_bottom);
		var temp_point3_angle = point_direction(0, 0, temp_bbox_right, temp_bbox_bottom);
		var temp_point4_dis = point_distance(0, 0, temp_bbox_left, temp_bbox_bottom);
		var temp_point4_angle = point_direction(0, 0, temp_bbox_left, temp_bbox_bottom);
	
		var temp_left_top_x_offset = lengthdir_x(temp_point1_dis, temp_point1_angle + temp_object_angle);
		var temp_left_top_y_offset = lengthdir_y(temp_point1_dis, temp_point1_angle + temp_object_angle);
		var temp_right_top_x_offset = lengthdir_x(temp_point2_dis, temp_point2_angle + temp_object_angle);
		var temp_right_top_y_offset = lengthdir_y(temp_point2_dis, temp_point2_angle + temp_object_angle);
		var temp_right_bottom_x_offset = lengthdir_x(temp_point3_dis, temp_point3_angle + temp_object_angle);
		var temp_right_bottom_y_offset = lengthdir_y(temp_point3_dis, temp_point3_angle + temp_object_angle);
		var temp_left_bottom_x_offset = lengthdir_x(temp_point4_dis, temp_point4_angle + temp_object_angle);
		var temp_left_bottom_y_offset = lengthdir_y(temp_point4_dis, temp_point4_angle + temp_object_angle);

		var temp_hitbox_left_top_x_offset = min(temp_left_top_x_offset, temp_right_top_x_offset, temp_right_bottom_x_offset, temp_left_bottom_x_offset);
		var temp_hitbox_right_bottom_x_offset = max(temp_left_top_x_offset, temp_right_top_x_offset, temp_right_bottom_x_offset, temp_left_bottom_x_offset);
		var temp_hitbox_left_top_y_offset = min(temp_left_top_y_offset, temp_right_top_y_offset, temp_right_bottom_y_offset, temp_left_bottom_y_offset);
		var temp_hitbox_right_bottom_y_offset = max(temp_left_top_y_offset, temp_right_top_y_offset, temp_right_bottom_y_offset, temp_left_bottom_y_offset);

		var temp_hitbox_center_x = lerp(temp_solid_inst.x + temp_hitbox_left_top_x_offset, temp_solid_inst.x + temp_hitbox_right_bottom_x_offset, 0.5);
		var temp_hitbox_center_y = lerp(temp_solid_inst.y + temp_hitbox_left_top_y_offset, temp_solid_inst.y + temp_hitbox_right_bottom_y_offset, 0.5);

		//
		draw_set_color(c_red);
		draw_circle(temp_solid_inst.x + temp_left_top_x_offset, temp_solid_inst.y + temp_left_top_y_offset, 3, false);
		draw_circle(temp_solid_inst.x + temp_right_top_x_offset, temp_solid_inst.y + temp_right_top_y_offset, 3, false);
		draw_circle(temp_solid_inst.x + temp_right_bottom_x_offset, temp_solid_inst.y + temp_right_bottom_y_offset, 3, false);
		draw_circle(temp_solid_inst.x + temp_left_bottom_x_offset, temp_solid_inst.y + temp_left_bottom_y_offset, 3, false);
		draw_set_color(c_white);
		
		var temp_solid_data = point_check_solid_surface_angle(mouse_room_x(), mouse_room_y(), temp_solid_inst);
		draw_circle(temp_solid_data[1], temp_solid_data[2], 3, false);
	}
}