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

/// @function celestial_pathfinding_a_star(celestial_object, start_node_index, end_node_index);
/// @description Finds the shortest path of nodes between the Starting Pathfinding Node's Index to the Ending Pathfinding Node's Index (or, optionally, to multiple possible Ending Pathfinding Node Indexes within an array) using the A* algorithm
/// @param {real:Id.Instance} celestial_object The Celestial Object the Pathfinding Nodes belong to
/// @param {int} start_node_index The starting Pathfinding Node's Index to create a Path from to the given ending Pathfinding Node
/// @param {*int,array<int>} end_node_index The ending Pathfinding Node's Index to create a Path to the given starting Pathfinding Node, optionally can be passed as an array of multiple acceptable ending Pathfinding Node Indexes
/// @return {?Id.DsList<int>} Returns a DS List of Pathfinding Node Indexes from the Starting Pathfinding Node's Index to the Ending Pathfinding Node's Index, and Undefined if a Path is not viable between the two given Pathfinding Nodes
function celestial_pathfinding_a_star(celestial_object, start_node_index, end_node_index)
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

/// @function celestial_pathfinding_funnel(path_node_index_list);
/// @description 
function celestial_pathfinding_funnel(celestial_object, path_list, end_x, end_y, end_z, end_elevation)
{
	// Initialize Empty Path Struct
	var temp_path_struct = 
	{
		path_size: 0,
		node_index: ds_list_create(),
		position_x: ds_list_create(),
		position_y: ds_list_create(),
		position_z: ds_list_create(),
		position_elevation: ds_list_create(),
	}
	
	// Check if Path List contains entries
	if (ds_list_size(path_list) < 2)
	{
		// Populate Path Struct with Final Destination
		temp_path_struct.path_size = 1;
		ds_list_add(temp_path_struct.node_index, ds_list_find_value(path_list, ds_list_size(path_list) - 1));
		ds_list_add(temp_path_struct.position_x, end_x);
		ds_list_add(temp_path_struct.position_y, end_y);
		ds_list_add(temp_path_struct.position_z, end_z);
		ds_list_add(temp_path_struct.position_elevation, end_elevation);
		
		// Destroy Unused Path DS List
		ds_list_destroy(path_list);
		path_list = -1;
		
		// Return Path Struct
		return temp_path_struct;
	}
	
	// Find Path's First Node, Edge, and Portal Indexes
	var temp_first_node_index = ds_list_find_value(path_list, 0);
	var temp_second_node_index = ds_list_find_value(path_list, 1);
	
	var temp_first_edge_index = array_get_index(celestial_object.pathfinding_node_edges_array[temp_first_node_index], temp_second_node_index);
	
	var temp_first_portal_left_index = array_get(celestial_object.pathfinding_node_edges_portal_left_array[temp_first_node_index], temp_first_edge_index);
	var temp_first_portal_right_index = array_get(celestial_object.pathfinding_node_edges_portal_right_array[temp_first_node_index], temp_first_edge_index);
	
	// Establish Apex and Portal Funnel Vectors
	var temp_apex_x = celestial_object.pathfinding_node_x_array[temp_first_node_index];
	var temp_apex_y = celestial_object.pathfinding_node_y_array[temp_first_node_index];
	var temp_apex_z = celestial_object.pathfinding_node_z_array[temp_first_node_index];
	
	var temp_left_x = celestial_object.pathfinding_portal_x_array[temp_first_portal_left_index];
	var temp_left_y = celestial_object.pathfinding_portal_y_array[temp_first_portal_left_index];
	var temp_left_z = celestial_object.pathfinding_portal_z_array[temp_first_portal_left_index];
	
	var temp_right_x = celestial_object.pathfinding_portal_x_array[temp_first_portal_right_index];
	var temp_right_y = celestial_object.pathfinding_portal_y_array[temp_first_portal_right_index];
	var temp_right_z = celestial_object.pathfinding_portal_z_array[temp_first_portal_right_index];
	
	var temp_left_node_index = temp_first_node_index;
	var temp_right_node_index = temp_first_node_index;
	
	var temp_left_edge_index = temp_first_edge_index;
	var temp_right_edge_index = temp_first_edge_index;
	
	// Initialize Empty Funnel DS Lists
	var temp_funnel_node_index_list = ds_list_create();
	var temp_funnel_position_x_list = ds_list_create();
	var temp_funnel_position_y_list = ds_list_create();
	var temp_funnel_position_z_list = ds_list_create();
	
	// Iterate through Path to perform Funnel Walk Behaviour
	var temp_path_index = 0;
	
	repeat (ds_list_size(path_list) - 1)
	{
		// Find Node Indexes
		var temp_node_index_a = ds_list_find_value(path_list, temp_path_index);
		var temp_node_index_b = ds_list_find_value(path_list, temp_path_index + 1);
		
		// Find Edge Index
		var temp_edge_index = array_get_index(celestial_object.pathfinding_node_edges_array[temp_node_index_a], temp_node_index_b);
		
		// Find Portal Indexes
		var temp_portal_left_index = array_get(celestial_object.pathfinding_node_edges_portal_left_array[temp_node_index_a], temp_edge_index);
		var temp_portal_right_index = array_get(celestial_object.pathfinding_node_edges_portal_right_array[temp_node_index_a], temp_edge_index);
		
		// Find Portal Positions
		var temp_portal_left_x = celestial_object.pathfinding_portal_x_array[temp_portal_left_index];
		var temp_portal_left_y = celestial_object.pathfinding_portal_y_array[temp_portal_left_index];
		var temp_portal_left_z = celestial_object.pathfinding_portal_z_array[temp_portal_left_index];
		
		var temp_portal_right_x = celestial_object.pathfinding_portal_x_array[temp_portal_right_index];
		var temp_portal_right_y = celestial_object.pathfinding_portal_y_array[temp_portal_right_index];
		var temp_portal_right_z = celestial_object.pathfinding_portal_z_array[temp_portal_right_index];
		
		//
		var temp_normal_x = celestial_object.pathfinding_node_x_array[temp_node_index_a];
		var temp_normal_y = celestial_object.pathfinding_node_y_array[temp_node_index_a];
		var temp_normal_z = celestial_object.pathfinding_node_z_array[temp_node_index_a];
		
		// Calculate Portal Left Funnel
		var temp_sl_sphere_side_left_vector = celestial_pathfinding_sphere_side(temp_apex_x, temp_apex_y, temp_apex_z, temp_left_x, temp_left_y, temp_left_z, temp_portal_left_x, temp_portal_left_y, temp_portal_left_z, temp_normal_x, temp_normal_y, temp_normal_z);
		var temp_sr_sphere_side_left_vector = celestial_pathfinding_sphere_side(temp_apex_x, temp_apex_y, temp_apex_z, temp_right_x, temp_right_y, temp_right_z, temp_portal_left_x, temp_portal_left_y, temp_portal_left_z, temp_normal_x, temp_normal_y, temp_normal_z);
		
		// Check Left Portal
		if (temp_sl_sphere_side_left_vector >= 0) 
		{
			// Left Portal is inside or tightens the Left Side's Vector
			temp_left_x = temp_portal_left_x;
			temp_left_y = temp_portal_left_y;
			temp_left_z = temp_portal_left_z;
			
			temp_left_node_index = temp_node_index_a;
			temp_left_edge_index = temp_edge_index;
		} 
		else if (temp_sr_sphere_side_left_vector < 0) 
		{
			// Index Right Vector into Funnel Waypoint List
			ds_list_add(temp_funnel_node_index_list, temp_right_node_index);
			ds_list_add(temp_funnel_position_x_list, temp_right_x);
			ds_list_add(temp_funnel_position_y_list, temp_right_y);
			ds_list_add(temp_funnel_position_z_list, temp_right_z);
			
			// new_left has crossed the right ray — apex must advance to right_ray vertex
			temp_apex_x = temp_right_x;
			temp_apex_y = temp_right_y;
			temp_apex_z = temp_right_z;
			
			// Re-initialise wedge from the new apex's portal
			var temp_apex_right_edge_portal_left_index = array_get(celestial_object.pathfinding_node_edges_portal_left_array[temp_right_node_index], temp_right_edge_index);
			var temp_apex_right_edge_portal_right_index = array_get(celestial_object.pathfinding_node_edges_portal_right_array[temp_right_node_index], temp_right_edge_index);
			
			temp_left_x = celestial_object.pathfinding_portal_x_array[temp_apex_right_edge_portal_left_index];
			temp_left_y = celestial_object.pathfinding_portal_y_array[temp_apex_right_edge_portal_left_index];
			temp_left_z = celestial_object.pathfinding_portal_z_array[temp_apex_right_edge_portal_left_index];
			
			temp_right_x = celestial_object.pathfinding_portal_x_array[temp_apex_right_edge_portal_right_index];
			temp_right_y = celestial_object.pathfinding_portal_y_array[temp_apex_right_edge_portal_right_index];
			temp_right_z = celestial_object.pathfinding_portal_z_array[temp_apex_right_edge_portal_right_index];
			
			// Increment Path Index
			temp_path_index++;
			
			// Advance Loop Behaviour
			continue;
		}
		
		// Calculate Portal Right Funnel
		var temp_sl_sphere_side_right_vector = celestial_pathfinding_sphere_side(temp_apex_x, temp_apex_y, temp_apex_z, temp_left_x, temp_left_y, temp_left_z, temp_portal_right_x, temp_portal_right_y, temp_portal_right_z, temp_normal_x, temp_normal_y, temp_normal_z);
		var temp_sr_sphere_side_right_vector = celestial_pathfinding_sphere_side(temp_apex_x, temp_apex_y, temp_apex_z, temp_right_x, temp_right_y, temp_right_z, temp_portal_right_x, temp_portal_right_y, temp_portal_right_z, temp_normal_x, temp_normal_y, temp_normal_z);
		
		// Check Right Portal
		if (temp_sr_sphere_side_right_vector <= 0) 
		{
			// Right Portal is inside or tightens the Right Side's Vector
			temp_right_x = temp_portal_right_x;
			temp_right_y = temp_portal_right_y;
			temp_right_z = temp_portal_right_z;
			
			temp_right_node_index = temp_node_index_a;
			temp_right_edge_index = temp_edge_index;
		} 
		else if (temp_sl_sphere_side_right_vector > 0) 
		{
			// Index Right Vector into Funnel Waypoint List
			ds_list_add(temp_funnel_node_index_list, temp_left_node_index);
			ds_list_add(temp_funnel_position_x_list, temp_left_x);
			ds_list_add(temp_funnel_position_y_list, temp_left_y);
			ds_list_add(temp_funnel_position_z_list, temp_left_z);
			
			// new_right has crossed the left ray — apex must advance to left_ray vertex
			temp_apex_x = temp_left_x;
			temp_apex_y = temp_left_y;
			temp_apex_z = temp_left_z;
			
			// Re-initialise wedge from the new apex's portal
			var temp_apex_left_edge_portal_left_index = array_get(celestial_object.pathfinding_node_edges_portal_left_array[temp_left_node_index], temp_left_edge_index);
			var temp_apex_left_edge_portal_right_index = array_get(celestial_object.pathfinding_node_edges_portal_right_array[temp_left_node_index], temp_left_edge_index);
			
			temp_left_x = celestial_object.pathfinding_portal_x_array[temp_apex_left_edge_portal_left_index];
			temp_left_y = celestial_object.pathfinding_portal_y_array[temp_apex_left_edge_portal_left_index];
			temp_left_z = celestial_object.pathfinding_portal_z_array[temp_apex_left_edge_portal_left_index];
			
			temp_right_x = celestial_object.pathfinding_portal_x_array[temp_apex_left_edge_portal_right_index];
			temp_right_y = celestial_object.pathfinding_portal_y_array[temp_apex_left_edge_portal_right_index];
			temp_right_z = celestial_object.pathfinding_portal_z_array[temp_apex_left_edge_portal_right_index];
			
			// Increment Path Index
			temp_path_index++;
			
			// Advance Loop Behaviour
			continue;
		}
		
		// Increment Path Index
		temp_path_index++;
	}
	
	// Add Final Waypoint
	ds_list_add(temp_funnel_node_index_list, ds_list_find_value(path_list, ds_list_size(path_list) - 1));
	ds_list_add(temp_funnel_position_x_list, end_x);
	ds_list_add(temp_funnel_position_y_list, end_y);
	ds_list_add(temp_funnel_position_z_list, end_z);
	
	// Iterate through Path and Funnel Lists to populate the Path Struct with the final Smoothed Path
	var temp_smoothing_path_index = 0;
	var temp_smoothing_funnel_index = 0;
	
	repeat (ds_list_size(path_list) - 1)
	{
		// Find Path Node Indexes
		var temp_path_node_index_a = ds_list_find_value(path_list, temp_smoothing_path_index);
		var temp_path_node_index_b = ds_list_find_value(path_list, temp_smoothing_path_index + 1);
		
		// Find Path Edge Index
		var temp_path_edge_index = array_get_index(celestial_object.pathfinding_node_edges_array[temp_path_node_index_a], temp_path_node_index_b);
		
		// Find Path Portal Indexes
		var temp_path_portal_left_index = array_get(celestial_object.pathfinding_node_edges_portal_left_array[temp_path_node_index_a], temp_path_edge_index);
		var temp_path_portal_right_index = array_get(celestial_object.pathfinding_node_edges_portal_right_array[temp_path_node_index_a], temp_path_edge_index);
		
		// Find Path Portal Positions
		var temp_path_portal_left_x = celestial_object.pathfinding_portal_x_array[temp_path_portal_left_index];
		var temp_path_portal_left_y = celestial_object.pathfinding_portal_y_array[temp_path_portal_left_index];
		var temp_path_portal_left_z = celestial_object.pathfinding_portal_z_array[temp_path_portal_left_index];
		
		var temp_path_portal_right_x = celestial_object.pathfinding_portal_x_array[temp_path_portal_right_index];
		var temp_path_portal_right_y = celestial_object.pathfinding_portal_y_array[temp_path_portal_right_index];
		var temp_path_portal_right_z = celestial_object.pathfinding_portal_z_array[temp_path_portal_right_index];
		
		// Find Path Portal Elevations
		var temp_path_portal_left_elevation = celestial_object.pathfinding_portal_elevation_array[temp_path_portal_left_index];
		var temp_path_portal_right_elevation = celestial_object.pathfinding_portal_elevation_array[temp_path_portal_right_index];
		
		// Establish Funnel Variables
		var temp_funnel_node_index = ds_list_find_value(temp_funnel_node_index_list, temp_smoothing_funnel_index);
		
		var temp_funnel_position_x = ds_list_find_value(temp_funnel_position_x_list, temp_smoothing_funnel_index);
		var temp_funnel_position_y = ds_list_find_value(temp_funnel_position_y_list, temp_smoothing_funnel_index);
		var temp_funnel_position_z = ds_list_find_value(temp_funnel_position_z_list, temp_smoothing_funnel_index);
		
		// Check to Increment Funnel Index
		if (temp_path_node_index_b == temp_funnel_node_index)
		{
			// Increment Funnel Index
			temp_funnel_node_index++;
		}
		
		// Find Lerp Value from Inverse Lerp between Portals using the Funnel Destination
		var temp_path_portal_lerp_value = inverse_lerp_position_3d(temp_path_portal_left_x, temp_path_portal_left_y, temp_path_portal_left_z, temp_path_portal_right_x, temp_path_portal_right_y, temp_path_portal_right_z, temp_funnel_position_x, temp_funnel_position_y, temp_funnel_position_z, true);
		
		// Populate Path Struct with new Smoothed Waypoint
		temp_path_struct.path_size++;
		ds_list_add(temp_path_struct.node_index, temp_path_node_index_a);
		ds_list_add(temp_path_struct.position_x, lerp(temp_path_portal_left_x, temp_path_portal_right_x, temp_path_portal_lerp_value));
		ds_list_add(temp_path_struct.position_y, lerp(temp_path_portal_left_y, temp_path_portal_right_y, temp_path_portal_lerp_value));
		ds_list_add(temp_path_struct.position_z, lerp(temp_path_portal_left_z, temp_path_portal_right_z, temp_path_portal_lerp_value));
		ds_list_add(temp_path_struct.position_elevation, lerp(temp_path_portal_left_elevation, temp_path_portal_right_elevation, temp_path_portal_lerp_value));
		
		// Increment Path Index
		temp_smoothing_path_index++;
	}
	
	// Populate Path Struct with Final Destination
	temp_path_struct.path_size++;
	ds_list_add(temp_path_struct.node_index, ds_list_find_value(path_list, ds_list_size(path_list) - 1));
	ds_list_add(temp_path_struct.position_x, end_x);
	ds_list_add(temp_path_struct.position_y, end_y);
	ds_list_add(temp_path_struct.position_z, end_z);
	ds_list_add(temp_path_struct.position_elevation, end_elevation);
	
	// Destroy Unused Funnel DS Lists
	ds_list_destroy(temp_funnel_node_index_list);
	ds_list_destroy(temp_funnel_position_x_list);
	ds_list_destroy(temp_funnel_position_y_list);
	ds_list_destroy(temp_funnel_position_z_list);
	
	temp_funnel_node_index_list = -1;
	temp_funnel_position_x_list = -1;
	temp_funnel_position_y_list = -1;
	temp_funnel_position_z_list = -1;
	
	// Destroy Unused Path DS List
	ds_list_destroy(path_list);
	path_list = -1;
	
	// Return Final Path Struct
	return temp_path_struct;
}

