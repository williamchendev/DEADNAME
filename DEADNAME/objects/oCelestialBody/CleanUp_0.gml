/// @description Default Celestial Body Clean Up
// Cleans up the Celestial Body's Data Structures and Buffers used for calculating the Celestial Body's Behaviour

// Delete Icosphere Vertex Buffer
vertex_delete_buffer(icosphere_vertex_buffer);
icosphere_vertex_buffer = -1;

// Clear all Battle Unit Connection Arrays
array_resize(battle_unit_connection_depth_sorting_index_array, 0);
array_resize(battle_unit_connection_depth_sorting_depth_array, 0);
array_resize(battle_unit_connection_point_a_position_x_array, 0);
array_resize(battle_unit_connection_point_a_position_y_array, 0);
array_resize(battle_unit_connection_point_a_alpha_array, 0);
array_resize(battle_unit_connection_point_b_position_x_array, 0);
array_resize(battle_unit_connection_point_b_position_y_array, 0);
array_resize(battle_unit_connection_point_b_alpha_array, 0);
array_resize(battle_unit_connection_thickness_array, 0);
array_resize(battle_unit_connection_draw_drop_shadow_array, 0);

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
	
	array_resize(units, 0);
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
	
	array_resize(cities, 0);
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
	
	array_resize(satellites, 0);
}

satellites = -1;

// Destroy all Battle Instances indexed in Celestial Body's Battle Array
if (array_length(battles) > 0)
{
	var temp_battle_index = array_length(battles) - 1;
	
	repeat (array_length(battles))
	{
		// Check if Battle Instance Exists
		if (instance_exists(battles[temp_battle_index]))
		{
			// Destroy Battle Instance
			instance_destroy(battles[temp_battle_index]);
		}
		
		// Decrement Battle Index
		temp_battle_index--;
	}
	
	array_resize(battles, 0);
}

battles = -1;

