/// @description Explosion Dynamic Cloud Update Event
// Performs Explosion's Dynamic Cloud Update Behaviour

// Iterate through Dynamic Cloud DS Lists to Draw Dynamic Cloud
var temp_cloud_index = ds_list_size(clouds_image_index_list) - 1;

repeat (ds_list_size(clouds_image_index_list))
{
	// Find Cloud Alpha Transparency
	var temp_cloud_alpha = ds_list_find_value(clouds_alpha_list, temp_cloud_index);
	
	// Decay Cloud Alpha Transparency
	temp_cloud_alpha *= power(cloud_alpha_mult, frame_delta);
	temp_cloud_alpha += cloud_alpha_spd * frame_delta;
	
	// Check if Cloud is fully Transparent and should be destroyed
	if (temp_cloud_alpha <= 0)
	{
		// Destroy Cloud Visual DS Lists
		ds_list_delete(clouds_image_index_list, temp_cloud_index);
		ds_list_delete(clouds_rotation_list, temp_cloud_index);
		ds_list_delete(clouds_horizontal_offset_list, temp_cloud_index);
		ds_list_delete(clouds_vertical_offset_list, temp_cloud_index);
		ds_list_delete(clouds_horizontal_scale_list, temp_cloud_index);
		ds_list_delete(clouds_vertical_scale_list, temp_cloud_index);
		ds_list_delete(clouds_alpha_list, temp_cloud_index);
		ds_list_delete(clouds_alpha_filter_list, temp_cloud_index);
		ds_list_delete(clouds_color_list, temp_cloud_index);
		
		// Destroy Cloud Physics DS Lists
		ds_list_delete(clouds_velocity_spd_list, temp_cloud_index);
		ds_list_delete(clouds_velocity_gravity_list, temp_cloud_index);
		ds_list_delete(clouds_velocity_horizontal_direction_list, temp_cloud_index);
		ds_list_delete(clouds_velocity_vertical_direction_list, temp_cloud_index);
		
		// Decrement Cloud Index
		temp_cloud_index--;
		
		// Continue to next Cloud to Perform Behaviour
		continue;
	}
	
	ds_list_set(clouds_alpha_list, temp_cloud_index, clamp(temp_cloud_alpha, 0, 1));
	
	// Establish Cloud Draw Variables
	var temp_cloud_rotation = ds_list_find_value(clouds_rotation_list, temp_cloud_index);
	
	var temp_cloud_velocity_spd = ds_list_find_value(clouds_velocity_spd_list, temp_cloud_index);
	var temp_cloud_velocity_gravity = ds_list_find_value(clouds_velocity_gravity_list, temp_cloud_index);
	
	var temp_cloud_velocity_horizontal_direction = ds_list_find_value(clouds_velocity_horizontal_direction_list, temp_cloud_index);
	var temp_cloud_velocity_vertical_direction = ds_list_find_value(clouds_velocity_vertical_direction_list, temp_cloud_index);
	
	var temp_cloud_horizontal_offset = ds_list_find_value(clouds_horizontal_offset_list, temp_cloud_index);
	var temp_cloud_vertical_offset = ds_list_find_value(clouds_vertical_offset_list, temp_cloud_index);
	
	var temp_cloud_horizontal_scale = ds_list_find_value(clouds_horizontal_scale_list, temp_cloud_index);
	var temp_cloud_vertical_scale = ds_list_find_value(clouds_vertical_scale_list, temp_cloud_index);
	
	var temp_cloud_alpha_filter = ds_list_find_value(clouds_alpha_filter_list, temp_cloud_index);
	
	var temp_cloud_color = ds_list_find_value(clouds_color_list, temp_cloud_index);
	
	// Cloud Physics Movement
	temp_cloud_velocity_spd *= power(cloud_movement_friction_mult, frame_delta);
	temp_cloud_velocity_gravity += cloud_movement_gravity * frame_delta;
	
	temp_cloud_horizontal_offset += temp_cloud_velocity_horizontal_direction * temp_cloud_velocity_spd * frame_delta;
	temp_cloud_vertical_offset += temp_cloud_velocity_vertical_direction * temp_cloud_velocity_spd * frame_delta;
	
	temp_cloud_vertical_offset += temp_cloud_velocity_gravity * frame_delta;
	
	// Cloud Wind Movement Animation
	temp_cloud_horizontal_offset += cloud_movement_wind_spd * cloud_movement_wind_horizontal_direction * frame_delta;
	temp_cloud_vertical_offset += cloud_movement_wind_spd * cloud_movement_wind_vertical_direction * frame_delta;
	
	// Cloud Size Expansion Animation
	temp_cloud_horizontal_scale += cloud_size_change * frame_delta;
	temp_cloud_vertical_scale += cloud_size_change * frame_delta;
	
	// Cloud Transparency & Alpha Filtering Animation
	temp_cloud_alpha_filter += cloud_alpha_filter_spd * frame_delta;
	
	// Save Cloud Draw Variables
	ds_list_set(clouds_rotation_list, temp_cloud_index, temp_cloud_rotation);
	
	ds_list_set(clouds_velocity_spd_list, temp_cloud_index, temp_cloud_velocity_spd);
	ds_list_set(clouds_velocity_gravity_list, temp_cloud_index, min(temp_cloud_velocity_gravity, cloud_movement_gravity_limit));
	
	ds_list_set(clouds_horizontal_offset_list, temp_cloud_index, temp_cloud_horizontal_offset);
	ds_list_set(clouds_vertical_offset_list, temp_cloud_index, temp_cloud_vertical_offset);
	
	ds_list_set(clouds_horizontal_scale_list, temp_cloud_index, max(temp_cloud_horizontal_scale, 0));
	ds_list_set(clouds_vertical_scale_list, temp_cloud_index, max(temp_cloud_vertical_scale, 0));
	
	ds_list_set(clouds_alpha_filter_list, temp_cloud_index, temp_cloud_alpha_filter);
	
	ds_list_set(clouds_color_list, temp_cloud_index, temp_cloud_color);
	
	// Decrement Cloud Index
	temp_cloud_index--;
}

// Check if Clouds DS Lists are Empty
if (ds_list_size(clouds_image_index_list) == 0)
{
	// Destroy Instance
	instance_destroy();
}