/// @function celestial_pathfinding_sphere_side(apex_vector_x, apex_vector_y, apex_vector_z, ray_vector_x, ray_vector_y, ray_vector_z, v_x, v_y, v_z);
/// @description 
function celestial_pathfinding_sphere_side(apex_vector_x, apex_vector_y, apex_vector_z, ray_vector_x, ray_vector_y, ray_vector_z, v_x, v_y, v_z, normal_x, normal_y, normal_z)
{
    //
    var temp_oa_x = ray_vector_x - apex_vector_x;
    var temp_oa_y = ray_vector_y - apex_vector_y;
    var temp_oa_z = ray_vector_z - apex_vector_z;
    
    var temp_ob_x = v_x - apex_vector_x;
    var temp_ob_y = v_y - apex_vector_y;
    var temp_ob_z = v_z - apex_vector_z;
    
	// Find Cross Product between Apex and Ray Vectors
	var temp_cross_product_x = temp_oa_y * temp_ob_z - temp_oa_z * temp_ob_y;
	var temp_cross_product_y = temp_oa_z * temp_ob_x - temp_oa_x * temp_ob_z;
	var temp_cross_product_z = temp_oa_x * temp_ob_y - temp_oa_y * temp_ob_x;
	
	// Return Dot Product of the Cross Product Result and the given Vector
	return dot_product_3d(temp_cross_product_x, temp_cross_product_y, temp_cross_product_z, normal_x, normal_y, normal_z);
}

