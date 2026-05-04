/// @description Celestial Object Behaviour
// Iterates through all Celestial Objects within the Simulator to perform their Behaviours while orienting their Orbital Positions and Rotations

// Increment Celestial Simulator's Global Noise Clock
global_noise_time += global_noise_time_spd * frame_delta;
global_noise_time = global_noise_time mod 1;

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Increment Celestial Simulator's Global Clocks
global_clock_delta_time = global_clock_delta_time_multiplier * frame_delta;

global_hydrosphere_time += global_clock_hydrosphere_delta_time_multiplier * global_clock_delta_time;
global_hydrosphere_time = global_hydrosphere_time mod 9999999; // please don't overflow

// Reset all Light Sources
var temp_light_source_index = CelestialSimMaxLights;

repeat (CelestialSimMaxLights)
{
	// Decrement Light Source Index
	temp_light_source_index--;
	
	// Reset Light Source to Default State
	light_source_exists[temp_light_source_index] = 0;
	
	light_source_position_x[temp_light_source_index] = 0;
	light_source_position_y[temp_light_source_index] = 0;
	light_source_position_z[temp_light_source_index] = 0;
	
	light_source_color_r[temp_light_source_index] = 0;
	light_source_color_g[temp_light_source_index] = 0;
	light_source_color_b[temp_light_source_index] = 0;
	
	light_source_radius[temp_light_source_index] = 0;
	light_source_falloff[temp_light_source_index] = 0;
	light_source_intensity[temp_light_source_index] = 0;
	light_source_emitter_size[temp_light_source_index] = 0;
}

// Iterate through all Solar Systems within the Celestial Simulation
var temp_solar_systems_index = 0;
	
