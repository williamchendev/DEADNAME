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

/// @function celestial_pathfinding_find_edge_weight(celestial_object, first_node_index, second_node_index);
/// @description Finds the weight of the Pathfinding Edge between two Pathfinding Node Indexes on the given Celestial Object and returns it as a real value or returns Undefined if the edge does not exist
/// @param {real:Id.Instance} celestial_object The Celestial Object the Pathfinding Nodes belong to
/// @param {int} first_node_index The first Pathfinding Node's Index in the Pathfinding Edge to find the Weights of
/// @param {int} second_node_index The second Pathfinding Node's Index in the Pathfinding Edge to find the Weights of
/// @returns {?real} Returns the cumulative weight of the edge between the given Node IDs, and returns Undefined if the Edge is not viable
function celestial_pathfinding_find_edge_weight(celestial_object, first_node_index, second_node_index)
{
	return 1;
}

/// @function celestial_pathfinding_reconstruct_path(path_map, node_index);
/// @description Reconstructs a Pathfinding Path using a Path Map and the given Pathfinding Node Index to work backwards from, tracing a sequence of Nodes that each "come from" the original Starting Pathfinding Node of the Path indexed in the Path Map
/// @param {Id.DsMap<int, int>} path_map The Path Map to reconstruct a Pathfinding Path backwards from (the path_map is a DS Map of directions mapped to Pathfinding Node Indexes coming from the Path's starting Node Index)
/// @param {int} node_index A Pathfinding Node's Index that represents the last Node in the Path to reconstruct that will lead to the given Path Map's original Starting Pathfinding Node
/// @return {Id.DsList<int>} Returns a DS List of Pathfinding Node Indexes from the Starting Pathfinding Node's Index to the Ending Pathfinding Node's Index
function celestial_pathfinding_reconstruct_path(path_map, node_index)
{
	// Create new Pathfinding DS List
	var temp_reconstructed_path_list = ds_list_create();
	
	// Add given Pathfinding Node Index to start reconstructing Pathfinding Path backwards from (the path_map is a DS Map of directions mapped to Pathfinding Node Indexes coming from the Path's starting Node Index)
	ds_list_add(temp_reconstructed_path_list, node_index);
	
	// Iterate through Pathfinding Map until there are no more Pathfinding Nodes to "come from"
	while (ds_map_exists(path_map, node_index))
	{
		// Find next Pathfinding Node Index the current Pathfinding Node Index "comes from" from Pathfinding Map using the current Node Index
		node_index = ds_map_find_value(path_map, node_index);
		
		// Add Pathfinding Node Index to the start of the Reconstructed Path DS List (so the order is from the Start Pathfinding Node Index to End Pathfinding Node Index)
		ds_list_insert(temp_reconstructed_path_list, 0, node_index);
	}
	
	// Return the Reconstructed Path DS List
	return temp_reconstructed_path_list;
}

