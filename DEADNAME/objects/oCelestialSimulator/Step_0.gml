/// @description Camera & Depth Sorting Event
// Calculates the Camera Matricies used for 3D Object View and Projection while performing the Celestial Simulator's Object Depth Sorting Behaviour for the Rendering Pipeline in the active Solar System being viewed

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Clear Celestial Simulator Solar System Depth Sorting Arrays
array_resize(solar_system_render_depth_sorting_index_array, 0);
array_resize(solar_system_render_depth_sorting_depth_array, 0);

// Check if Solar System exists and is being viewed
if (solar_system_index == -1)
{
	// Not currently viewing a Solar System - Early Return
	return;
}

// Establish Solar System from Solar Systems Array
var temp_solar_system = solar_systems[solar_system_index];

// Solar System's Camera Observation Behaviour - Establish Camera Position, Rotation, & View Matrix
if (instance_exists(camera_observing_instance))
{
	// Perform Camera Observing Instance's Zoom In & Zoom Out Behaviour
	if (mouse_wheel_up())
	{
		// Zoom In Effect
		camera_observing_instance_radius_offset_value -= camera_observing_instance_zoom_spd * frame_delta;
		camera_observing_instance_radius_offset_value = clamp(camera_observing_instance_radius_offset_value, 0, 1);
	}
	else if (mouse_wheel_down())
	{
		// Zoom Out Effect
		camera_observing_instance_radius_offset_value += camera_observing_instance_zoom_spd * frame_delta;
		camera_observing_instance_radius_offset_value = clamp(camera_observing_instance_radius_offset_value, 0, 1);
	}
	
	// Perform Camera Observing Instance's Click Drag Behaviour
	if (camera_observing_drag)
	{
		var temp_camera_observing_instance_drag_spd = lerp(camera_observing_instance_drag_spd_min, camera_observing_instance_drag_spd_max, camera_observing_instance_radius_offset_value);
		camera_observing_polar_horizontal_angle = camera_observing_drag_polar_horizontal_angle + (camera_observing_drag_start_x - GameManager.cursor_x) * temp_camera_observing_instance_drag_spd;
		camera_observing_polar_vertical_angle = camera_observing_drag_polar_vertical_angle + (GameManager.cursor_y - camera_observing_drag_start_y) * temp_camera_observing_instance_drag_spd;
	}
	
	// Establish Camera Observing Instance Default Observation Behaviour Variables
	var temp_camera_observing_instance_radius = 0;
	
	var temp_camera_observing_instance_radius_min = 150;
	var temp_camera_observing_instance_radius_max = 600;
	
	// Find Camera Celestial Object Observing Instance's Observation Behaviour Variables
	switch (camera_observing_instance.celestial_object_type)
	{
		case CelestialObjectType.Sun:
			temp_camera_observing_instance_radius = camera_observing_instance.radius;
		case CelestialObjectType.Planet:
			temp_camera_observing_instance_radius = camera_observing_instance.radius + camera_observing_instance.elevation;
			break;
		default:
			break;
	}
	
	// Calculate Camera Observing Radius Offset from Offset Value for Zoom In/Out Effect
	var temp_camera_observing_vector_length_offset = lerp(temp_camera_observing_instance_radius_min, temp_camera_observing_instance_radius_max, camera_observing_instance_radius_offset_value);
	
	// Apply Horizontal Wrap and Vertical Clamp to Camera Observing Polar Direction Angles
	camera_observing_polar_horizontal_angle = ((camera_observing_polar_horizontal_angle mod 360) + 360) mod 360;
	camera_observing_polar_vertical_angle = clamp(camera_observing_polar_vertical_angle, -89.5, 89.5);
	
	// Calculate Camera Observation Vector from Camera Observing Polar Direction Angles
	var temp_observing_vector_x = dcos(camera_observing_polar_vertical_angle) * dcos(camera_observing_polar_horizontal_angle);
	var temp_observing_vector_y = dsin(camera_observing_polar_vertical_angle);
	var temp_observing_vector_z = dcos(camera_observing_polar_vertical_angle) * dsin(camera_observing_polar_horizontal_angle);
	
	// Calculate Camera Observing Instance's Rotation Matrices
	var temp_observing_rotation_matrix = rotation_matrix_from_euler_angles(camera_observing_instance.euler_angle_x, camera_observing_instance.euler_angle_y, camera_observing_instance.euler_angle_z);
	
	// Rotate Camera Observation Vector by the Camera Observing Instance's Rotation Matrices
	var temp_observing_rotated_vector_x = temp_observing_vector_x * temp_observing_rotation_matrix[0] + temp_observing_vector_y * temp_observing_rotation_matrix[4] + temp_observing_vector_z * temp_observing_rotation_matrix[8];
	var temp_observing_rotated_vector_y = temp_observing_vector_x * temp_observing_rotation_matrix[1] + temp_observing_vector_y * temp_observing_rotation_matrix[5] + temp_observing_vector_z * temp_observing_rotation_matrix[9];
	var temp_observing_rotated_vector_z = temp_observing_vector_x * temp_observing_rotation_matrix[2] + temp_observing_vector_y * temp_observing_rotation_matrix[6] + temp_observing_vector_z * temp_observing_rotation_matrix[10];
	
	// Set Camera Position relative to Camera's Observing Instance
	camera_position_x = camera_observing_instance.x + temp_observing_rotated_vector_x * (temp_camera_observing_instance_radius + temp_camera_observing_vector_length_offset);
	camera_position_y = camera_observing_instance.y + temp_observing_rotated_vector_y * (temp_camera_observing_instance_radius + temp_camera_observing_vector_length_offset);
	camera_position_z = camera_observing_instance.z + temp_observing_rotated_vector_z * (temp_camera_observing_instance_radius + temp_camera_observing_vector_length_offset);
	
	// Build Camera Rotation Matrix from Observation Direction and Up Direction relative to the Camera Observing Instance as that the Camera is vertically aligned with the Camera Observing Instance's Poles and will horizontally wrap around the Camera Observing Instance
	matrix_build_lookat(camera_position_x, camera_position_y, camera_position_z, camera_observing_instance.x, camera_observing_instance.y, camera_observing_instance.z, temp_observing_rotation_matrix[4], temp_observing_rotation_matrix[5], temp_observing_rotation_matrix[6], camera_view_matrix);
	
	// Delete Unused Array
	array_resize(temp_observing_rotation_matrix, 0);
}
else
{
	// Reset Camera Observation Settings
	camera_observing_instance = noone;
	
	camera_observing_polar_horizontal_angle = 0;
	camera_observing_polar_vertical_angle = 0;
	
	// DEBUG KEYBOARD CONTROLS
	var temp_camera_move_spd = 2;
	
	if (keyboard_check(ord("A")))
	{
		camera_position_x -= temp_camera_move_spd * frame_delta;
	}
	else if (keyboard_check(ord("D")))
	{
		camera_position_x += temp_camera_move_spd * frame_delta;
	}
	
	if (keyboard_check(ord("W")))
	{
		camera_position_z += temp_camera_move_spd * frame_delta;
	}
	else if (keyboard_check(ord("S")))
	{
		camera_position_z -= temp_camera_move_spd * frame_delta;
	}
	
	if (keyboard_check(vk_space))
	{
		camera_position_y += temp_camera_move_spd * frame_delta;
	}
	else if (keyboard_check(vk_lcontrol))
	{
		camera_position_y -= temp_camera_move_spd * frame_delta;
	}
	
	//
	look_dir -= (window_mouse_get_x() - window_get_width() / 2) / 10;
    look_pitch -= (window_mouse_get_y() - window_get_height() / 2) / 10;
    look_pitch = clamp(look_pitch, 10, 80);

    window_mouse_set(window_get_width() / 2, window_get_height() / 2);
	
	var camera_distance = 160;
	var xto = camera_position_x;
	var yto = camera_position_y;
	var zto = camera_position_z;
	var xfrom = xto - camera_distance * dsin(look_dir);
	var yfrom = yto + camera_distance * dsin(look_pitch);
	var zfrom = zto + camera_distance * dcos(look_dir);
	
	matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 1, 0, camera_view_matrix);
	
	if (keyboard_check(vk_escape))
	{
		game_end();
	}
}