repeat (array_length(solar_systems))
{
	// Find the Solar System at the given Solar System Index
	var temp_solar_system = solar_systems[temp_solar_systems_index];
	
	// Find the Solar System's Orbit Update Order Array at the given Solar System Index
	var temp_solar_system_orbit_update_order = solar_systems_orbit_update_order[temp_solar_systems_index];
	
	// Iterate through all the Celestial Objects within the given Solar System
	var temp_celestial_object_index = 0;
	
	repeat (array_length(temp_solar_system))
	{
		// Find the given Celestial Object at the given Celestial Object Orbit Update Order Index within the Solar System's Celestial Objects Array
		var temp_celestial_object = temp_solar_system[temp_solar_system_orbit_update_order[temp_celestial_object_index]];
		
		// Perform Celestial Object Simulation
		with (temp_celestial_object)
		{
			// Update Celestial Object's Rotation around Y Axis
			euler_angle_y += rotation_speed * CelestialSimulator.global_clock_delta_time;
			euler_angle_y = ((euler_angle_y mod 360) + 360) mod 360;
			
			// Update Orbital Rotation around Solar System's Origin
			orbit_rotation += orbit_speed * CelestialSimulator.global_clock_delta_time;
			orbit_rotation = ((orbit_rotation mod 360) + 360) mod 360;
			
			// Calculate Local Orbit Position Offset from Orbit Parent
			var temp_orbit_x = lengthdir_x(orbit_size, orbit_rotation);
			var temp_orbit_y = 0;
			var temp_orbit_z = lengthdir_y(orbit_size, orbit_rotation);
			
			// Create Celestial Object's Orbit Rotation Matrix its Orbit Rotation Euler Angles
			var temp_orbit_rotation_matrix = rotation_matrix_from_euler_angles(orbit_euler_angle_x, orbit_euler_angle_y, orbit_euler_angle_z);
			
			// Update Position within Solar System's Space based on Orbital Rotation
			x = orbit_offset_x + (temp_orbit_x * temp_orbit_rotation_matrix[0] + temp_orbit_y * temp_orbit_rotation_matrix[4] + temp_orbit_z * temp_orbit_rotation_matrix[8]);
			y = orbit_offset_y + (temp_orbit_x * temp_orbit_rotation_matrix[1] + temp_orbit_y * temp_orbit_rotation_matrix[5] + temp_orbit_z * temp_orbit_rotation_matrix[9]);
			z = orbit_offset_z + (temp_orbit_x * temp_orbit_rotation_matrix[2] + temp_orbit_y * temp_orbit_rotation_matrix[6] + temp_orbit_z * temp_orbit_rotation_matrix[10]);
			
			// Check if Orbit Parent Exists
			if (instance_exists(orbit_parent_instance))
			{
				x += orbit_parent_instance.x;
				y += orbit_parent_instance.y;
				z += orbit_parent_instance.z;
			}
			
			// Establish Minimum Elevation
			var temp_celestial_object_minimum_elevation = 0;
			
			// Celestial Object Type Behaviour
			switch (celestial_object_type)
			{
				case CelestialObjectType.Planet:
					// Planet Simulation Behaviour
					render_depth_radius = radius + elevation + (sky ? sky_radius : CelestialSimulator.global_no_atmosphere_radius_padding);
					frustum_culling_radius = radius + elevation + (sky ? sky_radius : CelestialSimulator.global_no_atmosphere_radius_padding);
					temp_celestial_object_minimum_elevation = ocean_elevation;
					break;
				case CelestialObjectType.Sun:
					// Sun Simulation Behaviour
					if (CelestialSimulator.solar_system_index == temp_solar_systems_index)
					{
						// Set Sun's Light Source Properties
						CelestialSimulator.light_source_exists[temp_light_source_index] = 1;
						
						CelestialSimulator.light_source_position_x[temp_light_source_index] = x;
						CelestialSimulator.light_source_position_y[temp_light_source_index] = y;
						CelestialSimulator.light_source_position_z[temp_light_source_index] = z;
						
						CelestialSimulator.light_source_color_r[temp_light_source_index] = color_get_red(light_source_color) / 255;
						CelestialSimulator.light_source_color_g[temp_light_source_index] = color_get_green(light_source_color) / 255;
						CelestialSimulator.light_source_color_b[temp_light_source_index] = color_get_blue(light_source_color) / 255;
						
						CelestialSimulator.light_source_radius[temp_light_source_index] = light_source_radius;
						CelestialSimulator.light_source_falloff[temp_light_source_index] = light_source_distance_fade;
						CelestialSimulator.light_source_intensity[temp_light_source_index] = light_source_intensity;
						CelestialSimulator.light_source_emitter_size[temp_light_source_index] = radius;
						
						// Increment Light Source Index
						temp_light_source_index++;
					}
					
					// Set Sun Render Depth Radius and Frustum Culling Radius
					render_depth_radius = radius + elevation;
					frustum_culling_radius = radius + elevation;
					break;
				case CelestialObjectType.None:
				default:
					// Empty Celestial Object Type - Skip Behaviour
					break;
			}
			
			// Iterate through Celestial Object Unit Behaviours
			var temp_unit_index = 0;
			
			repeat (array_length(units))
			{
				// Find Unit Instance
				var temp_unit_instance = units[temp_unit_index];
				
				// Performm Action Behaviour
				switch (temp_unit_instance.unit_behaviour)
				{
					case CelestialUnitBehaviour.Attack:
					case CelestialUnitBehaviour.Regroup:
					case CelestialUnitBehaviour.Hunt:
					case CelestialUnitBehaviour.Garrison:
						// Check if Unit is already indexed in the Celestial Simulator's Pathfinding Queue
						if (ds_list_find_index(CelestialSimulator.pathfinding_queue_list, temp_unit_instance) != -1)
						{
							// Unit is already scheduled to Recalculate Pathfinding Behaviour - Early Break
							break;
						}
						
						// Check if Unit's Behaviour Target Instance still exists and shares the same Celestial Body Instance
						if (!instance_exists(temp_unit_instance.unit_behaviour_target_instance) or temp_unit_instance.celestial_body_instance != temp_unit_instance.unit_behaviour_target_instance.celestial_body_instance)
						{
							// Unit's Behaviour Target Instance is no longer valid - Reset Unit's Behaviour
							temp_unit_instance.unit_behaviour = CelestialUnitBehaviour.None;
							
							// Destroy Unit's Pathfinding Path Struct
							celestial_pathfinding_destroy_path(temp_unit_instance.pathfinding_path);
							
							// Reset Unit's Pathfinding Path
							temp_unit_instance.pathfinding_path = undefined;
							
							// Early Break
							break;
						}
						
						// Check if Unit's Pathfinding Path is still Valid
						if (is_undefined(temp_unit_instance.pathfinding_path))
						{
							// Schedule Unit to recalculate thier Pathfinding Path to the Unit's Behaviour Target Instance
							ds_list_add(CelestialSimulator.pathfinding_queue_list, temp_unit_instance);
						}
						else if (temp_unit_instance.unit_behaviour_target_instance.pathfinding_node_index != ds_list_find_value(temp_unit_instance.pathfinding_path.node_index, temp_unit_instance.pathfinding_path.path_size - 1))
						{
							// Schedule Unit to recalculate thier Pathfinding Path to the Unit's Behaviour Target Instance
							ds_list_add(CelestialSimulator.pathfinding_queue_list, temp_unit_instance);
						}
						else if (temp_unit_instance.unit_behaviour_target_instance.celestial_render_object_type == CelestialRenderObjectType.Unit)
						{
							// Update Pathfinding Path to end at the Target Instance's Position & Elevation
							ds_list_set(temp_unit_instance.pathfinding_path.position_x, temp_unit_instance.pathfinding_path.path_size - 1, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_x);
							ds_list_set(temp_unit_instance.pathfinding_path.position_y, temp_unit_instance.pathfinding_path.path_size - 1, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_y);
							ds_list_set(temp_unit_instance.pathfinding_path.position_z, temp_unit_instance.pathfinding_path.path_size - 1, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_z);
							ds_list_set(temp_unit_instance.pathfinding_path.position_elevation, temp_unit_instance.pathfinding_path.path_size - 1, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_elevation);
						}
						break;
					case CelestialUnitBehaviour.Patrol:
					case CelestialUnitBehaviour.None:
					default:
						break;
				}
				
				// Perform Movement Behaviour
				if (!is_undefined(temp_unit_instance.pathfinding_path))
				{
					// Establish Unit Movement Power
					var temp_movement_power = temp_unit_instance.unit_movement_power * CelestialSimulator.global_clock_delta_time;
					
					// Check if Unit Movement Behaviour is driven by the Celestial Object's Pathfinding Grid Movement or by an Alternative Movement Ruleset
					if (pathfinding_enabled)
					{
						// Check if Unit's Pathfinding Path Index is Valid
						if (temp_unit_instance.pathfinding_path_index < 0 or temp_unit_instance.pathfinding_path_index >= temp_unit_instance.pathfinding_path.path_size)
						{
							// Destroy Unit's Pathfinding Path Struct
							celestial_pathfinding_destroy_path(temp_unit_instance.pathfinding_path);
							
							// Reset Unit's Pathfinding Path
							temp_unit_instance.pathfinding_path = undefined;
						}
						else
						{
							// Perform Unit Pathfinding Movement
							while (temp_movement_power > 0)
							{
								// Find Unit Pathfinding Path Node Index
								var temp_pathfinding_node_index = ds_list_find_value(temp_unit_instance.pathfinding_path.node_index, temp_unit_instance.pathfinding_path_index);
								
								// Find Unit Pathfinding Path Current Elevation
								var temp_pathfinding_unit_elevation = temp_unit_instance.pathfinding_position_elevation;
								var temp_pathfinding_unit_position_elevation = radius + elevation * max(temp_pathfinding_unit_elevation, temp_celestial_object_minimum_elevation);
								
								// Find Unit Pathfinding Path Current Position
								var temp_pathfinding_unit_x = temp_unit_instance.pathfinding_position_x;
								var temp_pathfinding_unit_y = temp_unit_instance.pathfinding_position_y;
								var temp_pathfinding_unit_z = temp_unit_instance.pathfinding_position_z;
								
								var temp_pathfinding_unit_position_x = temp_pathfinding_unit_x * temp_pathfinding_unit_position_elevation;
								var temp_pathfinding_unit_position_y = temp_pathfinding_unit_y * temp_pathfinding_unit_position_elevation;
								var temp_pathfinding_unit_position_z = temp_pathfinding_unit_z * temp_pathfinding_unit_position_elevation;
								
								// Find Unit Pathfinding Path Target Elevation
								var temp_pathfinding_target_elevation = ds_list_find_value(temp_unit_instance.pathfinding_path.position_elevation, temp_unit_instance.pathfinding_path_index);
								var temp_pathfinding_target_position_elevation = radius + elevation * max(temp_pathfinding_target_elevation, temp_celestial_object_minimum_elevation);
								
								// Find Unit Pathfinding Path Target Position
								var temp_pathfinding_target_x = ds_list_find_value(temp_unit_instance.pathfinding_path.position_x, temp_unit_instance.pathfinding_path_index);
								var temp_pathfinding_target_y = ds_list_find_value(temp_unit_instance.pathfinding_path.position_y, temp_unit_instance.pathfinding_path_index);
								var temp_pathfinding_target_z = ds_list_find_value(temp_unit_instance.pathfinding_path.position_z, temp_unit_instance.pathfinding_path_index);
								
								var temp_pathfinding_target_position_x = temp_pathfinding_target_x * temp_pathfinding_target_position_elevation;
								var temp_pathfinding_target_position_y = temp_pathfinding_target_y * temp_pathfinding_target_position_elevation;
								var temp_pathfinding_target_position_z = temp_pathfinding_target_z * temp_pathfinding_target_position_elevation;
								
								// Update Unit Pathfinding Path Target if Pathing to Instance
								switch (temp_unit_instance.unit_behaviour)
								{
									case CelestialUnitBehaviour.Attack:
									case CelestialUnitBehaviour.Regroup:
									case CelestialUnitBehaviour.Hunt:
									case CelestialUnitBehaviour.Garrison:
										// Check if Target Instance exists and shares the current Node 
										if (instance_exists(temp_unit_instance.unit_behaviour_target_instance) and temp_pathfinding_node_index == temp_unit_instance.unit_behaviour_target_instance.pathfinding_node_index)
										{
											// Check if Target Instance is a Unit or another kind of Render Object Instance
											if (temp_unit_instance.unit_behaviour_target_instance.celestial_render_object_type == CelestialRenderObjectType.Unit)
											{
												temp_pathfinding_target_elevation = temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_elevation;
												temp_pathfinding_target_position_elevation = radius + elevation * max(temp_pathfinding_target_elevation, temp_celestial_object_minimum_elevation);
												
												temp_pathfinding_target_x = temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_x;
												temp_pathfinding_target_y = temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_y;
												temp_pathfinding_target_z = temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_z;
												
												temp_pathfinding_target_position_x = temp_pathfinding_target_x * temp_pathfinding_target_position_elevation;
												temp_pathfinding_target_position_y = temp_pathfinding_target_y * temp_pathfinding_target_position_elevation;
												temp_pathfinding_target_position_z = temp_pathfinding_target_z * temp_pathfinding_target_position_elevation;
											}
											
											// Update Path Size as that this Path Index is the Final Pathfinding Node in the Unit's Pathfinding Node List
											temp_unit_instance.pathfinding_path.path_size = temp_unit_instance.pathfinding_path_index;
										}
										break;
									case CelestialUnitBehaviour.Patrol:
									case CelestialUnitBehaviour.None:
									default:
										break;
								}
								
								// Find Unit Pathfinding Node Microbiome
								var temp_pathfinding_node_microbiome_type = microclimate_biome_type_array[pathfinding_node_microclimate_array[temp_pathfinding_node_index]];
								
								// Find Unit Pathfinding Node Microbiome Movement Cost Modifier
								var temp_pathfinding_microbiome_movement_cost_modifier = celestial_microclimate_biome_get_movement_cost_modifier(temp_pathfinding_node_microbiome_type);
								
								// Find Unit Pathfinding Remaining Distance
								var temp_pathfinding_remaining_distance = point_distance_3d(temp_pathfinding_unit_position_x, temp_pathfinding_unit_position_y, temp_pathfinding_unit_position_z, temp_pathfinding_target_position_x, temp_pathfinding_target_position_y, temp_pathfinding_target_position_z);
								
								// Find Unit Pathfinding Remaining Movement Cost
								var temp_pathfinding_remaining_movement_cost = temp_pathfinding_remaining_distance * temp_pathfinding_microbiome_movement_cost_modifier;
								
								// Find Unit Pathfinding Movement Spend
								var temp_pathfinding_movement_power_spend = min(temp_movement_power, temp_pathfinding_remaining_movement_cost);
								
								// Decrement Unit Movement Power
								temp_movement_power -= temp_pathfinding_remaining_movement_cost;
								
								// Calculate Pathfinding Path Progress Lerp Value
								var temp_pathfinding_path_lerp_value = temp_pathfinding_remaining_movement_cost <= 0 ? 1 : temp_pathfinding_movement_power_spend / temp_pathfinding_remaining_movement_cost;
								
								// Update Unit's Pathfinding Position & Elevation based on Pathfinding Path Progress
								temp_unit_instance.pathfinding_position_x = lerp(temp_pathfinding_unit_x, temp_pathfinding_target_x, temp_pathfinding_path_lerp_value);
								temp_unit_instance.pathfinding_position_y = lerp(temp_pathfinding_unit_y, temp_pathfinding_target_y, temp_pathfinding_path_lerp_value);
								temp_unit_instance.pathfinding_position_z = lerp(temp_pathfinding_unit_z, temp_pathfinding_target_z, temp_pathfinding_path_lerp_value);
								temp_unit_instance.pathfinding_position_elevation = lerp(temp_pathfinding_unit_elevation, temp_pathfinding_target_elevation, temp_pathfinding_path_lerp_value);
								
								// Find Celestial Unit's U Positions and convert them into Horizontal Angles from Celestial Body's Sphere Horizontal Wrap
								var temp_pathfinding_unit_position_u_angle = (0.5 - arctan2(-temp_pathfinding_unit_x, -temp_pathfinding_unit_z) / (2 * pi)) * 360;
								var temp_pathfinding_target_position_u_angle = (0.5 - arctan2(-temp_pathfinding_target_x, -temp_pathfinding_target_z) / (2 * pi)) * 360;
								
								// Update Unit's Sprite Facing Direction based on their Pathfinding Angle Difference
								var temp_pathfinding_horizontal_angle_difference = angle_difference(temp_pathfinding_target_position_u_angle, temp_pathfinding_unit_position_u_angle);
								temp_unit_instance.image_xscale = temp_pathfinding_horizontal_angle_difference != 0 ? sign(temp_pathfinding_horizontal_angle_difference) : temp_unit_instance.image_xscale;
								
								// Check if Unit's has made enough Path Progress to elapse to the next Pathfinding Node
								if (temp_pathfinding_path_lerp_value >= 1)
								{
									// Increment Unit's Pathfinding Path Index
									temp_unit_instance.pathfinding_path_index++;
									
									// Check if Unit has finished moving through their Pathfinding Path
									if (temp_unit_instance.pathfinding_path_index >= temp_unit_instance.pathfinding_path.path_size)
									{
										// Perform Unit's End Pathfinding Behaviour
										switch (temp_unit_instance.unit_behaviour)
										{
											case CelestialUnitBehaviour.Attack:
											case CelestialUnitBehaviour.Regroup:
											case CelestialUnitBehaviour.Hunt:
											case CelestialUnitBehaviour.Garrison:
											case CelestialUnitBehaviour.Patrol:
											case CelestialUnitBehaviour.None:
											default:
												temp_unit_instance.unit_behaviour = CelestialUnitBehaviour.None;
												break;
										}
										
										// Destroy Unit's Pathfinding Path Struct
										celestial_pathfinding_destroy_path(temp_unit_instance.pathfinding_path);
										
										// Reset Unit's Pathfinding Path
										temp_unit_instance.pathfinding_path = undefined;
										
										// Break from Movement Behaviour Loop
										break;
									}
									
									// Find Index of Unit Instance within Celestial Body's Pathfinding Node Unit Arrays
									var temp_pathfinding_node_unit_array_index = array_get_index(pathfinding_node_units_array[temp_unit_instance.pathfinding_node_index], temp_unit_instance);
									
									// Check if Unit Instance's Index within Celestial Body's Pathfinding Node Unit Array is valid
									if (temp_pathfinding_node_unit_array_index != -1)
									{
										// Delete Unit Instance from Celestial Body's Pathfinding Node Unit Array
										array_delete(pathfinding_node_units_array[temp_unit_instance.pathfinding_node_index], temp_pathfinding_node_unit_array_index, 1);
									}
									
									// Update Unit's Pathfinding Node Index
									temp_unit_instance.pathfinding_node_index = ds_list_find_value(temp_unit_instance.pathfinding_path.node_index, temp_unit_instance.pathfinding_path_index);
									
									// Add Unit Instance back to Celestial Body's Pathfinding Node Unit Array
									array_push(pathfinding_node_units_array[temp_unit_instance.pathfinding_node_index], temp_unit_instance);
								}
							}
						}
					}
					else
					{
						// Unit Movement based on the Celestial Object's Alternative Movement Ruleset
					}
				}
				
				// Increment Unit Index
				temp_unit_index++;
			}
			
			// Build Identity Matrix of Celestial Object
			matrix_build(x, y, z, euler_angle_x, euler_angle_y, euler_angle_z, scale_x, scale_y, scale_z, identity_matrix);
			
			// Delete Unused Array
			array_resize(temp_orbit_rotation_matrix, 0);
		}
		
		// Increment the Celestial Object Index
		temp_celestial_object_index++;
	}
	
	// Increment the Solar System Index
	temp_solar_systems_index++;
}

