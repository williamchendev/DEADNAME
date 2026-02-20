//
enum PlanetBiome
{
	Terrestrial_Rainforest,
	Terrestrial_Forest,
	Terrestrial_Woodland,
	Terrestrial_Shrubland,
	Terrestrial_Savannah,
	Terrestrial_Grassland,
	Terrestrial_Wetlands,
	Terrestrial_SaltMarsh,
	Terrestrial_Bog,
	Terrestrial_Tundra,
	Terrestrial_Desert,
	Terrestrial_Arcology,
	Marine_ShallowOcean,
	Marine_Estuary,
	Marine_Reef,
	Marine_DeepOcean,
	Marine_Abyssal
}

enum PlanetTemperature
{
	CosmicCold,
	InhospitablyCold,
	ExtremeCold,
	BrutalCold,
	UncomfortablyCold,
	Chilly,
	WilliamIdeal,
	Warm,
	UncomfortablyHot,
	BrutalHot,
	ExtremeHot,
	InhospitablyHot,
	CosmicHot
}

//
function geodesic_icosphere_biome_is_marine(biome)
{
	switch (biome)
	{ 
		case PlanetBiome.Marine_ShallowOcean:
		case PlanetBiome.Marine_Estuary:
		case PlanetBiome.Marine_Reef:
		case PlanetBiome.Marine_DeepOcean:
		case PlanetBiome.Marine_Abyssal:
			return true;
		default:
			return false;
	}
}

//
function celestial_pathfinding_find_path_weight(celestial_object, path_list)
{
	// Check if Path List contains less than 2 nodes
	if (ds_list_size(path_list) < 2)
	{
		return 0;
	}
	
	// Iterate through Path Edges to find Cumulative Weight
	var temp_weight = 0;
	var temp_path_index = 1;
	
	repeat (ds_list_size(path_list) - 1)
	{
		// Find Path Node
		var temp_node_index = ds_list_find_value(path_list, temp_path_index);
		
		// Add Weight Between Edges
		temp_weight += 1;
		
		// Increment Path Index
		temp_path_index++;
	}
	
	// Return Cumulative Path Weight
	return temp_weight;
}

function celestial_pathfinding_recursive(celestial_object, start_node_index, end_node_index, path_list = ds_list_create())
{
	// Index Start Node in Array
	ds_list_add(path_list, start_node_index);
	
	// Check that Start Node and End Node Match - Early Return of Recursive Path Structure
	if (start_node_index == end_node_index)
	{
		return path_list;
	}
	
	// Find Node Edges Array
	var temp_node_edges_array = celestial_object.pathfinding_node_edges_array[start_node_index];
	
	// Establish Path Comparison Variables
	var temp_path_weight = -1;
	var temp_path_list = undefined;
	
	// Iterate through all Node Edges
	var temp_edge_index = 0;
	
	repeat (array_length(temp_node_edges_array))
	{
		// Find Edge Node Index
		var temp_edge_node_index = temp_node_edges_array[temp_edge_index];
		
		show_debug_message($"{start_node_index} {temp_edge_index} {temp_edge_node_index}");
		
		// Check if Path contains Edge Node
		var temp_path_contains_edge_node = ds_list_find_index(path_list, temp_edge_node_index) != -1;
		
		// If Path does not contain Edge Node continue Recursive Pathfinding from there
		if (!temp_path_contains_edge_node)
		{
			// Duplicate Path List
			var temp_comparison_path = ds_list_create();
			ds_list_copy(temp_comparison_path, path_list);
			
			// Create Comparison Path List and Path Weight
			temp_comparison_path = celestial_pathfinding_recursive(celestial_object, temp_edge_node_index, end_node_index, temp_comparison_path);
			
			// Check if Comparison Path Exists
			if (is_undefined(temp_comparison_path))
			{
				// Comparison Path does not Exist - Increment Edge Index
				temp_edge_index++;
				continue;
			}
			
			// Calculate Comparison Path's Weight
			var temp_comparison_path_weight = celestial_pathfinding_find_path_weight(celestial_object, temp_comparison_path);
			
			// Check if Path List Exists and can be Compared
			if (!is_undefined(temp_path_list))
			{
				// Compare Path Weights
				if (temp_comparison_path_weight >= temp_path_weight)
				{
					// Comparison Path Weight is greater or equal than the current Path - Destroy Comparison Path List
					ds_list_destroy(temp_comparison_path);
					temp_comparison_path = -1;
					
					// Increment Edge Index
					temp_edge_index++;
					continue;
				}
				else
				{
					// Comparison Path Weight is less than the current Path - Destroy Old Path List
					ds_list_destroy(temp_path_list);
					temp_path_list = -1;
				}
			}
			
			// Set new Path List and Path Weight
			temp_path_list = temp_comparison_path;
			temp_path_weight = temp_comparison_path_weight;
		}
		
		// Increment Edge Index
		temp_edge_index++;
	}
	
	// Destroy Unused Given Path List
	ds_list_destroy(path_list);
	path_list = -1;
	
	// Return Compared Path List
	return temp_path_list;
}

function celestial_pathfinding_recursive_ext(celestial_object, start_node_index, end_node_feature, path_list = ds_list_create())
{
	
}

function celestial_pathfinding_get_closest_point_on_edge(x_position, y_position, position_z)
{
	
}

function celestial_pathfinding_create_path(planet, start_x_position, start_y_position, start_z_position, end_x_position, end_y_position, end_z_position)
{
	
}