/// @description Cursor Selection & UI Event
// Performs the Celestial Simulator's Cursor Selection, Observation Instance Movement, Inspection, & UI Behaviours after all Celestial Objects have been depth sorted in the Step Event

// Check if Celestial Simulator is Active
if (!active)
{
	// Reset Input Behaviour
	input_select = false;
	input_action = false;
	
	// Inactive - Early Return
	return;
}

// Check if Solar System exists and is being viewed
if (solar_system_index == -1)
{
	// Not currently viewing a Solar System - Early Return
	return;
}

// Establish Solar System from Solar Systems Array
var temp_solar_system = solar_systems[solar_system_index];

// Celestial Simulator Input Behaviour
var temp_input_select = mouse_check_button(mb_left);
var temp_input_action = mouse_check_button(mb_right);

// Establish Empty Render Object Selection Variables
var temp_render_object_click_inst = noone;
var temp_render_object_action_inst = noone;
var temp_render_object_selected_inst = noone;

// Render Object Selection Behaviour
if (((!temp_input_select and input_select) or (temp_input_action and !input_action)) and !camera_observing_drag)
{
	// Check if Celestial Simulator is Observing a Celestial Body Instance with Render Objects Enabled and is Zoomed In
	if (instance_exists(camera_observing_instance) and camera_observing_instance.render_objects_enabled and camera_observing_instance_radius_offset_value <= camera_observing_instance_radius_offset_zoom_in_threshold)
	{
		// Iterate through all Celestial Render Object Instances in Observing Instance's Render Object Front Layer for Cursor Collisions
		var temp_render_object_index = 0;
		
		repeat (array_length(camera_observing_instance.render_objects_front_layer_index_array))
		{
			// Find Render Object Index and Instance
			var temp_render_object_sorted_index = camera_observing_instance.render_objects_front_layer_index_array[temp_render_object_index];
			var temp_render_object_sorted_instance = camera_observing_instance.render_objects_front_layer_instance_array[temp_render_object_sorted_index];
			
			// Check for Render Object Instance's Collision with Cursor
			if (position_meeting(GameManager.cursor_x, GameManager.cursor_y, temp_render_object_sorted_instance))
			{
				temp_render_object_click_inst = temp_render_object_sorted_instance;
			}
			
			// Increment Render Object Index
			temp_render_object_index++;
		}
	}
	
	// Update Celestial Simulator's Render Object Selected Instance with the possible Selection
	if (temp_input_action and !input_action)
	{
		temp_render_object_action_inst = temp_render_object_click_inst;
	}
	else if (!temp_input_select and input_select)
	{
		render_object_selected_instance = temp_render_object_click_inst;
		temp_render_object_selected_inst = temp_render_object_click_inst;
	}
}

// Calculate Cursor's Screen to World Raycast Vector
var temp_cursor_raycast = screen_position_to_world_vector(clamp(GameManager.cursor_x, 0, GameManager.game_width), clamp(GameManager.cursor_y, 0, GameManager.game_height), camera_view_matrix, camera_projection_matrix);

