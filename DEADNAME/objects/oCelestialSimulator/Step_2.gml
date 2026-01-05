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

var temp_dm = dot_product_3d(temp_dx, temp_dy, temp_dz, temp_dx, temp_dy, temp_dz);

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
	var temp_projection_scalar = dot_product_3d(temp_vx, temp_vy, temp_vz, temp_dx, temp_dy, temp_dz) / temp_dm;
	
	// Calculate Celestial Object Depth from Camera's Position, Rotation, and Forward Vector
	var temp_celestial_object_depth = lerp(camera_z_near + camera_z_near_depth_overpass, camera_z_far, temp_projection_scalar);
	
	// Celestial Object Type  Depth Sorting Behaviour
	switch (temp_celestial_object_instance.celestial_object_type)
	{
		case CelestialObjectType.Planet:
			// Planet Depth Sorting Behaviour
			if (temp_celestial_object_instance.clouds)
			{
				//
				ds_list_clear(temp_celestial_object_instance.clouds_depth_list);
				ds_list_clear(temp_celestial_object_instance.clouds_render_list);
				
				//
				var temp_planet_rotation_matrix = rotation_matrix_from_euler_angles(-temp_celestial_object_instance.euler_angle_x, -temp_celestial_object_instance.euler_angle_y, -temp_celestial_object_instance.euler_angle_z);
				
				// Iterate through Planet's Clouds
				var temp_cloud_index = 0;
				
				repeat (array_length(temp_celestial_object_instance.clouds_active_array))
				{
					// Check if Cloud is Active
					if (temp_celestial_object_instance.clouds_active_array[temp_cloud_index] == 1)
					{
						// Find Cloud Height
						var temp_cloud_height = temp_celestial_object_instance.radius + temp_celestial_object_instance.clouds_height_array[temp_cloud_index];
						
						// Find Cloud Sphere UV
						var temp_cloud_u = temp_celestial_object_instance.clouds_u_position_array[temp_cloud_index];
						var temp_cloud_v = temp_celestial_object_instance.clouds_v_position_array[temp_cloud_index];
						
						// Find Vertical Sphere Vector
						var temp_cloud_atan_value = (0.5 - temp_cloud_u) * 2 * pi;
						var temp_cloud_asin_value = (0.5 - temp_cloud_v) * pi;
						var temp_cloud_y_value = -sin(temp_cloud_asin_value);
						
						// Find Horizontal and Forwards Sphere Vectors
						var temp_cloud_sphere_horizontal_radius = sqrt(1.0 - temp_cloud_y_value * temp_cloud_y_value);
						var temp_cloud_x_value = temp_cloud_sphere_horizontal_radius * -sin(temp_cloud_atan_value);
						var temp_cloud_z_value = temp_cloud_sphere_horizontal_radius * -cos(temp_cloud_atan_value);
						
						//
						var temp_cloud_x = temp_cloud_height * (temp_cloud_x_value * temp_planet_rotation_matrix[0] + temp_cloud_y_value * temp_planet_rotation_matrix[1] + temp_cloud_z_value * temp_planet_rotation_matrix[2]) + temp_celestial_object_instance.x;
						var temp_cloud_y = temp_cloud_height * (temp_cloud_x_value * temp_planet_rotation_matrix[4] + temp_cloud_y_value * temp_planet_rotation_matrix[5] + temp_cloud_z_value * temp_planet_rotation_matrix[6]) + temp_celestial_object_instance.y;
						var temp_cloud_z = temp_cloud_height * (temp_cloud_x_value * temp_planet_rotation_matrix[8] + temp_cloud_y_value * temp_planet_rotation_matrix[9] + temp_cloud_z_value * temp_planet_rotation_matrix[10]) + temp_celestial_object_instance.z;
						
						//
						var temp_cloud_vx = temp_cloud_x - temp_render_start_x;
						var temp_cloud_vy = temp_cloud_y - temp_render_start_y;
						var temp_cloud_vz = temp_cloud_z - temp_render_start_z;
						
						//
						var temp_cloud_depth = dot_product_3d(temp_cloud_vx, temp_cloud_vy, temp_cloud_vz, temp_dx, temp_dy, temp_dz) / temp_dm;
						
						// Iterate through Planet's Cloud Depth Sorting List to Sort and Index Cloud by Depth
						if (ds_list_size(temp_celestial_object_instance.clouds_depth_list) == 0)
						{
							// Index Cloud Depth and Index into Planet's Cloud Depth Sorting Lists
							ds_list_add(temp_celestial_object_instance.clouds_depth_list, temp_cloud_depth);
							ds_list_add(temp_celestial_object_instance.clouds_render_list, temp_cloud_index);
						}
						else
						{
							// Establish Toggle if Celestial Object was Indexed
							var temp_cloud_depth_is_indexed = false;
							
							// Iterate through Solar System Depth Sorting List
							for (var q = 0; q < ds_list_size(temp_celestial_object_instance.clouds_depth_list); q++)
							{
								// Find Solar System Depth Sorting List's Celestial Object Depth for Comparison
								var temp_cloud_depth_comparison = ds_list_find_value(temp_celestial_object_instance.clouds_depth_list, q);
								
								// Compare Depth Values
								if (temp_cloud_depth >= temp_cloud_depth_comparison)
								{
									// Index Celestial Object Depth and Instance into Solar System Depth Sorting Lists
									ds_list_insert(temp_celestial_object_instance.clouds_depth_list, q, temp_cloud_depth);
									ds_list_insert(temp_celestial_object_instance.clouds_render_list, q, temp_cloud_index);
									
									// Toggle Celestial Object was Indexed and Break Loop
									temp_cloud_depth_is_indexed = true;
									break;
								}
							}
							
							// Check if Celestial Object was Indexed
							if (!temp_cloud_depth_is_indexed)
							{
								// Index Celestial Object Depth and Instance into Solar System Depth Sorting Lists
								ds_list_add(temp_celestial_object_instance.clouds_depth_list, temp_cloud_depth);
								ds_list_add(temp_celestial_object_instance.clouds_render_list, temp_cloud_index);
							}
						}
					}
					
					// Increment Cloud Index
					temp_cloud_index++;
				}
			}
			break;
		default:
			// Skip Celestial Object Depth Sorting Behaviour
			break;
	}
	
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