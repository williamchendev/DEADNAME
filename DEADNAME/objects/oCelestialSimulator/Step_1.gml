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
var temp_solar_systems_count = array_length(solar_systems);
	
repeat (temp_solar_systems_count)
{
	// Find the Solar System at the given Solar System Index
	var temp_solar_system = solar_systems[temp_solar_systems_index];
	
	// Check if Solar System Sun Instance exists
	var temp_solar_system_sun_exists = instance_exists(solar_systems_suns[temp_solar_systems_index]);
	
	// Find the Solar System's Orbit Update Order Array at the given Solar System Index
	var temp_solar_system_orbit_update_order = solar_systems_orbit_update_order[temp_solar_systems_index];
	
	// Iterate through all the Celestial Objects within the given Solar System
	var temp_celestial_object_index = 0;
	var temp_celestial_object_count = array_length(temp_solar_system);
	
	repeat (temp_celestial_object_count)
	{
		// Find the given Celestial Object at the given Celestial Object Orbit Update Order Index within the Solar System's Celestial Objects Array
		var temp_celestial_object = temp_solar_system[temp_solar_system_orbit_update_order[temp_celestial_object_index]];
		
		// Perform Celestial Object Simulation
		with (temp_celestial_object)
		{
			#region Celestial Physics
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
			
			// Delete the previous Celestial Object's Rotation Matrix
			array_resize(rotation_matrix, 0);
			rotation_matrix = -1;
			
			// Create Celestial Object's Rotation Matrix its local Euler Angles
			rotation_matrix = rotation_matrix_from_euler_angles(euler_angle_x, euler_angle_y, euler_angle_z);
			
			// Calculate Celestial Body Sun Vector
			var temp_sun_vector_x = temp_solar_system_sun_exists ? CelestialSimulator.solar_systems_suns[temp_solar_systems_index].x - x : 0;
			var temp_sun_vector_y = temp_solar_system_sun_exists ? CelestialSimulator.solar_systems_suns[temp_solar_systems_index].y - y : 0;
			var temp_sun_vector_z = temp_solar_system_sun_exists ? CelestialSimulator.solar_systems_suns[temp_solar_systems_index].z - z : 0;
			
			// Normalize Celestial Body Sun Vector
			var temp_sun_vector_magnitude = sqrt(dot_product_3d(temp_sun_vector_x, temp_sun_vector_y, temp_sun_vector_z, temp_sun_vector_x, temp_sun_vector_y, temp_sun_vector_z));
			
			temp_sun_vector_x /= temp_sun_vector_magnitude;
			temp_sun_vector_y /= temp_sun_vector_magnitude;
			temp_sun_vector_z /= temp_sun_vector_magnitude;
			
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
					
					// Planet Cloud Movement Behaviour
					if (clouds)
					{
						// Calculate Corolis Winds Speed
						var temp_coriolis_winds_movement_speed = rotation_speed * CelestialSimulator.global_clock_delta_time * 0.00137;
						var temp_coriolis_winds_rotation_speed = rotation_speed * CelestialSimulator.global_clock_delta_time * 3;
						
						// Iterate through Planet's Clouds
						var temp_cloud_index = 0;
						
						repeat (clouds_count)
						{
							// Find Cloud UV Position
							var temp_cloud_u = clouds_position_u_array[temp_cloud_index];
							var temp_cloud_v = clouds_position_v_array[temp_cloud_index];
							
							// Find Cloud Rotation
							var temp_cloud_rotation = clouds_rotation_array[temp_cloud_index];
							
							// Apply Planetary Rotation's Corolis Winds Effect to Cloud's Movement
							switch (floor(temp_cloud_v * 6))
							{
								case 0:
									// (Southern) Polar Easterlies
									var temp_southern_polar_easterlies_speed_modifier = lerp(0.25, 1.0, temp_cloud_v / 0.166666666667);
									
									// Apply Corolis Winds Position & Rotation Movement
									temp_cloud_u -= temp_coriolis_winds_movement_speed * temp_southern_polar_easterlies_speed_modifier;
									temp_cloud_rotation -= temp_coriolis_winds_rotation_speed * temp_southern_polar_easterlies_speed_modifier;
									break;
								case 1:
									// (Southern) Westerlies
									var temp_southern_westerlies_speed_modifier = lerp(1.0, 0.25, (temp_cloud_v - 0.166666666667) / 0.166666666667);
									
									// Apply Corolis Winds Position & Rotation Movement
									temp_cloud_u += temp_coriolis_winds_movement_speed * temp_southern_westerlies_speed_modifier;
									temp_cloud_rotation += temp_coriolis_winds_rotation_speed * temp_southern_westerlies_speed_modifier;
									break;
								case 2:
									// (South-East) Trade Winds
									var temp_south_east_trade_winds_speed_modifier = lerp(0.25, 1.0, (temp_cloud_v - 0.333333333334) / 0.166666666667);
									
									// Apply Corolis Winds Position & Rotation Movement
									temp_cloud_u -= temp_coriolis_winds_movement_speed * temp_south_east_trade_winds_speed_modifier;
									temp_cloud_rotation -= temp_coriolis_winds_rotation_speed * temp_south_east_trade_winds_speed_modifier;
									break;
								case 3:
									// (North-East) Trade Winds
									var temp_north_east_trade_winds_speed_modifier = lerp(1.0, 0.25, (temp_cloud_v - 0.5) / 0.166666666667);
									
									// Apply Corolis Winds Position & Rotation Movement
									temp_cloud_u -= temp_coriolis_winds_movement_speed * temp_north_east_trade_winds_speed_modifier;
									temp_cloud_rotation -= temp_coriolis_winds_rotation_speed * temp_north_east_trade_winds_speed_modifier;
									break;
								case 4:
									// (Northern) Westerlies
									var temp_northern_westerlies_speed_modifier = lerp(0.25, 1.0, (temp_cloud_v - 0.666666666668) / 0.166666666667);
									
									// Apply Corolis Winds Position & Rotation Movement
									temp_cloud_u += temp_coriolis_winds_movement_speed * temp_northern_westerlies_speed_modifier;
									temp_cloud_rotation += temp_coriolis_winds_rotation_speed * temp_northern_westerlies_speed_modifier;
									break;
								case 5:
								default:
									// (Northern) Polar Easterlies
									var temp_northern_polar_easterlies_speed_modifier = lerp(1.0, 0.25, (temp_cloud_v - 0.833333333335) / 0.166666666667);
									
									// Apply Corolis Winds Position & Rotation Movement
									temp_cloud_u -= temp_coriolis_winds_movement_speed * temp_northern_polar_easterlies_speed_modifier;
									temp_cloud_rotation -= temp_coriolis_winds_rotation_speed * temp_northern_polar_easterlies_speed_modifier;
									break;
							}
							
							// Set Cloud Position Movement with Horizontal Wrap & Vertical Clamp
							clouds_position_u_array[temp_cloud_index] = ((temp_cloud_u mod 1) + 1) mod 1;
							clouds_position_v_array[temp_cloud_index] = clamp(temp_cloud_v, 0, 1);
							
							// Set Cloud Rotation Movement with Horizontal Wrap
							clouds_rotation_array[temp_cloud_index] = ((temp_cloud_rotation mod 360) + 360) mod 360;
							
							// Increment Cloud Index
							temp_cloud_index++;
						}
					}
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
			#endregion
			
			#region City Behaviour 
			// Iterate through Celestial Object Cities Behaviours
			var temp_city_count = array_length(cities);
			var temp_city_index = temp_city_count - 1;
			
			repeat (temp_city_count)
			{
				// Find City Instance
				var temp_city_instance = cities[temp_city_index];
				
				// Establish City Instance's Local Sphere Vector
				if (!pathfinding_enabled)
				{
					// Find Vertical Sphere Vector
					var temp_city_atan_value = (0.5 - temp_city_instance.local_position_u) * 2 * pi;
					var temp_city_asin_value = (0.5 - temp_city_instance.local_position_v) * pi;
					temp_city_instance.sphere_vector_y = -sin(temp_city_asin_value);
					
					// Find Horizontal and Forwards Sphere Vectors
					var temp_city_sphere_horizontal_radius = sqrt(1.0 - temp_city_instance.sphere_vector_y * temp_city_instance.sphere_vector_y);
					temp_city_instance.sphere_vector_x = temp_city_sphere_horizontal_radius * -sin(temp_city_atan_value);
					temp_city_instance.sphere_vector_z = temp_city_sphere_horizontal_radius * -cos(temp_city_atan_value);
				}
				else
				{
					// Find Celestial City's Normalized Local Vector from Celestial Body's Sphere Center with their Pathfinding Node Index
					temp_city_instance.sphere_vector_x = pathfinding_node_x_array[temp_city_instance.pathfinding_node_index];
					temp_city_instance.sphere_vector_y = pathfinding_node_y_array[temp_city_instance.pathfinding_node_index];
					temp_city_instance.sphere_vector_z = pathfinding_node_z_array[temp_city_instance.pathfinding_node_index];
				}
				
				// Calculate City Solar Value & City Solar Type
				var temp_city_solar_x = temp_city_instance.sphere_vector_x * rotation_matrix[0] + temp_city_instance.sphere_vector_y * rotation_matrix[4] + temp_city_instance.sphere_vector_z * rotation_matrix[8];
				var temp_city_solar_y = temp_city_instance.sphere_vector_x * rotation_matrix[1] + temp_city_instance.sphere_vector_y * rotation_matrix[5] + temp_city_instance.sphere_vector_z * rotation_matrix[9];
				var temp_city_solar_z = temp_city_instance.sphere_vector_x * rotation_matrix[2] + temp_city_instance.sphere_vector_y * rotation_matrix[6] + temp_city_instance.sphere_vector_z * rotation_matrix[10];
				
				var temp_city_solar_value = dot_product_3d(temp_city_solar_x, temp_city_solar_y, temp_city_solar_z, temp_sun_vector_x, temp_sun_vector_y, temp_sun_vector_z);
				
				switch (floor((temp_city_solar_value + 1) * 1.5))
				{
					case 0:
						temp_city_instance.city_solar = CelestialSolarType.Night
						break;
					case 1:
						temp_city_instance.city_solar = CelestialSolarType.Twilight
						break;
					default:
						temp_city_instance.city_solar = CelestialSolarType.Day
						break;
				}
				
				// Check to see if City is on the Celestial Body being Observed by the Celestial Simulator
				if (temp_celestial_object == CelestialSimulator.camera_observing_instance)
				{
					// Iterate through City Notifications
					var temp_city_notification_count = array_length(temp_city_instance.notifications);
					var temp_city_notification_index = temp_city_notification_count - 1;
					
					repeat (temp_city_notification_count)
					{
						// Establish City Notification Struct
						var temp_city_notification_struct = temp_city_instance.notifications[temp_city_notification_index];
						
						// Decrement Notification Duration
						temp_city_notification_struct.duration -= CelestialSimulator.global_clock_delta_time;
						
						// Check if Notification has elapsed its duration
						if (temp_city_notification_struct.duration <= 0)
						{
							// Delete Notification from City Notifications Array
							delete temp_city_notification_struct;
							array_delete(temp_city_instance.notifications, temp_city_notification_index, 1);
						}
						
						// Decrement City Notification Index
						temp_city_notification_index--;
					}
				}
				
				// Iterate through City Buildings
				var temp_city_building_count = array_length(temp_city_instance.buildings);
				var temp_city_building_index = temp_city_building_count - 1;
				
				repeat (temp_city_building_count)
				{
					// Establish City Building Struct
					var temp_city_building_struct = temp_city_instance.buildings[temp_city_building_index];
					
					// Establish City Building Variables
					var temp_city_building_production_resource = global.celestial_buildings[temp_city_building_struct.building].production_resource;
					
					// Check if City Building Produces a Resource
					if (temp_city_building_production_resource != -1)
					{
						// Check if City is Eligible to Produce Resource
						if (temp_city_instance.resources_supply[temp_city_building_production_resource] < temp_city_instance.resources_limit[temp_city_building_production_resource])
						{
							// Establish Production Variables
							var temp_city_building_solar_cycle_production_enabled = false;
							
							// Check if City Solar Type and Production Solar Cycle allow for the Building to Produce its Resource
							if (temp_city_instance.city_solar == CelestialSolarType.Day and global.celestial_buildings[temp_city_building_struct.building].production_cycle_day_enabled)
							{
								temp_city_building_solar_cycle_production_enabled = true;
							}
							else if (temp_city_instance.city_solar == CelestialSolarType.Day and global.celestial_buildings[temp_city_building_struct.building].production_cycle_twilight_enabled)
							{
								temp_city_building_solar_cycle_production_enabled = true;
							}
							else if (temp_city_instance.city_solar == CelestialSolarType.Day and global.celestial_buildings[temp_city_building_struct.building].production_cycle_night_enabled)
							{
								temp_city_building_solar_cycle_production_enabled = true;
							}
							
							// Check if City Building is Producing a Resource right now
							if (temp_city_building_solar_cycle_production_enabled)
							{
								// Decrement Production Cycle Timer by Delta-Time
								temp_city_building_struct.production_cycle_timer -= CelestialSimulator.global_clock_delta_time;
								
								// Check how much Building Production Resource was created
								if (temp_city_building_struct.production_cycle_timer < 0)
								{
									// Calculate Production Cycle Resource Creation & Production Cycle Timer
									var temp_building_production_resources_count = 0;
									
									while (temp_city_building_struct.production_cycle_timer < 0)
									{
										temp_city_building_struct.production_cycle_timer += global.celestial_buildings[temp_city_building_struct.building].production_cycle_duration;
										temp_building_production_resources_count += global.celestial_buildings[temp_city_building_struct.building].production_cycle_resource_count;
									}
									
									// Add Production Resource to City Resource Supply
									var temp_city_resource_amount_added = celestial_cities_add_resource(temp_city_instance, temp_city_building_production_resource, temp_building_production_resources_count);
									
									// Check if Production Resource Added is greater than Zero
									if (temp_city_resource_amount_added > 0)
									{
										// Establish Resource Name
										var temp_resource_name = global.celestial_resources[temp_city_building_production_resource].name;
										
										// Check if Supply Limit Reached
										if (temp_city_instance.resources_supply[temp_city_building_production_resource] == temp_city_instance.resources_limit[temp_city_building_production_resource])
										{
											// Add Production Resource Notification to City Instance
											celestial_cities_add_notification(temp_city_instance, $"[{temp_resource_name} Supply Limit]", 11);
										}
										else
										{
											// Add Production Resource Notification to City Instance
											celestial_cities_add_notification(temp_city_instance, $"+{temp_city_resource_amount_added} {temp_resource_name}", 8);
										}
									}
								}
							}
						}
					}
					
					// Decrement City Building Index
					temp_city_building_index--;
				}
				
				// Decrement City Index
				temp_city_index--;
			}
			#endregion
			
			#region Battle Behaviour 
			// Iterate through Celestial Object Battle Behaviours
			var temp_battle_count = array_length(battles);
			var temp_battle_index = temp_battle_count - 1;
			
			repeat (temp_battle_count)
			{
				// Find Battle Instance
				var temp_battle_instance = battles[temp_battle_index];
				
				// Establish Battle's Celestial Unit Counts
				var temp_battle_units_count = array_length(temp_battle_instance.battle_units);
				var temp_battle_units_a_count = array_length(temp_battle_instance.battle_units_a);
				var temp_battle_units_b_count = array_length(temp_battle_instance.battle_units_b);
				
				// Check to Destroy Battle Instance
				if (!temp_battle_instance.battle_exists)
				{
					// If this Battle was selected by the Celestial Simulator, Check for Duplicate Battles to switch to as the Celestial Simulator's next Selected Battle
					if (CelestialSimulator.sub_object_selected_instance == temp_battle_instance)
					{
						// Search for Battle's Duplicate Instance
						var temp_battle_duplicate_instance = celestial_battle_check_for_duplicate(temp_battle_instance);
						
						// Check if Duplicate Battle Exists
						if (instance_exists(temp_battle_duplicate_instance))
						{
							// Duplicate Battle Exists - Select the Duplicate Celestial Battle that matches the selected Celestial Battle that has ended
							CelestialSimulator.select_sub_object_instance(temp_battle_duplicate_instance);
						}
					}
					
					// Decrement Battle Instance's Ending Timer
					temp_battle_instance.battle_ending_time -= CelestialSimulator.global_clock_delta_time;
					
					// Check if Battle's Ending Duration Timer has Elapsed
					if (temp_battle_instance.battle_ending_time <= 0)
					{
						// Destroy Battle Instance
						instance_destroy(temp_battle_instance);
						
						// Decrement Battle Index
						temp_battle_index--;
						
						// Skip to Next Battle Instance
						continue;
					}
				}
				else
				{
					// Establish the Battle's Faction Aligned Combat Units Count
					var temp_battle_combat_units_a_count = array_length(temp_battle_instance.battle_combat_units_a);
					var temp_battle_combat_units_b_count = array_length(temp_battle_instance.battle_combat_units_b);
					
					// Check if the Battle's Left-Hand Combat Grid is still populated Combat Units
					if (temp_battle_combat_units_a_count < 1)
					{
						// Iterate through the Battle's Faction Aligned Celestial Units to pull their engaged Combat Units into this fight
						var temp_battle_units_a_index = 0;
						
						repeat (temp_battle_units_a_count)
						{
							// Find Battle Faction Aligned Celestial Unit Instance
							var temp_battle_units_a_instance = temp_battle_instance.battle_units_a[temp_battle_units_a_index];
							
							// Iterate through Celestial Unit's Engaged Battles
							var temp_battle_units_a_engaged_battles_index = 0;
							var temp_battle_units_a_engaged_battles_count = array_length(temp_battle_units_a_instance.engaged_battles);
							
							repeat (temp_battle_units_a_engaged_battles_count)
							{
								// Find Celestial Unit's Combat Unit Contribution to this given Battle
								var temp_battle_units_a_engaged_battles_combat_unit_contribution = temp_battle_units_a_instance.engaged_battles_combat_units_contribution[temp_battle_units_a_engaged_battles_index];
								
								// Check if the Celestial Unit's Combat Unit Contribution is greater than the Battle Population Minimum
								if (temp_battle_units_a_engaged_battles_combat_unit_contribution > global.celestial_battle_combat_grid_population_minimum)
								{
									// Find both the Celestial Unit's Engaged Battle Instance
									var temp_battle_units_a_engaged_battle_instance = temp_battle_units_a_instance.engaged_battles[temp_battle_units_a_engaged_battles_index];
									
									// Calculate how many Combat Units can be pulled from this Engaged Battle without dropping below the Battle Population Minimum
									var temp_battle_units_a_contribution_pull = min(temp_battle_units_a_engaged_battles_combat_unit_contribution - global.celestial_battle_combat_grid_population_minimum, global.celestial_battle_combat_grid_population_minimum - temp_battle_combat_units_a_count);
									
									// Move Combat Units from the Celestial Unit's Engaged Battle Instance to this Battle Instance
									repeat (temp_battle_units_a_contribution_pull)
									{
										// Find a Random Combat Unit to pull from the Celestial Unit's Engaged Battle
										var temp_random_battle_units_a_contribution_pull_combat_unit_index = irandom(temp_battle_units_a_engaged_battles_combat_unit_contribution - 1);
										var temp_random_battle_units_a_contribution_pull_combat_unit_instance = array_get(temp_battle_units_a_instance.engaged_battles_combat_units[temp_battle_units_a_engaged_battles_index], temp_random_battle_units_a_contribution_pull_combat_unit_index);
										
										// Remove the Random Combat Unit from the Celestial Unit's Engaged Battle
										celestial_battle_remove_combat_unit(temp_battle_units_a_engaged_battle_instance, temp_random_battle_units_a_contribution_pull_combat_unit_instance);
										
										// Add the Random Combat Unit to this Battle Instance
										celestial_battle_add_combat_unit(temp_battle_instance, temp_random_battle_units_a_contribution_pull_combat_unit_instance);
										
										// Decrement the Celestial Unit's Combat Unit Contribution Count
										temp_battle_units_a_engaged_battles_combat_unit_contribution--;
										
										// Increment the Battle's Faction Aligned Combat Units Count
										temp_battle_combat_units_a_count++;
									}
									
									// Check if the Battle's Faction Aligned Combat Units Count has met the Battle Population Minimum
									if (temp_battle_combat_units_a_count >= global.celestial_battle_combat_grid_population_minimum)
									{
										// Exit from Combat Unit Pull Behaviour
										break;
									}
								}
								
								// Increment Battle Faction Aligned Celestial Unit's Engaged Battles Index
								temp_battle_units_a_engaged_battles_index++;
							}
							
							// Check if the Battle's Faction Aligned Combat Units Count has met the Battle Population Minimum
							if (temp_battle_combat_units_a_count >= global.celestial_battle_combat_grid_population_minimum)
							{
								// Exit from Combat Unit Pull Behaviour
								break;
							}
							
							// Increment Battle Faction Aligned Celestial Unit Index
							temp_battle_units_a_index++;
						}
					}
					
					// Check if the Battle's Right-Hand Combat Grid is still populated Combat Units
					if (temp_battle_combat_units_b_count < 1)
					{
						// Iterate through the Battle's Faction Aligned Celestial Units to pull their engaged Combat Units into this fight
						var temp_battle_units_b_index = 0;
						
						repeat (temp_battle_units_b_count)
						{
							// Find Battle Faction Aligned Celestial Unit Instance
							var temp_battle_units_b_instance = temp_battle_instance.battle_units_b[temp_battle_units_b_index];
							
							// Iterate through Celestial Unit's Engaged Battles
							var temp_battle_units_b_engaged_battles_index = 0;
							var temp_battle_units_b_engaged_battles_count = array_length(temp_battle_units_b_instance.engaged_battles);
							
							repeat (temp_battle_units_b_engaged_battles_count)
							{
								// Find Celestial Unit's Combat Unit Contribution to this given Battle
								var temp_battle_units_b_engaged_battles_combat_unit_contribution = temp_battle_units_b_instance.engaged_battles_combat_units_contribution[temp_battle_units_b_engaged_battles_index];
								
								// Check if the Celestial Unit's Combat Unit Contribution is greater than the Battle Population Minimum
								if (temp_battle_units_b_engaged_battles_combat_unit_contribution > global.celestial_battle_combat_grid_population_minimum)
								{
									// Find both the Celestial Unit's Engaged Battle Instance
									var temp_battle_units_b_engaged_battle_instance = temp_battle_units_b_instance.engaged_battles[temp_battle_units_b_engaged_battles_index];
									
									// Calculate how many Combat Units can be pulled from this Engaged Battle without dropping below the Battle Population Minimum
									var temp_battle_units_b_contribution_pull = min(temp_battle_units_b_engaged_battles_combat_unit_contribution - global.celestial_battle_combat_grid_population_minimum, global.celestial_battle_combat_grid_population_minimum - temp_battle_combat_units_b_count);
									
									// Move Combat Units from the Celestial Unit's Engaged Battle Instance to this Battle Instance
									repeat (temp_battle_units_b_contribution_pull)
									{
										// Find a Random Combat Unit to pull from the Celestial Unit's Engaged Battle
										var temp_random_battle_units_b_contribution_pull_combat_unit_index = irandom(temp_battle_units_b_engaged_battles_combat_unit_contribution - 1);
										var temp_random_battle_units_b_contribution_pull_combat_unit_instance = array_get(temp_battle_units_b_instance.engaged_battles_combat_units[temp_battle_units_b_engaged_battles_index], temp_random_battle_units_b_contribution_pull_combat_unit_index);
										
										// Remove the Random Combat Unit from the Celestial Unit's Engaged Battle
										celestial_battle_remove_combat_unit(temp_battle_units_b_engaged_battle_instance, temp_random_battle_units_b_contribution_pull_combat_unit_instance);
										
										// Add the Random Combat Unit to this Battle Instance
										celestial_battle_add_combat_unit(temp_battle_instance, temp_random_battle_units_b_contribution_pull_combat_unit_instance);
										
										// Decrement the Celestial Unit's Combat Unit Contribution Count
										temp_battle_units_b_engaged_battles_combat_unit_contribution--;
										
										// Increment the Battle's Faction Aligned Combat Units Count
										temp_battle_combat_units_b_count++;
									}
									
									// Check if the Battle's Faction Aligned Combat Units Count has met the Battle Population Minimum
									if (temp_battle_combat_units_b_count >= global.celestial_battle_combat_grid_population_minimum)
									{
										// Exit from Combat Unit Pull Behaviour
										break;
									}
								}
								
								// Increment Battle Faction Aligned Celestial Unit's Engaged Battles Index
								temp_battle_units_b_engaged_battles_index++;
							}
							
							// Check if the Battle's Faction Aligned Combat Units Count has met the Battle Population Minimum
							if (temp_battle_combat_units_b_count >= global.celestial_battle_combat_grid_population_minimum)
							{
								// Exit from Combat Unit Pull Behaviour
								break;
							}
							
							// Increment Battle Faction Aligned Celestial Unit Index
							temp_battle_units_b_index++;
						}
					}
				}
				
				// Update Battle Clock
				temp_battle_instance.battle_total_time += CelestialSimulator.global_clock_delta_time;
				
				#region Battle Position
				// Establish Battle Position, Elevation, & Divisor
				var temp_battle_x = 0;
				var temp_battle_y = 0;
				var temp_battle_z = 0;
				var temp_battle_elevation = 0;
				var temp_battle_divisor = 0;
				
				// Iterate through Battle's participating Celestial Units to calculate the Battle's Position and Unit Proximity
				var temp_battle_units_index = temp_battle_units_count - 1;
				
				repeat (temp_battle_units_count)
				{
					// Find Battle Celestial Unit Instance
					var temp_battle_unit_instance = temp_battle_instance.battle_units[temp_battle_units_index];
					
					// Check if Celestial Unit is moving despite being Engaged in Combat
					if (temp_battle_unit_instance.unit_behaviour == CelestialUnitBehaviourType.Retreat)
					{
						// Calculate the Dot Product between the Battle Instance's Normalized Local Sphere Vector and the Battle Celestial Unit Instance's Normalized Local Sphere Vector
						var temp_battle_unit_dot_product = dot_product_3d
						(
							temp_battle_instance.sphere_vector_x, 
							temp_battle_instance.sphere_vector_y, 
							temp_battle_instance.sphere_vector_z, 
							temp_battle_unit_instance.sphere_vector_x, 
							temp_battle_unit_instance.sphere_vector_y, 
							temp_battle_unit_instance.sphere_vector_z
						);
						
						// Check if Celestial Unit is within the Battle's Collision Threshold
						if (temp_battle_unit_dot_product < temp_battle_instance.battle_far_collision_threshold)
						{
							// Remove Celestial Unit from Celestial Battle's Combat
							celestial_battle_remove_unit(temp_battle_instance, temp_battle_unit_instance);
							
							// Decrement Battle Celestial Units Index
							temp_battle_units_index--;
							
							// Continue iteration to next Celestial Unit Instance's Behaviour
							continue;
						}
					}
					
					// Add Unit's Position to Battle Position Centering
					temp_battle_x += temp_battle_unit_instance.sphere_vector_x;
					temp_battle_y += temp_battle_unit_instance.sphere_vector_y;
					temp_battle_z += temp_battle_unit_instance.sphere_vector_z;
					
					// Find Battle Faction's Elevation Maxiumum
					temp_battle_elevation = max(temp_battle_elevation, temp_battle_unit_instance.pathfinding_position_elevation);
					
					// Increment Battle's Unit Divisor
					temp_battle_divisor++;
					
					// Decrement Battle Units Index
					temp_battle_units_index--;
				}
				
				// Update Battle's Position if the Battle's Combat is still ongoing
				if (temp_battle_instance.battle_exists)
				{
					// Calculate Battle's Target Position from dividing the Battle's Cumulative Position Value by the Battle's Unit Divisor
					temp_battle_x /= temp_battle_divisor;
					temp_battle_y /= temp_battle_divisor;
					temp_battle_z /= temp_battle_divisor;
					
					// Calculate Battle's Position from Lerped Movement to Battle's Target Position & Elevation
					var temp_battle_position_lerp_value = temp_battle_instance.battle_position_lerp_spd * CelestialSimulator.global_clock_delta_time;
					temp_battle_x = lerp(temp_battle_instance.battle_x, temp_battle_x, temp_battle_position_lerp_value);
					temp_battle_y = lerp(temp_battle_instance.battle_y, temp_battle_y, temp_battle_position_lerp_value);
					temp_battle_z = lerp(temp_battle_instance.battle_z, temp_battle_z, temp_battle_position_lerp_value);
					temp_battle_elevation = lerp(temp_battle_instance.battle_elevation, temp_battle_elevation, temp_battle_position_lerp_value);
					
					// Update Battle Sphere Vector and Battle's Position & Elevation Values
					temp_battle_instance.sphere_vector_x = temp_battle_x;
					temp_battle_instance.sphere_vector_y = temp_battle_y;
					temp_battle_instance.sphere_vector_z = temp_battle_z;
					
					temp_battle_instance.battle_x = temp_battle_x;
					temp_battle_instance.battle_y = temp_battle_y;
					temp_battle_instance.battle_z = temp_battle_z;
					temp_battle_instance.battle_elevation = temp_battle_elevation;
				}
				#endregion
				
				#region Battle Choreography
				// Iterate through and Perform Battle Combat Units Behaviour
				var temp_combat_unit_count = array_length(temp_battle_instance.battle_combat_units);
				var temp_combat_unit_index = temp_combat_unit_count - 1;
				
				repeat (temp_combat_unit_count)
				{
					// Find Battle Combat Unit Instance
					var temp_combat_unit_instance = temp_battle_instance.battle_combat_units[temp_combat_unit_index];
					
					// Establish Action Time Elapsed
					temp_combat_unit_instance.combat_unit_action_time += CelestialSimulator.global_clock_delta_time;
					
					// Check if Combat Unit is performing an Action or reducing their Exhaustion
					if (temp_combat_unit_instance.combat_unit_action_count > 0)
					{
						// Calculate the Action Duration Spend from the Action Time Elapsed
						var temp_combat_unit_action_duration_time_spend = clamp(temp_combat_unit_instance.combat_unit_action_time, 0, temp_combat_unit_instance.combat_unit_action_duration);
						
						// Decrement the Total Action Time Elapsed and the Action Duration Timer by the Action Duration Spend
						temp_combat_unit_instance.combat_unit_action_time -= temp_combat_unit_action_duration_time_spend;
						temp_combat_unit_instance.combat_unit_action_duration -= temp_combat_unit_action_duration_time_spend;
						
						// Check if the Combat Unit is finished Performing their Action
						if (temp_combat_unit_instance.combat_unit_action_duration <= 0)
						{
							// Initialize Combat Action Instance
							var temp_new_combat_action_instance = instance_create_depth(0, 0, 0, global.celestial_combat_unit_actions[temp_combat_unit_instance.combat_unit_action].action_instance);
							
							// Index Combat Action Instance within the Celestial Battle's Combat Actions Array
							array_insert(temp_battle_instance.battle_combat_actions, 0, temp_new_combat_action_instance);
							temp_new_combat_action_instance.battle_instance = temp_battle_instance;
							
							// Set the Combat Action Instance's Combat Unit and Combat Unit Action Behaviour
							temp_new_combat_action_instance.combat_unit = temp_combat_unit_instance;
							temp_new_combat_action_instance.combat_unit_action = temp_combat_unit_instance.combat_unit_action;
							
							// Set Combat Action Instance's Stats from Combat Unit's Stats
							temp_new_combat_action_instance.action_accuracy = temp_combat_unit_instance.combat_unit_accuracy;
							
							// Set the Combat Action Instance's Target Combat Unit and Target Combat Grid Variables
							temp_new_combat_action_instance.target_combat_unit = temp_combat_unit_instance.combat_unit_action_target_inst;
							temp_new_combat_action_instance.target_combat_grid_side = temp_combat_unit_instance.combat_unit_action_target_combat_grid_side;
							temp_new_combat_action_instance.target_combat_grid_column = temp_combat_unit_instance.combat_unit_action_target_combat_grid_column;
							temp_new_combat_action_instance.target_combat_grid_row = temp_combat_unit_instance.combat_unit_action_target_combat_grid_row;
							
							// Decrement Combat Unit's Action Count
							temp_combat_unit_instance.combat_unit_action_count--;
							
							// Check if Combat Unit has more Actions to Perform
							if (temp_combat_unit_instance.combat_unit_action_count > 0)
							{
								// Reset Combat Unit's Action Duration
								temp_combat_unit_instance.combat_unit_action_duration = global.celestial_combat_unit_actions[temp_combat_unit_instance.combat_unit_action].action_duration;
							}
						}
					}
					else if (temp_combat_unit_instance.unit_instance.unit_behaviour != CelestialUnitBehaviourType.Retreat)
					{
						// Find the Combat Unit's Agility Value
						var temp_combat_unit_agility_value = global.celestial_combat_units[temp_combat_unit_instance.combat_unit_type].unit_agility;
						
						// Calculate the Action Exhaustion Spend from the Action Time Elapsed
						var temp_combat_unit_action_exhaustion_time_spend = clamp(temp_combat_unit_instance.combat_unit_action_time * temp_combat_unit_agility_value, 0, temp_combat_unit_instance.combat_unit_action_exhaustion);
						
						// Decrement Total Action Time Elapsed and the Combat Unit's Action Exhaustion by their Agility Value
						temp_combat_unit_instance.combat_unit_action_exhaustion -= temp_combat_unit_action_exhaustion_time_spend;
						temp_combat_unit_instance.combat_unit_action_time -= temp_combat_unit_action_exhaustion_time_spend / temp_combat_unit_agility_value;
						
						// Check if the Combat Unit can perform an Action
						if (temp_combat_unit_instance.combat_unit_action_exhaustion <= 0)
						{
							// Reset Combat Unit's Action Selection
							temp_combat_unit_instance.combat_unit_action = -1;
							temp_combat_unit_instance.combat_unit_action_target_inst = noone;
							
							// Calculate Combat Unit's Action Selection
							var temp_combat_unit_action = CelestialCombatUnitAction.DefaultFirearm;
							
							// Perform Combat Unit Action's Behaviour based on Combat Unit Action Type
							switch (global.celestial_combat_unit_actions[temp_combat_unit_action].action_type)
							{
								case CelestialCombatUnitActionType.Attack:
									// Establish Combat Unit Attack Target
									var temp_combat_unit_attack_target_instance = noone;
									
									// Find Valid Combat Unit Instance as Attack Target relative to enemies opposing the Combat Unit's Combat Grid Side
									switch (temp_combat_unit_instance.combat_grid_side)
									{
										case CelestialBattleCombatGridSide.Left:
											// Iterate through Combat Grid's Columns to find Valid Target
											var temp_combat_grid_b_attack_column_index = 0;
											
											repeat (CelestialBattleCombatGridColumns)
											{
												// Find number of Combat Grid Column's Instances
												var temp_combat_grid_b_attack_column_instance_count = array_length(temp_battle_instance.battle_combat_grid_instances_b[temp_combat_grid_b_attack_column_index]);
												
												// Check if Valid Instance exists in the Combat Grid Column
												if (temp_combat_grid_b_attack_column_instance_count > 0)
												{
													// Select random Valid Instance from Combat Grid Column
													var temp_random_combat_grid_b_attack_column_instance_index = irandom(temp_combat_grid_b_attack_column_instance_count - 1);
													
													// Set random Valid Instance as Attack Target
													temp_combat_unit_attack_target_instance = array_get(temp_battle_instance.battle_combat_grid_instances_b[temp_combat_grid_b_attack_column_index], temp_random_combat_grid_b_attack_column_instance_index);
													
													// Exit Loop
													break;
												}
												
												// Increment Combat Grid Attack Column Index
												temp_combat_grid_b_attack_column_index++;
											}
											break;
										case CelestialBattleCombatGridSide.Right:
											// Iterate through Combat Grid's Columns to find Valid Target
											var temp_combat_grid_a_attack_column_index = 0;
											
											repeat (CelestialBattleCombatGridColumns)
											{
												// Find number of Combat Grid Column's Instances
												var temp_combat_grid_a_attack_column_instance_count = array_length(temp_battle_instance.battle_combat_grid_instances_a[temp_combat_grid_a_attack_column_index]);
												
												// Check if Valid Instance exists in the Combat Grid Column
												if (temp_combat_grid_a_attack_column_instance_count > 0)
												{
													// Select random Valid Instance from Combat Grid Column
													var temp_random_combat_grid_a_attack_column_instance_index = irandom(temp_combat_grid_a_attack_column_instance_count - 1);
													
													// Set random Valid Instance as Attack Target
													temp_combat_unit_attack_target_instance = array_get(temp_battle_instance.battle_combat_grid_instances_a[temp_combat_grid_a_attack_column_index], temp_random_combat_grid_a_attack_column_instance_index);
													
													// Exit Loop
													break;
												}
												
												// Increment Combat Grid Attack Column Index
												temp_combat_grid_a_attack_column_index++;
											}
											break;
									}
									
									// Set Combat Unit's Action Target Instance as the Attack Target Instance
									temp_combat_unit_instance.combat_unit_action_target_inst = temp_combat_unit_attack_target_instance;
									break;
								case CelestialCombatUnitActionType.Support:
									// Establish Combat Unit Support Target
									var temp_combat_unit_support_target_instance = noone;
									
									// Find Valid Combat Unit Instance as Support Target relative to enemies opposing the Combat Unit's Combat Grid Side
									switch (temp_combat_unit_instance.combat_grid_side)
									{
										case CelestialBattleCombatGridSide.Left:
											// Iterate through Combat Grid's Columns to find Valid Target
											break;
										case CelestialBattleCombatGridSide.Right:
											// Iterate through Combat Grid's Columns to find Valid Target
											break;
									}
									
									// Set Combat Unit's Action Target Instance as the Support Target Instance
									temp_combat_unit_instance.combat_unit_action_target_inst = temp_combat_unit_support_target_instance;
									break;
							}
							
							// Check if Valid Combat Unit Target Instance has been identified
							if (instance_exists(temp_combat_unit_instance.combat_unit_action_target_inst))
							{
								// Set Combat Unit's Action Behaviour
								temp_combat_unit_instance.combat_unit_action = temp_combat_unit_action;
								temp_combat_unit_instance.combat_unit_action_count = global.celestial_combat_unit_actions[temp_combat_unit_action].action_count;
								temp_combat_unit_instance.combat_unit_action_duration = global.celestial_combat_unit_actions[temp_combat_unit_action].action_duration;
								
								// Set Combat Unit's Action Target Variables
								temp_combat_unit_instance.combat_unit_action_target_combat_grid_side = temp_combat_unit_instance.combat_unit_action_target_inst.combat_grid_side;
								temp_combat_unit_instance.combat_unit_action_target_combat_grid_column = temp_combat_unit_instance.combat_unit_action_target_inst.combat_grid_column;
								temp_combat_unit_instance.combat_unit_action_target_combat_grid_row = temp_combat_unit_instance.combat_unit_action_target_inst.combat_grid_row;
							}
							else
							{
								// Combat Unit has no Valid Targets and must skip their Action behaviour
							}
							
							// Increast Combat Unit's Action Exhaustion
							temp_combat_unit_instance.combat_unit_action_exhaustion += 1;
						}
					}
					
					// Decrement Battle Combat Unit Index
					temp_combat_unit_index--;
				}
				
				// Iterate through and Perform Battle Combat Actions Behaviour
				var temp_combat_action_count = array_length(temp_battle_instance.battle_combat_actions);
				var temp_combat_action_index = temp_combat_action_count - 1;
				
				repeat (temp_combat_action_count)
				{
					// Find Battle Combat Action Instance
					var temp_combat_action_instance = temp_battle_instance.battle_combat_actions[temp_combat_action_index];
					
					// Decrement Combat Action's Timer
					temp_combat_action_instance.action_timer -= CelestialSimulator.global_clock_delta_time;
					
					// Check if Combat Action's Lifetime has Elapsed
					if (temp_combat_action_instance.action_timer <= 0)
					{
						// Check if Combat Action's Target still exists
						if (!instance_exists(temp_combat_action_instance.target_combat_unit))
						{
							// Combat Action's Target Instance does not exist - Attempt to pull Target Combat Unit from Target Combat Grid Variables
							switch (temp_combat_action_instance.target_combat_grid_side)
							{
								case CelestialBattleCombatGridSide.Left:
									// Combat Grid Left Side Target Instance Retrieval
									temp_combat_action_instance.target_combat_unit = array_get(temp_battle_instance.battle_combat_grid_instances_a[temp_combat_action_instance.target_combat_grid_column], temp_combat_action_instance.target_combat_grid_row);
									break;
								case CelestialBattleCombatGridSide.Right:
									// Combat Grid Right Side Target Instance Retrieval
									temp_combat_action_instance.target_combat_unit = array_get(temp_battle_instance.battle_combat_grid_instances_b[temp_combat_action_instance.target_combat_grid_column], temp_combat_action_instance.target_combat_grid_row);
									break;
								
							}
						}
						
						// Check if Combat Action has a Valid Target Combat Unit Instance
						if (instance_exists(temp_combat_action_instance.target_combat_unit))
						{
							// Perform Combat Action Behaviour on Target Combat Unit Instance
							switch (global.celestial_combat_unit_actions[temp_combat_action_instance.combat_unit_action].action_type)
							{
								case CelestialCombatUnitActionType.Attack:
									// Calculate Combat Action's Attack Success Chance
									var temp_combat_action_attack_accuracy = temp_combat_action_instance.action_accuracy;
									var temp_combat_action_defend_evasion = temp_combat_action_instance.target_combat_unit.combat_unit_evasion;
									var temp_combat_action_attack_success_chance = clamp(0.5 + (temp_combat_action_attack_accuracy - temp_combat_action_defend_evasion) * 0.05, 0, 1);
									
									// Calculate Combat Action's Attack Random Chance to hit the Target Combat Unit Instance
									var temp_combat_action_attack_random_chance = random(1.0);
									
									if (temp_combat_action_attack_random_chance <= temp_combat_action_attack_success_chance)
									{
										
									}
									break;
								case CelestialCombatUnitActionType.Support:
									break;
							}
						}
						
						// Deindex Combat Action from the Celestial Battle's Combat Actions Array
						temp_combat_action_instance.battle_instance = noone;
						array_delete(temp_battle_instance.battle_combat_actions, temp_combat_action_index, 1);
						
						// Destroy the Combat Action Instance
						instance_destroy(temp_combat_action_instance);
					}
					
					// Decrement Battle Combat Action Index
					temp_combat_action_index--;
				}
				#endregion
				
				// Decrement Battle Index
				temp_battle_index--;
			}
			#endregion
			
			#region Unit Behaviour 
			// Iterate through Celestial Object Unit Behaviours
			var temp_unit_index = 0;
			var temp_unit_count = array_length(units);
			
			repeat (temp_unit_count)
			{
				// Find Unit Instance
				var temp_unit_instance = units[temp_unit_index];
				
				// Check for Unit Hazard Avoidance Behaviour
				temp_unit_instance.unit_behaviour = temp_unit_instance.avoid_count > 0 ? CelestialUnitBehaviourType.Avoid : temp_unit_instance.unit_behaviour;
				
				// Establish Unit Behaviour Variables
				var temp_unit_movement = !temp_unit_instance.engaged_in_battle;
				
				// Perform Action Behaviour
				switch (temp_unit_instance.unit_behaviour)
				{
					case CelestialUnitBehaviourType.Attack:
					case CelestialUnitBehaviourType.Regroup:
					case CelestialUnitBehaviourType.Hunt:
					case CelestialUnitBehaviourType.Garrison:
						// Check if Unit Instance is Engaged in Battle
						if (temp_unit_instance.engaged_in_battle)
						{
							// Unit is busy fighting in Combat and does not need to recalculate their Pathfinding Behaviour - Early Break
							break;
						}
						
						// Check if Unit is already indexed in the Celestial Simulator's Pathfinding Queue
						if (ds_list_find_index(CelestialSimulator.pathfinding_queue_list, temp_unit_instance) != -1)
						{
							// Unit is already scheduled to recalculate their Pathfinding Behaviour - Early Break
							break;
						}
						
						// Check if Unit's Behaviour Target Instance still exists and shares the same Celestial Body Instance
						if (!instance_exists(temp_unit_instance.unit_behaviour_target_instance) or temp_unit_instance.celestial_body_instance != temp_unit_instance.unit_behaviour_target_instance.celestial_body_instance)
						{
							// Unit's Behaviour Target Instance is no longer valid - Reset Unit's Behaviour
							temp_unit_instance.unit_behaviour = CelestialUnitBehaviourType.None;
							
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
						else if (temp_unit_instance.unit_behaviour_target_instance.celestial_sub_object_type == CelestialSubObjectType.Unit)
						{
							// Update Pathfinding Path to end at the Target Instance's Position & Elevation
							ds_list_set(temp_unit_instance.pathfinding_path.position_x, temp_unit_instance.pathfinding_path.path_size - 1, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_x);
							ds_list_set(temp_unit_instance.pathfinding_path.position_y, temp_unit_instance.pathfinding_path.path_size - 1, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_y);
							ds_list_set(temp_unit_instance.pathfinding_path.position_z, temp_unit_instance.pathfinding_path.path_size - 1, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_z);
							ds_list_set(temp_unit_instance.pathfinding_path.position_elevation, temp_unit_instance.pathfinding_path.path_size - 1, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_elevation);
						}
						break;
					case CelestialUnitBehaviourType.Retreat:
						// Unit Instance is Retreating and is allowed to Perform Movement Behaviour
						temp_unit_movement = true;
						
						// Check if Unit Instance is Engaged in Battle
						if (!temp_unit_instance.engaged_in_battle)
						{
							// Unit is no longer fighting in Combat and does not need to Retreat - Reset Unit's Behaviour
							temp_unit_instance.unit_behaviour = CelestialUnitBehaviourType.None;
							break;
						}
						break;
					case CelestialUnitBehaviourType.Avoid:
						// Iterate through Unit's Avoid Instances
						var temp_unit_avoid_instance_index = temp_unit_instance.avoid_count - 1;
						
						repeat (temp_unit_instance.avoid_count)
						{
							// Establish Avoid Instance & Radius
							var temp_unit_avoid_instance = temp_unit_instance.avoid_instance[temp_unit_avoid_instance_index];
							var temp_unit_avoid_radius = temp_unit_instance.avoid_radius[temp_unit_avoid_instance_index];
							var temp_unit_avoid_dot_product = -2;
							
							// Check if Unit's Avoid Instance Exists
							if (instance_exists(temp_unit_avoid_instance))
							{
								// Calculate the Dot Product between the Unit Instance's Normalized Local Sphere Vector and the Avoid Instance's Normalized Local Sphere Vector
								temp_unit_avoid_dot_product = dot_product_3d
								(
									temp_unit_instance.sphere_vector_x, 
									temp_unit_instance.sphere_vector_y, 
									temp_unit_instance.sphere_vector_z, 
									temp_unit_avoid_instance.sphere_vector_x, 
									temp_unit_avoid_instance.sphere_vector_y, 
									temp_unit_avoid_instance.sphere_vector_z
								);
							}
							
							// Check if Unit Instance is still within the Avoid Instance's Radius
							if (temp_unit_avoid_dot_product < temp_unit_avoid_radius)
							{
								// Unit has left the Avoid Instance's Area of Effect - Remove Avoid Instance from Unit's Avoid Arrays
								temp_unit_instance.avoid_count--;
								array_delete(temp_unit_instance.avoid_instance, temp_unit_avoid_instance_index, 1);
								array_delete(temp_unit_instance.avoid_radius, temp_unit_avoid_instance_index, 1);
							}
							
							// Decrement Unit's Avoid Instance Index
							temp_unit_avoid_instance_index--;
						}
						
						// Check if Unit Instance is still within range of Hazards to Avoid
						if (temp_unit_instance.avoid_count > 0)
						{
							// Initiate Unit Pathfinding (Avoid) Behaviour
							celestial_pathfinding_avoid(temp_unit_instance);
						}
						else if (is_undefined(temp_unit_instance.pathfinding_path))
						{
							// Unit is no longer within range of a Hazard and does not need to perform their Avoid Behaviour - Reset Unit's Behaviour
							temp_unit_instance.unit_behaviour = CelestialUnitBehaviourType.None;
						}
						break;
					case CelestialUnitBehaviourType.Patrol:
					case CelestialUnitBehaviourType.None:
					default:
						break;
				}
				
				// Perform Movement Behaviour
				if (!is_undefined(temp_unit_instance.pathfinding_path) and temp_unit_movement)
				{
					// Establish Unit Movement Power
					var temp_movement_power = temp_unit_instance.unit_movement_power * CelestialSimulator.global_clock_delta_time;
					
					// If Unit is currently engaged in a Battle, Apply Unit's Battle Engagement Movement Penalty to Unit Movement Power
					temp_movement_power *= temp_unit_instance.engaged_in_battle ? 0.5 : 1;
					
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
								var temp_next_pathfinding_node_index = ds_list_find_value(temp_unit_instance.pathfinding_path.node_index, min(temp_unit_instance.pathfinding_path_index + 1, temp_unit_instance.pathfinding_path.path_size - 1));
								
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
								
								// Establish Unit Pathfinding Target Instance Variables
								var temp_pathfinding_target_instance_check_collision = false;
								
								// Update Unit Pathfinding Path Target if Pathing to Instance
								switch (temp_unit_instance.unit_behaviour)
								{
									case CelestialUnitBehaviourType.Attack:
									case CelestialUnitBehaviourType.Regroup:
									case CelestialUnitBehaviourType.Hunt:
									case CelestialUnitBehaviourType.Garrison:
										// Check if the Unit Behaviour Target Instance Exists
										if (instance_exists(temp_unit_instance.unit_behaviour_target_instance))
										{
											// Check if Pathfinding Unit Instance shares their current Pathfinding Node Index with their Unit Behaviour Target Instance
											if (temp_pathfinding_node_index == temp_unit_instance.unit_behaviour_target_instance.pathfinding_node_index)
											{
												// Check if Target Instance is a Unit or another kind of Sub Object Instance
												if (temp_unit_instance.unit_behaviour_target_instance.celestial_sub_object_type == CelestialSubObjectType.Unit)
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
											
											// Enable Collision Checking with the Unit Behaviour Target Instance
											temp_pathfinding_target_instance_check_collision = true;
										}
										break;
									case CelestialUnitBehaviourType.Patrol:
									case CelestialUnitBehaviourType.Retreat:
									case CelestialUnitBehaviourType.Avoid:
									case CelestialUnitBehaviourType.None:
									default:
										break;
								}
								
								// Battle Engagement Unit Pathfinding Behaviour
								if (temp_unit_instance.engaged_in_battle)
								{
									// Establish Pathfinding Unit's Valid Retreat Destination Condition
									var temp_pathfinding_target_is_valid_retreat_destination = true;
									
									// Iterate through Pathfinding Unit's Engaged Battles and check if their Target Position is a Valid Retreat Destination
									var temp_pathfinding_unit_engaged_battle_count = array_length(temp_unit_instance.engaged_battles);
									var temp_pathfinding_unit_engaged_battle_index = temp_pathfinding_unit_engaged_battle_count - 1;
									
									repeat (temp_pathfinding_unit_engaged_battle_count)
									{
										// Find Pathfinding Unit's Engaged Battle Instance
										var temp_pathfinding_unit_engaged_battle_instance = temp_unit_instance.engaged_battles[temp_pathfinding_unit_engaged_battle_index];
										
										// Calculate the Retreat Direction the Pathfinding Unit is heading towards using their current position and their orientation to the Engaged Battle as a reference
										var temp_pathfinding_retreat_direction = spherical_point_direction
										(
											temp_pathfinding_unit_x, 
											temp_pathfinding_unit_y, 
											temp_pathfinding_unit_z,
											temp_pathfinding_unit_engaged_battle_instance.sphere_vector_x, 
											temp_pathfinding_unit_engaged_battle_instance.sphere_vector_y, 
											temp_pathfinding_unit_engaged_battle_instance.sphere_vector_z,
											temp_pathfinding_target_x, 
											temp_pathfinding_target_y, 
											temp_pathfinding_target_z
										);
										
										// Check if the Retreat Direction is above the Celestial Battle Unit Retreat Angle Minimum
										if (temp_pathfinding_retreat_direction <= global.celestial_battle_unit_retreat_angle_minimum)
										{
											// Retreat Direction is in the direction the Unit is facing towards the Battle - Target Position is disqualified as a Valid Retreat Destination
											temp_pathfinding_target_is_valid_retreat_destination = false;
											
											// End iterating through the Pathfinding Unit's Engaged Battles
											break;
										}
										
										// Decrement the Pathfinding Unit's Engaged Battle Index
										temp_pathfinding_unit_engaged_battle_index--;
									}
									
									// Check if Unit's Pathfinding Target was a Valid Retreat Destination
									if (!temp_pathfinding_target_is_valid_retreat_destination)
									{
										// Reset Unit's Behaviour to end their Retreat
										temp_unit_instance.unit_behaviour = CelestialUnitBehaviourType.None;
										
										// Find Celestial Unit's First Engaged Battle Spherical Normalized Vector
										var temp_pathfinding_retreat_battle_x = temp_unit_instance.engaged_battles[0].sphere_vector_x;
										var temp_pathfinding_retreat_battle_z = temp_unit_instance.engaged_battles[0].sphere_vector_z;
										
										// Update Unit's Sprite Facing Direction based on their Pathfinding Angle Difference
										var temp_pathfinding_retreat_facing_direction = celestial_unit_calculate_spherical_facing_direction(temp_unit_instance.sphere_vector_x, temp_unit_instance.sphere_vector_z, temp_pathfinding_retreat_battle_x, temp_pathfinding_retreat_battle_z);
										temp_unit_instance.image_xscale = temp_pathfinding_retreat_facing_direction != 0 ? temp_pathfinding_retreat_facing_direction : temp_unit_instance.image_xscale;
										
										// End Unit's Pathfinding Behaviour
										break;
									}
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
								
								// Calculate Pathfinding Path Progress Lerp Value
								var temp_pathfinding_path_lerp_value = temp_pathfinding_remaining_movement_cost <= 0 ? 1 : temp_pathfinding_movement_power_spend / temp_pathfinding_remaining_movement_cost;
								
								// Calculate Unit's Pathfinding Position & Elevation based on Pathfinding Path Progress
								var temp_pathfinding_movement_position_x = lerp(temp_pathfinding_unit_x, temp_pathfinding_target_x, temp_pathfinding_path_lerp_value);
								var temp_pathfinding_movement_position_y = lerp(temp_pathfinding_unit_y, temp_pathfinding_target_y, temp_pathfinding_path_lerp_value);
								var temp_pathfinding_movement_position_z = lerp(temp_pathfinding_unit_z, temp_pathfinding_target_z, temp_pathfinding_path_lerp_value);
								var temp_pathfinding_movement_position_elevation = lerp(temp_pathfinding_unit_elevation, temp_pathfinding_target_elevation, temp_pathfinding_path_lerp_value);
								
								// Update Unit's Sprite Facing Direction based on their Pathfinding Angle Difference
								var temp_pathfinding_movement_facing_direction = celestial_unit_calculate_spherical_facing_direction(temp_pathfinding_unit_x, temp_pathfinding_unit_z, temp_pathfinding_target_x, temp_pathfinding_target_z);
								temp_unit_instance.image_xscale = temp_pathfinding_movement_facing_direction != 0 ? temp_pathfinding_movement_facing_direction : temp_unit_instance.image_xscale;
								
								// Update Unit's Pathfinding Position & Elevation
								temp_unit_instance.pathfinding_position_x = temp_pathfinding_movement_position_x;
								temp_unit_instance.pathfinding_position_y = temp_pathfinding_movement_position_y;
								temp_unit_instance.pathfinding_position_z = temp_pathfinding_movement_position_z;
								temp_unit_instance.pathfinding_position_elevation = temp_pathfinding_movement_position_elevation;
								
								// Decrement Unit Movement Power
								temp_movement_power -= temp_pathfinding_remaining_movement_cost;
								
								// Pathfinding Unit Collision Check Behaviour
								if (temp_pathfinding_target_instance_check_collision)
								{
									// Calculate the Dot Product between the Pathfinding Unit Instance's Normalized Local Sphere Vector and the Comparison Unit Behaviour Target Instance's Normalized Local Sphere Vector
									var temp_pathfinding_target_instance_collision_dot_product = dot_product_3d
									(
										temp_unit_instance.sphere_vector_x, 
										temp_unit_instance.sphere_vector_y, 
										temp_unit_instance.sphere_vector_z, 
										temp_unit_instance.unit_behaviour_target_instance.sphere_vector_x, 
										temp_unit_instance.unit_behaviour_target_instance.sphere_vector_y, 
										temp_unit_instance.unit_behaviour_target_instance.sphere_vector_z
									);
									
									// Check if Pathfinding Unit has entered the Collision Distance Threshold with their Target Instance
									if (temp_pathfinding_target_instance_collision_dot_product >= temp_unit_instance.unit_collision_threshold)
									{
										// Determine Unit's Collision Behaviour based on Target Instance's Celestial Sub Object Type
										switch (temp_unit_instance.unit_behaviour_target_instance.celestial_sub_object_type)
										{
											case CelestialSubObjectType.Unit:
												// Check Pathfinding Unit Instance's Faction Relationship to the Target Unit's Faction
												if (temp_unit_instance.unit_faction == temp_unit_instance.unit_behaviour_target_instance)
												{
													// Units are both in the same Faction
												}
												else if (celestial_faction_is_relationship_hostile(temp_unit_instance.unit_faction, temp_unit_instance.unit_behaviour_target_instance.unit_faction))
												{
													// Unit is Hostile to Target Unit - Create a new Celestial Battle between the two Units if eligible to do so
													if (!temp_unit_instance.engaged_in_battle)
													{
														// Instantiate and Establish Celestial Battle Instance
														var temp_pathfinding_collision_unit_battle_instance = celestial_battle_create(id, temp_unit_instance.unit_faction, temp_unit_instance.unit_behaviour_target_instance.unit_faction);
														
														// Update Celestial Battle Instance's Position & Elevation
														temp_pathfinding_collision_unit_battle_instance.battle_x = lerp(temp_unit_instance.pathfinding_position_x, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_x, 0.5);
														temp_pathfinding_collision_unit_battle_instance.battle_y = lerp(temp_unit_instance.pathfinding_position_y, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_y, 0.5);
														temp_pathfinding_collision_unit_battle_instance.battle_z = lerp(temp_unit_instance.pathfinding_position_z, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_z, 0.5);
														temp_pathfinding_collision_unit_battle_instance.battle_elevation = lerp(temp_unit_instance.pathfinding_position_elevation, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_elevation, 0.5);
														
														temp_pathfinding_collision_unit_battle_instance.sphere_vector_x = temp_pathfinding_collision_unit_battle_instance.battle_x;
														temp_pathfinding_collision_unit_battle_instance.sphere_vector_y = temp_pathfinding_collision_unit_battle_instance.battle_y;
														temp_pathfinding_collision_unit_battle_instance.sphere_vector_z = temp_pathfinding_collision_unit_battle_instance.battle_z;
														
														// Check if Target Unit Instance was Engaged in Combat
														if (temp_unit_instance.unit_behaviour_target_instance.engaged_in_battle)
														{
															// Add Target Unit Instance's Battle Engagement Action Stun Penalty
															celestial_unit_add_status_effect(temp_unit_instance.unit_behaviour_target_instance, CelestialUnitStatusEffectType.CombatActionStun);
														}
														
														// Add Unit Instances to Battle
														celestial_battle_add_unit(temp_pathfinding_collision_unit_battle_instance, temp_unit_instance);
														celestial_battle_add_unit(temp_pathfinding_collision_unit_battle_instance, temp_unit_instance.unit_behaviour_target_instance);
														
														// Check if either of the Unit Instances are currently selected by the Player
														if (temp_unit_instance == CelestialSimulator.sub_object_selected_instance or temp_unit_instance.unit_behaviour_target_instance == CelestialSimulator.sub_object_selected_instance)
														{
															// Select the Celestial Battle
															CelestialSimulator.select_sub_object_instance(temp_pathfinding_collision_unit_battle_instance);
														}
														
														// Reset Unit Instance's Movement Power
														temp_movement_power = 0;
													}
												}
												break;
											case CelestialSubObjectType.City:
												break;
											default:
												break;
										}
									}
								}
								
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
											case CelestialUnitBehaviourType.Attack:
											case CelestialUnitBehaviourType.Regroup:
											case CelestialUnitBehaviourType.Hunt:
											case CelestialUnitBehaviourType.Garrison:
											case CelestialUnitBehaviourType.Patrol:
											case CelestialUnitBehaviourType.Retreat:
											case CelestialUnitBehaviourType.Avoid:
											case CelestialUnitBehaviourType.None:
											default:
												temp_unit_instance.unit_behaviour = CelestialUnitBehaviourType.None;
												break;
										}
										
										// Face the Celestial Unit towards the Battle they're engaged in
										if (temp_unit_instance.engaged_in_battle)
										{
											// Find Celestial Unit's First Engaged Battle Spherical Normalized Vector
											var temp_pathfinding_ended_battle_x = temp_unit_instance.engaged_battles[0].sphere_vector_x;
											var temp_pathfinding_ended_battle_z = temp_unit_instance.engaged_battles[0].sphere_vector_z;
											
											// Update Unit's Sprite Facing Direction based on their Pathfinding Angle Difference
											var temp_pathfinding_ended_facing_direction = celestial_unit_calculate_spherical_facing_direction(temp_unit_instance.sphere_vector_x, temp_unit_instance.sphere_vector_z, temp_pathfinding_ended_battle_x, temp_pathfinding_ended_battle_z);
											temp_unit_instance.image_xscale = temp_pathfinding_ended_facing_direction != 0 ? temp_pathfinding_ended_facing_direction : temp_unit_instance.image_xscale;
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
									
									// Check for Hostile Unit at Unit's Pathfinding Node Index
									if (!temp_unit_instance.engaged_in_battle and instance_exists(temp_unit_instance.unit_faction))
									{
										// Iterate through the Pathfinding Node Index's Units Array
										var temp_pathfinding_node_units_array_count = array_length(pathfinding_node_units_array[temp_unit_instance.pathfinding_node_index]);
										var temp_pathfinding_node_units_array_index = temp_pathfinding_node_units_array_count - 1;
										
										repeat (temp_pathfinding_node_units_array_count)
										{
											// Find Unit Instance from Pathfinding Node Units Array
											var temp_pathfinding_node_units_array_unit_instance = array_get(pathfinding_node_units_array[temp_unit_instance.pathfinding_node_index], temp_pathfinding_node_units_array_index);
											
											// Add Unit Instance to Battle
											if (celestial_faction_is_relationship_hostile(temp_unit_instance.unit_faction, temp_pathfinding_node_units_array_unit_instance.unit_faction))
											{
												// Instantiate and Establish Celestial Battle Instance
												var temp_pathfinding_node_unit_battle_instance = celestial_battle_create(id, temp_unit_instance.unit_faction, temp_pathfinding_node_units_array_unit_instance.unit_faction);
												
												// Update Celestial Battle Instance's Position & Elevation
												temp_pathfinding_node_unit_battle_instance.battle_x = lerp(temp_unit_instance.pathfinding_position_x, temp_pathfinding_node_units_array_unit_instance.pathfinding_position_x, 0.5);
												temp_pathfinding_node_unit_battle_instance.battle_y = lerp(temp_unit_instance.pathfinding_position_y, temp_pathfinding_node_units_array_unit_instance.pathfinding_position_y, 0.5);
												temp_pathfinding_node_unit_battle_instance.battle_z = lerp(temp_unit_instance.pathfinding_position_z, temp_pathfinding_node_units_array_unit_instance.pathfinding_position_z, 0.5);
												temp_pathfinding_node_unit_battle_instance.battle_elevation = lerp(temp_unit_instance.pathfinding_position_elevation, temp_pathfinding_node_units_array_unit_instance.pathfinding_position_elevation, 0.5);
												
												temp_pathfinding_node_unit_battle_instance.sphere_vector_x = temp_pathfinding_node_unit_battle_instance.battle_x;
												temp_pathfinding_node_unit_battle_instance.sphere_vector_y = temp_pathfinding_node_unit_battle_instance.battle_y;
												temp_pathfinding_node_unit_battle_instance.sphere_vector_z = temp_pathfinding_node_unit_battle_instance.battle_z;
												
												// Check if Hostile Unit Instance was Engaged in Combat
												if (temp_pathfinding_node_units_array_unit_instance.engaged_in_battle)
												{
													// Add Hostile Unit Instance's Battle Engagement Action Stun Penalty
													celestial_unit_add_status_effect(temp_pathfinding_node_units_array_unit_instance, CelestialUnitStatusEffectType.CombatActionStun);
												}
												
												// Add Unit Instances to Battle
												celestial_battle_add_unit(temp_pathfinding_node_unit_battle_instance, temp_unit_instance);
												celestial_battle_add_unit(temp_pathfinding_node_unit_battle_instance, temp_pathfinding_node_units_array_unit_instance);
												
												// Check if either of the Unit Instances are currently selected by the Player
												if (temp_unit_instance == CelestialSimulator.sub_object_selected_instance or temp_pathfinding_node_units_array_unit_instance == CelestialSimulator.sub_object_selected_instance)
												{
													// Select the Celestial Battle
													CelestialSimulator.select_sub_object_instance(temp_pathfinding_node_unit_battle_instance);
												}
												
												// Reset Unit Instance's Movement Power
												temp_movement_power = 0;
												
												// Battle Instantiated - Exit from Pathfinding Node Units Array Loop
												break;
											}
											
											// Decrement Pathfinding Node Units Array Index
											temp_pathfinding_node_units_array_index--;
										}
									}
									
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
				
				// Establish Unit Instance's Local Sphere Vector
				if (!pathfinding_enabled)
				{
					// Find Vertical Sphere Vector
					var temp_unit_atan_value = (0.5 - temp_unit_instance.local_position_u) * 2 * pi;
					var temp_unit_asin_value = (0.5 - temp_unit_instance.local_position_v) * pi;
					temp_unit_instance.sphere_vector_y = -sin(temp_unit_asin_value);
					
					// Find Horizontal and Forwards Sphere Vectors
					var temp_unit_sphere_horizontal_radius = sqrt(1.0 - temp_unit_instance.sphere_vector_y * temp_unit_instance.sphere_vector_y);
					temp_unit_instance.sphere_vector_x = temp_unit_sphere_horizontal_radius * -sin(temp_unit_atan_value);
					temp_unit_instance.sphere_vector_z = temp_unit_sphere_horizontal_radius * -cos(temp_unit_atan_value);
				}
				else
				{
					// Find Celestial Unit's Normalized Local Vector and Elevation from Celestial Body's Sphere Center with their Pathfinding positioning variables
					temp_unit_instance.sphere_vector_x = temp_unit_instance.pathfinding_position_x;
					temp_unit_instance.sphere_vector_y = temp_unit_instance.pathfinding_position_y;
					temp_unit_instance.sphere_vector_z = temp_unit_instance.pathfinding_position_z;
				}
				
				// Iterate through Unit Instance's Timed Collision Checks with Battles
				var temp_unit_timed_collision_check_battles_count = array_length(temp_unit_instance.unit_battle_within_timed_collision_check_battles);
				var temp_unit_timed_collision_check_battles_index = temp_unit_timed_collision_check_battles_count - 1;
				
				repeat (temp_unit_timed_collision_check_battles_count)
				{
					// Find Timed Collision Check Battle Instance
					var temp_timed_collision_check_battle_instance = temp_unit_instance.unit_battle_within_timed_collision_check_battles[temp_unit_timed_collision_check_battles_index];
					
					// Check if Timed Collision Check Battle Instance Exists
					if (instance_exists(temp_timed_collision_check_battle_instance))
					{
						// Calculate the Dot Product between the Timed Collision Check Battle Instance's Normalized Local Sphere Vector and the Unit Instance's Normalized Local Sphere Vector
						var temp_unit_timed_collision_check_battle_dot_product = dot_product_3d
						(
							temp_unit_instance.sphere_vector_x, 
							temp_unit_instance.sphere_vector_y, 
							temp_unit_instance.sphere_vector_z,
							temp_timed_collision_check_battle_instance.sphere_vector_x, 
							temp_timed_collision_check_battle_instance.sphere_vector_y, 
							temp_timed_collision_check_battle_instance.sphere_vector_z
						);
						
						// Check if Unit Instance is still within the Battle's Far Combat Engagement Threshold
						if (temp_unit_timed_collision_check_battle_dot_product >= temp_timed_collision_check_battle_instance.battle_far_collision_threshold)
						{
							// Decrement Timed Collision Check Battle's Timer
							temp_unit_instance.unit_battle_within_timed_collision_check_timers[temp_unit_timed_collision_check_battles_index] -= CelestialSimulator.global_clock_delta_time;
							
							// Check if Timer is not done counting down
							if (temp_unit_instance.unit_battle_within_timed_collision_check_timers[temp_unit_timed_collision_check_battles_index] > 0)
							{
								// Decrement Unit's Timed Collision Check Battles Index
								temp_unit_timed_collision_check_battles_index--;
								
								// Skip adding Unit to Battle or deleting Battle from Unit Instance's Timed Collision Check Battles
								continue;
							}
							
							// Add Unit Instance to Battle
							celestial_battle_add_unit(temp_timed_collision_check_battle_instance, temp_unit_instance);
						}
					}
					
					// Delete Timed Collision Check Battle and Timer from Unit Instance
					array_delete(temp_unit_instance.unit_battle_within_timed_collision_check_battles, temp_unit_timed_collision_check_battles_index, 1);
					array_delete(temp_unit_instance.unit_battle_within_timed_collision_check_timers, temp_unit_timed_collision_check_battles_index, 1);
					
					// Decrement Unit's Timed Collision Check Battles Index
					temp_unit_timed_collision_check_battles_index--;
				}
				
				// Check if Unit is Engaged in Battle
				if (!temp_unit_instance.engaged_in_battle)
				{
					// Decrement Collision Check Timer
					temp_unit_instance.unit_collision_check_timer -= frame_delta;
					
					// Collision Check Behaviour
					if (temp_unit_instance.unit_collision_check_timer <= 0 and instance_exists(temp_unit_instance.unit_faction))
					{
						// Reset Collision Check Timer
						temp_unit_instance.unit_collision_check_timer = CelestialSimulator.global_collision_check_interval;
						
						// Iterate through Celestial Object Battle Behaviours
						var temp_battle_check_index = 0;
						var temp_battle_check_count = array_length(battles);
						
						repeat (temp_battle_check_count)
						{
							// Find Battle Instance
							var temp_battle_check_instance = battles[temp_battle_check_index];
							
							// Calculate the Dot Product between the Battle Instance's Normalized Local Sphere Vector and the Unit Instance's Normalized Local Sphere Vector
							var temp_unit_collision_check_battle_dot_product = dot_product_3d
							(
								temp_unit_instance.sphere_vector_x, 
								temp_unit_instance.sphere_vector_y, 
								temp_unit_instance.sphere_vector_z,
								temp_battle_check_instance.sphere_vector_x, 
								temp_battle_check_instance.sphere_vector_y, 
								temp_battle_check_instance.sphere_vector_z
							);
							
							// Check if Unit is within the Battle's Combat Engagement Threshold
							if (temp_unit_collision_check_battle_dot_product >= temp_battle_check_instance.battle_near_collision_threshold)
							{
								// Add Unit Instance to Battle
								celestial_battle_add_unit(temp_battle_check_instance, temp_unit_instance);
							}
							else if (temp_unit_collision_check_battle_dot_product >= temp_battle_check_instance.battle_far_collision_threshold and array_get_index(temp_unit_instance.unit_battle_within_timed_collision_check_battles, temp_battle_check_instance) == -1)
							{
								// Add Battle to Unit Instance's Timed Collision Check Battles
								array_push(temp_unit_instance.unit_battle_within_timed_collision_check_battles, temp_battle_check_instance);
								array_push(temp_unit_instance.unit_battle_within_timed_collision_check_timers, temp_battle_check_instance.battle_far_collision_delay);
							}
							
							// Increment Battles Check Index
							temp_battle_check_index++;
						}
					}
				}
				else
				{
					// Unit Reinforcement Behaviour
					temp_unit_instance.battle_reinforcement_timer -= CelestialSimulator.global_clock_delta_time;
					
					if (temp_unit_instance.battle_reinforcement_timer <= 0)
					{
						// Check if Unit has Unengaged Combat Units to load into their Engaged Battles
						if (temp_unit_instance.combat_unit_unengaged_count > 0)
						{
							// Load Combat Units into the first Battle the Unit is engaged in
							celestial_battle_load_combat_units(temp_unit_instance.engaged_battles[0], temp_unit_instance);
						}
						
						// Reset the Unit's Battle Reinforcement Timer
						temp_unit_instance.battle_reinforcement_timer += global.celestial_battle_unit_reinforcement_delay;
					}
					
					// Calculate Unit Solar Value & Unit Solar Type
					var temp_unit_solar_x = temp_unit_instance.sphere_vector_x * rotation_matrix[0] + temp_unit_instance.sphere_vector_y * rotation_matrix[4] + temp_unit_instance.sphere_vector_z * rotation_matrix[8];
					var temp_unit_solar_y = temp_unit_instance.sphere_vector_x * rotation_matrix[1] + temp_unit_instance.sphere_vector_y * rotation_matrix[5] + temp_unit_instance.sphere_vector_z * rotation_matrix[9];
					var temp_unit_solar_z = temp_unit_instance.sphere_vector_x * rotation_matrix[2] + temp_unit_instance.sphere_vector_y * rotation_matrix[6] + temp_unit_instance.sphere_vector_z * rotation_matrix[10];
					
					var temp_unit_solar_value = dot_product_3d(temp_unit_solar_x, temp_unit_solar_y, temp_unit_solar_z, temp_sun_vector_x, temp_sun_vector_y, temp_sun_vector_z);
					
					switch (floor((temp_unit_solar_value + 1) * 1.5))
					{
						case 0:
							temp_unit_instance.unit_solar = CelestialSolarType.Night
							break;
						case 1:
							temp_unit_instance.unit_solar = CelestialSolarType.Twilight
							break;
						default:
							temp_unit_instance.unit_solar = CelestialSolarType.Day
							break;
					}
				}
				
				// Calculate Unit Instance's Status Effect Behaviour
				var temp_unit_status_effect_count = array_length(temp_unit_instance.status_effect_array);
				
				if (temp_unit_status_effect_count > 0)
				{
					// Iterate through all of the Unit's Status Effects
					var temp_unit_status_effect_index = temp_unit_status_effect_count - 1;
					
					repeat (temp_unit_status_effect_count)
					{
						// Find Unit Status Effect's Duration
						var temp_unit_status_effect_duration = array_get(temp_unit_instance.status_effect_duration_array, temp_unit_status_effect_index);
						
						// Decrement Unit Status Effect's Duration
						temp_unit_status_effect_duration -= CelestialSimulator.global_clock_delta_time;
						
						// Check if Unit Status Effect has Elapsed
						if (temp_unit_status_effect_duration <= 0)
						{
							// Delete Unit Status Effect
							array_delete(temp_unit_instance.status_effect_array, temp_unit_status_effect_index, 1);
							array_delete(temp_unit_instance.status_effect_duration_array, temp_unit_status_effect_index, 1);
						}
						else
						{
							// Update Unit Status Effect's Duration
							array_set(temp_unit_instance.status_effect_duration_array, temp_unit_status_effect_index, temp_unit_status_effect_duration);
						}
						
						// Decrement Unit Status Effect Index
						temp_unit_status_effect_index--;
					}
				}
				
				// Increment Unit Index
				temp_unit_index++;
			}
			#endregion
			
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

#region Pathfinding Queue
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
					case CelestialUnitBehaviourType.Attack:
					case CelestialUnitBehaviourType.Regroup:
					case CelestialUnitBehaviourType.Hunt:
					case CelestialUnitBehaviourType.Garrison:
						// Check if Unit Instance's Pathfinding Target Instance Exists or if Unit Instance's Pathfinding Target Instance does not share the same Celestial Body Instance
						if (!instance_exists(temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance) or temp_pathfinding_queue_unit_inst.celestial_body_instance != temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.celestial_body_instance)
						{
							// Unit Instance's Pathfinding Target Instance does not exist - Remove Unit Instance from Pathfinding Queue
							ds_list_delete(pathfinding_queue_list, 0);
							
							// Reset Unit Instance's Behaviour
							temp_pathfinding_queue_unit_inst.unit_behaviour = CelestialUnitBehaviourType.None;
							
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
						if (temp_pathfinding_queue_unit_inst.unit_behaviour_target_instance.celestial_sub_object_type == CelestialSubObjectType.Unit)
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
					case CelestialUnitBehaviourType.Patrol:
						// Check if Unit Instance's Pathfinding Target Node Index is a valid Pathfinding Node Index
						if (temp_pathfinding_queue_unit_inst.unit_behaviour_target_node_index < 0 or temp_pathfinding_queue_unit_inst.unit_behaviour_target_node_index >= temp_pathfinding_queue_unit_inst.celestial_body_instance.pathfinding_nodes_count)
						{
							// Unit Instance's Pathfinding Target Node Index does not exist - Remove Unit Instance from Pathfinding Queue
							ds_list_delete(pathfinding_queue_list, 0);
							
							// Reset Unit Instance's Behaviour
							temp_pathfinding_queue_unit_inst.unit_behaviour = CelestialUnitBehaviourType.None;
							
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
					case CelestialUnitBehaviourType.Retreat:
					case CelestialUnitBehaviourType.Avoid:
					case CelestialUnitBehaviourType.None:
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
#endregion

// Reset Celestial Simulator's UI Behaviours
selected_unit_movement_path_ui = false;
