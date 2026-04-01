/// @description Cursor Selection & UI Event
// Performs the Celestial Simulator's Cursor Selection, Observation Instance Movement, Inspection, & UI Behaviours after all Celestial Objects have been depth sorted in the Step Event

// Check if Celestial Simulator is Active
if (!active)
{
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

// Calculate Cursor's Screen to World Raycast Vector
var temp_cursor_raycast = screen_position_to_world_vector(GameManager.cursor_x, GameManager.cursor_y, camera_view_matrix, camera_projection_matrix);

// Check for Celestial Simulator Selection & Action Input
var temp_click_behaviour = mouse_check_button(mb_left);
var temp_action_behaviour = mouse_check_button(mb_right);

// Celestial Simulator Selection & Action Behaviour
if (camera_observing_drag)
{
	// Check if Click Drag Behaviour has Finished
	if (!temp_click_behaviour)
	{
		camera_observing_drag = false;
	}
}
else if (temp_click_behaviour or temp_action_behaviour)
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
		temp_selection_y /= -temp_selection_magnitude;
		temp_selection_z /= temp_selection_magnitude;
		
		// Find the Selection's UV Coordinates of the Localized Selection Position
		//var temp_selection_u = 0.5 - arctan2(-temp_selection_x, -temp_selection_z) / (2 * pi);
		//var temp_selection_v = 0.5 - arcsin(-temp_selection_y) / pi;
		
		// Check if Selected Celestial Object has Pathfinding Enabled
		if (temp_selection_inst.pathfinding_enabled)
		{
			// Establish Default Pathfinding Node Selection
			var temp_selection_node_index = -1;
			var temp_selection_node_dot_product = -1;
			
			// Iterate through all Pathfinding Nodes to find closest Pathfinding Node to Selection Position on Celestial Object
			var temp_pathfinding_node_index = 0;
			
			repeat (temp_selection_inst.pathfinding_nodes_count)
			{
				// Establish Pathfinding Node's Normalized Sphere Vector
				var temp_node_vector_x = temp_selection_inst.pathfinding_node_x_array[temp_pathfinding_node_index];
				var temp_node_vector_y = temp_selection_inst.pathfinding_node_y_array[temp_pathfinding_node_index];
				var temp_node_vector_z = temp_selection_inst.pathfinding_node_z_array[temp_pathfinding_node_index];
				
				// Calculate Dot Product of Pathfinding Node's Normalized Sphere Vector and the Selection Position's Normalized Sphere Vector
				var temp_comparison_dot_product = dot_product_3d(temp_selection_x, temp_selection_y, temp_selection_z, temp_node_vector_x, temp_node_vector_y, temp_node_vector_z);
				
				// Compare the new Dot Product of the Pathfinding Node to the Selection Pathfinding Node's Dot Product
				if (temp_comparison_dot_product > temp_selection_node_dot_product)
				{
					// Update Selection Node Index and Dot Product
					temp_selection_node_index = temp_pathfinding_node_index;
					temp_selection_node_dot_product = temp_comparison_dot_product;
				}
				
				// Increment Pathfinding Node Index
				temp_pathfinding_node_index++;
			}
			
			// Check if Selection Node Index Exists
			if (temp_selection_node_index != -1)
			{
				//
				
				//show_debug_message($"[{temp_selection_inst.pathfinding_node_region_array[temp_selection_node_index]}]");
			}
		}
		
		// Check for Camera Observing Instance Click Drag Behaviour
		if (instance_exists(camera_observing_instance) and temp_selection_inst == camera_observing_instance and temp_click_behaviour)
		{
			// Enable Click Drag Behaviour
			camera_observing_drag = true;
			camera_observing_drag_start_x = GameManager.cursor_x;
			camera_observing_drag_start_y = GameManager.cursor_y;
			camera_observing_drag_polar_horizontal_angle = camera_observing_polar_horizontal_angle;
			camera_observing_drag_polar_vertical_angle = camera_observing_polar_vertical_angle;
		}
	}
}