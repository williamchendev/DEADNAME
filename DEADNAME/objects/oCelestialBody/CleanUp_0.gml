/// @description Default Celestial Body Clean Up
// Cleans up the Celestial Body's Data Structures and Buffers used for calculating the Celestial Body's Behaviour

// Delete Icosphere Vertex Buffer
vertex_delete_buffer(icosphere_vertex_buffer);
icosphere_vertex_buffer = -1;

// Destroy all Unit Instances indexed in Celestial Body's Unit Array
if (array_length(units) > 0)
{
	var temp_unit_index = array_length(units) - 1;
	
	repeat (array_length(units))
	{
		// Check if Unit Instance Exists
		if (instance_exists(units[temp_unit_index]))
		{
			// Destroy Unit Instance
			instance_destroy(units[temp_unit_index]);
		}
		
		// Decrement Unit Index
		temp_unit_index--;
	}
	
	array_clear(units);
}

units = -1;

// Destroy all City Instances indexed in Celestial Body's City Array
if (array_length(cities) > 0)
{
	var temp_city_index = array_length(cities) - 1;
	
	repeat (array_length(cities))
	{
		// Check if City Instance Exists
		if (instance_exists(cities[temp_city_index]))
		{
			// Destroy City Instance
			instance_destroy(cities[temp_city_index]);
		}
		
		// Decrement City Index
		temp_city_index--;
	}
	
	array_clear(cities);
}

cities = -1;

// Destroy all Satellite Instances indexed in Celestial Body's Satellite Array
if (array_length(satellites) > 0)
{
	var temp_satellite_index = array_length(satellites) - 1;
	
	repeat (array_length(satellites))
	{
		// Check if Satellite Instance Exists
		if (instance_exists(satellites[temp_satellite_index]))
		{
			// Destroy Satellite Instance
			instance_destroy(satellites[temp_satellite_index]);
		}
		
		// Decrement Satellite Index
		temp_satellite_index--;
	}
	
	array_clear(satellites);
}

satellites = -1;