/// @function celestial_pathfinding(celestial_object, unit_object, goal_node_index, goal_position_x, goal_position_y, goal_position_z, goal_position_elevation);
/// @description 
function celestial_pathfinding(celestial_object, unit_object, goal_node_index, goal_position_x, goal_position_y, goal_position_z, goal_position_elevation)
{
	// Destroy Unit's Pathfinding Path
	celestial_pathfinding_destroy_path(unit_object.pathfinding_path);
	
	// Create Path Node List using A* Pathfinding
	var temp_path_node_list = celestial_pathfinding_a_star(celestial_object, unit_object.pathfinding_node_index, goal_node_index);
	
	// Create and set the Unit's Pathfinding Path Struct by smoothing the Path Node List using a Funnel Algorithm
	unit_object.pathfinding_path = celestial_pathfinding_funnel(celestial_object, temp_path_node_list, goal_position_x, goal_position_y, goal_position_z, goal_position_elevation);
	
	// Reset Unit's Path Index
	unit_object.pathfinding_path_index = 0;
}

function celestial_pathfinding_destroy_path(path_struct)
{
	//
	if (is_undefined(path_struct))
	{
		return;
	}
	
	//
	ds_list_destroy(path_struct.node_index);
	ds_list_destroy(path_struct.position_x);
	ds_list_destroy(path_struct.position_y);
	ds_list_destroy(path_struct.position_z);
	ds_list_destroy(path_struct.position_elevation);
	
	//
	delete(path_struct);
}

