/// @description Celestial Object Behaviour
// Iterates through all Celestial Objects within the Simulator to perform their Behaviours while orienting their Orbital Positions and Rotations

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

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
}

// Iterate through all Solar Systems within the Celestial Simulation
var temp_solar_systems_index = 0;
	
repeat (array_length(solar_systems))
{
	// Find the Solar System at the given Solar System Index
	var temp_solar_system = solar_systems[temp_solar_systems_index];
	
	// Iterate through all the Celestial Objects within the given Solar System
	var temp_celestial_object_index = 0;
	
	repeat (array_length(temp_solar_system))
	{
		// Find the given Celestial Object at the given Celestial Object Index within the Solar System
		var temp_celestial_object = temp_solar_system[temp_celestial_object_index];
		
		// Perform Celestial Object Simulation
		with (temp_celestial_object)
		{
			// Update Orbital Rotation around Solar System's Origin
			orbit_angle += orbit_speed * frame_delta;
			orbit_angle = orbit_angle mod 360;
			
			// Update Celestial Object's Rotation around Y Axis
			euler_angle_y += rotation_speed * frame_delta;
			euler_angle_y = euler_angle_y mod 360;
			
			// Update Position within Solar System's Space based on Orbital Rotation
			x = lengthdir_x(orbit_size, orbit_angle) + orbit_offset_x;
			z = lengthdir_y(orbit_size, orbit_angle) + orbit_offset_z;
			
			// Celestial Object Type Behaviour
			switch (celestial_object_type)
			{
				case CelestialObjectType.Planet:
					// Planet Simulation Behaviour
					frustum_culling_radius = radius + elevation + (sky ? sky_radius : 0);
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
						
						// Increment Light Source Index
						temp_light_source_index++;
					}
					
					// Set Sun Frustum Culling Radius
					frustum_culling_radius = radius;
					break;
				case CelestialObjectType.None:
				default:
					// Empty Celestial Object Type - Skip Behaviour
					break;
			}
		}
		
		// Increment the Celestial Object Index
		temp_celestial_object_index++;
	}
	
	// Increment the Solar System Index
	temp_solar_systems_index++;
}
