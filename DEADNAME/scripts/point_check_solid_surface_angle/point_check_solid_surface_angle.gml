/// point_check_solid_surface_angle(x, y, solid);
/// @description Uses a point to check what angle the instance colliding with the given solid will be
/// @param {real} x The x position of the point to check
/// @param {real} y The y position of the point to check
/// @param {real} solid The Solid Object instance's id to check the angle of the point resting on its surface
/// @return {real} angle The direction/angle of the object sitting on the solid instance surface

// Establish Variables
var temp_x = argument0;
var temp_y = argument1;
var temp_solid_inst = argument2;

// Hitbox
var temp_sprite_index = temp_solid_inst.sprite_index;
var temp_object_x_scale = temp_solid_inst.image_xscale;
var temp_object_y_scale = temp_solid_inst.image_yscale;
var temp_object_angle = temp_solid_inst.image_angle;

var temp_bbox_left = sprite_get_bbox_left(temp_sprite_index) * temp_object_x_scale;
var temp_bbox_right = sprite_get_bbox_right(temp_sprite_index) * temp_object_x_scale;
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

// Angle Calculation
var temp_point_angle = point_direction(temp_hitbox_center_x, temp_hitbox_center_y, temp_x, temp_y);

var temp_left_top_angle = point_direction(temp_hitbox_center_x, temp_hitbox_center_y, temp_solid_inst.x + temp_left_top_x_offset, temp_solid_inst.y + temp_left_top_y_offset);
var temp_right_top_angle = point_direction(temp_hitbox_center_x, temp_hitbox_center_y, temp_solid_inst.x + temp_right_top_x_offset, temp_solid_inst.y + temp_right_top_y_offset);
var temp_right_bottom_angle = point_direction(temp_hitbox_center_x, temp_hitbox_center_y, temp_solid_inst.x + temp_right_bottom_x_offset, temp_solid_inst.y + temp_right_bottom_y_offset);
var temp_left_bottom_angle = point_direction(temp_hitbox_center_x, temp_hitbox_center_y, temp_solid_inst.x + temp_left_bottom_x_offset, temp_solid_inst.y + temp_left_bottom_y_offset);

// Check if Point is relative to the Solid's Top Side
if (temp_left_top_angle > temp_right_top_angle) {
	if ((temp_point_angle <= temp_left_top_angle) and (temp_point_angle >= temp_right_top_angle)) {
		return point_direction(temp_left_top_x_offset, temp_left_top_y_offset, temp_right_top_x_offset, temp_right_top_y_offset);
	}
}
else if ((temp_point_angle <= temp_left_top_angle) or (temp_point_angle >= temp_right_top_angle)) {
	return point_direction(temp_left_top_x_offset, temp_left_top_y_offset, temp_right_top_x_offset, temp_right_top_y_offset);
}

// Check if Point is relative to the Solid's Left Side
if (temp_left_bottom_angle > temp_left_top_angle) {
	if ((temp_point_angle <= temp_left_bottom_angle) and (temp_point_angle >= temp_left_top_angle)) {
		return point_direction(temp_left_bottom_x_offset, temp_left_bottom_y_offset, temp_left_top_x_offset, temp_left_top_y_offset);
	}
}
else if ((temp_point_angle <= temp_left_bottom_angle) or (temp_point_angle >= temp_left_top_angle)) {
	return point_direction(temp_left_bottom_x_offset, temp_left_bottom_y_offset, temp_left_top_x_offset, temp_left_top_y_offset);
}

// Check if Point is relative to the Solid's Right Side
if (temp_right_top_angle > temp_right_bottom_angle) {
	if ((temp_point_angle <= temp_right_top_angle) and (temp_point_angle >= temp_right_bottom_angle)) {
		return point_direction(temp_right_top_x_offset, temp_right_top_y_offset, temp_right_bottom_x_offset, temp_right_bottom_y_offset);
	}
}
else if ((temp_point_angle <= temp_right_top_angle) or (temp_point_angle >= temp_right_bottom_angle)) {
	return point_direction(temp_right_top_x_offset, temp_right_top_y_offset, temp_right_bottom_x_offset, temp_right_bottom_y_offset);
}

// Point is relative to the Solid's Bottom Side
return point_direction(temp_right_bottom_x_offset, temp_right_bottom_y_offset, temp_left_bottom_x_offset, temp_left_bottom_y_offset);

/*
if (temp_right_bottom_angle > temp_left_bottom_angle) {
	if ((temp_point_angle <= temp_right_bottom_angle) and (temp_point_angle >= temp_left_bottom_angle)) {
		
	}
}
else if ((temp_point_angle <= temp_right_bottom_angle) or (temp_point_angle >= temp_left_bottom_angle)) {
	
}
*/