/// @description Explosion Dynamic Cloud Update Event
// Performs Explosion's Dynamic Cloud Update Behaviour

// Iterate through Dynamic Cloud DS Lists to Draw Dynamic Cloud
var temp_cloud_index = ds_list_size(clouds_image_index_list) - 1;

repeat (ds_list_size(clouds_image_index_list))
{
	// Establish Cloud Draw Variables
	var temp_cloud_rotation = ds_list_find_value(clouds_rotation_list, temp_cloud_index);
	
	var temp_cloud_velocity_spd = ds_list_find_value(clouds_velocity_spd_list, temp_cloud_index);
	var temp_cloud_velocity_direction = ds_list_find_value(clouds_velocity_direction_list, temp_cloud_index);
	
	var temp_cloud_horizontal_offset = ds_list_find_value(clouds_horizontal_offset_list, temp_cloud_index);
	var temp_cloud_vertical_offset = ds_list_find_value(clouds_vertical_offset_list, temp_cloud_index);
	
	var temp_cloud_horizontal_scale = ds_list_find_value(clouds_horizontal_scale_list, temp_cloud_index);
	var temp_cloud_vertical_scale = ds_list_find_value(clouds_vertical_scale_list, temp_cloud_index);
	
	var temp_cloud_alpha = ds_list_find_value(clouds_alpha_list, temp_cloud_index);
	var temp_cloud_alpha_filter = ds_list_find_value(clouds_alpha_filter_list, temp_cloud_index);
	
	var temp_cloud_color = ds_list_find_value(clouds_color_list, temp_cloud_index);
	
	// Edit Cloud Draw Variables
	rot_prefetch(temp_cloud_velocity_direction);
	
	temp_cloud_velocity_spd *= power(cloud_movement_friction_mult, frame_delta);
	
	temp_cloud_horizontal_offset += rot_dist_x(temp_cloud_velocity_spd);
	temp_cloud_vertical_offset += rot_dist_y(temp_cloud_velocity_spd);
	
	temp_cloud_alpha -= cloud_alpha_spd * frame_delta;
	temp_cloud_alpha_filter += cloud_alpha_filter_spd * frame_delta;
	
	// Save Cloud Draw Variables
	ds_list_set(clouds_rotation_list, temp_cloud_index, temp_cloud_rotation);
	
	ds_list_set(clouds_velocity_spd_list, temp_cloud_index, temp_cloud_velocity_spd);
	ds_list_set(clouds_velocity_direction_list, temp_cloud_index, temp_cloud_velocity_direction);
	
	ds_list_set(clouds_horizontal_offset_list, temp_cloud_index, temp_cloud_horizontal_offset);
	ds_list_set(clouds_vertical_offset_list, temp_cloud_index, temp_cloud_vertical_offset);
	
	ds_list_set(clouds_horizontal_scale_list, temp_cloud_index, temp_cloud_horizontal_scale);
	ds_list_set(clouds_vertical_scale_list, temp_cloud_index, temp_cloud_vertical_scale);
	
	ds_list_set(clouds_alpha_list, temp_cloud_index, clamp(temp_cloud_alpha, 0, 1));
	ds_list_set(clouds_alpha_filter_list, temp_cloud_index, temp_cloud_alpha_filter);
	
	ds_list_set(clouds_color_list, temp_cloud_index, temp_cloud_color);
	
	// Decrement Cloud Index
	temp_cloud_index--;
}

