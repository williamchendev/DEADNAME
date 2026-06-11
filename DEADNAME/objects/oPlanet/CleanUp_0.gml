/// @description Default Planet Clean Up
// Cleans up the Planet's Data Structures and Buffers used for calculating the Planet's Behaviour

// Perform Inherited Celestial Body Cleanup Behaviour
event_inherited();

// Destroy Clouds Depth Sorted Rendering DS List
ds_list_destroy(clouds_render_u_list);
clouds_render_u_list = -1;

ds_list_destroy(clouds_render_v_list);
clouds_render_v_list = -1;

ds_list_destroy(clouds_render_height_list);
clouds_render_height_list = -1;

ds_list_destroy(clouds_render_radius_list);
clouds_render_radius_list = -1;

ds_list_destroy(clouds_render_density_list);
clouds_render_density_list = -1;

ds_list_destroy(clouds_render_absorption_list);
clouds_render_absorption_list = -1;

// Destroy Clouds Behavioural Properties Arrays
if (clouds)
{
	// Iterate through and Destroy all Nested Cloud Individual Arrays
	var temp_cloud_index = 0;
	
	repeat (clouds_count)
	{
		// Destroy Nested Cloud Individual Arrays
		array_resize(clouds_group_radius_array[temp_cloud_index], 0);
		clouds_group_radius_array[temp_cloud_index] = -1;
		
		array_resize(clouds_group_height_array[temp_cloud_index], 0);
		clouds_group_height_array[temp_cloud_index] = -1;
		
		array_resize(clouds_group_bearing_array[temp_cloud_index], 0);
		clouds_group_bearing_array[temp_cloud_index] = -1;
		
		array_resize(clouds_group_distance_array[temp_cloud_index], 0);
		clouds_group_distance_array[temp_cloud_index] = -1;
		
		// Increment Cloud Index
		temp_cloud_index++;
	}
}

array_resize(clouds_density_array, 0);
clouds_density_array = -1;

array_resize(clouds_absorption_array, 0);
clouds_absorption_array = -1;

array_resize(clouds_position_u_array, 0);
clouds_position_u_array = -1;

array_resize(clouds_position_v_array, 0);
clouds_position_v_array = -1;

array_resize(clouds_position_height_array, 0);
clouds_position_height_array = -1;

array_resize(clouds_rotation_array, 0);
clouds_rotation_array = -1;

array_resize(clouds_group_count_array, 0);
clouds_group_count_array = -1;

array_resize(clouds_group_radius_array, 0);
clouds_group_radius_array = -1;

array_resize(clouds_group_height_array, 0);
clouds_group_height_array = -1;

array_resize(clouds_group_bearing_array, 0);
clouds_group_bearing_array = -1;

array_resize(clouds_group_distance_array, 0);
clouds_group_distance_array = -1;

