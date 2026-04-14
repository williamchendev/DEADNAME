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
			
			// Celestial Object Type Behaviour
			switch (celestial_object_type)
			{
				case CelestialObjectType.Planet:
					// Planet Simulation Behaviour
					render_depth_radius = radius + elevation + (sky ? sky_radius : CelestialSimulator.global_no_atmosphere_radius_padding);
					frustum_culling_radius = radius + elevation + (sky ? sky_radius : CelestialSimulator.global_no_atmosphere_radius_padding);
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
				
				// Perform Movement Behaviour
				if (!is_undefined(temp_unit_instance.pathfinding_path))
				{
					// Establish Unit Movement Power
					var temp_movement_power = temp_unit_instance.unit_movement_power * CelestialSimulator.global_clock_delta_time;
					
					// Check if Unit Movement Behaviour is driven by the Celestial Object's Pathfinding Grid Movement or by an Alternative Movement Ruleset
					if (pathfinding_enabled)
					{
						// Check if Unit's Pathfinding Path Index is Valid
						if (temp_unit_instance.pathfinding_path_index < 0 or temp_unit_instance.pathfinding_path_index >= ds_list_size(temp_unit_instance.pathfinding_path) - 1)
						{
							// Destroy Unit's Pathfinding Path DS List
							ds_list_destroy(temp_unit_instance.pathfinding_path);
							
							// Reset Unit's Pathfinding Path
							temp_unit_instance.pathfinding_path = undefined;
						}
						else
						{
							// Perform Unit Pathfinding Movement
							while (temp_movement_power > 0)
							{
								// Find Unit Pathfinding Node Indexes
								var temp_unit_pathfinding_node_a_index = ds_list_find_value(temp_unit_instance.pathfinding_path, temp_unit_instance.pathfinding_path_index);
								var temp_unit_pathfinding_node_b_index = ds_list_find_value(temp_unit_instance.pathfinding_path, temp_unit_instance.pathfinding_path_index + 1);
								
								// Find Unit Pathfinding Node Microbiomes
								var temp_unit_pathfinding_node_a_microbiome_type = microclimate_biome_type_array[pathfinding_node_microclimate_array[temp_unit_pathfinding_node_a_index]];
								var temp_unit_pathfinding_node_b_microbiome_type = microclimate_biome_type_array[pathfinding_node_microclimate_array[temp_unit_pathfinding_node_b_index]];
								
								// Find Unit Pathfinding Nodes Combined Microbiome Movement Cost
								var temp_unit_pathfinding_combined_microbiome_movement_cost = celestial_microclimate_biome_get_movement_cost(temp_unit_pathfinding_node_a_microbiome_type) * 0.5 + celestial_microclimate_biome_get_movement_cost(temp_unit_pathfinding_node_b_microbiome_type) * 0.5;
								
								// Find Unit Pathfinding Remaining Movement Cost
								var temp_unit_pathfinding_remaining_movement_cost = (1 - temp_unit_instance.pathfinding_path_node_progress) * temp_unit_pathfinding_combined_microbiome_movement_cost;
								
								// Find Unit Pathfinding Movement Spend
								var temp_unit_pathfinding_movement_power_spend = min(temp_movement_power, temp_unit_pathfinding_remaining_movement_cost);
								
								// Decrement Unit Movement Power
								temp_movement_power -= temp_unit_pathfinding_movement_power_spend;
								
								// Increment Pathfinding Path Progress
								temp_unit_instance.pathfinding_path_node_progress += temp_unit_pathfinding_movement_power_spend / temp_unit_pathfinding_combined_microbiome_movement_cost;
								
								// Check if Unit's has made enough Path Progress to elapse to the next Pathfinding Node
								if (temp_unit_instance.pathfinding_path_node_progress >= 1)
								{
									// Increment Unit's Pathfinding Path Index
									temp_unit_instance.pathfinding_path_index++;
									
									// Update Unit's Pathfinding Node Index
									temp_unit_instance.pathfinding_node_index = ds_list_find_value(temp_unit_instance.pathfinding_path, temp_unit_instance.pathfinding_path_index);
									
									// Reset Unit's Pathfinding Path Progress
									temp_unit_instance.pathfinding_path_node_progress = 0;
								}
								
								// Check if Unit has finished moving through their Pathfinding Path
								if (temp_unit_instance.pathfinding_path_index >= ds_list_size(temp_unit_instance.pathfinding_path) - 1)
								{
									// Destroy Unit's Pathfinding Path DS List
									ds_list_destroy(temp_unit_instance.pathfinding_path);
									
									// Reset Unit's Pathfinding Path
									temp_unit_instance.pathfinding_path = undefined;
									
									// Break from Movement Behaviour Loop
									break;
								}
							}
							
							// Update Unit Position based on Pathfinding Progress
							if (!is_undefined(temp_unit_instance.pathfinding_path))
							{
								// Establish Unit Pathfinding Node Indexes
								var temp_unit_position_pathfinding_node_index_a = ds_list_find_value(temp_unit_instance.pathfinding_path, temp_unit_instance.pathfinding_path_index);
								var temp_unit_position_pathfinding_node_index_b = ds_list_find_value(temp_unit_instance.pathfinding_path, temp_unit_instance.pathfinding_path_index + 1);
								
								// Establish Unit Pathfinding Node Positions
								var temp_unit_position_pathfinding_node_a_local_x = pathfinding_node_x_array[temp_unit_position_pathfinding_node_index_a];
								var temp_unit_position_pathfinding_node_a_local_y = pathfinding_node_y_array[temp_unit_position_pathfinding_node_index_a];
								var temp_unit_position_pathfinding_node_a_local_z = pathfinding_node_z_array[temp_unit_position_pathfinding_node_index_a];
								
								var temp_unit_position_pathfinding_node_b_local_x = pathfinding_node_x_array[temp_unit_position_pathfinding_node_index_b];
								var temp_unit_position_pathfinding_node_b_local_y = pathfinding_node_y_array[temp_unit_position_pathfinding_node_index_b];
								var temp_unit_position_pathfinding_node_b_local_z = pathfinding_node_z_array[temp_unit_position_pathfinding_node_index_b];
								
								// Establish Unit Pathfinding Node Elevations
								var temp_unit_position_pathfinding_node_a_elevation = pathfinding_node_elevation_array[temp_unit_position_pathfinding_node_index_a];
								var temp_unit_position_pathfinding_node_b_elevation = pathfinding_node_elevation_array[temp_unit_position_pathfinding_node_index_b];
								
								// Find Celestial Unit's Normalized Local Vector from Celestial Body's Sphere Center by lerping their position between both their Pathfinding Node Indexes
								temp_unit_instance.pathfinding_position_x = lerp(temp_unit_position_pathfinding_node_a_local_x, temp_unit_position_pathfinding_node_b_local_x, temp_unit_instance.pathfinding_path_node_progress);
								temp_unit_instance.pathfinding_position_y = lerp(temp_unit_position_pathfinding_node_a_local_y, temp_unit_position_pathfinding_node_b_local_y, temp_unit_instance.pathfinding_path_node_progress);
								temp_unit_instance.pathfinding_position_z = lerp(temp_unit_position_pathfinding_node_a_local_z, temp_unit_position_pathfinding_node_b_local_z, temp_unit_instance.pathfinding_path_node_progress);
								
								// Find Celestial Unit's Elevation from Celestial Body's Sphere Center by lerping their position between both their Pathfinding Node Indexes
								temp_unit_instance.pathfinding_position_elevation = lerp(temp_unit_position_pathfinding_node_a_elevation, temp_unit_position_pathfinding_node_b_elevation, temp_unit_instance.pathfinding_path_node_progress);
								
								// Find Celestial Unit's U Positions and convert them into Horizontal Angles from Celestial Body's Sphere Horizontal Wrap
								var temp_unit_position_pathfinding_node_a_u_angle = pathfinding_node_u_array[temp_unit_position_pathfinding_node_index_a] * 360;
								var temp_unit_position_pathfinding_node_b_u_angle = pathfinding_node_u_array[temp_unit_position_pathfinding_node_index_b] * 360;
								
								// Update Unit's Sprite Facing Direction based on their Pathfinding Angle Difference
								var temp_unit_position_pathfinding_horizontal_angle_difference = angle_difference(temp_unit_position_pathfinding_node_b_u_angle, temp_unit_position_pathfinding_node_a_u_angle);
								temp_unit_instance.image_xscale = temp_unit_position_pathfinding_horizontal_angle_difference != 0 ? sign(temp_unit_position_pathfinding_horizontal_angle_difference) : temp_unit_instance.image_xscale;
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

// Reset Celestial Simulator's UI Behaviours
selected_unit_movement_path_ui = false;
