/// @description Celestial Object Depth Sorting Event
// Celestial Simulator Object Depth Sorting Behaviour for Rendering Pipeline

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Clear Celestial Simulator Solar System Depth Sorting Arrays
if (array_length(solar_system_render_depth_sorting_index_array) > 0)
{
	array_clear(solar_system_render_depth_sorting_index_array);
}

if (array_length(solar_system_render_depth_sorting_depth_array) > 0)
{
	array_clear(solar_system_render_depth_sorting_depth_array);
}

// Check if Solar System exists and is being viewed
if (solar_system_index == -1)
{
	// Not currently viewing a Solar System - Early Return
	return;
}

// Establish Solar System from Solar Systems Array
var temp_solar_system = solar_systems[solar_system_index];

// Establish Camera Frustum Culling Variables
var temp_camera_aspect = GameManager.game_width / GameManager.game_height;

var temp_camera_fov_radians = (camera_fov * pi) / 180;
var temp_camera_half_v = tan(temp_camera_fov_radians / 2);
var temp_camera_half_h = temp_camera_half_v * temp_camera_aspect;

// Establish Camera Vectors from Camera's Rotation Matrix
var temp_camera_right_vector_magnitude = sqrt(dot_product_3d(camera_rotation_matrix[0], camera_rotation_matrix[1], camera_rotation_matrix[2], camera_rotation_matrix[0], camera_rotation_matrix[1], camera_rotation_matrix[2]));
var temp_camera_right_vector_normalized = [ camera_rotation_matrix[0] / temp_camera_right_vector_magnitude, camera_rotation_matrix[1] / temp_camera_right_vector_magnitude, camera_rotation_matrix[2] / temp_camera_right_vector_magnitude ];

var temp_camera_up_vector_magnitude = sqrt(dot_product_3d(camera_rotation_matrix[4], camera_rotation_matrix[5], camera_rotation_matrix[6], camera_rotation_matrix[4], camera_rotation_matrix[5], camera_rotation_matrix[6]));
var temp_camera_up_vector_normalized = [ camera_rotation_matrix[4] / temp_camera_up_vector_magnitude, camera_rotation_matrix[5] / temp_camera_up_vector_magnitude, camera_rotation_matrix[6] / temp_camera_up_vector_magnitude ];

var temp_camera_forward_vector_magnitude = sqrt(dot_product_3d(camera_rotation_matrix[8], camera_rotation_matrix[9], camera_rotation_matrix[10], camera_rotation_matrix[8], camera_rotation_matrix[9], camera_rotation_matrix[10]));
var temp_camera_forward_vector_normalized = [ camera_rotation_matrix[8] / temp_camera_forward_vector_magnitude, camera_rotation_matrix[9] / temp_camera_forward_vector_magnitude, camera_rotation_matrix[10] / temp_camera_forward_vector_magnitude ];

