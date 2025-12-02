/// @description Celestial Body Depth Sorting Event
// Celestial Simulator Object Depth Sorting Behaviour for Rendering Pipeline

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Clear Solar System Depth Sorting Lists
ds_list_clear(solar_system_render_depth_values_list);
ds_list_clear(solar_system_render_depth_instances_list);

// Check if Solar System exists and is being viewed
if (solar_system_index == -1)
{
	// Not currently viewing a Solar System - Early Return
	return;
}

// Establish Solar System
var temp_solar_system = solar_systems[solar_system_index];

// Establish Camera's Forward Vector
var temp_camera_forward_vector = [ 0, 0, 1, 0 ];

// Transform Camera's Forward Vector
var temp_camera_transformed_forward_vector =
[
	temp_camera_forward_vector[0] * camera_rotation_matrix[0] + temp_camera_forward_vector[1] * camera_rotation_matrix[1] + temp_camera_forward_vector[2] * camera_rotation_matrix[2] + temp_camera_forward_vector[3] * camera_rotation_matrix[3],
	temp_camera_forward_vector[0] * camera_rotation_matrix[4] + temp_camera_forward_vector[1] * camera_rotation_matrix[5] + temp_camera_forward_vector[2] * camera_rotation_matrix[6] + temp_camera_forward_vector[3] * camera_rotation_matrix[7],
	temp_camera_forward_vector[0] * camera_rotation_matrix[8] + temp_camera_forward_vector[1] * camera_rotation_matrix[9] + temp_camera_forward_vector[2] * camera_rotation_matrix[10] + temp_camera_forward_vector[3] * camera_rotation_matrix[11],
	temp_camera_forward_vector[0] * camera_rotation_matrix[12] + temp_camera_forward_vector[1] * camera_rotation_matrix[13] + temp_camera_forward_vector[2] * camera_rotation_matrix[14] + temp_camera_forward_vector[3] * camera_rotation_matrix[15],
];

// Create Render Positions
var temp_render_start_x = camera_position_x + temp_camera_transformed_forward_vector[0] * (camera_z_near + camera_z_near_depth_overpass);
var temp_render_start_y = camera_position_y + temp_camera_transformed_forward_vector[1] * (camera_z_near + camera_z_near_depth_overpass);
var temp_render_start_z = camera_position_z + temp_camera_transformed_forward_vector[2] * (camera_z_near + camera_z_near_depth_overpass);

var temp_render_end_x = camera_position_x + temp_camera_transformed_forward_vector[0] * camera_z_far;
var temp_render_end_y = camera_position_y + temp_camera_transformed_forward_vector[1] * camera_z_far;
var temp_render_end_z = camera_position_z + temp_camera_transformed_forward_vector[2] * camera_z_far;

// Iterate through Solar System's Celestial Bodies to Calculate their Depths from the Camera's Render Orientation
var temp_celestial_body_index = 0;

repeat (array_length(temp_solar_system))
{
	// Find Celestial Body Instance within Solar System at Index
	var temp_celestial_body_instance = temp_solar_system[temp_celestial_body_index];
	
	// Direction vector of the line
	var temp_dx = temp_render_end_x - temp_render_start_x;
	var temp_dy = temp_render_end_y - temp_render_start_y;
	var temp_dz = temp_render_end_z - temp_render_start_z;
	
	// Vector from P1 to P3
	var temp_vx = temp_celestial_body_instance.x - temp_render_start_x;
	var temp_vy = temp_celestial_body_instance.y - temp_render_start_y;
	var temp_vz = temp_celestial_body_instance.z - temp_render_start_z;
	
	// Compute the projection scalar (dot(v, d) / dot(d, d))
	var temp_projection_scalar = dot_product_3d(temp_vx, temp_vy, temp_vz, temp_dx, temp_dy, temp_dz);
	
	// Calculate Celestial Body Depth from Camera's Position, Rotation, and Forward Vector
	var temp_celestial_body_depth = lerp(camera_z_near + camera_z_near_depth_overpass, camera_z_far, clamp(temp_projection_scalar, 0, 1));
	
	// Iterate through Solar System Depth Sorting List to Sort and Index Celestial Body Instance by Depth
	if (ds_list_size(solar_system_render_depth_values_list) == 0)
	{
		// Index Celestial Body Depth and Instance into Solar System Depth Sorting Lists
		ds_list_add(solar_system_render_depth_values_list, temp_celestial_body_depth);
		ds_list_add(solar_system_render_depth_instances_list, temp_celestial_body_instance);
	}
	else
	{
		// Establish Toggle if Celestial Body was Indexed
		var temp_celestial_body_depth_is_indexed = false;
		
		// Iterate through Solar System Depth Sorting List
		for (var i = 0; i < ds_list_size(solar_system_render_depth_values_list); i++)
		{
			// Find Solar System Depth Sorting List's Celestial Body Depth for Comparison
			var temp_celestial_body_depth_comparison = ds_list_find_value(solar_system_render_depth_values_list, i);
			
			// Compare Depth Values
			if (temp_celestial_body_depth >= temp_celestial_body_depth_comparison)
			{
				// Index Celestial Body Depth and Instance into Solar System Depth Sorting Lists
				ds_list_insert(solar_system_render_depth_values_list, i, temp_celestial_body_depth);
				ds_list_insert(solar_system_render_depth_instances_list, i, temp_celestial_body_instance);
				
				// Toggle Celestial Body was Indexed and Break Loop
				temp_celestial_body_depth_is_indexed = true;
				break;
			}
		}
		
		// Check if Celestial Body was Indexed
		if (!temp_celestial_body_depth_is_indexed)
		{
			// Index Celestial Body Depth and Instance into Solar System Depth Sorting Lists
			ds_list_add(solar_system_render_depth_values_list, temp_celestial_body_depth);
			ds_list_add(solar_system_render_depth_instances_list, temp_celestial_body_instance);
		}
	}
	
	// Increment Celestial Body Index
	temp_celestial_body_index++;
}
