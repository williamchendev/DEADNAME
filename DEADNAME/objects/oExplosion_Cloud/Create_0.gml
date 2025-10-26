/// @description Explosion Dynamic Cloud Initialization
// Initializes Explosion's Dynamic Cloud

//
cloud_movement_friction_mult = 0.98;

cloud_alpha_spd = 0.0015;
cloud_alpha_filter_spd = 0.01;

// Lighting Engine Behaviour: Initialize Dynamic Cloud
event_inherited();

//
clouds_velocity_spd_list = ds_list_create();
clouds_velocity_direction_list = ds_list_create();

//
var temp_side_direction_cos = 1;
var temp_side_direction_sin = 0;

//
var temp_explosion_direction = 0;
var temp_explosion_direction_range = 180;
var temp_explosion_horizontal_range = 0;

//
var temp_solid_collision = collision_circle(x, y, 12, oSolid, true, true);

if (temp_solid_collision != noone and instance_exists(temp_solid_collision))
{
	//
	temp_explosion_direction = point_check_solid_surface_angle(x, y, temp_solid_collision);
	temp_explosion_direction_range = 30;
	temp_explosion_horizontal_range = 24;
	
	//
	temp_side_direction_cos = dcos(temp_explosion_direction);
	temp_side_direction_sin = -dsin(temp_explosion_direction);
}

//
var temp_cloud_peaks_num = irandom_range(2, 5);

for (var p = 0; p < temp_cloud_peaks_num; p++)
{
	//
	
}

//
var temp_cloud_body_num = irandom_range(24, 48);

for (var i = 0; i < temp_cloud_body_num; i++)
{
	//
	ds_list_add(clouds_image_index_list, irandom_range(0, sprite_get_number(sprite_index) - 1));
	
	//
	ds_list_add(clouds_rotation_list, random(360));
	
	//
	var temp_cloud_body_random_side_offset = random_range(-temp_explosion_horizontal_range, temp_explosion_horizontal_range);
	var temp_cloud_body_horizontal_offset = temp_cloud_body_random_side_offset * temp_side_direction_cos;
	var temp_cloud_body_vertical_offset = temp_cloud_body_random_side_offset * temp_side_direction_sin;
	
	//
	temp_cloud_body_horizontal_offset += random_range(-6, 6);
	temp_cloud_body_vertical_offset += random_range(-6, 6);
	
	//
	var temp_cloud_body_direction = random(360);
	var temp_cloud_body_random_direction_distance = random_range(0, 16);
	
	if (temp_explosion_horizontal_range != 0)
	{
		temp_cloud_body_direction = temp_explosion_direction + (-temp_explosion_direction_range * (temp_cloud_body_random_side_offset / temp_explosion_horizontal_range)) + 90;
	}
	
	//
	rot_prefetch(temp_cloud_body_direction);
	temp_cloud_body_horizontal_offset += rot_dist_x(temp_cloud_body_random_direction_distance);
	temp_cloud_body_vertical_offset += rot_dist_y(temp_cloud_body_random_direction_distance);
	
	//
	ds_list_add(clouds_velocity_direction_list, temp_cloud_body_direction);
	
	//
	ds_list_add(clouds_velocity_spd_list, random_range(0, 1));
	
	//
	ds_list_add(clouds_horizontal_offset_list, temp_cloud_body_horizontal_offset);
	ds_list_add(clouds_vertical_offset_list, temp_cloud_body_vertical_offset);
	
	//
	var temp_cloud_body_random_scale = random_range(0.8, 1);
	
	//
	ds_list_add(clouds_horizontal_scale_list, temp_cloud_body_random_scale);
	ds_list_add(clouds_vertical_scale_list, temp_cloud_body_random_scale);
	
	//
	ds_list_add(clouds_alpha_list, random_range(0.7, 1));
	ds_list_add(clouds_alpha_filter_list, 0);
	
	//
	ds_list_add(clouds_color_list, c_white);
}