// Create Camera Render Near and Far Positions
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
	
	// Index Celestial Object's Depth into Celestial Simulator's Render Depth Sorting Arrays
	array_push(solar_system_render_depth_sorting_depth_array, temp_celestial_object_depth);
	
	// Celestial Object Frustum Culling Behaviour
	if (temp_celestial_object_instance.frustum_culling)
	{
		// Establish Celestial Object Frustum Culling Radius
		var temp_frustum_culling_radius = temp_celestial_object_instance.frustum_culling_radius;
		
		// Celestial Object Frustum Depth Culling
		if (temp_celestial_object_depth + temp_frustum_culling_radius < camera_z_near)
		{
			// Increment Celestial Object Index
			temp_celestial_object_index++;
			
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
		var temp_camera_frustum_half_width = temp_camera_half_h * temp_camera_forward_to_object_dot_product * 2;
		
		if (temp_camera_right_to_object_dot_product < -temp_camera_frustum_half_width - temp_frustum_culling_radius or temp_camera_right_to_object_dot_product > temp_camera_frustum_half_width + temp_frustum_culling_radius) 
		{
			// Increment Celestial Object Index
			temp_celestial_object_index++;
			
			// Celestial Object Frustum Culled - Skip Celestial Object
			continue;
		}
		
		// Check if Celestial Object can be Vertically Frustum Culled
		var temp_camera_frustum_half_height = temp_camera_half_v * temp_camera_forward_to_object_dot_product * 2;
		
		if (temp_camera_up_to_object_dot_product < -temp_camera_frustum_half_height - temp_frustum_culling_radius or temp_camera_up_to_object_dot_product > temp_camera_frustum_half_height + temp_frustum_culling_radius) 
		{
			// Increment Celestial Object Index
			temp_celestial_object_index++;
			
			// Celestial Object Frustum Culled - Skip Celestial Object
			continue;
		}
	}
	
	// Celestial Object Type Depth Sorting Behaviour
	switch (temp_celestial_object_instance.celestial_object_type)
	{
		case CelestialObjectType.Planet:
			// Planet Depth Sorting Behaviour
			if (temp_celestial_object_instance.clouds)
			{
				// Reset Celestial Simulator Clouds Render Depth Sorting Arrays
				array_clear(CelestialSimulator.clouds_render_depth_sorting_index_array);
				array_clear(CelestialSimulator.clouds_render_depth_sorting_depth_array);
				
				// Reset Planet Cloud Depth Sorted Index Array
				array_clear(temp_celestial_object_instance.clouds_index_array);
				
				// Reset Planet Cloud Rendering Lists
				ds_list_clear(temp_celestial_object_instance.clouds_render_u_list);
				ds_list_clear(temp_celestial_object_instance.clouds_render_v_list);
				ds_list_clear(temp_celestial_object_instance.clouds_render_height_list);
				ds_list_clear(temp_celestial_object_instance.clouds_render_radius_list);
				ds_list_clear(temp_celestial_object_instance.clouds_render_density_list);
				ds_list_clear(temp_celestial_object_instance.clouds_render_absorption_list);
				
				// Create Planet's Rotation Matrix and Inverse Rotation Matrix from its local Euler Angle Rotation
				var temp_planet_rotation_matrix = rotation_matrix_from_euler_angles(temp_celestial_object_instance.euler_angle_x, temp_celestial_object_instance.euler_angle_y, temp_celestial_object_instance.euler_angle_z);
				var temp_planet_rotation_matrix_inverse = matrix_inverse(temp_planet_rotation_matrix);
				
				// Iterate through Planet's Clouds
				var temp_cloud_count = 0;
				var temp_cloud_index = 0;
				
				repeat (ds_list_size(temp_celestial_object_instance.clouds_density_list))
				{
					// Find Cloud's Density
					var temp_cloud_density = ds_list_find_value(temp_celestial_object_instance.clouds_density_list, temp_cloud_index);
					
					// Check if Cloud is Active
					if (temp_cloud_density > 0)
					{
						// Find Cloud's Absorption
						var temp_cloud_absorption = ds_list_find_value(temp_celestial_object_instance.clouds_absorption_list, temp_cloud_index);
						
						// Find Cloud Height
						var temp_cloud_height = ds_list_find_value(temp_celestial_object_instance.clouds_position_height_list, temp_cloud_index);
						
						// Find Cloud Sphere UV
						var temp_cloud_u = ds_list_find_value(temp_celestial_object_instance.clouds_position_u_list, temp_cloud_index);
						var temp_cloud_v = ds_list_find_value(temp_celestial_object_instance.clouds_position_v_list, temp_cloud_index);
						
						// Find Cloud Group's Individual Cloud Properties nested DS Lists
						var temp_cloud_group_radius_list = ds_list_find_value(temp_celestial_object_instance.clouds_group_radius_list, temp_cloud_index);
						var temp_cloud_group_height_list = ds_list_find_value(temp_celestial_object_instance.clouds_group_height_list, temp_cloud_index);
						var temp_cloud_group_bearing_list = ds_list_find_value(temp_celestial_object_instance.clouds_group_bearing_list, temp_cloud_index);
						var temp_cloud_group_distance_list = ds_list_find_value(temp_celestial_object_instance.clouds_group_distance_list, temp_cloud_index);
						
						// Iterate through Cloud Group's Individual Clouds
						var temp_cloud_individual_index = 0;
						
						repeat (ds_list_size(temp_cloud_group_radius_list))
						{
							// Find Individual Cloud's Properties from nested DS Lists
							var temp_cloud_individual_radius = ds_list_find_value(temp_cloud_group_radius_list, temp_cloud_individual_index);
							var temp_cloud_individual_height = temp_cloud_height + ds_list_find_value(temp_cloud_group_height_list, temp_cloud_individual_index);
							var temp_cloud_individual_bearing = ds_list_find_value(temp_cloud_group_bearing_list, temp_cloud_individual_index);
							var temp_cloud_individual_distance = ds_list_find_value(temp_cloud_group_distance_list, temp_cloud_individual_index);
							
							// Find Individual Cloud's UV from Cloud Group's Origin UV Position
							var temp_cloud_individual_uv_offset = haversine_distance_uv_offset(temp_cloud_u, temp_cloud_v, temp_cloud_individual_bearing, temp_cloud_individual_distance, temp_celestial_object_instance.radius);
							var temp_cloud_individual_u = temp_cloud_u + temp_cloud_individual_uv_offset[0];
							var temp_cloud_individual_v = temp_cloud_v + temp_cloud_individual_uv_offset[1];
							
							// Find Vertical Sphere Vector
							var temp_cloud_atan_value = (0.5 - temp_cloud_individual_u) * 2 * pi;
							var temp_cloud_asin_value = (0.5 - temp_cloud_individual_v) * pi;
							var temp_cloud_y_value = -sin(temp_cloud_asin_value);
							
							// Find Horizontal and Forwards Sphere Vectors
							var temp_cloud_sphere_horizontal_radius = sqrt(1.0 - temp_cloud_y_value * temp_cloud_y_value);
							var temp_cloud_x_value = temp_cloud_sphere_horizontal_radius * -sin(temp_cloud_atan_value);
							var temp_cloud_z_value = temp_cloud_sphere_horizontal_radius * -cos(temp_cloud_atan_value);
							
							// Find Individual Cloud's Position in World Space
							var temp_cloud_adjusted_height = temp_celestial_object_instance.radius + temp_cloud_individual_height;
							
							var temp_cloud_x = temp_cloud_adjusted_height * (temp_cloud_x_value * temp_planet_rotation_matrix_inverse[0] + temp_cloud_y_value * temp_planet_rotation_matrix_inverse[1] + temp_cloud_z_value * temp_planet_rotation_matrix_inverse[2]) + temp_celestial_object_instance.x;
							var temp_cloud_y = temp_cloud_adjusted_height * (temp_cloud_x_value * temp_planet_rotation_matrix_inverse[4] + temp_cloud_y_value * temp_planet_rotation_matrix_inverse[5] + temp_cloud_z_value * temp_planet_rotation_matrix_inverse[6]) + temp_celestial_object_instance.y;
							var temp_cloud_z = temp_cloud_adjusted_height * (temp_cloud_x_value * temp_planet_rotation_matrix_inverse[8] + temp_cloud_y_value * temp_planet_rotation_matrix_inverse[9] + temp_cloud_z_value * temp_planet_rotation_matrix_inverse[10]) + temp_celestial_object_instance.z;
							
							// Find Individual Cloud's Depth from Render Camera
							var temp_cloud_vx = temp_cloud_x - temp_render_start_x;
							var temp_cloud_vy = temp_cloud_y - temp_render_start_y;
							var temp_cloud_vz = temp_cloud_z - temp_render_start_z;
							
							var temp_cloud_depth = dot_product_3d(temp_cloud_vx, temp_cloud_vy, temp_cloud_vz, temp_dx, temp_dy, temp_dz) / temp_dm;
							
							// Index Cloud's Index and Depth into Planet's Cloud Depth Sorting Arrays
							array_push(CelestialSimulator.clouds_render_depth_sorting_index_array, temp_cloud_count);
							array_push(CelestialSimulator.clouds_render_depth_sorting_depth_array, temp_cloud_depth);
							
							// Index Cloud's Properties into Planet's Cloud Render Properties Lists
							ds_list_add(temp_celestial_object_instance.clouds_render_u_list, temp_cloud_individual_u);
							ds_list_add(temp_celestial_object_instance.clouds_render_v_list, temp_cloud_individual_v);
							ds_list_add(temp_celestial_object_instance.clouds_render_height_list, temp_cloud_individual_height);
							ds_list_add(temp_celestial_object_instance.clouds_render_radius_list, temp_cloud_individual_radius);
							ds_list_add(temp_celestial_object_instance.clouds_render_density_list, temp_cloud_density);
							ds_list_add(temp_celestial_object_instance.clouds_render_absorption_list, temp_cloud_absorption);
							
							// Increment Individual Cloud Index
							temp_cloud_individual_index++;
							
							// Increment Cloud Count
							temp_cloud_count++;
						}
					}
					
					// Increment Cloud Index
					temp_cloud_index++;
				}
				
				// Sort Celestial Simulator's Clouds Render Depth Sorting Array
				array_sort(CelestialSimulator.clouds_render_depth_sorting_index_array, clouds_render_depth_sort);
				
				// Copy Depth Sorted Cloud Index Order to Planet's Cloud Index Array
				array_copy(temp_celestial_object_instance.clouds_index_array, 0, CelestialSimulator.clouds_render_depth_sorting_index_array, 0, temp_cloud_count);
			}
			break;
		default:
			// Skip Celestial Object Depth Sorting Behaviour
			break;
	}
	
	// Index Celestial Object's Index into Celestial Simulator's Render Depth Sorting Arrays
	array_push(solar_system_render_depth_sorting_index_array, temp_celestial_object_index);
	
	// Increment Celestial Object Index
	temp_celestial_object_index++;
}

// Check if Celestial Simulator's Solar System Render Depth Sorting Array contains any entries
if (array_length(solar_system_render_depth_sorting_index_array) > 0)
{
	// Sort Celestial Simulator's Solar System Render Depth Sorting Array
	array_sort(solar_system_render_depth_sorting_index_array, solar_system_render_depth_sort);
}