// Establish Perspective Camera Projection Matrix
matrix_build_projection_perspective_fov(-camera_fov, -GameManager.game_width / GameManager.game_height, camera_z_near, camera_z_far, camera_projection_matrix);

// Establish Camera Aspect & Perspective FOV Variables for Frustum Culling Behaviour
var temp_camera_aspect = GameManager.game_width / GameManager.game_height;

var temp_camera_fov_radians = (camera_fov * pi) / 180;
var temp_camera_half_v = tan(temp_camera_fov_radians / 2);
var temp_camera_half_h = temp_camera_half_v * temp_camera_aspect;

// Establish Camera Vectors from Camera's Rotation Matrix
var temp_camera_right_vector_magnitude = sqrt(dot_product_3d(camera_view_matrix[0], camera_view_matrix[4], camera_view_matrix[8], camera_view_matrix[0], camera_view_matrix[4], camera_view_matrix[8]));
var temp_camera_right_vector_normalized = [ camera_view_matrix[0] / temp_camera_right_vector_magnitude, camera_view_matrix[4] / temp_camera_right_vector_magnitude, camera_view_matrix[8] / temp_camera_right_vector_magnitude ];

var temp_camera_up_vector_magnitude = sqrt(dot_product_3d(camera_view_matrix[1], camera_view_matrix[5], camera_view_matrix[9], camera_view_matrix[1], camera_view_matrix[5], camera_view_matrix[9]));
var temp_camera_up_vector_normalized = [ camera_view_matrix[1] / temp_camera_up_vector_magnitude, camera_view_matrix[5] / temp_camera_up_vector_magnitude, camera_view_matrix[9] / temp_camera_up_vector_magnitude ];