function celestial_pathfinding_draw_path_gizmos(celestial_object, unit_object)
{
	// Calculate Celestial Object's Rotation Matrix
	var temp_rotation_matrix = rotation_matrix_from_euler_angles(celestial_object.euler_angle_x, celestial_object.euler_angle_y, celestial_object.euler_angle_z);
	
	// Find Selected Unit's Pathfinding Path World Positions
	var temp_celestial_object_minimum_elevation = 0;
	
	if (celestial_object.celestial_object_type == CelestialObjectType.Planet)
	{
		// If the Celestial Object is a Planet, the Elevation must be equal to or higher than the Planet's Ocean Elevation Value
		temp_celestial_object_minimum_elevation = celestial_object.ocean_elevation;
	}
	
	// Iterate Through Path Nodes to draw all Path Node Triangles
	var temp_path_node_index = 0;
	
	repeat (unit_object.pathfinding_path.path_size)
	{
		// Find Node Index
		var temp_node_index = ds_list_find_value(unit_object.pathfinding_path.node_index, temp_path_node_index);
		
		// Find Edge Indexes
		var temp_edge_a_index = array_get(celestial_object.pathfinding_node_edges_portal_left_array[temp_node_index], 0);
		var temp_edge_b_index = array_get(celestial_object.pathfinding_node_edges_portal_left_array[temp_node_index], 1);
		var temp_edge_c_index = array_get(celestial_object.pathfinding_node_edges_portal_left_array[temp_node_index], 2);
		
		// Find Edge Vectors
		var temp_edge_a_x = celestial_object.pathfinding_portal_x_array[temp_edge_a_index];
		var temp_edge_a_y = celestial_object.pathfinding_portal_y_array[temp_edge_a_index];
		var temp_edge_a_z = celestial_object.pathfinding_portal_z_array[temp_edge_a_index];
		
		var temp_edge_b_x = celestial_object.pathfinding_portal_x_array[temp_edge_b_index];
		var temp_edge_b_y = celestial_object.pathfinding_portal_y_array[temp_edge_b_index];
		var temp_edge_b_z = celestial_object.pathfinding_portal_z_array[temp_edge_b_index];
		
		var temp_edge_c_x = celestial_object.pathfinding_portal_x_array[temp_edge_c_index];
		var temp_edge_c_y = celestial_object.pathfinding_portal_y_array[temp_edge_c_index];
		var temp_edge_c_z = celestial_object.pathfinding_portal_z_array[temp_edge_c_index];
		
		// Find Edge Elevations
		var temp_edge_a_elevation = max(celestial_object.pathfinding_portal_elevation_array[temp_edge_a_index], temp_celestial_object_minimum_elevation);
		var temp_edge_b_elevation = max(celestial_object.pathfinding_portal_elevation_array[temp_edge_b_index], temp_celestial_object_minimum_elevation);
		var temp_edge_c_elevation = max(celestial_object.pathfinding_portal_elevation_array[temp_edge_c_index], temp_celestial_object_minimum_elevation);
		
		temp_edge_a_elevation = celestial_object.radius + (temp_edge_a_elevation * celestial_object.elevation);
		temp_edge_b_elevation = celestial_object.radius + (temp_edge_b_elevation * celestial_object.elevation);
		temp_edge_c_elevation = celestial_object.radius + (temp_edge_c_elevation * celestial_object.elevation);
		
		// Calculate Edge Positions
		var temp_edge_a_position_x = temp_edge_a_elevation * (temp_edge_a_x * temp_rotation_matrix[0] + temp_edge_a_y * temp_rotation_matrix[4] + temp_edge_a_z * temp_rotation_matrix[8]);
		var temp_edge_a_position_y = temp_edge_a_elevation * (temp_edge_a_x * temp_rotation_matrix[1] + temp_edge_a_y * temp_rotation_matrix[5] + temp_edge_a_z * temp_rotation_matrix[9]);
		var temp_edge_a_position_z = temp_edge_a_elevation * (temp_edge_a_x * temp_rotation_matrix[2] + temp_edge_a_y * temp_rotation_matrix[6] + temp_edge_a_z * temp_rotation_matrix[10]);
		
		temp_edge_a_position_x += celestial_object.x;
		temp_edge_a_position_y += celestial_object.y;
		temp_edge_a_position_z += celestial_object.z;
		
		var temp_edge_b_position_x = temp_edge_b_elevation * (temp_edge_b_x * temp_rotation_matrix[0] + temp_edge_b_y * temp_rotation_matrix[4] + temp_edge_b_z * temp_rotation_matrix[8]);
		var temp_edge_b_position_y = temp_edge_b_elevation * (temp_edge_b_x * temp_rotation_matrix[1] + temp_edge_b_y * temp_rotation_matrix[5] + temp_edge_b_z * temp_rotation_matrix[9]);
		var temp_edge_b_position_z = temp_edge_b_elevation * (temp_edge_b_x * temp_rotation_matrix[2] + temp_edge_b_y * temp_rotation_matrix[6] + temp_edge_b_z * temp_rotation_matrix[10]);
		
		temp_edge_b_position_x += celestial_object.x;
		temp_edge_b_position_y += celestial_object.y;
		temp_edge_b_position_z += celestial_object.z;
		
		var temp_edge_c_position_x = temp_edge_c_elevation * (temp_edge_c_x * temp_rotation_matrix[0] + temp_edge_c_y * temp_rotation_matrix[4] + temp_edge_c_z * temp_rotation_matrix[8]);
		var temp_edge_c_position_y = temp_edge_c_elevation * (temp_edge_c_x * temp_rotation_matrix[1] + temp_edge_c_y * temp_rotation_matrix[5] + temp_edge_c_z * temp_rotation_matrix[9]);
		var temp_edge_c_position_z = temp_edge_c_elevation * (temp_edge_c_x * temp_rotation_matrix[2] + temp_edge_c_y * temp_rotation_matrix[6] + temp_edge_c_z * temp_rotation_matrix[10]);
		
		temp_edge_c_position_x += celestial_object.x;
		temp_edge_c_position_y += celestial_object.y;
		temp_edge_c_position_z += celestial_object.z;
		
		// Draw Edge to Screen
		var temp_edge_a_screen_position = world_position_to_screen_position(temp_edge_a_position_x, temp_edge_a_position_y, temp_edge_a_position_z, CelestialSimulator.camera_view_matrix, CelestialSimulator.camera_projection_matrix);
		var temp_edge_b_screen_position = world_position_to_screen_position(temp_edge_b_position_x, temp_edge_b_position_y, temp_edge_b_position_z, CelestialSimulator.camera_view_matrix, CelestialSimulator.camera_projection_matrix);
		var temp_edge_c_screen_position = world_position_to_screen_position(temp_edge_c_position_x, temp_edge_c_position_y, temp_edge_c_position_z, CelestialSimulator.camera_view_matrix, CelestialSimulator.camera_projection_matrix);
		
		draw_triangle_color(temp_edge_a_screen_position[0], temp_edge_a_screen_position[1], temp_edge_b_screen_position[0], temp_edge_b_screen_position[1], temp_edge_c_screen_position[0], temp_edge_c_screen_position[1], c_white, c_white, c_white, true);
		
		// Delete Unused Arrays
		array_resize(temp_edge_a_screen_position, 0);
		array_resize(temp_edge_b_screen_position, 0);
		array_resize(temp_edge_c_screen_position, 0);
		
		// Increment Path's Node Index
		temp_path_node_index++;
	}
	
	// Iterate through Pathfinding Path Array to Draw Path Trajectory
	var temp_path_index = 0;
	
	repeat (unit_object.pathfinding_path.path_size)
	{
		// Check if Selected Unit has progressed past the given Pathfinding Path Index
		if (unit_object.pathfinding_path_index > temp_path_index)
		{
			// Increment Selected Unit's Pathfinding Path Index
			temp_path_index++;
			continue;
		}
		
		// Find Selected Unit's Pathfinding Path Node Positions & Elevations
		var temp_path_a_local_x, temp_path_a_local_y, temp_path_a_local_z, temp_path_a_local_elevation;
		
		var temp_path_b_local_x = ds_list_find_value(unit_object.pathfinding_path.position_x, temp_path_index);
		var temp_path_b_local_y = ds_list_find_value(unit_object.pathfinding_path.position_y, temp_path_index);
		var temp_path_b_local_z = ds_list_find_value(unit_object.pathfinding_path.position_z, temp_path_index);
		
		var temp_path_b_local_elevation = max(ds_list_find_value(unit_object.pathfinding_path.position_elevation, temp_path_index), temp_celestial_object_minimum_elevation);
		
		// Check if Pathfinding Path Index is the First Path Index or Selected Unit is currently traversing the given Pathfinding Path Index
		if (temp_path_index == 0 or unit_object.pathfinding_path_index == temp_path_index)
		{
			// Find Celestial Unit's Normalized Local Vector and Elevation from Celestial Body's Sphere Center with their precalculated positioning variables from their Pathfinding Behaviour
			temp_path_a_local_x = unit_object.pathfinding_position_x;
			temp_path_a_local_y = unit_object.pathfinding_position_y;
			temp_path_a_local_z = unit_object.pathfinding_position_z;
			
			temp_path_a_local_elevation = max(unit_object.pathfinding_position_elevation, temp_celestial_object_minimum_elevation);
		}
		else
		{
			// Use Previous Pathfinding Path Index Position and Elevation Values
			temp_path_a_local_x = ds_list_find_value(unit_object.pathfinding_path.position_x, temp_path_index - 1);
			temp_path_a_local_y = ds_list_find_value(unit_object.pathfinding_path.position_y, temp_path_index - 1);
			temp_path_a_local_z = ds_list_find_value(unit_object.pathfinding_path.position_z, temp_path_index - 1);
			
			temp_path_a_local_elevation = max(ds_list_find_value(unit_object.pathfinding_path.position_elevation, temp_path_index - 1), temp_celestial_object_minimum_elevation);
		}
		
		// Find Selected Unit's Pathfinding Path World Positions
		var temp_path_a_elevation = celestial_object.radius + (temp_path_a_local_elevation * celestial_object.elevation);
		var temp_path_b_elevation = celestial_object.radius + (temp_path_b_local_elevation * celestial_object.elevation);
		
		var temp_path_a_world_position_x = temp_path_a_elevation * (temp_path_a_local_x * temp_rotation_matrix[0] + temp_path_a_local_y * temp_rotation_matrix[4] + temp_path_a_local_z * temp_rotation_matrix[8]);
		var temp_path_a_world_position_y = temp_path_a_elevation * (temp_path_a_local_x * temp_rotation_matrix[1] + temp_path_a_local_y * temp_rotation_matrix[5] + temp_path_a_local_z * temp_rotation_matrix[9]);
		var temp_path_a_world_position_z = temp_path_a_elevation * (temp_path_a_local_x * temp_rotation_matrix[2] + temp_path_a_local_y * temp_rotation_matrix[6] + temp_path_a_local_z * temp_rotation_matrix[10]);
		
		var temp_path_b_world_position_x = temp_path_b_elevation * (temp_path_b_local_x * temp_rotation_matrix[0] + temp_path_b_local_y * temp_rotation_matrix[4] + temp_path_b_local_z * temp_rotation_matrix[8]);
		var temp_path_b_world_position_y = temp_path_b_elevation * (temp_path_b_local_x * temp_rotation_matrix[1] + temp_path_b_local_y * temp_rotation_matrix[5] + temp_path_b_local_z * temp_rotation_matrix[9]);
		var temp_path_b_world_position_z = temp_path_b_elevation * (temp_path_b_local_x * temp_rotation_matrix[2] + temp_path_b_local_y * temp_rotation_matrix[6] + temp_path_b_local_z * temp_rotation_matrix[10]);
		
		temp_path_a_world_position_x += celestial_object.x;
		temp_path_a_world_position_y += celestial_object.y;
		temp_path_a_world_position_z += celestial_object.z;
		
		temp_path_b_world_position_x += celestial_object.x;
		temp_path_b_world_position_y += celestial_object.y;
		temp_path_b_world_position_z += celestial_object.z;
		
		// Find Selected Unit's Pathfinding Path Screen Positions
		var temp_path_a_screen_position = world_position_to_screen_position(temp_path_a_world_position_x, temp_path_a_world_position_y, temp_path_a_world_position_z, CelestialSimulator.camera_view_matrix, CelestialSimulator.camera_projection_matrix);
		var temp_path_b_screen_position = world_position_to_screen_position(temp_path_b_world_position_x, temp_path_b_world_position_y, temp_path_b_world_position_z, CelestialSimulator.camera_view_matrix, CelestialSimulator.camera_projection_matrix);
		
		//
		draw_line_width_color(temp_path_a_screen_position[0], temp_path_a_screen_position[1], temp_path_b_screen_position[0], temp_path_b_screen_position[1], 2, c_teal, c_teal);
		
		// Increment Path Index
		temp_path_index++;
	}
	
	// Iterate Through Path Portals to draw all Path Portal Positions
	var temp_portal_index = 0;
	
	repeat (unit_object.pathfinding_path.path_size - 1)
	{
		// Find Node Indexes
		var temp_node_index_a = ds_list_find_value(unit_object.pathfinding_path.node_index, temp_portal_index);
		var temp_node_index_b = ds_list_find_value(unit_object.pathfinding_path.node_index, temp_portal_index + 1);
		
		// Find Edge Index
		var temp_edge_index = array_get_index(celestial_object.pathfinding_node_edges_array[temp_node_index_a], temp_node_index_b);
		
		// Find Portal Indexes
		var temp_portal_left_index = array_get(celestial_object.pathfinding_node_edges_portal_left_array[temp_node_index_a], temp_edge_index);
		var temp_portal_right_index = array_get(celestial_object.pathfinding_node_edges_portal_right_array[temp_node_index_a], temp_edge_index);
		
		// Find Portal Vectors
		var temp_portal_left_x = celestial_object.pathfinding_portal_x_array[temp_portal_left_index];
		var temp_portal_left_y = celestial_object.pathfinding_portal_y_array[temp_portal_left_index];
		var temp_portal_left_z = celestial_object.pathfinding_portal_z_array[temp_portal_left_index];
		
		var temp_portal_right_x = celestial_object.pathfinding_portal_x_array[temp_portal_right_index];
		var temp_portal_right_y = celestial_object.pathfinding_portal_y_array[temp_portal_right_index];
		var temp_portal_right_z = celestial_object.pathfinding_portal_z_array[temp_portal_right_index];
		
		// Find Path Portal Elevations
		var temp_portal_left_elevation = max(celestial_object.pathfinding_portal_elevation_array[temp_portal_left_index], temp_celestial_object_minimum_elevation);
		var temp_portal_right_elevation = max(celestial_object.pathfinding_portal_elevation_array[temp_portal_right_index], temp_celestial_object_minimum_elevation);
		
		temp_portal_left_elevation = celestial_object.radius + (temp_portal_left_elevation * celestial_object.elevation);
		temp_portal_right_elevation = celestial_object.radius + (temp_portal_right_elevation * celestial_object.elevation);
		
		// Find Portal Positions
		var temp_portal_left_position_x = temp_portal_left_elevation * (temp_portal_left_x * temp_rotation_matrix[0] + temp_portal_left_y * temp_rotation_matrix[4] + temp_portal_left_z * temp_rotation_matrix[8]);
		var temp_portal_left_position_y = temp_portal_left_elevation * (temp_portal_left_x * temp_rotation_matrix[1] + temp_portal_left_y * temp_rotation_matrix[5] + temp_portal_left_z * temp_rotation_matrix[9]);
		var temp_portal_left_position_z = temp_portal_left_elevation * (temp_portal_left_x * temp_rotation_matrix[2] + temp_portal_left_y * temp_rotation_matrix[6] + temp_portal_left_z * temp_rotation_matrix[10]);
		
		temp_portal_left_position_x += celestial_object.x;
		temp_portal_left_position_y += celestial_object.y;
		temp_portal_left_position_z += celestial_object.z;
		
		var temp_portal_right_position_x = temp_portal_right_elevation * (temp_portal_right_x * temp_rotation_matrix[0] + temp_portal_right_y * temp_rotation_matrix[4] + temp_portal_right_z * temp_rotation_matrix[8]);
		var temp_portal_right_position_y = temp_portal_right_elevation * (temp_portal_right_x * temp_rotation_matrix[1] + temp_portal_right_y * temp_rotation_matrix[5] + temp_portal_right_z * temp_rotation_matrix[9]);
		var temp_portal_right_position_z = temp_portal_right_elevation * (temp_portal_right_x * temp_rotation_matrix[2] + temp_portal_right_y * temp_rotation_matrix[6] + temp_portal_right_z * temp_rotation_matrix[10]);
		
		temp_portal_right_position_x += celestial_object.x;
		temp_portal_right_position_y += celestial_object.y;
		temp_portal_right_position_z += celestial_object.z;
		
		// Draw Left & Right Portals to Screen
		var temp_portal_left_screen_position = world_position_to_screen_position(temp_portal_left_position_x, temp_portal_left_position_y, temp_portal_left_position_z, CelestialSimulator.camera_view_matrix, CelestialSimulator.camera_projection_matrix);
		var temp_portal_right_screen_position = world_position_to_screen_position(temp_portal_right_position_x, temp_portal_right_position_y, temp_portal_right_position_z, CelestialSimulator.camera_view_matrix, CelestialSimulator.camera_projection_matrix);
		
		draw_circle_color(temp_portal_left_screen_position[0], temp_portal_left_screen_position[1], 2, c_black, c_black, false);
		draw_circle_color(temp_portal_left_screen_position[0], temp_portal_left_screen_position[1], 1, c_blue, c_blue, false);
		draw_circle_color(temp_portal_right_screen_position[0], temp_portal_right_screen_position[1], 2, c_black, c_black, false);
		draw_circle_color(temp_portal_right_screen_position[0], temp_portal_right_screen_position[1], 1, c_red, c_red, false);
		
		// Delete Unused Arrays
		array_resize(temp_portal_left_screen_position, 0);
		array_resize(temp_portal_right_screen_position, 0);
		
		// Increment Portal Index
		temp_portal_index++;
	}
	
	// Delete Unused Rotation Matrix
	array_resize(temp_rotation_matrix, 0);
}

