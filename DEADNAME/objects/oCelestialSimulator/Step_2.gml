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

#region Cursor Input Collision
// Celestial Simulator Input Behaviour
var temp_input_select = mouse_check_button(mb_left);
var temp_input_action = mouse_check_button(mb_right);

// Establish Empty Sub Object Selection Variables
var temp_sub_object_click_inst = noone;
var temp_sub_object_action_inst = noone;
var temp_sub_object_selected_inst = noone;

// Sub Object Selection Behaviour
if (((!temp_input_select and input_select) or (temp_input_action and !input_action)) and !camera_observing_drag)
{
	// Check if Celestial Simulator is Observing a Celestial Body Instance with Sub Objects Enabled and is Zoomed In
	if (instance_exists(camera_observing_instance) and camera_observing_instance.sub_objects_render_enabled and camera_observing_instance_radius_offset_value <= camera_observing_instance_radius_offset_zoom_in_threshold)
	{
		// Iterate through all Celestial Sub Object Instances in Observing Instance's Sub Object Front Layer for Cursor Collisions
		var temp_sub_object_index = 0;
		var temp_sub_object_count = array_length(camera_observing_instance.sub_objects_front_layer_index_array);
		
		repeat (temp_sub_object_count)
		{
			// Find Sub Object Index and Instance
			var temp_sub_object_sorted_index = camera_observing_instance.sub_objects_front_layer_index_array[temp_sub_object_index];
			var temp_sub_object_sorted_instance = camera_observing_instance.sub_objects_front_layer_instance_array[temp_sub_object_sorted_index];
			
			// Check for Sub Object Instance's Collision with Cursor
			if (position_meeting(GameManager.cursor_x, GameManager.cursor_y, temp_sub_object_sorted_instance))
			{
				// Establish Sorted Sub Object Selection Variables
				var temp_sorted_sub_object_can_be_selected = true;
				
				// Check if Sub Object has Selection Conditions
				switch (temp_sub_object_sorted_instance.celestial_sub_object_type)
				{
					case CelestialSubObjectType.Unit:
						// Allow Units of all Factions for Action Behaviour but Limit Unit Selection to Units belonging to Player's Faction
						temp_sorted_sub_object_can_be_selected = (temp_input_action and !input_action) or temp_sub_object_sorted_instance.unit_faction == player_faction;
						break;
					case CelestialSubObjectType.Battle:
						// Limit Battle Selection to Battles involving the Player's Faction
						temp_sorted_sub_object_can_be_selected = instance_exists(player_faction) and array_get_index(temp_sub_object_sorted_instance.battle_factions, player_faction) != -1;
						break;
					default:
						break;
				}
				
				// Check if Sub Object can be Selected
				if (temp_sorted_sub_object_can_be_selected)
				{
					temp_sub_object_click_inst = temp_sub_object_sorted_instance;
				}
			}
			
			// Increment Sub Object Index
			temp_sub_object_index++;
		}
	}
	
	// Update Celestial Simulator's Sub Object Selected Instance with the possible Selection
	if (temp_input_action and !input_action)
	{
		// New Action Input Sub Object
		temp_sub_object_action_inst = temp_sub_object_click_inst;
	}
	else if (!temp_input_select and input_select)
	{
		// New Select Input Sub Object
		select_sub_object_instance(temp_sub_object_click_inst);
		temp_sub_object_selected_inst = temp_sub_object_click_inst;
	}
}
#endregion

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
	var temp_celestial_object_count = array_length(temp_solar_system);
	
	repeat (temp_celestial_object_count)
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
	
	#region Cursor Raycast Collision
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
		var temp_selection_rotation_matrix = temp_selection_inst.rotation_matrix;
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
			var temp_pathfinding_group_count = array_length(temp_selection_inst.pathfinding_group_direction_array);
			
			repeat (temp_pathfinding_group_count)
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
				var temp_pathfinding_node_count = array_length(temp_selection_inst.pathfinding_group_node_index_array[temp_selection_group_index]);
				
				repeat (temp_pathfinding_node_count)
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
				
				// Check if Celestial Object is being Observed and Celestial Simulator's Sub Object Selected Instance Exists
				if (instance_exists(camera_observing_instance) and instance_exists(sub_object_selected_instance))
				{
					// Perform Sub Object Selected Instance's Input Behaviour Tree
					if (temp_input_action and !input_action)
					{
						// Action Input Behaviour
						switch (sub_object_selected_instance.celestial_sub_object_type)
						{
							case CelestialSubObjectType.Unit:
								// Unit Action Behaviour - Pathfinding
								if (temp_selection_inst == sub_object_selected_instance.celestial_body_instance)
								{
									// Establish Pathfinding Goal Variables
									var temp_pathfinding_goal_node_index = temp_selection_node_index;
									var temp_pathfinding_goal_x = temp_selection_tri_x;
									var temp_pathfinding_goal_y = temp_selection_tri_y;
									var temp_pathfinding_goal_z = temp_selection_tri_z;
									var temp_pathfinding_goal_elevation = temp_selection_tri_elevation;
									
									// Reset Selected Unit's Behaviour to None
									sub_object_selected_instance.unit_behaviour = CelestialUnitBehaviourType.None;
									sub_object_selected_instance.unit_behaviour_target_instance = noone;
									sub_object_selected_instance.unit_behaviour_target_node_index = -1;
									
									// Check Unit Pathfinding Action Behaviour Conditions
									if (sub_object_selected_instance.engaged_in_battle)
									{
										// Unit is currently engaged in Battle and Pathfinding to a new Location is considered Retreating - Change their Unit Behaviour to "Retreat" before Pathfinding to their new Location
										sub_object_selected_instance.unit_behaviour = CelestialUnitBehaviourType.Retreat;
									}
									else if (instance_exists(temp_sub_object_action_inst) and temp_sub_object_action_inst.celestial_body_instance == sub_object_selected_instance.celestial_body_instance)
									{
										// Action Sub Object was selected as an Action and is on the same Celestial Body Instance as the Selected Sub Object Instance - Set new Pathfinding Goal Behaviour based on Action Sub Object Type
										switch (temp_sub_object_action_inst.celestial_sub_object_type)
										{
											case CelestialSubObjectType.Unit:
												// Establish Action Unit Movement Variables
												var temp_unit_movement_behaviour_type = CelestialUnitBehaviourType.None;
												
												// Check Selected Unit's Faction Relationship to the Action Unit's Faction
												if (sub_object_selected_instance.unit_faction == temp_sub_object_action_inst.unit_faction)
												{
													temp_unit_movement_behaviour_type = CelestialUnitBehaviourType.Regroup;
												}
												else if (instance_exists(sub_object_selected_instance.unit_faction) and ds_map_find_value(sub_object_selected_instance.unit_faction.relationships, temp_sub_object_action_inst.unit_faction) == CelestialFactionRelationshipType.Hostile)
												{
													temp_unit_movement_behaviour_type = CelestialUnitBehaviourType.Attack;
												}
												
												// Check if Action Unit is Pathfinding
												if (temp_unit_movement_behaviour_type == CelestialUnitBehaviourType.Regroup and !is_undefined(temp_sub_object_action_inst.pathfinding_path))
												{
													// Set Pathfinding Goal as Action Unit's Pathfinding Path Endpoint
													temp_pathfinding_goal_node_index = ds_list_find_value(temp_sub_object_action_inst.pathfinding_path.node_index, temp_sub_object_action_inst.pathfinding_path.path_size - 1);
													temp_pathfinding_goal_x = ds_list_find_value(temp_sub_object_action_inst.pathfinding_path.position_x, temp_sub_object_action_inst.pathfinding_path.path_size - 1);
													temp_pathfinding_goal_y = ds_list_find_value(temp_sub_object_action_inst.pathfinding_path.position_y, temp_sub_object_action_inst.pathfinding_path.path_size - 1);
													temp_pathfinding_goal_z = ds_list_find_value(temp_sub_object_action_inst.pathfinding_path.position_z, temp_sub_object_action_inst.pathfinding_path.path_size - 1);
													temp_pathfinding_goal_elevation = ds_list_find_value(temp_sub_object_action_inst.pathfinding_path.position_elevation, temp_sub_object_action_inst.pathfinding_path.path_size - 1);
												}
												else
												{
													// Set Pathfinding Goal as Action Unit's Position
													temp_pathfinding_goal_node_index = temp_sub_object_action_inst.pathfinding_node_index;
													temp_pathfinding_goal_x = temp_sub_object_action_inst.pathfinding_position_x;
													temp_pathfinding_goal_y = temp_sub_object_action_inst.pathfinding_position_y;
													temp_pathfinding_goal_z = temp_sub_object_action_inst.pathfinding_position_z;
													temp_pathfinding_goal_elevation = temp_sub_object_action_inst.pathfinding_position_elevation;
												}
												
												// Set Selected Unit's Behaviour and Target Instance
												sub_object_selected_instance.unit_behaviour = temp_unit_movement_behaviour_type;
												sub_object_selected_instance.unit_behaviour_target_instance = temp_unit_movement_behaviour_type != CelestialUnitBehaviourType.None ? temp_sub_object_action_inst : noone;
												break;
											case CelestialSubObjectType.City:
												// Set Pathfinding Goal as Action City's Position
												temp_pathfinding_goal_node_index = temp_sub_object_action_inst.pathfinding_node_index;
												temp_pathfinding_goal_x = temp_selection_inst.pathfinding_node_x_array[temp_sub_object_action_inst.pathfinding_node_index];
												temp_pathfinding_goal_y = temp_selection_inst.pathfinding_node_y_array[temp_sub_object_action_inst.pathfinding_node_index];
												temp_pathfinding_goal_z = temp_selection_inst.pathfinding_node_z_array[temp_sub_object_action_inst.pathfinding_node_index];
												temp_pathfinding_goal_elevation = temp_selection_inst.pathfinding_node_elevation_array[temp_sub_object_action_inst.pathfinding_node_index];
												break;
											default:
												break;
										}
									}
									
									// Initiate Unit Pathfinding Behaviour
									celestial_pathfinding(sub_object_selected_instance.celestial_body_instance, sub_object_selected_instance, temp_pathfinding_goal_node_index, temp_pathfinding_goal_x, temp_pathfinding_goal_y, temp_pathfinding_goal_z, temp_pathfinding_goal_elevation);
								}
								else
								{
									// Behaviour for Pathfinding to a Location on a Celestial Body that the Unit Instance is not currently on
								}
								break;
							case CelestialSubObjectType.City:
							case CelestialSubObjectType.Satellite:
							case CelestialSubObjectType.Battle:
							default:
								break;
						}
					}
					else if (temp_input_select and !input_select)
					{
						// Select Input Behaviour
						switch (sub_object_selected_instance.celestial_sub_object_type)
						{
							case CelestialSubObjectType.Unit:
							case CelestialSubObjectType.City:
							case CelestialSubObjectType.Satellite:
							case CelestialSubObjectType.Battle:
							default:
								break;
						}
					}
				}
			}
		}
		
		// Check for Camera Observing Instance Click Drag Behaviour
		if (temp_input_select and !instance_exists(temp_sub_object_selected_inst) and instance_exists(camera_observing_instance) and temp_selection_inst == camera_observing_instance)
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
				
				// Check if Sub Object Selected Instance Exists
				if (instance_exists(sub_object_selected_instance))
				{
					// Deselect Sub Object Behaviour
					switch (sub_object_selected_instance.celestial_sub_object_type)
					{
						case CelestialSubObjectType.Battle:
							// Deselect Battle Instance
							sub_object_selected_instance = noone;
							break;
						case CelestialSubObjectType.Unit:
						case CelestialSubObjectType.City:
						case CelestialSubObjectType.Satellite:
						default:
							break;
					}
				}
			}
		}
		
		// Delete Unused Array
		array_resize(temp_selection_rotation_matrix_inverse, 0);
	}
	#endregion
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