// Celestial Simulator Selection & Action Behaviour
if (camera_observing_drag)
{
	// Check if Click Drag Behaviour has Finished
	if (!temp_input_select)
	{
		camera_observing_drag = false;
	}
}
else if (temp_input_select or temp_input_action)
{
	// Establish Empty Selection Variables
	var temp_selection_inst = noone;
	var temp_selection_radius = 1;
	var temp_selection_position = undefined;
	
	// Iterate through Solar System's Celestial Objects to check Cursor Raycast Selection
	var temp_celestial_object_index = 0;
	
	repeat (array_length(temp_solar_system))
	{
		// Find Celestial Object Instance within Solar System at Index
		var temp_celestial_object_instance = temp_solar_system[temp_celestial_object_index];
		
		// Establish Default Invalid Celestial Object Selection Properties
		var temp_celestial_object_radius = 0;
		var temp_celestial_object_select = false;
		
		// Celestial Object Type Cursor Raycast Behaviour
		switch (temp_celestial_object_instance.celestial_object_type)
		{
			case CelestialObjectType.Planet:
				// Planet Celestial Object Selection Properties
				temp_celestial_object_radius = temp_celestial_object_instance.radius + temp_celestial_object_instance.elevation * temp_celestial_object_instance.ocean_elevation;
				temp_celestial_object_select = true;
				break;
			default:
				// Skip Celestial Object Cursor Raycast Behaviour
				break;
		}
		
		// Check if Celestial Object can be Selected
		if (!temp_celestial_object_select)
		{
			// Increment Celestial Object Index
			temp_celestial_object_index++;
			
			// Skip Celestial Object's Raycast Behaviour
			continue;
		}
		
		// Calculate Cursor's Raycast with Celestial Object's Spherical Selection Mask
		var temp_celestial_object_raycast = raycast_sphere
		(
			camera_position_x, 
			camera_position_y, 
			camera_position_z, 
			temp_cursor_raycast[0], 
			temp_cursor_raycast[1], 
			temp_cursor_raycast[2], 
			temp_celestial_object_instance.x, 
			temp_celestial_object_instance.y, 
			temp_celestial_object_instance.z, 
			temp_celestial_object_radius
		);
		
		// Check if Cursor's Raycast Vector intersected with the Celestial Object's Spherical Selection Mask
		if (!is_undefined(temp_celestial_object_raycast))
		{
			// Compare the Cursor's Raycast Collision Depth with the last valid Raycast Collision Depth
			if (is_undefined(temp_selection_position) or temp_celestial_object_raycast[3] < temp_selection_position[3])
			{
				// Set Cursor's Selection Instance and Selection Position from Cursor's Raycast Behaviour
				temp_selection_inst = temp_celestial_object_instance;
				temp_selection_radius = temp_celestial_object_radius;
				temp_selection_position = temp_celestial_object_raycast;
			}
		}
		
		// Increment Celestial Object Index
		temp_celestial_object_index++;
	}
	
	// Check if Selection Position is Valid
	if (!is_undefined(temp_selection_position))
	{
		// Establish Selection Instance's Minimum Elevation
		var temp_selection_inst_minimum_elevation = 0;
		
		if (temp_selection_inst.celestial_object_type == CelestialObjectType.Planet)
		{
			// If the Celestial Object is a Planet, the Elevation must be equal to or higher than the Planet's Ocean Elevation Value
			temp_selection_inst_minimum_elevation = temp_selection_inst.ocean_elevation;
		}
		
		// Create Selection Instance's Rotation Matrix and Inverse Rotation Matrix from its local Euler Angle Rotation
		var temp_selection_rotation_matrix = rotation_matrix_from_euler_angles(temp_selection_inst.euler_angle_x, temp_selection_inst.euler_angle_y, temp_selection_inst.euler_angle_z);
		var temp_selection_rotation_matrix_inverse = matrix_inverse(temp_selection_rotation_matrix);
		
		// Find Selection Position's Radial Offset from Selection Instance's Origin Position
		var temp_selection_offset_x = temp_selection_position[0] - temp_selection_inst.x;
		var temp_selection_offset_y = temp_selection_position[1] - temp_selection_inst.y;
		var temp_selection_offset_z = temp_selection_position[2] - temp_selection_inst.z;
		
		// Rotate Selection Position's Radial Offset Vector by the Inverse of the Selection Instance's Rotation Matrix to find the Localized Selection Position
		var temp_selection_x = temp_selection_offset_x * temp_selection_rotation_matrix_inverse[0] + temp_selection_offset_y * temp_selection_rotation_matrix_inverse[4] + temp_selection_offset_z * temp_selection_rotation_matrix_inverse[8];
		var temp_selection_y = temp_selection_offset_x * temp_selection_rotation_matrix_inverse[1] + temp_selection_offset_y * temp_selection_rotation_matrix_inverse[5] + temp_selection_offset_z * temp_selection_rotation_matrix_inverse[9];
		var temp_selection_z = temp_selection_offset_x * temp_selection_rotation_matrix_inverse[2] + temp_selection_offset_y * temp_selection_rotation_matrix_inverse[6] + temp_selection_offset_z * temp_selection_rotation_matrix_inverse[10];
		
		// Calculate Localized Selection Position Vector's Magnitude
		var temp_selection_magnitude = sqrt(dot_product_3d(temp_selection_x, temp_selection_y, temp_selection_z, temp_selection_x, temp_selection_y, temp_selection_z));
		
		// Normalize Localized Selection Position Vector with Localized Selection Position Vector's Magnitude
		temp_selection_x /= temp_selection_magnitude;
		temp_selection_y /= temp_selection_magnitude;
		temp_selection_z /= temp_selection_magnitude;
		
		// Find the Selection's UV Coordinates of the Localized Selection Position
		//var temp_selection_u = 0.5 - arctan2(-temp_selection_x, -temp_selection_z) / (2 * pi);
		//var temp_selection_v = 0.5 - arcsin(-temp_selection_y) / pi;
		
		// Check if Selected Celestial Object has Pathfinding Enabled
		if (temp_selection_inst.pathfinding_enabled)
		{
			// Establish Default Pathfinding Group & Node Selection
			var temp_selection_group_index = -1;
			var temp_selection_group_dot_product = -1;
			
			var temp_selection_node_index = -1;
			var temp_selection_node_dot_product = -1;
			
			// Iterate through all Pathfinding Groups to find closest Pathfinding Group to Selection Position on Celestial Object
			var temp_pathfinding_group_index = 0;
			
			repeat (array_length(temp_selection_inst.pathfinding_group_direction_array))
			{
				// Establish Pathfinding Group's Normalized Sphere Vector
				var temp_group_vector_x = array_get(temp_selection_inst.pathfinding_group_direction_array[temp_pathfinding_group_index], 0);
				var temp_group_vector_y = array_get(temp_selection_inst.pathfinding_group_direction_array[temp_pathfinding_group_index], 1);
				var temp_group_vector_z = array_get(temp_selection_inst.pathfinding_group_direction_array[temp_pathfinding_group_index], 2);
				
				// Calculate Dot Product of Pathfinding Group's Normalized Sphere Vector and the Selection Position's Normalized Sphere Vector
				var temp_group_comparison_dot_product = dot_product_3d(temp_selection_x, temp_selection_y, temp_selection_z, temp_group_vector_x, temp_group_vector_y, temp_group_vector_z);
				
				// Compare the new Dot Product of the Pathfinding Group to the Selection Pathfinding Group's Dot Product
				if (temp_group_comparison_dot_product > temp_selection_group_dot_product)
				{
					// Update Selection Group Index and Dot Product
					temp_selection_group_index = temp_pathfinding_group_index;
					temp_selection_group_dot_product = temp_group_comparison_dot_product;
				}
				
				// Increment Pathfinding Group Index
				temp_pathfinding_group_index++;
			}
			
			// Iterate through all Pathfinding Nodes to find closest Pathfinding Node to Selection Position on Celestial Object
			if (temp_selection_group_index != -1)
			{
				var temp_pathfinding_node_index = 0;
				
				repeat (array_length(temp_selection_inst.pathfinding_group_node_index_array[temp_selection_group_index]))
				{
					// Establish Node Index from Pathfinding Group
					var temp_group_node_index = array_get(temp_selection_inst.pathfinding_group_node_index_array[temp_selection_group_index], temp_pathfinding_node_index);
					
					// Establish Pathfinding Node's Normalized Sphere Vector
					var temp_node_vector_x = temp_selection_inst.pathfinding_node_x_array[temp_group_node_index];
					var temp_node_vector_y = temp_selection_inst.pathfinding_node_y_array[temp_group_node_index];
					var temp_node_vector_z = temp_selection_inst.pathfinding_node_z_array[temp_group_node_index];
					
					// Calculate Dot Product of Pathfinding Node's Normalized Sphere Vector and the Selection Position's Normalized Sphere Vector
					var temp_node_comparison_dot_product = dot_product_3d(temp_selection_x, temp_selection_y, temp_selection_z, temp_node_vector_x, temp_node_vector_y, temp_node_vector_z);
					
					// Compare the new Dot Product of the Pathfinding Node to the Selection Pathfinding Node's Dot Product
					if (temp_node_comparison_dot_product > temp_selection_node_dot_product)
					{
						// Update Selection Node Index and Dot Product
						temp_selection_node_index = temp_group_node_index;
						temp_selection_node_dot_product = temp_node_comparison_dot_product;
					}
					
					// Increment Pathfinding Node Index
					temp_pathfinding_node_index++;
				}
			}
			
			// Check if Selection Node Index Exists
			if (temp_selection_node_index != -1)
			{
				// Set Default Selection Triangle Position & Elevation as Pathfinding Node's Position and Elevation
				var temp_selection_tri_x = temp_selection_inst.pathfinding_node_x_array[temp_selection_node_index];
				var temp_selection_tri_y = temp_selection_inst.pathfinding_node_y_array[temp_selection_node_index];
				var temp_selection_tri_z = temp_selection_inst.pathfinding_node_z_array[temp_selection_node_index];
				var temp_selection_tri_elevation = temp_selection_inst.pathfinding_node_elevation_array[temp_selection_node_index];
				
				// Find Pathfinding Node Triangle Portal Vertex Indexes and Positions
				var temp_selection_a_portal_index = array_get(temp_selection_inst.pathfinding_node_edges_portal_left_array[temp_selection_node_index], 0);
				var temp_selection_b_portal_index = array_get(temp_selection_inst.pathfinding_node_edges_portal_left_array[temp_selection_node_index], 1);
				var temp_selection_c_portal_index = array_get(temp_selection_inst.pathfinding_node_edges_portal_left_array[temp_selection_node_index], 2);
				
				var temp_selection_tri_ax = temp_selection_inst.pathfinding_portal_x_array[temp_selection_a_portal_index];
				var temp_selection_tri_ay = temp_selection_inst.pathfinding_portal_y_array[temp_selection_a_portal_index];
				var temp_selection_tri_az = temp_selection_inst.pathfinding_portal_z_array[temp_selection_a_portal_index];
				var temp_selection_tri_ae = temp_selection_inst.pathfinding_portal_elevation_array[temp_selection_a_portal_index];
				
				var temp_selection_tri_bx = temp_selection_inst.pathfinding_portal_x_array[temp_selection_b_portal_index];
				var temp_selection_tri_by = temp_selection_inst.pathfinding_portal_y_array[temp_selection_b_portal_index];
				var temp_selection_tri_bz = temp_selection_inst.pathfinding_portal_z_array[temp_selection_b_portal_index];
				var temp_selection_tri_be = temp_selection_inst.pathfinding_portal_elevation_array[temp_selection_b_portal_index];
				
				var temp_selection_tri_cx = temp_selection_inst.pathfinding_portal_x_array[temp_selection_c_portal_index];
				var temp_selection_tri_cy = temp_selection_inst.pathfinding_portal_y_array[temp_selection_c_portal_index];
				var temp_selection_tri_cz = temp_selection_inst.pathfinding_portal_z_array[temp_selection_c_portal_index];
				var temp_selection_tri_ce = temp_selection_inst.pathfinding_portal_elevation_array[temp_selection_c_portal_index];
				
				// Find Pathfinding Node Triangle Portal Vertices Elevation Values
				var temp_selection_tri_a_elevation = temp_selection_inst.radius + temp_selection_inst.elevation * max(temp_selection_tri_ae, temp_selection_inst_minimum_elevation);
				var temp_selection_tri_b_elevation = temp_selection_inst.radius + temp_selection_inst.elevation * max(temp_selection_tri_be, temp_selection_inst_minimum_elevation);
				var temp_selection_tri_c_elevation = temp_selection_inst.radius + temp_selection_inst.elevation * max(temp_selection_tri_ce, temp_selection_inst_minimum_elevation);
				
				// Find Pathfinding Node Triangle Portal Vertices World Positions
				var temp_selection_tri_a_world_position_x = temp_selection_tri_a_elevation * (temp_selection_tri_ax * temp_selection_rotation_matrix[0] + temp_selection_tri_ay * temp_selection_rotation_matrix[4] + temp_selection_tri_az * temp_selection_rotation_matrix[8]) + temp_selection_inst.x;
				var temp_selection_tri_a_world_position_y = temp_selection_tri_a_elevation * (temp_selection_tri_ax * temp_selection_rotation_matrix[1] + temp_selection_tri_ay * temp_selection_rotation_matrix[5] + temp_selection_tri_az * temp_selection_rotation_matrix[9]) + temp_selection_inst.y;
				var temp_selection_tri_a_world_position_z = temp_selection_tri_a_elevation * (temp_selection_tri_ax * temp_selection_rotation_matrix[2] + temp_selection_tri_ay * temp_selection_rotation_matrix[6] + temp_selection_tri_az * temp_selection_rotation_matrix[10]) + temp_selection_inst.z;
				
				var temp_selection_tri_b_world_position_x = temp_selection_tri_b_elevation * (temp_selection_tri_bx * temp_selection_rotation_matrix[0] + temp_selection_tri_by * temp_selection_rotation_matrix[4] + temp_selection_tri_bz * temp_selection_rotation_matrix[8]) + temp_selection_inst.x;
				var temp_selection_tri_b_world_position_y = temp_selection_tri_b_elevation * (temp_selection_tri_bx * temp_selection_rotation_matrix[1] + temp_selection_tri_by * temp_selection_rotation_matrix[5] + temp_selection_tri_bz * temp_selection_rotation_matrix[9]) + temp_selection_inst.y;
				var temp_selection_tri_b_world_position_z = temp_selection_tri_b_elevation * (temp_selection_tri_bx * temp_selection_rotation_matrix[2] + temp_selection_tri_by * temp_selection_rotation_matrix[6] + temp_selection_tri_bz * temp_selection_rotation_matrix[10]) + temp_selection_inst.z;
				
				var temp_selection_tri_c_world_position_x = temp_selection_tri_c_elevation * (temp_selection_tri_cx * temp_selection_rotation_matrix[0] + temp_selection_tri_cy * temp_selection_rotation_matrix[4] + temp_selection_tri_cz * temp_selection_rotation_matrix[8]) + temp_selection_inst.x;
				var temp_selection_tri_c_world_position_y = temp_selection_tri_c_elevation * (temp_selection_tri_cx * temp_selection_rotation_matrix[1] + temp_selection_tri_cy * temp_selection_rotation_matrix[5] + temp_selection_tri_cz * temp_selection_rotation_matrix[9]) + temp_selection_inst.y;
				var temp_selection_tri_c_world_position_z = temp_selection_tri_c_elevation * (temp_selection_tri_cx * temp_selection_rotation_matrix[2] + temp_selection_tri_cy * temp_selection_rotation_matrix[6] + temp_selection_tri_cz * temp_selection_rotation_matrix[10]) + temp_selection_inst.z;
				
				// Find Pathfinding Node Triangle Portal Vertices Screen Positions
				var temp_selection_tri_a_screen_position = world_position_to_screen_position(temp_selection_tri_a_world_position_x, temp_selection_tri_a_world_position_y, temp_selection_tri_a_world_position_z, camera_view_matrix, camera_projection_matrix);
				var temp_selection_tri_b_screen_position = world_position_to_screen_position(temp_selection_tri_b_world_position_x, temp_selection_tri_b_world_position_y, temp_selection_tri_b_world_position_z, camera_view_matrix, camera_projection_matrix);
				var temp_selection_tri_c_screen_position = world_position_to_screen_position(temp_selection_tri_c_world_position_x, temp_selection_tri_c_world_position_y, temp_selection_tri_c_world_position_z, camera_view_matrix, camera_projection_matrix);
				
				// Find Barycentric Coordinate Values of the (Closest Point to the) Cursor Position within Selection Node's World Triangle Transposed as a Screen Position Triangle
				var temp_selection_tri_barycentric_values = closest_point_in_triangle_barycentric
				(
					temp_selection_tri_a_screen_position[0], 
					temp_selection_tri_a_screen_position[1],
					temp_selection_tri_b_screen_position[0], 
					temp_selection_tri_b_screen_position[1],
					temp_selection_tri_c_screen_position[0], 
					temp_selection_tri_c_screen_position[1],
					GameManager.cursor_x,
					GameManager.cursor_y
				);
				
				// Set Selection Triangle's Position and Elevation as the Cursor Position's Barycentric Coordinates using the Selection Node's World Position Triangle Values
				temp_selection_tri_x = temp_selection_tri_ax * temp_selection_tri_barycentric_values[0] + temp_selection_tri_bx * temp_selection_tri_barycentric_values[1] + temp_selection_tri_cx * temp_selection_tri_barycentric_values[2];
				temp_selection_tri_y = temp_selection_tri_ay * temp_selection_tri_barycentric_values[0] + temp_selection_tri_by * temp_selection_tri_barycentric_values[1] + temp_selection_tri_cy * temp_selection_tri_barycentric_values[2];
				temp_selection_tri_z = temp_selection_tri_az * temp_selection_tri_barycentric_values[0] + temp_selection_tri_bz * temp_selection_tri_barycentric_values[1] + temp_selection_tri_cz * temp_selection_tri_barycentric_values[2];
				temp_selection_tri_elevation = temp_selection_tri_ae * temp_selection_tri_barycentric_values[0] + temp_selection_tri_be * temp_selection_tri_barycentric_values[1] + temp_selection_tri_ce * temp_selection_tri_barycentric_values[2];
				
				// Delete Unused Array
				array_resize(temp_selection_tri_barycentric_values, 0);
				
				// Check if Celestial Object is being Observed and Celestial Simulator's Render Object Selected Instance Exists
				if (instance_exists(camera_observing_instance) and instance_exists(render_object_selected_instance))
				{
					// Perform Render Object Selected Instance's Input Behaviour Tree
					if (temp_input_action and !input_action)
					{
						// Action Input Behaviour
						switch (render_object_selected_instance.celestial_render_object_type)
						{
							case CelestialRenderObjectType.Unit:
								// Unit Action Behaviour - Pathfinding
								if (temp_selection_inst == render_object_selected_instance.celestial_body_instance)
								{
									// Establish Pathfinding Goal Variables
									var temp_pathfinding_goal_node_index = temp_selection_node_index;
									var temp_pathfinding_goal_x = temp_selection_tri_x;
									var temp_pathfinding_goal_y = temp_selection_tri_y;
									var temp_pathfinding_goal_z = temp_selection_tri_z;
									var temp_pathfinding_goal_elevation = temp_selection_tri_elevation;
									
									// Check if Action Render Object was selected as an Action and is on the same Celestial Body Instance as the Selected Render Object Instance
									if (instance_exists(temp_render_object_action_inst) and temp_render_object_action_inst.celestial_body_instance == render_object_selected_instance.celestial_body_instance)
									{
										// Set new Pathfinding Goal Behaviour based on Action Render Object Type
										switch (temp_render_object_action_inst.celestial_render_object_type)
										{
											case CelestialRenderObjectType.Unit:
												// Check if Action Unit is Pathfinding
												if (is_undefined(temp_render_object_action_inst.pathfinding_path))
												{
													// Set Pathfinding Goal as Action Unit's Position
													temp_pathfinding_goal_node_index = temp_render_object_action_inst.pathfinding_node_index;
													temp_pathfinding_goal_x = temp_render_object_action_inst.pathfinding_position_x;
													temp_pathfinding_goal_y = temp_render_object_action_inst.pathfinding_position_y;
													temp_pathfinding_goal_z = temp_render_object_action_inst.pathfinding_position_z;
													temp_pathfinding_goal_elevation = temp_render_object_action_inst.pathfinding_position_elevation;
												}
												else
												{
													// Set Pathfinding Goal as Action Unit's Pathfinding Path Endpoint
													temp_pathfinding_goal_node_index = ds_list_find_value(temp_render_object_action_inst.pathfinding_path.node_index, temp_render_object_action_inst.pathfinding_path.path_size - 1);
													temp_pathfinding_goal_x = ds_list_find_value(temp_render_object_action_inst.pathfinding_path.position_x, temp_render_object_action_inst.pathfinding_path.path_size - 1);
													temp_pathfinding_goal_y = ds_list_find_value(temp_render_object_action_inst.pathfinding_path.position_y, temp_render_object_action_inst.pathfinding_path.path_size - 1);
													temp_pathfinding_goal_z = ds_list_find_value(temp_render_object_action_inst.pathfinding_path.position_z, temp_render_object_action_inst.pathfinding_path.path_size - 1);
													temp_pathfinding_goal_elevation = ds_list_find_value(temp_render_object_action_inst.pathfinding_path.position_elevation, temp_render_object_action_inst.pathfinding_path.path_size - 1);
												}
												break;
											case CelestialRenderObjectType.City:
												// Set Pathfinding Goal as Action City's Position
												temp_pathfinding_goal_node_index = temp_render_object_action_inst.pathfinding_node_index;
												temp_pathfinding_goal_x = temp_selection_inst.pathfinding_node_x_array[temp_render_object_action_inst.pathfinding_node_index];
												temp_pathfinding_goal_y = temp_selection_inst.pathfinding_node_y_array[temp_render_object_action_inst.pathfinding_node_index];
												temp_pathfinding_goal_z = temp_selection_inst.pathfinding_node_z_array[temp_render_object_action_inst.pathfinding_node_index];
												temp_pathfinding_goal_elevation = temp_selection_inst.pathfinding_node_elevation_array[temp_render_object_action_inst.pathfinding_node_index];
												break;
											default:
												break;
										}
									}
									
									// Initiate Unit Pathfinding Behaviour
									celestial_pathfinding(render_object_selected_instance.celestial_body_instance, render_object_selected_instance, temp_pathfinding_goal_node_index, temp_pathfinding_goal_x, temp_pathfinding_goal_y, temp_pathfinding_goal_z, temp_pathfinding_goal_elevation);
								}
								else
								{
									// Behaviour for Pathfinding to Location that the Unit is not currently on
								}
								break;
							case CelestialRenderObjectType.City:
							case CelestialRenderObjectType.Satellite:
							default:
								break;
						}
					}
					else if (temp_input_select and !input_select)
					{
						// Select Input Behaviour
						switch (render_object_selected_instance.celestial_render_object_type)
						{
							case CelestialRenderObjectType.Unit:
							case CelestialRenderObjectType.City:
							case CelestialRenderObjectType.Satellite:
							default:
								break;
						}
					}
				}
			}
		}
		
		// Check for Camera Observing Instance Click Drag Behaviour
		if (temp_input_select and !instance_exists(temp_render_object_selected_inst) and instance_exists(camera_observing_instance) and temp_selection_inst == camera_observing_instance)
		{
			// Determine if Input is New or if Input Drag has occured
			if (!input_select)
			{
				// Input is New - Set Camera Observing Instance Click Drag Position Variables
				camera_observing_drag_start_x = GameManager.cursor_x;
				camera_observing_drag_start_y = GameManager.cursor_y;
			}
			else if (point_distance(camera_observing_drag_start_x, camera_observing_drag_start_y, GameManager.cursor_x, GameManager.cursor_y) > 2)
			{
				// Input is Drag Movement - Enable Click Drag Behaviour & Set Camera Observing Instance Click Drag Position and Angle Variables
				camera_observing_drag = true;
				
				camera_observing_drag_start_x = GameManager.cursor_x;
				camera_observing_drag_start_y = GameManager.cursor_y;
				
				camera_observing_drag_polar_horizontal_angle = camera_observing_polar_horizontal_angle;
				camera_observing_drag_polar_vertical_angle = camera_observing_polar_vertical_angle;
			}
		}
		
		// Delete Unused Array
		array_resize(temp_selection_rotation_matrix, 0);
		array_resize(temp_selection_rotation_matrix_inverse, 0);
	}
}

