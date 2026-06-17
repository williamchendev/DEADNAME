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

// Reset Celestial Unit Behaviours
with (oCelestialUnit)
{
	// Reset Celestial Unit Combat Behaviour
	engaged_in_battle = false;
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
			
			// Iterate through Celestial Object Battle Behaviours
			var temp_battle_index = 0;
			var temp_battle_count = array_length(battles);
			
			repeat (temp_battle_count)
			{
				// Find Battle Instance
				var temp_battle_instance = battles[temp_battle_index];
				
				// Decrement Collision Check Timer
				temp_battle_instance.battle_collision_check_timer -= frame_delta;
				
				// Establish Battle Position, Elevation, & Divisor
				var temp_battle_x = 0;
				var temp_battle_y = 0;
				var temp_battle_z = 0;
				var temp_battle_elevation = 0;
				var temp_battle_unit_divisor = 0;
				var temp_battle_faction_divisor = 0;
				
				// Iterate through Battle Faction Unit Arrays
				var temp_battle_faction_count = array_length(temp_battle_instance.battle_factions);
				var temp_battle_faction_index = temp_battle_faction_count - 1;
				
				repeat (temp_battle_faction_count)
				{
					// Establish Faction's Hostile Encounter Toggle & Units Active Count
					var temp_battle_faction_hostile_encounter = array_length(temp_battle_instance.battle_hostile_factions[temp_battle_faction_index]) > 0;
					var temp_battle_faction_units_active = 0;
					
					// Establish Faction's Unit Center Position & Elevation
					var temp_battle_faction_unit_center_x = 0;
					var temp_battle_faction_unit_center_y = 0;
					var temp_battle_faction_unit_center_z = 0;
					var temp_battle_faction_unit_elevation = 0;
					
					// Iterate through Battle Units
					var temp_battle_unit_count = array_length(temp_battle_instance.battle_units[temp_battle_faction_index]);
					var temp_battle_unit_index = temp_battle_unit_count - 1;
					
					repeat (temp_battle_unit_count)
					{
						// Find Battle Unit Instance
						var temp_battle_unit_instance = array_get(temp_battle_instance.battle_units[temp_battle_faction_index], temp_battle_unit_index);
						
						// Check if Unit is still in the Active Combat Pathfinding Node
						if (!instance_exists(temp_battle_unit_instance))
						{
							// Remove Battle Unit from Battle Faction Unit Array
							array_delete(temp_battle_instance.battle_units[temp_battle_faction_index], temp_battle_unit_index, 1);
						}
						else if (temp_battle_instance.battle_collision_check_timer <= 0)
						{
							// Calculate the Dot Product between the Battle Instance's Normalized Local Sphere Vector and the Battle Unit Instance's Normalized Local Sphere Vector
							var temp_battle_unit_dot_product = dot_product_3d
							(
								temp_battle_instance.sphere_vector_x, 
								temp_battle_instance.sphere_vector_y, 
								temp_battle_instance.sphere_vector_z, 
								temp_battle_unit_instance.sphere_vector_x, 
								temp_battle_unit_instance.sphere_vector_y, 
								temp_battle_unit_instance.sphere_vector_z
							);
							
							// Check if Unit is within the Battle's Collision Threshold
							if (temp_battle_unit_dot_product < temp_battle_instance.battle_far_collision_threshold)
							{
								// Remove Battle Unit from Battle Faction Unit Array
								array_delete(temp_battle_instance.battle_units[temp_battle_faction_index], temp_battle_unit_index, 1);
							}
							else
							{
								// Set Unit is Engaged in Battle
								temp_battle_unit_instance.engaged_in_battle = true;
								
								// Add Unit's Position to Faction Centering
								temp_battle_faction_unit_center_x += temp_battle_unit_instance.sphere_vector_x;
								temp_battle_faction_unit_center_y += temp_battle_unit_instance.sphere_vector_y;
								temp_battle_faction_unit_center_z += temp_battle_unit_instance.sphere_vector_z;
								
								// Find Battle Faction's Elevation Maxiumum
								temp_battle_faction_unit_elevation = max(temp_battle_faction_unit_elevation, temp_battle_unit_instance.pathfinding_position_elevation);
								
								// Increment Faction's Units Active Count
								temp_battle_faction_units_active++;
							}
						}
						else
						{
							// Set Unit is Engaged in Battle
							temp_battle_unit_instance.engaged_in_battle = true;
							
							// Add Unit's Position to Faction Centering
							temp_battle_faction_unit_center_x += temp_battle_unit_instance.sphere_vector_x;
							temp_battle_faction_unit_center_y += temp_battle_unit_instance.sphere_vector_y;
							temp_battle_faction_unit_center_z += temp_battle_unit_instance.sphere_vector_z;
							
							// Find Battle Faction's Elevation Maxiumum
							temp_battle_faction_unit_elevation = max(temp_battle_faction_unit_elevation, temp_battle_unit_instance.pathfinding_position_elevation);
							
							// Increment Faction's Units Active Count
							temp_battle_faction_units_active++;
						}
						
						// Decrement Battle Unit Index
						temp_battle_unit_index--;
					}
					
					// Check if Battle Faction is Eligible to Impact Battle Instance's Position & Elevation
					if (temp_battle_faction_hostile_encounter and temp_battle_faction_units_active > 0)
					{
						// Calculate Battle Faction's Unit Center Position
						temp_battle_faction_unit_center_x /= temp_battle_faction_units_active;
						temp_battle_faction_unit_center_y /= temp_battle_faction_units_active;
						temp_battle_faction_unit_center_z /= temp_battle_faction_units_active;
						
						// Add Battle Faction's Unit Center Position and Elevation to Battle's Updated Position and Elevation
						temp_battle_x += temp_battle_faction_unit_center_x * temp_battle_faction_units_active;
						temp_battle_y += temp_battle_faction_unit_center_y * temp_battle_faction_units_active;
						temp_battle_z += temp_battle_faction_unit_center_z * temp_battle_faction_units_active;
						temp_battle_elevation += temp_battle_faction_unit_elevation * temp_battle_faction_units_active;
						
						// Increment Battle Unit Divisor by Battle Faction's Units Active Count
						temp_battle_unit_divisor += temp_battle_faction_units_active;
						
						// Increment Battle Faction Divisor
						temp_battle_faction_divisor++;
					}
					
					// Decrement Battle Faction Index
					temp_battle_faction_index--;
				}
				
				// Check if Battle can update its Position & Elevation if there are Units belonging to Factions participating in Combat
				if (temp_battle_unit_divisor > 0 and temp_battle_faction_divisor > 1)
				{
					// Calculate Updated Battle Position & Elevation by using the Battle's Unit Divisor to find the Weighted Averaged Faction Center Position & Elevation Contribution
					temp_battle_x /= temp_battle_unit_divisor;
					temp_battle_y /= temp_battle_unit_divisor;
					temp_battle_z /= temp_battle_unit_divisor;
					temp_battle_elevation /= temp_battle_unit_divisor;
					
					// Calculate Final Lerped Movement Battle Position & Elevation
					temp_battle_x = lerp(temp_battle_instance.battle_x, temp_battle_x, temp_battle_instance.battle_unit_centering_lerp_spd * CelestialSimulator.global_clock_delta_time);
					temp_battle_y = lerp(temp_battle_instance.battle_y, temp_battle_y, temp_battle_instance.battle_unit_centering_lerp_spd * CelestialSimulator.global_clock_delta_time);
					temp_battle_z = lerp(temp_battle_instance.battle_z, temp_battle_z, temp_battle_instance.battle_unit_centering_lerp_spd * CelestialSimulator.global_clock_delta_time);
					temp_battle_elevation = lerp(temp_battle_instance.battle_elevation, temp_battle_elevation, temp_battle_instance.battle_unit_centering_lerp_spd * CelestialSimulator.global_clock_delta_time);
					
					// Update Battle Sphere Vector and Battle's Position & Elevation Values
					temp_battle_instance.sphere_vector_x = temp_battle_x;
					temp_battle_instance.sphere_vector_y = temp_battle_y;
					temp_battle_instance.sphere_vector_z = temp_battle_z;
					
					temp_battle_instance.battle_x = temp_battle_x;
					temp_battle_instance.battle_y = temp_battle_y;
					temp_battle_instance.battle_z = temp_battle_z;
					temp_battle_instance.battle_elevation = temp_battle_elevation;
				}
				
				// Battle Collision Check Behaviour
				if (temp_battle_instance.battle_collision_check_timer <= 0)
				{
					// Reset Collision Check Timer
					temp_battle_instance.battle_collision_check_timer = CelestialSimulator.global_collision_check_interval;
				}
				
				// Update Battle Clock
				temp_battle_instance.battle_total_time += CelestialSimulator.global_clock_delta_time;
				temp_battle_instance.battle_round_timer -= CelestialSimulator.global_clock_delta_time;
				
				// Perform Battle Round & Shuffle Behaviours
				if (temp_battle_instance.battle_round_timer <= 0)
				{
					// Decrement Battle Round
					temp_battle_instance.battle_round--;
					
					// Check if Battle should be Shuffled
					if (temp_battle_instance.battle_round <= 0)
					{
						// Battle Shuffle Round Behaviour
						celestial_battle_shuffle_round(temp_battle_instance);
						
						// Reset Battle Round Count
						temp_battle_instance.battle_round = temp_battle_instance.battle_rounds_per_shuffle;
						
						// Battle Perform Round Behaviour
						celestial_battle_perform_round(temp_battle_instance);
					}
					else
					{
						// Cleanup Sub-Units based on Priority Pool & Matchup Participation
						celestial_battle_check_participation(temp_battle_instance);
						
						// Battle Perform Round Behaviour
						celestial_battle_perform_round(temp_battle_instance);
					}
					
					// Reset Battle Round Timer
					temp_battle_instance.battle_round_timer = temp_battle_instance.battle_rounds_time_duration;
				}
				
				// Check to Destroy Battle Instance
				if (!temp_battle_instance.battle_exists)
				{
					// Delete Battle Instance from Celestial Body's Battles Array
					array_delete(battles, temp_battle_index, 1);
					
					// Destroy Battle Instance
					instance_destroy(temp_battle_instance);
					
					// Skip to Next Battle Instance
					continue;
				}
				
				// Increment Battle Index
				temp_battle_index++;
			}
			
			// Iterate through Celestial Object Unit Behaviours
			var temp_unit_index = 0;
			var temp_unit_count = array_length(units);
			
			repeat (temp_unit_count)
			{
				// Find Unit Instance
				var temp_unit_instance = units[temp_unit_index];
				
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
									case CelestialUnitBehaviourType.None:
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
								
								// Calculate Pathfinding Path Progress Lerp Value
								var temp_pathfinding_path_lerp_value = temp_pathfinding_remaining_movement_cost <= 0 ? 1 : temp_pathfinding_movement_power_spend / temp_pathfinding_remaining_movement_cost;
								
								// Calculate Unit's Pathfinding Position & Elevation based on Pathfinding Path Progress
								var temp_pathfinding_movement_position_x = lerp(temp_pathfinding_unit_x, temp_pathfinding_target_x, temp_pathfinding_path_lerp_value);
								var temp_pathfinding_movement_position_y = lerp(temp_pathfinding_unit_y, temp_pathfinding_target_y, temp_pathfinding_path_lerp_value);
								var temp_pathfinding_movement_position_z = lerp(temp_pathfinding_unit_z, temp_pathfinding_target_z, temp_pathfinding_path_lerp_value);
								var temp_pathfinding_movement_position_elevation = lerp(temp_pathfinding_unit_elevation, temp_pathfinding_target_elevation, temp_pathfinding_path_lerp_value);
								
								// Find Celestial Unit's U Positions and convert them into Horizontal Angles from Celestial Body's Sphere Horizontal Wrap
								var temp_pathfinding_unit_position_u_angle = (0.5 - arctan2(-temp_pathfinding_unit_x, -temp_pathfinding_unit_z) / (2 * pi)) * 360;
								var temp_pathfinding_target_position_u_angle = (0.5 - arctan2(-temp_pathfinding_target_x, -temp_pathfinding_target_z) / (2 * pi)) * 360;
								
								// Update Unit's Sprite Facing Direction based on their Pathfinding Angle Difference
								var temp_pathfinding_horizontal_angle_difference = angle_difference(temp_pathfinding_target_position_u_angle, temp_pathfinding_unit_position_u_angle);
								temp_unit_instance.image_xscale = temp_pathfinding_horizontal_angle_difference != 0 ? sign(temp_pathfinding_horizontal_angle_difference) : temp_unit_instance.image_xscale;
								
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
												else if (instance_exists(temp_unit_instance.unit_faction) and ds_map_find_value(temp_unit_instance.unit_faction.relationships, temp_unit_instance.unit_behaviour_target_instance.unit_faction) == CelestialFactionRelationshipType.Hostile)
												{
													// Unit is Hostile to Target Unit - Create a new Celestial Battle between the two Units if eligible to do so
													if (!temp_unit_instance.engaged_in_battle)
													{
														// Instantiate and Establish Celestial Battle Instance
														var temp_pathfinding_collision_unit_battle_instance = celestial_battle_create(id);
														
														// Update Celestial Battle Instance's Position & Elevation
														temp_pathfinding_collision_unit_battle_instance.battle_x = lerp(temp_unit_instance.pathfinding_position_x, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_x, 0.5);
														temp_pathfinding_collision_unit_battle_instance.battle_y = lerp(temp_unit_instance.pathfinding_position_y, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_y, 0.5);
														temp_pathfinding_collision_unit_battle_instance.battle_z = lerp(temp_unit_instance.pathfinding_position_z, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_z, 0.5);
														temp_pathfinding_collision_unit_battle_instance.battle_elevation = lerp(temp_unit_instance.pathfinding_position_elevation, temp_unit_instance.unit_behaviour_target_instance.pathfinding_position_elevation, 0.5);
														
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
											case CelestialUnitBehaviourType.None:
											default:
												temp_unit_instance.unit_behaviour = CelestialUnitBehaviourType.None;
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
											if (ds_map_find_value(temp_unit_instance.unit_faction.relationships, temp_pathfinding_node_units_array_unit_instance.unit_faction) == CelestialFactionRelationshipType.Hostile)
											{
												// Instantiate and Establish Celestial Battle Instance
												var temp_pathfinding_node_unit_battle_instance = celestial_battle_create(id);
												
												// Update Celestial Battle Instance's Position & Elevation
												temp_pathfinding_node_unit_battle_instance.battle_x = lerp(temp_unit_instance.pathfinding_position_x, temp_pathfinding_node_units_array_unit_instance.pathfinding_position_x, 0.5);
												temp_pathfinding_node_unit_battle_instance.battle_y = lerp(temp_unit_instance.pathfinding_position_y, temp_pathfinding_node_units_array_unit_instance.pathfinding_position_y, 0.5);
												temp_pathfinding_node_unit_battle_instance.battle_z = lerp(temp_unit_instance.pathfinding_position_z, temp_pathfinding_node_units_array_unit_instance.pathfinding_position_z, 0.5);
												temp_pathfinding_node_unit_battle_instance.battle_elevation = lerp(temp_unit_instance.pathfinding_position_elevation, temp_pathfinding_node_units_array_unit_instance.pathfinding_position_elevation, 0.5);
												
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

// Reset Celestial Simulator's UI Behaviours
selected_unit_movement_path_ui = false;
