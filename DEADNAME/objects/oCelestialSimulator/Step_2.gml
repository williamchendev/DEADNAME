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

// Establish Solar System from Solar Systems Array
var temp_solar_system = solar_systems[solar_system_index];

// Establish Forward Camera Vector from Camera's Rotation Matrix
var temp_camera_forward_vector_magnitude = sqrt(dot_product_3d(camera_rotation_matrix[8], camera_rotation_matrix[9], camera_rotation_matrix[10], camera_rotation_matrix[8], camera_rotation_matrix[9], camera_rotation_matrix[10]));
var temp_camera_forward_vector_normalized = [ camera_rotation_matrix[8] / temp_camera_forward_vector_magnitude, camera_rotation_matrix[9] / temp_camera_forward_vector_magnitude, camera_rotation_matrix[10] / temp_camera_forward_vector_magnitude ];

// Create Render Positions
var temp_render_start_x = camera_position_x + temp_camera_forward_vector_normalized[0] * (camera_z_near + camera_z_near_depth_overpass);
var temp_render_start_y = camera_position_y + temp_camera_forward_vector_normalized[1] * (camera_z_near + camera_z_near_depth_overpass);
var temp_render_start_z = camera_position_z + temp_camera_forward_vector_normalized[2] * (camera_z_near + camera_z_near_depth_overpass);

var temp_render_end_x = camera_position_x + temp_camera_forward_vector_normalized[0] * camera_z_far;
var temp_render_end_y = camera_position_y + temp_camera_forward_vector_normalized[1] * camera_z_far;
var temp_render_end_z = camera_position_z + temp_camera_forward_vector_normalized[2] * camera_z_far;

// Calculate Camera's Depth Render Vector
var temp_dx = temp_render_end_x - temp_render_start_x;
var temp_dy = temp_render_end_y - temp_render_start_y;
var temp_dz = temp_render_end_z - temp_render_start_z;

// Iterate through Solar System's Celestial Objects to Calculate their Depths from the Camera's Render Orientation
var temp_celestial_object_index = 0;

repeat (array_length(temp_solar_system))
{
	// Find Celestial Object Instance within Solar System at Index
	var temp_celestial_object_instance = temp_solar_system[temp_celestial_object_index];
	
	// Calculate Vector from Camera to Celestial Object
	var temp_vx = temp_celestial_object_instance.x - temp_render_start_x;
	var temp_vy = temp_celestial_object_instance.y - temp_render_start_y;
	var temp_vz = temp_celestial_object_instance.z - temp_render_start_z;
	
	// Compute the Projection Scalar (dot(v, d) / dot(d, d))
	var temp_projection_scalar = dot_product_3d(temp_vx, temp_vy, temp_vz, temp_dx, temp_dy, temp_dz) / dot_product_3d(temp_dx, temp_dy, temp_dz, temp_dx, temp_dy, temp_dz);
	
	// Calculate Celestial Object Depth from Camera's Position, Rotation, and Forward Vector
	var temp_celestial_object_depth = lerp(camera_z_near + camera_z_near_depth_overpass, camera_z_far, temp_projection_scalar);
	
	// Iterate through Solar System Depth Sorting List to Sort and Index Celestial Object Instance by Depth
	if (ds_list_size(solar_system_render_depth_values_list) == 0)
	{
		// Index Celestial Object Depth and Instance into Solar System Depth Sorting Lists
		ds_list_add(solar_system_render_depth_values_list, temp_celestial_object_depth);
		ds_list_add(solar_system_render_depth_instances_list, temp_celestial_object_instance);
	}
	else
	{
		// Establish Toggle if Celestial Object was Indexed
		var temp_celestial_object_depth_is_indexed = false;
		
		// Iterate through Solar System Depth Sorting List
		for (var i = 0; i < ds_list_size(solar_system_render_depth_values_list); i++)
		{
			// Find Solar System Depth Sorting List's Celestial Object Depth for Comparison
			var temp_celestial_object_depth_comparison = ds_list_find_value(solar_system_render_depth_values_list, i);
			
			// Compare Depth Values
			if (temp_celestial_object_depth >= temp_celestial_object_depth_comparison)
			{
				// Index Celestial Object Depth and Instance into Solar System Depth Sorting Lists
				ds_list_insert(solar_system_render_depth_values_list, i, temp_celestial_object_depth);
				ds_list_insert(solar_system_render_depth_instances_list, i, temp_celestial_object_instance);
				
				// Toggle Celestial Object was Indexed and Break Loop
				temp_celestial_object_depth_is_indexed = true;
				break;
			}
		}
		
		// Check if Celestial Object was Indexed
		if (!temp_celestial_object_depth_is_indexed)
		{
			// Index Celestial Object Depth and Instance into Solar System Depth Sorting Lists
			ds_list_add(solar_system_render_depth_values_list, temp_celestial_object_depth);
			ds_list_add(solar_system_render_depth_instances_list, temp_celestial_object_instance);
		}
	}
	
	// Increment Celestial Object Index
	temp_celestial_object_index++;
}