// Calculate Triangle UI Animation Behaviour
if (selected_unit_movement_path_entries > 0)
{
	// Update Triangle UI Animation Timers and Values
	triangle_animation_value += triangle_animation_speed * frame_delta;
	triangle_animation_value = triangle_animation_value mod 1;
	
	triangle_breath_value = triangle_breath_padding * ((sin(triangle_animation_value * 2 * pi) * 0.5) + 0.5);
	triangle_draw_angle = triangle_angle + (triangle_rotate_range * ((sin(triangle_animation_value * 2 * pi * triangle_rotate_spd) * 0.5) + 0.5));
	
	// Update Triangle UI Animation Geometry Behaviour
	tri_x_1 = rot_dist_x(triangle_radius, triangle_draw_angle);
	tri_y_1 = rot_dist_y(triangle_radius);
	tri_x_2 = rot_dist_x(triangle_radius, triangle_draw_angle - 130);
	tri_y_2 = rot_dist_y(triangle_radius);
	tri_x_3 = rot_dist_x(triangle_radius, triangle_draw_angle + 130);
	tri_y_3 = rot_dist_y(triangle_radius);
}

// Update Celestial Simulator's Input Variables
input_select = temp_input_select;
input_action = temp_input_action;

// Delete Unused Array
array_resize(temp_cursor_raycast, 0);