// Pathfinding Queue Behaviour
if (ds_list_size(pathfinding_queue_list) > 0)
{
	// Establish Pathfinding Queue Variables
	var temp_pathfinding_queue_calculations = global_pathfinding_queue_calculations_max;
	
	// Iterate through Pathfinding Queue for Valid Pathfinding Calculations
	while (temp_pathfinding_queue_calculations > 0 and ds_list_size(pathfinding_queue_list) > 0)
	{
		// Find Unit Instance from Pathfinding Queue
		var temp_pathfinding_queue_unit_inst = ds_list_find_value(pathfinding_queue_list, 0);
		
		// Check if Unit Instance Exists
		if (instance_exists(temp_pathfinding_queue_unit_inst))
		{
			// Implement Pathfinding Behaviour based on Unit's Pathfinding/Movement Scenario (If the Celestial Body Instance the Unit is on exists or if it even has a Pathfinding Navigation Mesh)
			if (instance_exists(temp_pathfinding_queue_unit_inst.celestial_body_instance) and temp_pathfinding_queue_unit_inst.celestial_body_instance.pathfinding_enabled)
			{
				// Perform Pathfinding Calculation based on Unit's Behaviour
				switch (temp_pathfinding_queue_unit_inst.unit_behaviour)
				{
					case CelestialUnitBehaviour.Attack:
					case CelestialUnitBehaviour.Regroup:
					case CelestialUnitBehaviour.Hunt:
					case CelestialUnitBehaviour.Garrison:
						// Check if Unit Instance's Pathfinding Target Instance Exists or if Unit Instance's Pathfinding Target Instance does not share the same Celestial Body Instance
						if (!instance_exists(temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance) or temp_pathfinding_queue_unit_inst.celestial_body_instance != temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.celestial_body_instance)
						{
							// Unit Instance's Pathfinding Target Instance does not exist - Remove Unit Instance from Pathfinding Queue
							ds_list_delete(pathfinding_queue_list, 0);
							
							// Reset Unit Instance's Behaviour
							temp_pathfinding_queue_unit_inst.unit_behaviour = CelestialUnitBehaviour.None;
							
							// Reset Unit Instance's Behaviour Target Instance & Node Index
							temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance = noone;
							temp_pathfinding_queue_unit_inst.unit_behaviour_target_node_index = -1;
							
							// Skip to next available Unit Instance in Pathfinding Queue
							continue;
						}
						
						// Establish Pathfinding Path's Target Variables as the Target Instance Pathfinding Node's Index and Position
						var temp_unit_target_inst_node_index = temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.pathfinding_node_index;
						var temp_unit_target_inst_x = temp_pathfinding_queue_unit_inst.celestial_body_instance.pathfinding_node_x_array[temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.pathfinding_node_index];
						var temp_unit_target_inst_y = temp_pathfinding_queue_unit_inst.celestial_body_instance.pathfinding_node_y_array[temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.pathfinding_node_index];
						var temp_unit_target_inst_z = temp_pathfinding_queue_unit_inst.celestial_body_instance.pathfinding_node_z_array[temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.pathfinding_node_index];
						var temp_unit_target_inst_elevation = temp_pathfinding_queue_unit_inst.celestial_body_instance.pathfinding_node_elevation_array[temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.pathfinding_node_index];
						
						// Check if Target Instance is a Celestial Unit Instance
						if (temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.celestial_render_object_type == CelestialRenderObjectType.Unit)
						{
							// Update Pathfinding Path's Target Variables as the Pathfinding Node Index and Position of the Target Unit Instance
							temp_unit_target_inst_node_index = temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.pathfinding_node_index;
							temp_unit_target_inst_x = temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.pathfinding_position_x;
							temp_unit_target_inst_y = temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.pathfinding_position_y;
							temp_unit_target_inst_z = temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.pathfinding_position_z;
							temp_unit_target_inst_elevation = temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.pathfinding_position_elevation;
						}
						
						// Check if Unit Instance's Pathfinding Path Struct exists
						if (!is_undefined(temp_pathfinding_queue_unit_inst.pathfinding_path))
						{
							// Check if Unit Instance is already Pathfinding to the current Target Pathfinding Node Index
							if (temp_unit_target_inst_node_index == ds_list_find_value(temp_pathfinding_queue_unit_inst.pathfinding_path.node_index, temp_pathfinding_queue_unit_inst.pathfinding_path.path_size - 1))
							{
								// Unit already has a Path heading towards the Target Pathfinding Node Index and does not need a new Pathfinding Path to be calculated - Remove Unit Instance from Pathfinding Queue
								ds_list_delete(pathfinding_queue_list, 0);
								
								// Skip to next available Unit Instance in Pathfinding Queue
								continue;
							}
							
							// Destroy Unit Instance's current Pathfinding Path Struct
							celestial_pathfinding_destroy_path(temp_pathfinding_queue_unit_inst.pathfinding_path);
						}
						
						// Check if Unit Instance shares its Pathfinding Node Index with its Target Instance
						if (temp_pathfinding_queue_unit_inst.pathfinding_node_index == temp_unit_target_inst_node_index)
						{
							// Initialize Empty Path Struct
							temp_pathfinding_queue_unit_inst.pathfinding_path = 
							{
								path_size: 0,
								node_index: ds_list_create(),
								position_x: ds_list_create(),
								position_y: ds_list_create(),
								position_z: ds_list_create(),
								position_elevation: ds_list_create(),
							}
							
							// Populate Path Struct with Final Destination (The Pathfinding Node Index and Position of the Target Instance)
							temp_pathfinding_queue_unit_inst.pathfinding_path.path_size = 1;
							ds_list_add(temp_pathfinding_queue_unit_inst.pathfinding_path.node_index, temp_unit_target_inst_node_index);
							ds_list_add(temp_pathfinding_queue_unit_inst.pathfinding_path.position_x, temp_unit_target_inst_x);
							ds_list_add(temp_pathfinding_queue_unit_inst.pathfinding_path.position_y, temp_unit_target_inst_y);
							ds_list_add(temp_pathfinding_queue_unit_inst.pathfinding_path.position_z, temp_unit_target_inst_z);
							ds_list_add(temp_pathfinding_queue_unit_inst.pathfinding_path.position_elevation, temp_unit_target_inst_elevation);
							
							// Remove Unit Instance from Pathfinding Queue
							ds_list_delete(pathfinding_queue_list, 0);
							
							// Skip to next available Unit Instance in Pathfinding Queue
							continue;
						}
						
						// Initiate Unit Pathfinding Behaviour
						celestial_pathfinding(temp_pathfinding_queue_unit_inst.celestial_body_instance, temp_pathfinding_queue_unit_inst, temp_unit_target_inst_node_index, temp_unit_target_inst_x, temp_unit_target_inst_y, temp_unit_target_inst_z, temp_unit_target_inst_elevation);
						break;
					case CelestialUnitBehaviour.Patrol:
						// Check if Unit Instance's Pathfinding Target Node Index is a valid Pathfinding Node Index
						if (temp_pathfinding_queue_unit_inst.unit_behaviour_target_node_index < 0 or temp_pathfinding_queue_unit_inst.unit_behaviour_target_node_index >= temp_pathfinding_queue_unit_inst.celestial_body_instance.pathfinding_nodes_count)
						{
							// Unit Instance's Pathfinding Target Node Index does not exist - Remove Unit Instance from Pathfinding Queue
							ds_list_delete(pathfinding_queue_list, 0);
							
							// Reset Unit Instance's Behaviour
							temp_pathfinding_queue_unit_inst.unit_behaviour = CelestialUnitBehaviour.None;
							
							// Reset Unit Instance's Behaviour Target Instance & Node Index
							temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance = noone;
							temp_pathfinding_queue_unit_inst.unit_behaviour_target_node_index = -1;
							
							// Skip to next available Unit Instance in Pathfinding Queue
							continue;
						}
						
						// Establish Pathfinding Path's Target Variables as the Unit Instance Pathfinding Target Node's Index and Position
						var temp_node_target_node_index = temp_pathfinding_queue_unit_inst.unit_behaviour_target_node_index;
						var temp_node_target_x = temp_pathfinding_queue_unit_inst.celestial_body_instance.pathfinding_node_x_array[temp_pathfinding_queue_unit_inst.unit_behaviour_target_node_index];
						var temp_node_target_y = temp_pathfinding_queue_unit_inst.celestial_body_instance.pathfinding_node_y_array[temp_pathfinding_queue_unit_inst.unit_behaviour_target_node_index];
						var temp_node_target_z = temp_pathfinding_queue_unit_inst.celestial_body_instance.pathfinding_node_z_array[temp_pathfinding_queue_unit_inst.unit_behaviour_target_node_index];
						var temp_node_target_elevation = temp_pathfinding_queue_unit_inst.celestial_body_instance.pathfinding_node_elevation_array[temp_pathfinding_queue_unit_inst.unit_behaviour_target_node_index];
						
						// Check if Unit Instance's Pathfinding Path Struct exists
						if (!is_undefined(temp_pathfinding_queue_unit_inst.pathfinding_path))
						{
							// Check if Unit Instance is already Pathfinding to the current Target Pathfinding Node Index
							if (temp_node_target_node_index == ds_list_find_value(temp_pathfinding_queue_unit_inst.pathfinding_path.node_index, temp_pathfinding_queue_unit_inst.pathfinding_path.path_size - 1))
							{
								// Unit already has a Path heading towards the Target Pathfinding Node Index and does not need a new Pathfinding Path to be calculated - Remove Unit Instance from Pathfinding Queue
								ds_list_delete(pathfinding_queue_list, 0);
								
								// Skip to next available Unit Instance in Pathfinding Queue
								continue;
							}
							
							// Destroy Unit Instance's current Pathfinding Path Struct
							celestial_pathfinding_destroy_path(temp_pathfinding_queue_unit_inst.pathfinding_path);
						}
						
						// Check if Unit Instance shares its Pathfinding Node Index with its Target Node Index
						if (temp_pathfinding_queue_unit_inst.pathfinding_node_index == temp_node_target_node_index)
						{
							// Initialize Empty Path Struct
							temp_pathfinding_queue_unit_inst.pathfinding_path = 
							{
								path_size: 0,
								node_index: ds_list_create(),
								position_x: ds_list_create(),
								position_y: ds_list_create(),
								position_z: ds_list_create(),
								position_elevation: ds_list_create(),
							}
							
							// Populate Path Struct with Final Destination (The Pathfinding Node's Index and Position)
							temp_pathfinding_queue_unit_inst.pathfinding_path.path_size = 1;
							ds_list_add(temp_pathfinding_queue_unit_inst.pathfinding_path.node_index, temp_node_target_node_index);
							ds_list_add(temp_pathfinding_queue_unit_inst.pathfinding_path.position_x, temp_node_target_x);
							ds_list_add(temp_pathfinding_queue_unit_inst.pathfinding_path.position_y, temp_node_target_y);
							ds_list_add(temp_pathfinding_queue_unit_inst.pathfinding_path.position_z, temp_node_target_z);
							ds_list_add(temp_pathfinding_queue_unit_inst.pathfinding_path.position_elevation, temp_node_target_elevation);
							
							// Remove Unit Instance from Pathfinding Queue
							ds_list_delete(pathfinding_queue_list, 0);
							
							// Skip to next available Unit Instance in Pathfinding Queue
							continue;
						}
						
						// Initiate Unit Pathfinding Behaviour
						celestial_pathfinding(temp_pathfinding_queue_unit_inst.celestial_body_instance, temp_pathfinding_queue_unit_inst, temp_node_target_node_index, temp_node_target_x, temp_node_target_y, temp_node_target_z, temp_node_target_elevation);
						break;
					case CelestialUnitBehaviour.None:
					default:
						// Remove Unit Instance from Pathfinding Queue
						ds_list_delete(pathfinding_queue_list, 0);
						
						// Skip to next available Unit Instance in Pathfinding Queue
						continue;
				}
			}
			else if (instance_exists(temp_pathfinding_queue_unit_inst.celestial_body_instance))
			{
				// Pathfinding Unit Instance belongs to a Celestial Body without a Pathfinding Navigation Mesh
			}
			else
			{
				// Pathfinding Unit Instance does not belong to a Celestial Body
			}
			
			// Finished Pathfinding Queue Unit Instance's Pathfinding Behaviour - Remove Unit Instance from Pathfinding Queue
			ds_list_delete(pathfinding_queue_list, 0);
		}
		else
		{
			// Unit Instance does not exist - Remove Unit Instance from Pathfinding Queue
			ds_list_delete(pathfinding_queue_list, 0);
			
			// Skip to next available Unit Instance in Pathfinding Queue
			continue;
		}
		
		// Decrement Pathfinding Queue Calculations Remaining
		temp_pathfinding_queue_calculations--;
	}
}

// Reset Celestial Simulator's UI Behaviours
selected_unit_movement_path_ui = false;
