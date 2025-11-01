/// @description Explosion Dynamic Cloud Initialization
// Initializes Explosion's Dynamic Cloud

// Inherit the parent event
event_inherited();

// Establish Explosion Side Direction
var temp_side_direction_cos = 1;
var temp_side_direction_sin = 0;

// Establish Explosion Direction and Horizontal Range
var temp_explosion_direction_range = 180;
var temp_explosion_horizontal_range = 8;

// Check if Clouds have a Perpendicular Explosion
if (cloud_collision)
{
	// Establish Explosion Direction and Horizontal Range
	temp_explosion_direction_range = 30;
	temp_explosion_horizontal_range = 24;
}

// Set Explosion Spread Direction
temp_side_direction_cos = dcos(image_angle);
temp_side_direction_sin = -dsin(image_angle);

// Instantiate Clouds
var temp_cloud_body_num = 48;

for (var i = 0; i < temp_cloud_body_num; i++)
{
	// Set Cloud Image Index
	ds_list_add(clouds_image_index_list, irandom_range(0, sprite_get_number(sprite_index) - 1));
	
	// Set Cloud Rotation
	ds_list_add(clouds_rotation_list, random(360));
	
	// Establish Random Side Offset
	var temp_cloud_body_random_side_offset = random_range(-temp_explosion_horizontal_range, temp_explosion_horizontal_range);
	
	// Set Cloud Side Offset Direction
	var temp_cloud_body_direction = random(360);
	var temp_cloud_body_random_direction_distance = random_range(0, 16);
	
	if (temp_explosion_horizontal_range != 0)
	{
		temp_cloud_body_direction = image_angle + (-temp_explosion_direction_range * (temp_cloud_body_random_side_offset / temp_explosion_horizontal_range)) + 90;
	}
	
	// Calculate Cloud Horizontal and Vertical Position Offset
	var temp_cloud_body_horizontal_offset = temp_cloud_body_random_side_offset * temp_side_direction_cos;
	var temp_cloud_body_vertical_offset = temp_cloud_body_random_side_offset * temp_side_direction_sin;
	
	temp_cloud_body_horizontal_offset += random_range(-9, 9);
	temp_cloud_body_vertical_offset += random_range(-9, 9);
	
	rot_prefetch(temp_cloud_body_direction);
	
	temp_cloud_body_horizontal_offset += rot_dist_x(temp_cloud_body_random_direction_distance);
	temp_cloud_body_vertical_offset += rot_dist_y(temp_cloud_body_random_direction_distance);
	
	// Set Cloud Velocity Direction
	ds_list_add(clouds_velocity_horizontal_direction_list, dcos(temp_cloud_body_direction));
	ds_list_add(clouds_velocity_vertical_direction_list, -dsin(temp_cloud_body_direction));
	
	// Set Cloud Velocity Speed
	var temp_cloud_body_velocity_spd = power(random(1), 2);
	ds_list_add(clouds_velocity_spd_list, temp_cloud_body_velocity_spd * cloud_movement_spd);
	
	// Set Cloud Gravity
	ds_list_add(clouds_velocity_gravity_list, 0);
	
	// Set CLoud Horizontal and Vertical Position Offset
	ds_list_add(clouds_horizontal_offset_list, temp_cloud_body_horizontal_offset);
	ds_list_add(clouds_vertical_offset_list, temp_cloud_body_vertical_offset);
	
	// Set Cloud Size
	var temp_cloud_body_random_scale = lerp(cloud_size_max, cloud_size_min, temp_cloud_body_velocity_spd);
	
	ds_list_add(clouds_horizontal_scale_list, temp_cloud_body_random_scale);
	ds_list_add(clouds_vertical_scale_list, temp_cloud_body_random_scale);
	
	// Set Cloud Alpha and Alpha Filter
	ds_list_add(clouds_alpha_list, 1 - power(random(1), 2));
	ds_list_add(clouds_alpha_filter_list, cloud_alpha_filter_init);
	
	// Set Cloud Color
	ds_list_add(clouds_color_list, c_white);
}