#region Selected UI Behaviour
// Selected Celestial Sub Object UI Behaviour
if (instance_exists(sub_object_selected_instance))
{
	// Determine Behaviour based on Selected Celestial Sub Object Type
	if (sub_object_selected_instance.celestial_sub_object_type == CelestialSubObjectType.Unit)
	{
		// Celestial Unit Selected UI Behaviour
	}
	else if (sub_object_selected_instance.celestial_sub_object_type == CelestialSubObjectType.Battle)
	{
		// Celestial Battle Selected UI Behaviour
		array_resize(battle_choreography_stack, 0);
		
		// Check if Battle is Rendering its Choreography Stack
		if (!battle_platform_animation)
		{
			// Perform Battle Choreography Stack Rendering Pre-Calculation
			calculate_celestial_battle_choreography_stack();
		}
		
		// Check if Camera is Observing a Battle on a valid Celestial Body Instance and Move Camera to face Battle
		if (instance_exists(camera_observing_instance) and sub_object_selected_instance.celestial_body_instance == camera_observing_instance)
		{
			// Update Battle's Local UV Position
			sub_object_selected_instance.local_position_u = 0.5 - arctan2(-sub_object_selected_instance.battle_x, -sub_object_selected_instance.battle_z) / (2 * pi);
			sub_object_selected_instance.local_position_v = 0.5 - arcsin(sub_object_selected_instance.battle_y) / pi;
			
			// Lerp Battle's Camera Movement Value
			battle_camera_observing_lerp += battle_camera_observing_lerp_spd * frame_delta;
			battle_camera_observing_lerp = clamp(battle_camera_observing_lerp, 0, 1);
			
			// Calculate Animation Curve for Battle's Camera Movement Value
			var temp_battle_camera_observing_lerp_value = power(battle_camera_observing_lerp, battle_camera_observing_lerp_multiplier);
			
			// Calculate Camera's new Polar Horizontal & Vertical Angles
			var temp_battle_target_camera_observing_polar_horizontal_angle = ((sub_object_selected_instance.local_position_u + 0.25) mod 1) * 360;
			var temp_battle_target_camera_observing_polar_vertical_angle = lerp(89.5, -89.5, sub_object_selected_instance.local_position_v);
			
			// Adjust Camera's Observing Polar Horizontal & Vertical based on the lerped Battle's Camera Movement Value
			camera_observing_polar_horizontal_angle = battle_camera_observing_polar_horizontal_angle + angle_difference(temp_battle_target_camera_observing_polar_horizontal_angle, battle_camera_observing_polar_horizontal_angle) * temp_battle_camera_observing_lerp_value;
			camera_observing_polar_vertical_angle = battle_camera_observing_polar_vertical_angle + angle_difference(temp_battle_target_camera_observing_polar_vertical_angle, battle_camera_observing_polar_vertical_angle) * temp_battle_camera_observing_lerp_value;
		}
	}
}
#endregion