function celestial_pathfinding_draw_navigation_mesh_gizmos(celestial_object)
{
	//
	if (!celestial_object.pathfinding_enabled)
	{
		return;
	}
	
	//
	var temp_celestial_minimum_elevation = 0;
	
	if (celestial_object.celestial_object_type == CelestialObjectType.Planet)
	{
		// If the Celestial Object is a Planet, the Elevation must be equal to or higher than the Planet's Ocean Elevation Value
		temp_celestial_minimum_elevation = celestial_object.ocean_elevation;
	}
	
	//
	var temp_rotation_matrix = rotation_matrix_from_euler_angles(celestial_object.euler_angle_x, celestial_object.euler_angle_y, celestial_object.euler_angle_z);
	
	/*
	// Interpolated Depth of Elevated Vertex Position relative to Camera's Viewing Orientation and the Radius of Atmosphere
	vec3 camera_view_direction = normalize(v_vPosition - in_vsh_CameraPosition);
	v_vDepth = dot(camera_view_direction, planet_rotated_local_vector_elevation / u_AtmosphereRadius) * u_AtmosphereRadius + u_AtmosphereRadius;
	*/
	
	//
	var temp_camera_vector_x = celestial_object.x - CelestialSimulator.camera_position_x;
	var temp_camera_vector_y = celestial_object.y - CelestialSimulator.camera_position_y;
	var temp_camera_vector_z = celestial_object.z - CelestialSimulator.camera_position_z;
	
	//
	var temp_camera_vector_magnitude = sqrt(dot_product_3d(temp_camera_vector_x, temp_camera_vector_y, temp_camera_vector_z, temp_camera_vector_x, temp_camera_vector_y, temp_camera_vector_z));
	
	//
	var temp_camera_normalized_vector_x = temp_camera_vector_x / temp_camera_vector_magnitude;
	var temp_camera_normalized_vector_y = temp_camera_vector_y / temp_camera_vector_magnitude;
	var temp_camera_normalized_vector_z = temp_camera_vector_z / temp_camera_vector_magnitude;
	
	// Iterate through all Nodes to Render Edges
	var temp_node_index = 0;
	
	repeat (celestial_object.pathfinding_nodes_count)
	{
		//
		var temp_node_x = celestial_object.pathfinding_node_x_array[temp_node_index];
		var temp_node_y = celestial_object.pathfinding_node_y_array[temp_node_index];
		var temp_node_z = celestial_object.pathfinding_node_z_array[temp_node_index];
		var temp_node_elevation = max(celestial_object.pathfinding_node_elevation_array[temp_node_index], temp_celestial_minimum_elevation);
		
		//
		temp_node_elevation = celestial_object.radius + (temp_node_elevation * celestial_object.elevation);
		
		// Find Celestial Unit's World Position
		var temp_node_position_x = temp_node_elevation * (temp_node_x * temp_rotation_matrix[0] + temp_node_y * temp_rotation_matrix[4] + temp_node_z * temp_rotation_matrix[8]);
		var temp_node_position_y = temp_node_elevation * (temp_node_x * temp_rotation_matrix[1] + temp_node_y * temp_rotation_matrix[5] + temp_node_z * temp_rotation_matrix[9]);
		var temp_node_position_z = temp_node_elevation * (temp_node_x * temp_rotation_matrix[2] + temp_node_y * temp_rotation_matrix[6] + temp_node_z * temp_rotation_matrix[10]);
		
		//
		var temp_node_render_depth_vector_x = temp_node_position_x / celestial_object.render_depth_radius;
		var temp_node_render_depth_vector_y = temp_node_position_y / celestial_object.render_depth_radius;
		var temp_node_render_depth_vector_z = temp_node_position_z / celestial_object.render_depth_radius;
		
		//
		var temp_node_render_depth_dot = dot_product_3d(temp_camera_normalized_vector_x, temp_camera_normalized_vector_y, temp_camera_normalized_vector_z, temp_node_render_depth_vector_x, temp_node_render_depth_vector_y, temp_node_render_depth_vector_z);
		
		//
		if (temp_node_render_depth_dot > -0.333)
		{
			// Increment Pathfinding Node Index
			temp_node_index++;
			
			//
			continue;
		}
		
		//
		var temp_node_world_position_x = temp_node_position_x + celestial_object.x;
		var temp_node_world_position_y = temp_node_position_y + celestial_object.y;
		var temp_node_world_position_z = temp_node_position_z + celestial_object.z;
		
		// Find Celestial Unit's Screen Position and set the Celestial Unit Instance's Position to their Converted World Position to Screen Coordinates
		var temp_node_screen_position = world_position_to_screen_position(temp_node_world_position_x, temp_node_world_position_y, temp_node_world_position_z, CelestialSimulator.camera_view_matrix, CelestialSimulator.camera_projection_matrix);
		
		// Find Edge Indexes
		var temp_edge_a_index = array_get(celestial_object.pathfinding_node_edges_portal_left_array[temp_node_index], 0);
		var temp_edge_b_index = array_get(celestial_object.pathfinding_node_edges_portal_left_array[temp_node_index], 1);
		var temp_edge_c_index = array_get(celestial_object.pathfinding_node_edges_portal_left_array[temp_node_index], 2);
		
		// Find Edge Vectors
		var temp_edge_a_x = celestial_object.pathfinding_portal_x_array[temp_edge_a_index];
		var temp_edge_a_y = celestial_object.pathfinding_portal_y_array[temp_edge_a_index];
		var temp_edge_a_z = celestial_object.pathfinding_portal_z_array[temp_edge_a_index];
		
		var temp_edge_b_x = celestial_object.pathfinding_portal_x_array[temp_edge_b_index];
		var temp_edge_b_y = celestial_object.pathfinding_portal_y_array[temp_edge_b_index];
		var temp_edge_b_z = celestial_object.pathfinding_portal_z_array[temp_edge_b_index];
		
		var temp_edge_c_x = celestial_object.pathfinding_portal_x_array[temp_edge_c_index];
		var temp_edge_c_y = celestial_object.pathfinding_portal_y_array[temp_edge_c_index];
		var temp_edge_c_z = celestial_object.pathfinding_portal_z_array[temp_edge_c_index];
		
		// Find Edge Elevations
		var temp_edge_a_elevation = max(celestial_object.pathfinding_portal_elevation_array[temp_edge_a_index], temp_celestial_minimum_elevation);
		var temp_edge_b_elevation = max(celestial_object.pathfinding_portal_elevation_array[temp_edge_b_index], temp_celestial_minimum_elevation);
		var temp_edge_c_elevation = max(celestial_object.pathfinding_portal_elevation_array[temp_edge_c_index], temp_celestial_minimum_elevation);
		
		temp_edge_a_elevation = celestial_object.radius + (temp_edge_a_elevation * celestial_object.elevation);
		temp_edge_b_elevation = celestial_object.radius + (temp_edge_b_elevation * celestial_object.elevation);
		temp_edge_c_elevation = celestial_object.radius + (temp_edge_c_elevation * celestial_object.elevation);
		
		// Calculate Edge Positions
		var temp_edge_a_position_x = temp_edge_a_elevation * (temp_edge_a_x * temp_rotation_matrix[0] + temp_edge_a_y * temp_rotation_matrix[4] + temp_edge_a_z * temp_rotation_matrix[8]);
		var temp_edge_a_position_y = temp_edge_a_elevation * (temp_edge_a_x * temp_rotation_matrix[1] + temp_edge_a_y * temp_rotation_matrix[5] + temp_edge_a_z * temp_rotation_matrix[9]);
		var temp_edge_a_position_z = temp_edge_a_elevation * (temp_edge_a_x * temp_rotation_matrix[2] + temp_edge_a_y * temp_rotation_matrix[6] + temp_edge_a_z * temp_rotation_matrix[10]);
		
		temp_edge_a_position_x += celestial_object.x;
		temp_edge_a_position_y += celestial_object.y;
		temp_edge_a_position_z += celestial_object.z;
		
		var temp_edge_b_position_x = temp_edge_b_elevation * (temp_edge_b_x * temp_rotation_matrix[0] + temp_edge_b_y * temp_rotation_matrix[4] + temp_edge_b_z * temp_rotation_matrix[8]);
		var temp_edge_b_position_y = temp_edge_b_elevation * (temp_edge_b_x * temp_rotation_matrix[1] + temp_edge_b_y * temp_rotation_matrix[5] + temp_edge_b_z * temp_rotation_matrix[9]);
		var temp_edge_b_position_z = temp_edge_b_elevation * (temp_edge_b_x * temp_rotation_matrix[2] + temp_edge_b_y * temp_rotation_matrix[6] + temp_edge_b_z * temp_rotation_matrix[10]);
		
		temp_edge_b_position_x += celestial_object.x;
		temp_edge_b_position_y += celestial_object.y;
		temp_edge_b_position_z += celestial_object.z;
		
		var temp_edge_c_position_x = temp_edge_c_elevation * (temp_edge_c_x * temp_rotation_matrix[0] + temp_edge_c_y * temp_rotation_matrix[4] + temp_edge_c_z * temp_rotation_matrix[8]);
		var temp_edge_c_position_y = temp_edge_c_elevation * (temp_edge_c_x * temp_rotation_matrix[1] + temp_edge_c_y * temp_rotation_matrix[5] + temp_edge_c_z * temp_rotation_matrix[9]);
		var temp_edge_c_position_z = temp_edge_c_elevation * (temp_edge_c_x * temp_rotation_matrix[2] + temp_edge_c_y * temp_rotation_matrix[6] + temp_edge_c_z * temp_rotation_matrix[10]);
		
		temp_edge_c_position_x += celestial_object.x;
		temp_edge_c_position_y += celestial_object.y;
		temp_edge_c_position_z += celestial_object.z;
		
		// Draw Edge to Screen
		var temp_edge_a_screen_position = world_position_to_screen_position(temp_edge_a_position_x, temp_edge_a_position_y, temp_edge_a_position_z, CelestialSimulator.camera_view_matrix, CelestialSimulator.camera_projection_matrix);
		var temp_edge_b_screen_position = world_position_to_screen_position(temp_edge_b_position_x, temp_edge_b_position_y, temp_edge_b_position_z, CelestialSimulator.camera_view_matrix, CelestialSimulator.camera_projection_matrix);
		var temp_edge_c_screen_position = world_position_to_screen_position(temp_edge_c_position_x, temp_edge_c_position_y, temp_edge_c_position_z, CelestialSimulator.camera_view_matrix, CelestialSimulator.camera_projection_matrix);
		
		draw_triangle_color(temp_edge_a_screen_position[0], temp_edge_a_screen_position[1], temp_edge_b_screen_position[0], temp_edge_b_screen_position[1], temp_edge_c_screen_position[0], temp_edge_c_screen_position[1], c_fuchsia, c_fuchsia, c_fuchsia, true);
		
		// Delete Unused Arrays
		array_resize(temp_edge_a_screen_position, 0);
		array_resize(temp_edge_b_screen_position, 0);
		array_resize(temp_edge_c_screen_position, 0);
		
		//
		draw_point_color(temp_node_screen_position[0], temp_node_screen_position[1], c_maroon);
		
		// Delete Unused Array
		array_resize(temp_node_screen_position, 0);
		
		// Increment Pathfinding Node Index
		temp_node_index++;
	}
	
	// Delete Unused Array
	array_resize(temp_rotation_matrix, 0)
}






























