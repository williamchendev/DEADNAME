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

// Establish Camera Vectors from Camera's Rotation Matrix
var temp_camera_right_vector_magnitude = sqrt(dot_product_3d(camera_rotation_matrix[0], camera_rotation_matrix[1], camera_rotation_matrix[2], camera_rotation_matrix[0], camera_rotation_matrix[1], camera_rotation_matrix[2]));
var temp_camera_right_vector_normalized = [ camera_rotation_matrix[0] / temp_camera_right_vector_magnitude, camera_rotation_matrix[1] / temp_camera_right_vector_magnitude, camera_rotation_matrix[2] / temp_camera_right_vector_magnitude ];

var temp_camera_up_vector_magnitude = sqrt(dot_product_3d(camera_rotation_matrix[4], camera_rotation_matrix[5], camera_rotation_matrix[6], camera_rotation_matrix[4], camera_rotation_matrix[5], camera_rotation_matrix[6]));
var temp_camera_up_vector_normalized = [ camera_rotation_matrix[4] / temp_camera_up_vector_magnitude, camera_rotation_matrix[5] / temp_camera_up_vector_magnitude, camera_rotation_matrix[6] / temp_camera_up_vector_magnitude ];

var temp_camera_forward_vector_magnitude = sqrt(dot_product_3d(camera_rotation_matrix[8], camera_rotation_matrix[9], camera_rotation_matrix[10], camera_rotation_matrix[8], camera_rotation_matrix[9], camera_rotation_matrix[10]));
var temp_camera_forward_vector_normalized = [ camera_rotation_matrix[8] / temp_camera_forward_vector_magnitude, camera_rotation_matrix[9] / temp_camera_forward_vector_magnitude, camera_rotation_matrix[10] / temp_camera_forward_vector_magnitude ];

// Celestial Object Frustum Culling
var temp_camera_aspect = GameManager.game_width / GameManager.game_height;

var temp_camera_fov_radians = (camera_fov * pi) / 180;
var temp_camera_half_v = tan(temp_camera_fov_radians / 2);
var temp_camera_half_h = temp_camera_half_v * temp_camera_aspect;

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

// Iterate through Solar System's Celestial Bodies to Calculate their Depths from the Camera's Render Orientation
var temp_celestial_body_index = 0;

repeat (array_length(temp_solar_system))
{
	// Find Celestial Body Instance within Solar System at Index
	var temp_celestial_object_instance = temp_solar_system[temp_celestial_body_index];
	
	// Calculate Vector from Camera to Celestial Body
	var temp_vx = temp_celestial_object_instance.x - temp_render_start_x;
	var temp_vy = temp_celestial_object_instance.y - temp_render_start_y;
	var temp_vz = temp_celestial_object_instance.z - temp_render_start_z;
	
	// Compute the Projection Scalar (dot(v, d) / dot(d, d))
	var temp_projection_scalar = dot_product_3d(temp_vx, temp_vy, temp_vz, temp_dx, temp_dy, temp_dz) / dot_product_3d(temp_dx, temp_dy, temp_dz, temp_dx, temp_dy, temp_dz);
	
	// Calculate Celestial Body Depth from Camera's Position, Rotation, and Forward Vector
	var temp_celestial_body_depth = lerp(camera_z_near + camera_z_near_depth_overpass, camera_z_far, temp_projection_scalar);
	
	// Celestial Object Frustum Culling Behaviour
	if (temp_celestial_object_instance.frustum_culling_enabled)
	{
		// Celestial Object Frustum Depth Culling
		if (temp_celestial_body_depth + temp_celestial_object_instance.frustum_culling_radius < camera_z_near)
		{
			// Increment Celestial Object Index
			temp_celestial_body_index++;
			
			// Celestial Object Frustum Depth Culled - Skip Celestial Object
			continue;
		}
		
		// Calculate Celestial Object Frustum Culling Vectors
		var temp_camera_to_object_vector_x = temp_celestial_object_instance.x - camera_position_x;
		var temp_camera_to_object_vector_y = temp_celestial_object_instance.y - camera_position_y;
		var temp_camera_to_object_vector_z = temp_celestial_object_instance.z - camera_position_z;
		
		// Calculate Celestial Object Frustum Culling Dot Products
		var temp_camera_right_to_object_dot_product = dot_product_3d(temp_camera_to_object_vector_x, temp_camera_to_object_vector_y, temp_camera_to_object_vector_z, temp_camera_right_vector_normalized[0], temp_camera_right_vector_normalized[1], temp_camera_right_vector_normalized[2]);
		var temp_camera_up_to_object_dot_product = dot_product_3d(temp_camera_to_object_vector_x, temp_camera_to_object_vector_y, temp_camera_to_object_vector_z, temp_camera_up_vector_normalized[0], temp_camera_up_vector_normalized[1], temp_camera_up_vector_normalized[2]);
		var temp_camera_forward_to_object_dot_product = dot_product_3d(temp_camera_to_object_vector_x, temp_camera_to_object_vector_y, temp_camera_to_object_vector_z, temp_camera_forward_vector_normalized[0], temp_camera_forward_vector_normalized[1], temp_camera_forward_vector_normalized[2]);
		
		// Check if Celestial Object can be Horizontally Frustum Culled
		var temp_camera_frustum_half_width = temp_camera_half_h * temp_camera_forward_to_object_dot_product;
		
		if (temp_camera_right_to_object_dot_product < -temp_camera_frustum_half_width - temp_celestial_object_instance.frustum_culling_radius or temp_camera_right_to_object_dot_product > temp_camera_frustum_half_width + temp_celestial_object_instance.frustum_culling_radius) 
		{
			// Increment Celestial Object Index
			temp_celestial_body_index++;
			
			// Celestial Object Frustum Culled - Skip Celestial Object
			continue;
		}
		
		// Check if Celestial Object can be Vertically Frustum Culled
		var temp_camera_frustum_half_height = temp_camera_half_v * temp_camera_forward_to_object_dot_product;
		
		if (temp_camera_up_to_object_dot_product < -temp_camera_frustum_half_height - temp_celestial_object_instance.frustum_culling_radius or temp_camera_up_to_object_dot_product > temp_camera_frustum_half_height + temp_celestial_object_instance.frustum_culling_radius) 
		{
			// Increment Celestial Object Index
			temp_celestial_body_index++;
			
			// Celestial Object Frustum Culled - Skip Celestial Object
			continue;
		}
	}
	
	// Iterate through Solar System Depth Sorting List to Sort and Index Celestial Body Instance by Depth
	if (ds_list_size(solar_system_render_depth_values_list) == 0)
	{
		// Index Celestial Body Depth and Instance into Solar System Depth Sorting Lists
		ds_list_add(solar_system_render_depth_values_list, temp_celestial_body_depth);
		ds_list_add(solar_system_render_depth_instances_list, temp_celestial_object_instance);
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
				ds_list_insert(solar_system_render_depth_instances_list, i, temp_celestial_object_instance);
				
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
			ds_list_add(solar_system_render_depth_instances_list, temp_celestial_object_instance);
		}
	}
	
	// Increment Celestial Body Index
	temp_celestial_body_index++;
}