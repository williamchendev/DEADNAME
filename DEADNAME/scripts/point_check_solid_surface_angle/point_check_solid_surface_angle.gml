/// point_check_solid_surface_angle(x, y, solid);
/// @description Uses a point to check what angle the instance colliding with the given solid will be
/// @param {real} x The x position of the point to check
/// @param {real} y The y position of the point to check
/// @param {real} solid The Solid Object instance's id to check the angle of the point resting on its surface
/// @return {array} An Array of the direction/angle of the object sitting on the solid instance surface along with the x and y coordinate of the nearest point on the given solid

// Establish Variables
var temp_x = argument0;
var temp_y = argument1;
var temp_solid_inst = argument2;

var temp_return_array = noone;

// Hitbox
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

// Point Closest on Line Calculations
var temp_point_closest_top = point_check_closest_position_line(temp_x, temp_y, temp_solid_inst.x + temp_left_top_x_offset, temp_solid_inst.y + temp_left_top_y_offset, temp_solid_inst.x + temp_right_top_x_offset, temp_solid_inst.y + temp_right_top_y_offset);
var temp_point_closest_left = point_check_closest_position_line(temp_x, temp_y, temp_solid_inst.x + temp_left_top_x_offset, temp_solid_inst.y + temp_left_top_y_offset, temp_solid_inst.x + temp_left_bottom_x_offset, temp_solid_inst.y + temp_left_bottom_y_offset);
var temp_point_closest_right = point_check_closest_position_line(temp_x, temp_y, temp_solid_inst.x + temp_right_top_x_offset, temp_solid_inst.y + temp_right_top_y_offset, temp_solid_inst.x + temp_right_bottom_x_offset, temp_solid_inst.y + temp_right_bottom_y_offset);
var temp_point_closest_bottom = point_check_closest_position_line(temp_x, temp_y, temp_solid_inst.x + temp_left_bottom_x_offset, temp_solid_inst.y + temp_left_bottom_y_offset, temp_solid_inst.x + temp_right_bottom_x_offset, temp_solid_inst.y + temp_right_bottom_y_offset);

var temp_point_closest_top_dis = point_distance(temp_x, temp_y, temp_point_closest_top[0], temp_point_closest_top[1]);
var temp_point_closest_left_dis = point_distance(temp_x, temp_y, temp_point_closest_left[0], temp_point_closest_left[1]);
var temp_point_closest_right_dis = point_distance(temp_x, temp_y, temp_point_closest_right[0], temp_point_closest_right[1]);
var temp_point_closest_bottom_dis = point_distance(temp_x, temp_y, temp_point_closest_bottom[0], temp_point_closest_bottom[1]);

switch(min(temp_point_closest_top_dis, temp_point_closest_left_dis, temp_point_closest_right_dis, temp_point_closest_bottom_dis)) {
	case temp_point_closest_top_dis:
		if (min(temp_point_closest_left_dis, temp_point_closest_right_dis, temp_point_closest_bottom_dis) == temp_point_closest_top_dis) {
			break;
		}
		temp_return_array[0] = point_direction(temp_left_top_x_offset, temp_left_top_y_offset, temp_right_top_x_offset, temp_right_top_y_offset);
		temp_return_array[1] = temp_point_closest_top[0];
		temp_return_array[2] = temp_point_closest_top[1];
		return temp_return_array;
	case temp_point_closest_left_dis:
		if (min(temp_point_closest_top_dis, temp_point_closest_right_dis, temp_point_closest_bottom_dis) == temp_point_closest_left_dis) {
			break;
		}
		temp_return_array[0] = point_direction(temp_left_bottom_x_offset, temp_left_bottom_y_offset, temp_left_top_x_offset, temp_left_top_y_offset);
		temp_return_array[1] = temp_point_closest_left[0];
		temp_return_array[2] = temp_point_closest_left[1];
		return temp_return_array;
	case temp_point_closest_right_dis:
		if (min(temp_point_closest_top_dis, temp_point_closest_left_dis, temp_point_closest_bottom_dis) == temp_point_closest_right_dis) {
			break;
		}
		temp_return_array[0] = point_direction(temp_right_top_x_offset, temp_right_top_y_offset, temp_right_bottom_x_offset, temp_right_bottom_y_offset);
		temp_return_array[1] = temp_point_closest_right[0];
		temp_return_array[2] = temp_point_closest_right[1];
		return temp_return_array;
	case temp_point_closest_bottom_dis:
		if (min(temp_point_closest_top_dis, temp_point_closest_left_dis, temp_point_closest_right_dis) == temp_point_closest_bottom_dis) {
			break;
		}
		temp_return_array[0] = point_direction(temp_right_bottom_x_offset, temp_right_bottom_y_offset, temp_left_bottom_x_offset, temp_left_bottom_y_offset);
		temp_return_array[1] = temp_point_closest_bottom[0];
		temp_return_array[2] = temp_point_closest_bottom[1];
		return temp_return_array;
	default:
		break;
}