var temp_camera_forward_vector_magnitude = sqrt(dot_product_3d(camera_view_matrix[2], camera_view_matrix[6], camera_view_matrix[10], camera_view_matrix[2], camera_view_matrix[6], camera_view_matrix[10]));
var temp_camera_forward_vector_normalized = [ camera_view_matrix[2] / temp_camera_forward_vector_magnitude, camera_view_matrix[6] / temp_camera_forward_vector_magnitude, camera_view_matrix[10] / temp_camera_forward_vector_magnitude ];

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
	
	// Create Celestial Object's Rotation Matrix and Inverse Rotation Matrix from its local Euler Angle Rotation
	var temp_celestial_obj_rotation_matrix = rotation_matrix_from_euler_angles(temp_celestial_object_instance.euler_angle_x, temp_celestial_object_instance.euler_angle_y, temp_celestial_object_instance.euler_angle_z);
	
	// Reset Celestial Object's Render Object Layers Toggle
	temp_celestial_object_instance.render_objects_enabled = false;
	
	// Check if Celestial Object is eligible to have its Render Object Layers Enabled
	if (temp_celestial_object_instance == camera_observing_instance)
	{
		// Celestial Object is being Inspected - Render Object Layers Enabled
		temp_celestial_object_instance.render_objects_enabled = true;
		
		// Celestial Object Inspection UI Precalculation Behaviour
		if (instance_exists(render_object_selected_instance))
		{
			// Perform Selected Render Object's UI Precalculation Behaviour based on Selected Render Object's Type
			switch (render_object_selected_instance.celestial_render_object_type)
			{
				case CelestialRenderObjectType.Unit:
					// Unit Pathfinding UI Precalculation Behaviour
					if (temp_celestial_object_instance.pathfinding_enabled and !is_undefined(render_object_selected_instance.pathfinding_path))
					{
						// Clear Selected Unit Movement Path UI Arrays
						if (selected_unit_movement_path_entries > 0)
						{
							array_resize(selected_unit_movement_path_depth_sorting_index_array, 0);
							array_resize(selected_unit_movement_path_depth_sorting_depth_array, 0);
							array_resize(selected_unit_movement_path_point_a_position_x_array, 0);
							array_resize(selected_unit_movement_path_point_a_position_y_array, 0);
							array_resize(selected_unit_movement_path_point_a_alpha_array, 0);
							array_resize(selected_unit_movement_path_point_b_position_x_array, 0);
							array_resize(selected_unit_movement_path_point_b_position_y_array, 0);
							array_resize(selected_unit_movement_path_point_b_alpha_array, 0);
						}
						
						// Reset Selected Unit Movement Path UI Entries Count
						selected_unit_movement_path_entries = 0;
						
						// Iterate through Selected Render Object Unit's Pathfinding Path Array to create Path UI
						var temp_selected_unit_pathfinding_path_index = 0;
						
						repeat (ds_list_size(render_object_selected_instance.pathfinding_path) - 1)
						{
							// Check if Selected Unit has progressed past the given Pathfinding Path Index
							if (render_object_selected_instance.pathfinding_path_index > temp_selected_unit_pathfinding_path_index)
							{
								// Increment Selected Unit's Pathfinding Path Index
								temp_selected_unit_pathfinding_path_index++;
								continue;
							}
							
							// Find Selected Unit's Pathfinding Path Node Indexes
							var temp_selected_unit_path_node_a_index = ds_list_find_value(render_object_selected_instance.pathfinding_path, temp_selected_unit_pathfinding_path_index);
							var temp_selected_unit_path_node_b_index = ds_list_find_value(render_object_selected_instance.pathfinding_path, temp_selected_unit_pathfinding_path_index + 1);
							
							// Find Selected Unit's Pathfinding Path Node Positions & Elevations
							var temp_ui_path_a_local_x = temp_celestial_object_instance.pathfinding_node_x_array[temp_selected_unit_path_node_a_index];
							var temp_ui_path_a_local_y = temp_celestial_object_instance.pathfinding_node_y_array[temp_selected_unit_path_node_a_index];
							var temp_ui_path_a_local_z = temp_celestial_object_instance.pathfinding_node_z_array[temp_selected_unit_path_node_a_index];
							
							var temp_ui_path_a_local_elevation = temp_celestial_object_instance.pathfinding_node_elevation_array[temp_selected_unit_path_node_a_index];
							
							var temp_ui_path_b_local_x = temp_celestial_object_instance.pathfinding_node_x_array[temp_selected_unit_path_node_b_index];
							var temp_ui_path_b_local_y = temp_celestial_object_instance.pathfinding_node_y_array[temp_selected_unit_path_node_b_index];
							var temp_ui_path_b_local_z = temp_celestial_object_instance.pathfinding_node_z_array[temp_selected_unit_path_node_b_index];
							
							var temp_ui_path_b_local_elevation = temp_celestial_object_instance.pathfinding_node_elevation_array[temp_selected_unit_path_node_b_index];
							
							// Check if Selected Unit is currently traversing the given Pathfinding Path Index
							if (render_object_selected_instance.pathfinding_path_index == temp_selected_unit_pathfinding_path_index)
							{
								// Find Celestial Unit's Normalized Local Vector and Elevation from Celestial Body's Sphere Center with their precalculated positioning variables from their Pathfinding Behaviour
								temp_ui_path_a_local_x = render_object_selected_instance.pathfinding_position_x;
								temp_ui_path_a_local_y = render_object_selected_instance.pathfinding_position_y;
								temp_ui_path_a_local_z = render_object_selected_instance.pathfinding_position_z;
								temp_ui_path_a_local_elevation = render_object_selected_instance.pathfinding_position_elevation;
							}
							
							// Find Selected Unit's Pathfinding Path World Positions
							if (temp_celestial_object_instance.celestial_object_type == CelestialObjectType.Planet)
							{
								// If the Celestial Object is a Planet, the Elevation must be equal to or higher than the Planet's Ocean Elevation Value
								temp_ui_path_a_local_elevation = max(temp_ui_path_a_local_elevation, temp_celestial_object_instance.ocean_elevation);
								temp_ui_path_b_local_elevation = max(temp_ui_path_b_local_elevation, temp_celestial_object_instance.ocean_elevation);
							}
							
							var temp_ui_path_a_elevation = temp_celestial_object_instance.radius + (temp_ui_path_a_local_elevation * temp_celestial_object_instance.elevation);
							var temp_ui_path_b_elevation = temp_celestial_object_instance.radius + (temp_ui_path_b_local_elevation * temp_celestial_object_instance.elevation);
							
							var temp_ui_path_a_world_position_x = temp_ui_path_a_elevation * (temp_ui_path_a_local_x * temp_celestial_obj_rotation_matrix[0] + temp_ui_path_a_local_y * temp_celestial_obj_rotation_matrix[4] + temp_ui_path_a_local_z * temp_celestial_obj_rotation_matrix[8]);
							var temp_ui_path_a_world_position_y = temp_ui_path_a_elevation * (temp_ui_path_a_local_x * temp_celestial_obj_rotation_matrix[1] + temp_ui_path_a_local_y * temp_celestial_obj_rotation_matrix[5] + temp_ui_path_a_local_z * temp_celestial_obj_rotation_matrix[9]);
							var temp_ui_path_a_world_position_z = temp_ui_path_a_elevation * (temp_ui_path_a_local_x * temp_celestial_obj_rotation_matrix[2] + temp_ui_path_a_local_y * temp_celestial_obj_rotation_matrix[6] + temp_ui_path_a_local_z * temp_celestial_obj_rotation_matrix[10]);
							
							var temp_ui_path_b_world_position_x = temp_ui_path_b_elevation * (temp_ui_path_b_local_x * temp_celestial_obj_rotation_matrix[0] + temp_ui_path_b_local_y * temp_celestial_obj_rotation_matrix[4] + temp_ui_path_b_local_z * temp_celestial_obj_rotation_matrix[8]);
							var temp_ui_path_b_world_position_y = temp_ui_path_b_elevation * (temp_ui_path_b_local_x * temp_celestial_obj_rotation_matrix[1] + temp_ui_path_b_local_y * temp_celestial_obj_rotation_matrix[5] + temp_ui_path_b_local_z * temp_celestial_obj_rotation_matrix[9]);
							var temp_ui_path_b_world_position_z = temp_ui_path_b_elevation * (temp_ui_path_b_local_x * temp_celestial_obj_rotation_matrix[2] + temp_ui_path_b_local_y * temp_celestial_obj_rotation_matrix[6] + temp_ui_path_b_local_z * temp_celestial_obj_rotation_matrix[10]);
							
							temp_ui_path_a_world_position_x += temp_celestial_object_instance.x;
							temp_ui_path_a_world_position_y += temp_celestial_object_instance.y;
							temp_ui_path_a_world_position_z += temp_celestial_object_instance.z;
							
							temp_ui_path_b_world_position_x += temp_celestial_object_instance.x;
							temp_ui_path_b_world_position_y += temp_celestial_object_instance.y;
							temp_ui_path_b_world_position_z += temp_celestial_object_instance.z;
							
							// Find Selected Unit's Pathfinding Path Screen Positions
							var temp_ui_path_a_screen_position = world_position_to_screen_position(temp_ui_path_a_world_position_x, temp_ui_path_a_world_position_y, temp_ui_path_a_world_position_z, camera_view_matrix, camera_projection_matrix);
							var temp_ui_path_b_screen_position = world_position_to_screen_position(temp_ui_path_b_world_position_x, temp_ui_path_b_world_position_y, temp_ui_path_b_world_position_z, camera_view_matrix, camera_projection_matrix);
							
							// Find Selected Unit's Pathfinding Path Depths from Render Camera
							var temp_ui_path_a_vx = temp_ui_path_a_world_position_x - temp_render_start_x;
							var temp_ui_path_a_vy = temp_ui_path_a_world_position_y - temp_render_start_y;
							var temp_ui_path_a_vz = temp_ui_path_a_world_position_z - temp_render_start_z;
							
							var temp_ui_path_a_projection_scalar = dot_product_3d(temp_ui_path_a_vx, temp_ui_path_a_vy, temp_ui_path_a_vz, temp_dx, temp_dy, temp_dz) / temp_dm;
							var temp_ui_path_a_depth = lerp(camera_z_near + camera_z_near_depth_overpass, camera_z_far, temp_ui_path_a_projection_scalar) - temp_celestial_object_depth;
							
							var temp_ui_path_b_vx = temp_ui_path_b_world_position_x - temp_render_start_x;
							var temp_ui_path_b_vy = temp_ui_path_b_world_position_y - temp_render_start_y;
							var temp_ui_path_b_vz = temp_ui_path_b_world_position_z - temp_render_start_z;
							
							var temp_ui_path_b_projection_scalar = dot_product_3d(temp_ui_path_b_vx, temp_ui_path_b_vy, temp_ui_path_b_vz, temp_dx, temp_dy, temp_dz) / temp_dm;
							var temp_ui_path_b_depth = lerp(camera_z_near + camera_z_near_depth_overpass, camera_z_far, temp_ui_path_b_projection_scalar) - temp_celestial_object_depth;
							
							// Calculate Selected Unit's Pathfinding Path Alpha Transparencies
							var temp_ui_path_point_a_alpha = inverse_lerp(temp_celestial_object_instance.render_depth_radius * global_render_path_depth_transparent_end, temp_celestial_object_instance.render_depth_radius * global_render_path_depth_transparent_start, temp_ui_path_a_depth);
							var temp_ui_path_point_b_alpha = inverse_lerp(temp_celestial_object_instance.render_depth_radius * global_render_path_depth_transparent_end, temp_celestial_object_instance.render_depth_radius * global_render_path_depth_transparent_start, temp_ui_path_b_depth);
							
							// Index Selected Unit's Movement Path UI Depth Sorting Entry Data
							array_push(selected_unit_movement_path_depth_sorting_index_array, selected_unit_movement_path_entries);
							array_push(selected_unit_movement_path_depth_sorting_depth_array, lerp(temp_ui_path_a_depth, temp_ui_path_b_depth, 0.5));
							
							// Index Selected Unit's Movement Path UI Point Positions
							array_push(selected_unit_movement_path_point_a_position_x_array, temp_ui_path_a_screen_position[0]);
							array_push(selected_unit_movement_path_point_a_position_y_array, temp_ui_path_a_screen_position[1]);
							
							array_push(selected_unit_movement_path_point_b_position_x_array, temp_ui_path_b_screen_position[0]);
							array_push(selected_unit_movement_path_point_b_position_y_array, temp_ui_path_b_screen_position[1]);
							
							// Index Selected Unit's Movement Path UI Point Alpha Transparencies
							array_push(selected_unit_movement_path_point_a_alpha_array, temp_ui_path_point_a_alpha * temp_ui_path_point_a_alpha * temp_ui_path_point_a_alpha * temp_ui_path_point_a_alpha * temp_ui_path_point_a_alpha * temp_ui_path_point_a_alpha);
							array_push(selected_unit_movement_path_point_b_alpha_array, temp_ui_path_point_b_alpha * temp_ui_path_point_b_alpha * temp_ui_path_point_b_alpha * temp_ui_path_point_b_alpha * temp_ui_path_point_b_alpha * temp_ui_path_point_b_alpha);
							
							// Delete Unused Arrays
							array_resize(temp_ui_path_a_screen_position, 0);
							array_resize(temp_ui_path_b_screen_position, 0);
							
							// Increment Selected Unit's Movement Path Entries Count
							selected_unit_movement_path_entries++;
							
							// Increment Selected Unit's Pathfinding Path Index
							temp_selected_unit_pathfinding_path_index++;
						}
						
						// Check Toggle UI if Selected Unit's Pathfinding Path has One or More Entries
						selected_unit_movement_path_ui = selected_unit_movement_path_entries > 0;
						
						// Depth Sort Selected Unit's Pathfinding Path UI Entries
						if (selected_unit_movement_path_entries > 1)
						{
							array_sort(selected_unit_movement_path_depth_sorting_index_array, selected_unit_movement_path_render_depth_sort);
						}
					}
					break;
				default:
					break;
			}
		}
	}
	else if (instance_exists(temp_celestial_object_instance.orbit_parent_instance) and temp_celestial_object_instance.orbit_parent_instance == camera_observing_instance)
	{
		// Celestial Object is in orbit of a Celestial Object being Inspected
		if (temp_celestial_object_instance.celestial_object_type == CelestialObjectType.Planet and temp_celestial_object_instance.orbit_parent_instance.celestial_object_type == CelestialObjectType.Planet)
		{
			// Both the Celestial Object and the Orbit Parent Celestial Object being Inspected are Planets - Render Object Layers Enabled
			temp_celestial_object_instance.render_objects_enabled = true;
		}
	}
	
	// Perform Celestial Object's Render Objects Depth Sorting Behaviour
	if (temp_celestial_object_instance.render_objects_enabled)
	{
		// Reset Celestial Simulator Render Depth Sorting Arrays
		array_resize(render_objects_back_render_depth_sorting_index_array, 0);
		array_resize(render_objects_back_render_depth_sorting_depth_array, 0);
		
		array_resize(render_objects_front_render_depth_sorting_index_array, 0);
		array_resize(render_objects_front_render_depth_sorting_depth_array, 0);
		
		// Reset Celestial Object Render Depth Sorting Arrays
		array_resize(temp_celestial_object_instance.render_objects_back_layer_index_array, 0);
		array_resize(temp_celestial_object_instance.render_objects_back_layer_depth_array, 0);
		array_resize(temp_celestial_object_instance.render_objects_back_layer_instance_array, 0);
	
		array_resize(temp_celestial_object_instance.render_objects_front_layer_index_array, 0);
		array_resize(temp_celestial_object_instance.render_objects_front_layer_depth_array, 0);
		array_resize(temp_celestial_object_instance.render_objects_front_layer_instance_array, 0);
		
		// Establish Empty Render Object Count
		var temp_render_object_back_layer_count = 0;
		var temp_render_object_front_layer_count = 0;
		
		// Celestial Object's Unit Depth Sorting Behaviour
		var temp_unit_index = 0;
		
		repeat (array_length(temp_celestial_object_instance.units))
		{
			// Find Celestial Unit's Instance
			var temp_unit_instance = temp_celestial_object_instance.units[temp_unit_index];
			
			// Establish Unit Local Vector and Elevation Variables
			var temp_unit_local_x, temp_unit_local_y, temp_unit_local_z, temp_unit_elevation;
			
			// Check if Pathfinding is Enabled or Unit's Celestial Body Pathfinding Node Index is Valid
			if (!temp_celestial_object_instance.pathfinding_enabled or temp_unit_instance.pathfinding_node_index < 0 or temp_unit_instance.pathfinding_node_index >= temp_celestial_object_instance.pathfinding_nodes_count)
			{
				// Find Vertical Sphere Vector
				var temp_unit_atan_value = (0.5 - temp_unit_instance.local_position_u) * 2 * pi;
				var temp_unit_asin_value = (0.5 - temp_unit_instance.local_position_v) * pi;
				temp_unit_local_y = -sin(temp_unit_asin_value);
				
				// Find Horizontal and Forwards Sphere Vectors
				var temp_unit_sphere_horizontal_radius = sqrt(1.0 - temp_unit_local_y * temp_unit_local_y);
				temp_unit_local_x = temp_unit_sphere_horizontal_radius * -sin(temp_unit_atan_value);
				temp_unit_local_z = temp_unit_sphere_horizontal_radius * -cos(temp_unit_atan_value);
				
				// Set Default Sphere Elevation
				temp_unit_elevation = 1.0;
			}
			else
			{
				// Establish Empty Unit Elevation
				var temp_unit_elevation = 0;
				
				// Check if Unit is currently Pathfinding
				if (is_undefined(temp_unit_instance.pathfinding_path))
				{
					// Find Celestial Unit's Normalized Local Vector from Celestial Body's Sphere Center with their Pathfinding Node Index
					temp_unit_local_x = temp_celestial_object_instance.pathfinding_node_x_array[temp_unit_instance.pathfinding_node_index];
					temp_unit_local_y = temp_celestial_object_instance.pathfinding_node_y_array[temp_unit_instance.pathfinding_node_index];
					temp_unit_local_z = temp_celestial_object_instance.pathfinding_node_z_array[temp_unit_instance.pathfinding_node_index];
					
					// Find Celestial Unit's Elevation from Celestial Body's Sphere Center with their Pathfinding Node Index
					temp_unit_elevation = temp_celestial_object_instance.pathfinding_node_elevation_array[temp_unit_instance.pathfinding_node_index];
				}
				else
				{
					// Find Celestial Unit's Normalized Local Vector and Elevation from Celestial Body's Sphere Center with their precalculated positioning variables from their Pathfinding Behaviour
					temp_unit_local_x = temp_unit_instance.pathfinding_position_x;
					temp_unit_local_y = temp_unit_instance.pathfinding_position_y;
					temp_unit_local_z = temp_unit_instance.pathfinding_position_z;
					temp_unit_elevation = temp_unit_instance.pathfinding_position_elevation;
				}
			}
			
			// Find Celestial Unit's Elevation from Celestial Body's Sphere Center
			if (temp_celestial_object_instance.celestial_object_type == CelestialObjectType.Planet)
			{
				// If the Celestial Object is a Planet, the Elevation must be equal to or higher than the Planet's Ocean Elevation Value
				temp_unit_elevation = max(temp_unit_elevation, temp_celestial_object_instance.ocean_elevation);
			}
			
			temp_unit_elevation = temp_celestial_object_instance.radius + (temp_unit_elevation * temp_celestial_object_instance.elevation);
			
			// Find Celestial Unit's World Position
			temp_unit_instance.world_position_x = temp_unit_elevation * (temp_unit_local_x * temp_celestial_obj_rotation_matrix[0] + temp_unit_local_y * temp_celestial_obj_rotation_matrix[4] + temp_unit_local_z * temp_celestial_obj_rotation_matrix[8]) + temp_celestial_object_instance.x;
			temp_unit_instance.world_position_y = temp_unit_elevation * (temp_unit_local_x * temp_celestial_obj_rotation_matrix[1] + temp_unit_local_y * temp_celestial_obj_rotation_matrix[5] + temp_unit_local_z * temp_celestial_obj_rotation_matrix[9]) + temp_celestial_object_instance.y;
			temp_unit_instance.world_position_z = temp_unit_elevation * (temp_unit_local_x * temp_celestial_obj_rotation_matrix[2] + temp_unit_local_y * temp_celestial_obj_rotation_matrix[6] + temp_unit_local_z * temp_celestial_obj_rotation_matrix[10]) + temp_celestial_object_instance.z;
			
			// Find Celestial Unit's Screen Position and set the Celestial Unit Instance's Position to their Converted World Position to Screen Coordinates
			var temp_unit_screen_position = world_position_to_screen_position(temp_unit_instance.world_position_x, temp_unit_instance.world_position_y, temp_unit_instance.world_position_z, camera_view_matrix, camera_projection_matrix);
			
			temp_unit_instance.x = temp_unit_screen_position[0];
			temp_unit_instance.y = temp_unit_screen_position[1];
			
			// Find Celestial Unit's Depth from Render Camera
			var temp_unit_vx = temp_unit_instance.world_position_x - temp_render_start_x;
			var temp_unit_vy = temp_unit_instance.world_position_y - temp_render_start_y;
			var temp_unit_vz = temp_unit_instance.world_position_z - temp_render_start_z;
			
			var temp_unit_projection_scalar = dot_product_3d(temp_unit_vx, temp_unit_vy, temp_unit_vz, temp_dx, temp_dy, temp_dz) / temp_dm;
			var temp_unit_depth = lerp(camera_z_near + camera_z_near_depth_overpass, camera_z_far, temp_unit_projection_scalar) - temp_celestial_object_depth;
			
			// Check if Unit's Depth is in front of the Celestial Body or behind the Celestial Body
			if (temp_unit_depth < 0)
			{
				// Index Celestial Unit's Index and Depth into Celestial Object's Render Object Front Layer Render Depth Sorting Arrays
				array_push(render_objects_front_render_depth_sorting_index_array, temp_render_object_front_layer_count);
				array_push(render_objects_front_render_depth_sorting_depth_array, temp_unit_depth + global_render_objects_unit_depth_offset);
				
				// Index Celestial Unit's Instance and Depth into Celestial Object's Render Object Front Layer Instance and Depth Arrays
				array_push(temp_celestial_object_instance.render_objects_front_layer_instance_array, temp_unit_instance);
				array_push(temp_celestial_object_instance.render_objects_front_layer_depth_array, temp_unit_depth + global_render_objects_unit_depth_offset);
				
				// Increment Render Object Front Layer Count Index
				temp_render_object_front_layer_count++;
			}
			
			// Delete Unused Array
			array_resize(temp_unit_screen_position, 0);
			
			// Increment Celestial Unit Index
			temp_unit_index++;
		}
		
		// Celestial Object's City Depth Sorting Behaviour
		var temp_city_index = 0;
		
		repeat (array_length(temp_celestial_object_instance.cities))
		{
			// Find Celestial City's Instance
			var temp_city_instance = temp_celestial_object_instance.cities[temp_city_index];
			
			// Establish City Local Vector and Elevation Variables
			var temp_city_local_x, temp_city_local_y, temp_city_local_z, temp_city_elevation;
			
			// Check if Pathfinding is Enabled or City's Celestial Body Pathfinding Node Index is Valid
			if (!temp_celestial_object_instance.pathfinding_enabled or temp_city_instance.pathfinding_node_index < 0 or temp_city_instance.pathfinding_node_index >= temp_celestial_object_instance.pathfinding_nodes_count)
			{
				// Find Vertical Sphere Vector
				var temp_city_atan_value = (0.5 - temp_city_instance.local_position_u) * 2 * pi;
				var temp_city_asin_value = (0.5 - temp_city_instance.local_position_v) * pi;
				temp_city_local_y = -sin(temp_city_asin_value);
				
				// Find Horizontal and Forwards Sphere Vectors
				var temp_city_sphere_horizontal_radius = sqrt(1.0 - temp_city_local_y * temp_city_local_y);
				temp_city_local_x = temp_city_sphere_horizontal_radius * -sin(temp_city_atan_value);
				temp_city_local_z = temp_city_sphere_horizontal_radius * -cos(temp_city_atan_value);
				
				// Set Default Sphere Elevation
				temp_city_elevation = 1.0;
			}
			else
			{
				// Find Celestial City's Normalized Local Vector from Celestial Body's Sphere Center with their Pathfinding Node Index
				temp_city_local_x = temp_celestial_object_instance.pathfinding_node_x_array[temp_city_instance.pathfinding_node_index];
				temp_city_local_y = temp_celestial_object_instance.pathfinding_node_y_array[temp_city_instance.pathfinding_node_index];
				temp_city_local_z = temp_celestial_object_instance.pathfinding_node_z_array[temp_city_instance.pathfinding_node_index];
				
				// Find Celestial City's Elevation from Celestial Body's Sphere Center with their Pathfinding Node Index
				temp_city_elevation = temp_celestial_object_instance.pathfinding_node_elevation_array[temp_city_instance.pathfinding_node_index];
			}
			
			// Find Celestial City's Elevation from Celestial Body's Sphere Center
			if (temp_celestial_object_instance.celestial_object_type == CelestialObjectType.Planet)
			{
				// If the Celestial Object is a Planet, the Elevation must be equal to or higher than the Planet's Ocean Elevation Value
				temp_city_elevation = max(temp_city_elevation, temp_celestial_object_instance.ocean_elevation);
			}
			
			temp_city_elevation = temp_celestial_object_instance.radius + (temp_city_elevation * temp_celestial_object_instance.elevation);
			
			// Find Celestial City's World Position
			temp_city_instance.world_position_x = temp_city_elevation * (temp_city_local_x * temp_celestial_obj_rotation_matrix[0] + temp_city_local_y * temp_celestial_obj_rotation_matrix[4] + temp_city_local_z * temp_celestial_obj_rotation_matrix[8]) + temp_celestial_object_instance.x;
			temp_city_instance.world_position_y = temp_city_elevation * (temp_city_local_x * temp_celestial_obj_rotation_matrix[1] + temp_city_local_y * temp_celestial_obj_rotation_matrix[5] + temp_city_local_z * temp_celestial_obj_rotation_matrix[9]) + temp_celestial_object_instance.y;
			temp_city_instance.world_position_z = temp_city_elevation * (temp_city_local_x * temp_celestial_obj_rotation_matrix[2] + temp_city_local_y * temp_celestial_obj_rotation_matrix[6] + temp_city_local_z * temp_celestial_obj_rotation_matrix[10]) + temp_celestial_object_instance.z;
			
			// Find Celestial City's Screen Position and set the Celestial City Instance's Position to their Converted World Position to Screen Coordinates
			var temp_city_screen_position = world_position_to_screen_position(temp_city_instance.world_position_x, temp_city_instance.world_position_y, temp_city_instance.world_position_z, camera_view_matrix, camera_projection_matrix);
			
			temp_city_instance.x = temp_city_screen_position[0];
			temp_city_instance.y = temp_city_screen_position[1];
			
			// Find Celestial City's Depth from Render Camera
			var temp_city_vx = temp_city_instance.world_position_x - temp_render_start_x;
			var temp_city_vy = temp_city_instance.world_position_y - temp_render_start_y;
			var temp_city_vz = temp_city_instance.world_position_z - temp_render_start_z;
			
			var temp_city_projection_scalar = dot_product_3d(temp_city_vx, temp_city_vy, temp_city_vz, temp_dx, temp_dy, temp_dz) / temp_dm;
			var temp_city_depth = lerp(camera_z_near + camera_z_near_depth_overpass, camera_z_far, temp_city_projection_scalar) - temp_celestial_object_depth;
			
			// Check if City's Depth is in front of the Celestial Body or behind the Celestial Body
			if (temp_city_depth < 0)
			{
				// Index Celestial City's Index and Depth into Celestial Object's Render Object Front Layer Render Depth Sorting Arrays
				array_push(render_objects_front_render_depth_sorting_index_array, temp_render_object_front_layer_count);
				array_push(render_objects_front_render_depth_sorting_depth_array, temp_city_depth + global_render_objects_city_depth_offset);
				
				// Index Celestial City's Instance and Depth into Celestial Object's Render Object Front Layer Instance and Depth Arrays
				array_push(temp_celestial_object_instance.render_objects_front_layer_instance_array, temp_city_instance);
				array_push(temp_celestial_object_instance.render_objects_front_layer_depth_array, temp_city_depth + global_render_objects_city_depth_offset);
				
				// Increment Render Object Front Layer Count Index
				temp_render_object_front_layer_count++;
			}
			
			// Delete Unused Array
			array_resize(temp_city_screen_position, 0);
			
			// Increment Celestial City Index
			temp_city_index++;
		}
		
		// Celestial Object's Satellite Depth Sorting Behaviour
		var temp_satellite_index = 0;
		
		repeat (array_length(temp_celestial_object_instance.satellites))
		{
			// Find Celestial Satellite's Instance
			var temp_satellite_instance = temp_celestial_object_instance.satellites[temp_satellite_index];
			
			// Establish Satellite Local Vector and Elevation Variables
			var temp_satellite_local_x, temp_satellite_local_y, temp_satellite_local_z, temp_satellite_elevation;
			
			// Check if Pathfinding is Enabled or Satellite's Celestial Body Pathfinding Node Index is Valid
			if (!temp_celestial_object_instance.pathfinding_enabled or temp_satellite_instance.pathfinding_node_index < 0 or temp_satellite_instance.pathfinding_node_index >= temp_celestial_object_instance.pathfinding_nodes_count)
			{
				// Find Vertical Sphere Vector
				var temp_satellite_atan_value = (0.5 - temp_satellite_instance.local_position_u) * 2 * pi;
				var temp_satellite_asin_value = (0.5 - temp_satellite_instance.local_position_v) * pi;
				temp_satellite_local_y = -sin(temp_satellite_asin_value);
				
				// Find Horizontal and Forwards Sphere Vectors
				var temp_satellite_sphere_horizontal_radius = sqrt(1.0 - temp_satellite_local_y * temp_satellite_local_y);
				temp_satellite_local_x = temp_satellite_sphere_horizontal_radius * -sin(temp_satellite_atan_value);
				temp_satellite_local_z = temp_satellite_sphere_horizontal_radius * -cos(temp_satellite_atan_value);
				
				// Set Default Sphere Elevation
				temp_satellite_elevation = 1.0;
			}
			else
			{
				// Find Celestial Satellite's Normalized Local Vector from Celestial Body's Sphere Center
				temp_satellite_local_x = temp_celestial_object_instance.pathfinding_node_x_array[temp_satellite_instance.pathfinding_node_index];
				temp_satellite_local_y = temp_celestial_object_instance.pathfinding_node_y_array[temp_satellite_instance.pathfinding_node_index];
				temp_satellite_local_z = temp_celestial_object_instance.pathfinding_node_z_array[temp_satellite_instance.pathfinding_node_index];
				
				// Find Celestial Satellite's Elevation from Celestial Body's Sphere Center with their Pathfinding Node Index
				temp_satellite_elevation = temp_celestial_object_instance.pathfinding_node_elevation_array[temp_satellite_instance.pathfinding_node_index];
			}
			
			// Find Celestial Satellite's Elevation from Celestial Body's Sphere Center
			if (temp_celestial_object_instance.celestial_object_type == CelestialObjectType.Planet)
			{
				// If the Celestial Object is a Planet, the Elevation must be equal to or higher than the Planet's Ocean Elevation Value
				temp_satellite_elevation = max(temp_satellite_elevation, temp_celestial_object_instance.ocean_elevation);
			}
			
			temp_satellite_elevation = temp_celestial_object_instance.radius + (temp_satellite_elevation * temp_celestial_object_instance.elevation) + temp_satellite_instance.satellite_elevation;
			
			// Find Celestial Satellite's Local Position
			var temp_satellite_local_position_x = temp_satellite_local_x * temp_celestial_obj_rotation_matrix[0] + temp_satellite_local_y * temp_celestial_obj_rotation_matrix[4] + temp_satellite_local_z * temp_celestial_obj_rotation_matrix[8];
			var temp_satellite_local_position_y = temp_satellite_local_x * temp_celestial_obj_rotation_matrix[1] + temp_satellite_local_y * temp_celestial_obj_rotation_matrix[5] + temp_satellite_local_z * temp_celestial_obj_rotation_matrix[9];
			var temp_satellite_local_position_z = temp_satellite_local_x * temp_celestial_obj_rotation_matrix[2] + temp_satellite_local_y * temp_celestial_obj_rotation_matrix[6] + temp_satellite_local_z * temp_celestial_obj_rotation_matrix[10];
			
			// Find Celestial Satellite's World Position
			temp_satellite_instance.world_position_x = temp_satellite_elevation * temp_satellite_local_position_x + temp_celestial_object_instance.x;
			temp_satellite_instance.world_position_y = temp_satellite_elevation * temp_satellite_local_position_y + temp_celestial_object_instance.y;
			temp_satellite_instance.world_position_z = temp_satellite_elevation * temp_satellite_local_position_z + temp_celestial_object_instance.z;
			
			// Find Celestial Satellite's Screen Position and set the Celestial Satellite Instance's Position to their Converted World Position to Screen Coordinates
			var temp_satellite_screen_position = world_position_to_screen_position(temp_satellite_instance.world_position_x, temp_satellite_instance.world_position_y, temp_satellite_instance.world_position_z, camera_view_matrix, camera_projection_matrix);
			
			temp_satellite_instance.x = temp_satellite_screen_position[0];
			temp_satellite_instance.y = temp_satellite_screen_position[1];
			
			// Find Celestial Satellite's Depth from Render Camera
			var temp_satellite_vx = temp_satellite_instance.world_position_x - temp_render_start_x;
			var temp_satellite_vy = temp_satellite_instance.world_position_y - temp_render_start_y;
			var temp_satellite_vz = temp_satellite_instance.world_position_z - temp_render_start_z;
			
			var temp_satellite_projection_scalar = dot_product_3d(temp_satellite_vx, temp_satellite_vy, temp_satellite_vz, temp_dx, temp_dy, temp_dz) / temp_dm;
			var temp_satellite_depth = lerp(camera_z_near + camera_z_near_depth_overpass, camera_z_far, temp_satellite_projection_scalar) - temp_celestial_object_depth;
			
			// Check if Satellite's Depth is in front of the Celestial Body or behind the Celestial Body
			if (temp_satellite_depth < temp_celestial_object_instance.render_depth_radius * -0.25)
			{
				// Index Celestial Satellite's Index and Depth into Celestial Object's Render Object Front Layer Render Depth Sorting Arrays
				array_push(render_objects_front_render_depth_sorting_index_array, temp_render_object_front_layer_count);
				array_push(render_objects_front_render_depth_sorting_depth_array, temp_satellite_depth);
				
				// Index Celestial Satellite's Instance and Depth into Celestial Object's Render Object Front Layer Instance and Depth Arrays
				array_push(temp_celestial_object_instance.render_objects_front_layer_instance_array, temp_satellite_instance);
				array_push(temp_celestial_object_instance.render_objects_front_layer_depth_array, temp_satellite_depth);
				
				// Increment Render Object Front Layer Count Index
				temp_render_object_front_layer_count++;
			}
			else
			{
				// Index Celestial Satellite's Index and Depth into Celestial Object's Render Object Back Layer Render Depth Sorting Arrays
				array_push(render_objects_back_render_depth_sorting_index_array, temp_render_object_back_layer_count);
				array_push(render_objects_back_render_depth_sorting_depth_array, temp_satellite_depth);
				
				// Index Celestial Satellite's Instance and Depth into Celestial Object's Render Object Back Layer Instance and Depth Arrays
				array_push(temp_celestial_object_instance.render_objects_back_layer_instance_array, temp_satellite_instance);
				array_push(temp_celestial_object_instance.render_objects_back_layer_depth_array, temp_satellite_depth);
				
				// Increment Render Object Back Layer Count Index
				temp_render_object_back_layer_count++;
			}
			
			// Delete Unused Array
			array_resize(temp_satellite_screen_position, 0);
			
			// Increment Celestial Satellite Index
			temp_satellite_index++;
		}
		
		// Sort Celestial Simulator's Render Objects Back and Front Render Depth Sorting Arrays
		array_sort(render_objects_back_render_depth_sorting_index_array, render_objects_back_render_depth_sort);
		array_sort(render_objects_front_render_depth_sorting_index_array, render_objects_front_render_depth_sort);
		
		// Copy Depth Sorted Render Objects Index Order to Celestial Object's Back and Front Render Objects Index Arrays
		array_copy(temp_celestial_object_instance.render_objects_back_layer_index_array, 0, render_objects_back_render_depth_sorting_index_array, 0, temp_render_object_back_layer_count);
		array_copy(temp_celestial_object_instance.render_objects_front_layer_index_array, 0, render_objects_front_render_depth_sorting_index_array, 0, temp_render_object_front_layer_count);
	}
	
	// Celestial Object Type Depth Sorting Behaviour
	switch (temp_celestial_object_instance.celestial_object_type)
	{
		case CelestialObjectType.Planet:
			// Planet Sphere Shadows Behaviour
			var temp_planet_shadow_index = 0;
			
			// Iterate through all of the Planet's Sphere Shadows
			repeat (CelestialSimMaxShadows)
			{
				// Check if Sphere Shadow is Active
				if (temp_celestial_object_instance.sphere_shadow_exists[temp_planet_shadow_index])
				{
					// Check if Sphere Shadow's Instance exists
					if (!instance_exists(temp_celestial_object_instance.sphere_shadow_instance[temp_planet_shadow_index]))
					{
						// Set Sphere Shadow to be Inactive
						temp_celestial_object_instance.sphere_shadow_exists[temp_planet_shadow_index] = false;
					}
					else
					{
						// Update Sphere Shadow's Radius
						temp_celestial_object_instance.sphere_shadow_radius[temp_planet_shadow_index] = temp_celestial_object_instance.sphere_shadow_instance[temp_planet_shadow_index].radius;
						
						// Update Sphere Shadow's World Position
						temp_celestial_object_instance.sphere_shadow_position_x[temp_planet_shadow_index] = temp_celestial_object_instance.sphere_shadow_instance[temp_planet_shadow_index].x;
						temp_celestial_object_instance.sphere_shadow_position_y[temp_planet_shadow_index] = temp_celestial_object_instance.sphere_shadow_instance[temp_planet_shadow_index].y;
						temp_celestial_object_instance.sphere_shadow_position_z[temp_planet_shadow_index] = temp_celestial_object_instance.sphere_shadow_instance[temp_planet_shadow_index].z;
					}
				}
				
				// Increment Planet's Sphere Shadow Index
				temp_planet_shadow_index++;
			}
			
			// Planet Cloud Depth Sorting Behaviour
			if (temp_celestial_object_instance.clouds)
			{
				// Reset Celestial Simulator Clouds Render Depth Sorting Arrays
				array_resize(clouds_render_depth_sorting_index_array, 0);
				array_resize(clouds_render_depth_sorting_depth_array, 0);
				
				// Reset Planet Cloud Depth Sorted Index Array
				array_resize(temp_celestial_object_instance.clouds_index_array, 0);
				
				// Reset Planet Cloud Rendering Lists
				ds_list_clear(temp_celestial_object_instance.clouds_render_u_list);
				ds_list_clear(temp_celestial_object_instance.clouds_render_v_list);
				ds_list_clear(temp_celestial_object_instance.clouds_render_height_list);
				ds_list_clear(temp_celestial_object_instance.clouds_render_radius_list);
				ds_list_clear(temp_celestial_object_instance.clouds_render_density_list);
				ds_list_clear(temp_celestial_object_instance.clouds_render_absorption_list);
				
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
							
							var temp_cloud_x = temp_cloud_adjusted_height * (temp_cloud_x_value * temp_celestial_obj_rotation_matrix[0] + temp_cloud_y_value * temp_celestial_obj_rotation_matrix[4] + temp_cloud_z_value * temp_celestial_obj_rotation_matrix[8]) + temp_celestial_object_instance.x;
							var temp_cloud_y = temp_cloud_adjusted_height * (temp_cloud_x_value * temp_celestial_obj_rotation_matrix[1] + temp_cloud_y_value * temp_celestial_obj_rotation_matrix[5] + temp_cloud_z_value * temp_celestial_obj_rotation_matrix[9]) + temp_celestial_object_instance.y;
							var temp_cloud_z = temp_cloud_adjusted_height * (temp_cloud_x_value * temp_celestial_obj_rotation_matrix[2] + temp_cloud_y_value * temp_celestial_obj_rotation_matrix[6] + temp_cloud_z_value * temp_celestial_obj_rotation_matrix[10]) + temp_celestial_object_instance.z;
							
							// Find Individual Cloud's Depth from Render Camera
							var temp_cloud_vx = temp_cloud_x - temp_render_start_x;
							var temp_cloud_vy = temp_cloud_y - temp_render_start_y;
							var temp_cloud_vz = temp_cloud_z - temp_render_start_z;
							
							var temp_cloud_depth = dot_product_3d(temp_cloud_vx, temp_cloud_vy, temp_cloud_vz, temp_dx, temp_dy, temp_dz) / temp_dm;
							
							// Index Cloud's Index and Depth into Planet's Cloud Depth Sorting Arrays
							array_push(clouds_render_depth_sorting_index_array, temp_cloud_count);
							array_push(clouds_render_depth_sorting_depth_array, temp_cloud_depth);
							
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
				array_sort(clouds_render_depth_sorting_index_array, clouds_render_depth_sort);
				
				// Copy Depth Sorted Cloud Index Order to Planet's Cloud Index Array
				array_copy(temp_celestial_object_instance.clouds_index_array, 0, clouds_render_depth_sorting_index_array, 0, temp_cloud_count);
			}
			break;
		default:
			// Skip Celestial Object Depth Sorting Behaviour
			break;
	}
	
	// Delete Unused Array
	array_resize(temp_celestial_obj_rotation_matrix, 0);
	
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