/// @function celestial_pathfinding(celestial_object, start_node_index, end_node_index);
/// @description Finds the path of least resistance between the Starting Pathfinding Node's Index to the Ending Pathfinding Node's Index (or, optionally, to multiple possible Ending Pathfinding Node Indexes within an array)
/// @param {real:Id.Instance} celestial_object The Celestial Object the Pathfinding Nodes belong to
/// @param {int} start_node_index The starting Pathfinding Node's Index to create a Path from to the given ending Pathfinding Node
/// @param {*int,array<int>} end_node_index The ending Pathfinding Node's Index to create a Path to the given starting Pathfinding Node, optionally can be passed as an array of multiple acceptable ending Pathfinding Node Indexes
/// @return {?Id.DsList<int>} Returns a DS List of Pathfinding Node Indexes from the Starting Pathfinding Node's Index to the Ending Pathfinding Node's Index, and Undefined if a Path is not viable between the two given Pathfinding Nodes
function celestial_pathfinding(celestial_object, start_node_index, end_node_index)
{
	// Initialize Unchecked Nodes Priority List, Path Reconstruction Map, and G Score Map Data Structures
	var temp_unchecked_nodes = ds_priority_create();
	var temp_path_map = ds_map_create();
	var temp_g_score_map = ds_map_create();
	
	// Initialize Checked Nodes Array
	var temp_checked_nodes = array_create(celestial_object.pathfinding_nodes_count, false);
	
	// Calculate Path Starting Node's G Score
	var temp_starting_node_g_score = is_array(end_node_index) ? celestial_object.celestial_pathfinding_heuristic_multiple(start_node_index, end_node_index) : celestial_object.celestial_pathfinding_heuristic(start_node_index, end_node_index);
	
	// Initialize Path Starting Node's G Score and index in Pathfinding Data Structures
	ds_map_add(temp_g_score_map, start_node_index, 0);
	ds_priority_add(temp_unchecked_nodes, start_node_index, temp_starting_node_g_score);
	
	// Iterate until Optimal Path is found
	while (!ds_priority_empty(temp_unchecked_nodes))
	{
		// Get Current Pathfinding Node from Pathfinding Node with lowest F Score (f_score = g_score + h_score)
		var temp_current_pathfinding_node_index = ds_priority_delete_min(temp_unchecked_nodes);
		
		// Check if Current Pathfinding Node has already been iterated over
		if (temp_checked_nodes[temp_current_pathfinding_node_index])
		{
			continue;
		}
		
		// Mark Current Pathfinding Node as Checked
		temp_checked_nodes[temp_current_pathfinding_node_index] = true;
		
		// Check if (a) Pathfinding Goal was reached
		if (is_array(end_node_index) ? array_contains(end_node_index, temp_current_pathfinding_node_index) : temp_current_pathfinding_node_index == end_node_index)
		{
			// Pathfinding Goal Found - Reconstruct Path DS List to return
			var temp_reconstructed_path = celestial_pathfinding_reconstruct_path(temp_path_map, temp_current_pathfinding_node_index);
			
			// Destroy Pathfinding Data Structures
			ds_priority_destroy(temp_unchecked_nodes);
			ds_map_destroy(temp_g_score_map);
			ds_map_destroy(temp_path_map);
			
			// Return Reconstructed Path DS List as Final Path
			return temp_reconstructed_path;
		}
		
		// Find Current Pathfinding Node's G Score
		var temp_current_pathfinding_node_g_score = ds_map_find_value(temp_g_score_map, temp_current_pathfinding_node_index);
		
		// Find Current Pathfinding Node's Edge Neighbors Array
		var temp_node_edges_array = celestial_object.pathfinding_node_edges_array[temp_current_pathfinding_node_index];
		var temp_node_edges_array_size = array_length(temp_node_edges_array);
		
		// Iterate through Current Pathfinding Node's Edge Neighbors for Pathfinding Evaluation
		var temp_node_edges_index = temp_node_edges_array_size - 1;
		
		repeat (temp_node_edges_array_size)
		{
			// Get Pathfinding Node Edge Neighbor's Pathfinding Node Index from Current Pathfinding Node's Edge Neighbors Array
			var temp_pathfinding_node_edge_neighbor_index = temp_node_edges_array[temp_node_edges_index];
			
			// Check if Current Pathfinding Node Edge Neighbor's Pathfinding Node Index has already been iterated over
			if (temp_checked_nodes[temp_pathfinding_node_edge_neighbor_index])
			{
				// Decrement Node Edge Neighbor Index
				temp_node_edges_index--;
				continue;
			}
			
			// Calculate Pathfinding Edge Weight between Current Pathfinding Node and Neighbor Pathfinding Node
			var temp_edge_weight = celestial_pathfinding_find_edge_weight(celestial_object, temp_current_pathfinding_node_index, temp_pathfinding_node_edge_neighbor_index);
			var temp_tentative_comparison_g_score = temp_current_pathfinding_node_g_score + temp_edge_weight;
			
			// Retreive Neighboring Pathfinding Node's G Score (if it exists)
			var temp_neighbor_g_score = ds_map_exists(temp_g_score_map, temp_pathfinding_node_edge_neighbor_index) ? ds_map_find_value(temp_g_score_map, temp_pathfinding_node_edge_neighbor_index) : undefined;
			
			// Check if Neighboring Pathfinding Node's G Score Exists or if the Neighboring Pathfinding Node's G Score is worse than the Current Pathfinding Node's G Score
			if (is_undefined(temp_neighbor_g_score) || temp_neighbor_g_score > temp_tentative_comparison_g_score)
			{
				// Set Neighboring Pathfinding Node's G Score within Pathfinding G Score Map
				ds_map_replace(temp_g_score_map, temp_pathfinding_node_edge_neighbor_index, temp_tentative_comparison_g_score);
				
				// Set Pathfinding Map to reflect path direction from Neighboring Pathfinding Node comes from the Current Pathfinding Node
				ds_map_replace(temp_path_map, temp_pathfinding_node_edge_neighbor_index, temp_current_pathfinding_node_index);
				
				// Calculate H Score and F Score from Pathfinding Heuristic between Neighbor Pathfinding Node and Goal Pathfinding Node
				var temp_h_score = is_array(end_node_index) ? celestial_object.celestial_pathfinding_heuristic_multiple(temp_pathfinding_node_edge_neighbor_index, end_node_index) : celestial_object.celestial_pathfinding_heuristic(temp_pathfinding_node_edge_neighbor_index, end_node_index);
				var temp_f_score = temp_tentative_comparison_g_score + temp_h_score;
				
				// Add Neighboring Pathfinding Node to Pathfinding Priority Data Structure with F Score
				ds_priority_add(temp_unchecked_nodes, temp_pathfinding_node_edge_neighbor_index, temp_f_score);
			}
			
			// Decrement Node Edge Neighbor Index
			temp_node_edges_index--;
		}
	}
	
	// Destroy Pathfinding Data Structures
	ds_priority_destroy(temp_unchecked_nodes);
	ds_map_destroy(temp_g_score_map);
	ds_map_destroy(temp_path_map);
	
	// Viable Path not found - Return Undefined
	return undefined;
}