// Angle Calculation
var temp_point_angle = point_direction(temp_hitbox_center_x, temp_hitbox_center_y, temp_x, temp_y);

var temp_left_top_angle = point_direction(temp_hitbox_center_x, temp_hitbox_center_y, temp_solid_inst.x + temp_left_top_x_offset, temp_solid_inst.y + temp_left_top_y_offset);
var temp_right_top_angle = point_direction(temp_hitbox_center_x, temp_hitbox_center_y, temp_solid_inst.x + temp_right_top_x_offset, temp_solid_inst.y + temp_right_top_y_offset);
var temp_right_bottom_angle = point_direction(temp_hitbox_center_x, temp_hitbox_center_y, temp_solid_inst.x + temp_right_bottom_x_offset, temp_solid_inst.y + temp_right_bottom_y_offset);
var temp_left_bottom_angle = point_direction(temp_hitbox_center_x, temp_hitbox_center_y, temp_solid_inst.x + temp_left_bottom_x_offset, temp_solid_inst.y + temp_left_bottom_y_offset);

// Check if Point is relative to the Solid's Top Side
if (temp_left_top_angle > temp_right_top_angle) {
	if ((temp_point_angle <= temp_left_top_angle) and (temp_point_angle >= temp_right_top_angle)) {
		temp_return_array[0] = point_direction(temp_left_top_x_offset, temp_left_top_y_offset, temp_right_top_x_offset, temp_right_top_y_offset);
		temp_return_array[1] = temp_point_closest_top[0];
		temp_return_array[2] = temp_point_closest_top[1];
		return temp_return_array;
	}
}
else if ((temp_point_angle <= temp_left_top_angle) or (temp_point_angle >= temp_right_top_angle)) {
	temp_return_array[0] = point_direction(temp_left_top_x_offset, temp_left_top_y_offset, temp_right_top_x_offset, temp_right_top_y_offset);
	temp_return_array[1] = temp_point_closest_top[0];
	temp_return_array[2] = temp_point_closest_top[1];
	return temp_return_array;
}

// Check if Point is relative to the Solid's Left Side
if (temp_left_bottom_angle > temp_left_top_angle) {
	if ((temp_point_angle <= temp_left_bottom_angle) and (temp_point_angle >= temp_left_top_angle)) {
		temp_return_array[0] = point_direction(temp_left_bottom_x_offset, temp_left_bottom_y_offset, temp_left_top_x_offset, temp_left_top_y_offset);
		temp_return_array[1] = temp_point_closest_left[0];
		temp_return_array[2] = temp_point_closest_left[1];
		return temp_return_array;
	}
}
else if ((temp_point_angle <= temp_left_bottom_angle) or (temp_point_angle >= temp_left_top_angle)) {
	temp_return_array[0] = point_direction(temp_left_bottom_x_offset, temp_left_bottom_y_offset, temp_left_top_x_offset, temp_left_top_y_offset);
	temp_return_array[1] = temp_point_closest_left[0];
	temp_return_array[2] = temp_point_closest_left[1];
	return temp_return_array;
}

// Check if Point is relative to the Solid's Right Side
if (temp_right_top_angle > temp_right_bottom_angle) {
	if ((temp_point_angle <= temp_right_top_angle) and (temp_point_angle >= temp_right_bottom_angle)) {
		temp_return_array[0] = point_direction(temp_right_top_x_offset, temp_right_top_y_offset, temp_right_bottom_x_offset, temp_right_bottom_y_offset);
		temp_return_array[1] = temp_point_closest_right[0];
		temp_return_array[2] = temp_point_closest_right[1];
		return temp_return_array;
	}
}
else if ((temp_point_angle <= temp_right_top_angle) or (temp_point_angle >= temp_right_bottom_angle)) {
	temp_return_array[0] = point_direction(temp_right_top_x_offset, temp_right_top_y_offset, temp_right_bottom_x_offset, temp_right_bottom_y_offset);
	temp_return_array[1] = temp_point_closest_right[0];
	temp_return_array[2] = temp_point_closest_right[1];
	return temp_return_array;
}

// Point is relative to the Solid's Bottom Side
temp_return_array[0] = point_direction(temp_right_bottom_x_offset, temp_right_bottom_y_offset, temp_left_bottom_x_offset, temp_left_bottom_y_offset);
temp_return_array[1] = temp_point_closest_bottom[0];
temp_return_array[2] = temp_point_closest_bottom[1];
return temp_return_array;