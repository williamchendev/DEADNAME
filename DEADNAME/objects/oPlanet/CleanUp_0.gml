/// @description Default Planet Clean Up
// Cleans up the Planet's Data Structures and Buffers used for calculating the Planet's Behaviour

// Perform Inherited Celestial Body Cleanup Behaviour
event_inherited();

// Destroy Clouds Depth Sorted Rendering DS List
ds_list_destroy(clouds_depth_list);
clouds_depth_list = -1;

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

// Destroy Clouds Behavioural Properties DS Lists
ds_list_destroy(clouds_density_list);
clouds_density_list = -1;

ds_list_destroy(clouds_absorption_list);
clouds_absorption_list = -1;

ds_list_destroy(clouds_position_u_list);
clouds_position_u_list = -1;

ds_list_destroy(clouds_position_v_list);
clouds_position_v_list = -1;

ds_list_destroy(clouds_position_height_list);
clouds_position_height_list = -1;

// Destroy Clouds Group DS Lists
for (var temp_clouds_group_radius_index = ds_list_size(clouds_group_radius_list) - 1; temp_clouds_group_radius_index >= 0; temp_clouds_group_radius_index--)
{
	// Find Nested DS List
	var temp_clouds_group_radius_list = ds_list_find_value(clouds_group_radius_list, temp_clouds_group_radius_index);
	
	// Destroy Nested DS List
	ds_list_destroy(temp_clouds_group_radius_list);
	
	// Set Former Nested List as an Inert Value
	ds_list_set(clouds_group_radius_list, temp_clouds_group_radius_index, -1);
}

ds_list_destroy(clouds_group_radius_list);
clouds_group_radius_list = -1;

for (var temp_clouds_group_height_index = ds_list_size(clouds_group_height_list) - 1; temp_clouds_group_height_index >= 0; temp_clouds_group_height_index--)
{
	// Find Nested DS List
	var temp_clouds_group_height_list = ds_list_find_value(clouds_group_height_list, temp_clouds_group_height_index);
	
	// Destroy Nested DS List
	ds_list_destroy(temp_clouds_group_height_list);
	
	// Set Former Nested List as an Inert Value
	ds_list_set(clouds_group_height_list, temp_clouds_group_height_index, -1);
}

ds_list_destroy(clouds_group_height_list);
clouds_group_height_list = -1;

for (var temp_clouds_group_bearing_index = ds_list_size(clouds_group_bearing_list) - 1; temp_clouds_group_bearing_index >= 0; temp_clouds_group_bearing_index--)
{
	// Find Nested DS List
	var temp_clouds_group_bearing_list = ds_list_find_value(clouds_group_bearing_list, temp_clouds_group_bearing_index);
	
	// Destroy Nested DS List
	ds_list_destroy(temp_clouds_group_bearing_list);
	
	// Set Former Nested List as an Inert Value
	ds_list_set(clouds_group_bearing_list, temp_clouds_group_bearing_index, -1);
}

ds_list_destroy(clouds_group_bearing_list);
clouds_group_bearing_list = -1;

for (var temp_clouds_group_distance_index = ds_list_size(clouds_group_distance_list) - 1; temp_clouds_group_distance_index >= 0; temp_clouds_group_distance_index--)
{
	// Find Nested DS List
	var temp_clouds_group_distance_list = ds_list_find_value(clouds_group_distance_list, temp_clouds_group_distance_index);
	
	// Destroy Nested DS List
	ds_list_destroy(temp_clouds_group_distance_list);
	
	// Set Former Nested List as an Inert Value
	ds_list_set(clouds_group_distance_list, temp_clouds_group_distance_index, -1);
}

ds_list_destroy(clouds_group_distance_list);
clouds_group_distance_list = -1;
