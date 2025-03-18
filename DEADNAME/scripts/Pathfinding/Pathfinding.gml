enum PathfindingEdgeType
{
	DefaultEdge,
	JumpEdge,
	TeleportEdge
}

/// pathfinding_add_node(node_position_x, node_position_y, node_edges, node_id);
function pathfinding_add_node(position_x, position_y, node_id = undefined)
{
	// Check if Node already exists
	if (!is_undefined(node_id) and !is_undefined(ds_map_find_value(GameManager.pathfinding_node_ids_map, node_id)))
	{
		// Node with Unique ID already exists - Early Return
		return;
	}
	
	// Create Unique Pathfinding Node ID
	var temp_node_id = is_undefined(node_id) ? 0 : node_id;
	var temp_node_id_found = !is_undefined(node_id) and is_undefined(ds_map_find_value(GameManager.pathfinding_node_ids_map, node_id));
	
	while (!temp_node_id_found)
	{
		// Generate New Pathfinding Node ID - I don't know why I chose to make it this way, I was just feeling quirky and I like the number 6
		var temp_generated_node_id = irandom(99999) + 600000;
		
		// Check if Generated Node ID already exists
		if (is_undefined(ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_generated_node_id)))
		{
			// Node ID is valid
			temp_node_id_found = true;
			temp_node_id = temp_generated_node_id;
			break;
		}
	}
	
	// Check if Deleted Pathfinding Node Index is available
	var temp_node_index = -1;
	var temp_deleted_node_index_available = false;
	
	if (ds_list_size(GameManager.pathfinding_node_deleted_indexes_list) > 0)
	{
		// Get next available deleted index in Pathfinding Nodes DS List
		temp_node_index = ds_list_find_value(GameManager.pathfinding_node_deleted_indexes_list, 0);
		temp_deleted_node_index_available = true;
		
		// Remove available index now that the index has been taken
		ds_list_delete(GameManager.pathfinding_node_deleted_indexes_list, 0);
	}
	else
	{
		// Get next available index in Pathfinding Nodes DS List
		temp_node_index = ds_list_size(GameManager.pathfinding_node_exists_list);
	}
	
	// Add Pathfinding Node ID and Pathfinding Node DS List Index to Pathfinding Node ID DS Map
	ds_map_add(GameManager.pathfinding_node_ids_map, temp_node_id, temp_node_index);
	
	// Obtain Pathfinding Node Anchor Position via Raycast towards Ground at Pathfinding Node Position
	var temp_raycast = platform_raycast(x, y, 100, 270);
	
	// Create Node at next available Pathfinding Node DS List Index
	if (temp_deleted_node_index_available)
	{
		// Set Pathfinding Node's Data at the Available Deleted Node Index within the Pathfinding Nodes DS Lists
		ds_list_set(GameManager.pathfinding_node_exists_list, temp_node_index, true);
		ds_list_set(GameManager.pathfinding_node_struct_list, temp_node_index, { node_position_x: position_x, node_position_y: position_y, anchor_position_x: temp_raycast.collision_x, anchor_position_y: temp_raycast.collision_y });
		ds_list_clear(ds_list_find_value(GameManager.pathfinding_node_edges_list, temp_node_index));
	}
	else
	{
		// Add New Pathfinding Node's Data to Pathfinding Nodes DS Lists
		ds_list_add(GameManager.pathfinding_node_exists_list, true);
		ds_list_add(GameManager.pathfinding_node_struct_list, { node_position_x: position_x, node_position_y: position_y, anchor_position_x: temp_raycast.collision_x, anchor_position_y: temp_raycast.collision_y });
		ds_list_add_list(GameManager.pathfinding_node_edges_list, ds_list_create());
	}
}

/// pathfinding_remove_node(node_id);
/// @description Removes a Pathfinding Node that shares the given Node ID
/// @param {int} node_id The Node ID of the Pathfinding Node to remove
function pathfinding_remove_node(node_id)
{
	// Check if Node Exists
	var temp_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, node_id);
	
	if (is_undefined(temp_node_index))
	{
		// Node is missing or Invalid - Early Return
		return;
	}
	
	// Find Pathfinding Node Indexes
	var temp_node_edges_list = ds_list_find_value(GameManager.pathfinding_node_edges_list, temp_node_index);
	
	for (var i = 0; i < ds_list_size(temp_node_edges_list); i++)
	{
		// Find Edge Node ID
		var temp_edge_node_id = ds_list_find_value(temp_node_edges_list, i);
		
		// Find Edge Node Index
		var temp_edge_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_edge_node_id);
		
		// Edge Node Index Exists
		if (!is_undefined(temp_edge_node_index))
		{
			// Find Edge Node's Edge Reference to Deleted Node ID 
			var temp_edge_node_edges_list = ds_list_find_value(GameManager.pathfinding_node_edges_list, temp_edge_node_index);
			var temp_node_within_edge_node_edges_list_index = ds_list_find_index(temp_edge_node_edges_list, node_id);
			
			// Remove Deleted Node's ID from Edge Node's Edge Reference
			ds_list_delete(temp_edge_node_edges_list, temp_node_within_edge_node_edges_list_index);
		}
		
		// Create Edge ID based on the given Node IDs and Find Edge Index
		var temp_edge_id = pathfinding_generate_edge_id(node_id, temp_edge_node_id);
		var temp_edge_index = ds_map_find_value(GameManager.pathfinding_edge_ids_map, temp_edge_id);
		
		// Edge Exists
		if (temp_edge_index != -1)
		{
			// Delete Edge ID from Edge ID DS Map
			ds_map_delete(GameManager.pathfinding_edge_ids_map, temp_edge_id);
			
			// Set Pathfinding Edge Existence at Edge Index to False
			ds_list_set(GameManager.pathfinding_edge_exists_list, temp_edge_index, false);
			
			// Add Deleted Pathfinding Edge Index to Deleted Pathfinding Edge Indexes DS List
			ds_list_add(GameManager.pathfinding_edge_deleted_indexes_list, temp_edge_index);
		}
	}
	
	// Delete Node ID from Node ID DS Map
	ds_map_delete(GameManager.pathfinding_node_ids_map, node_id);
			
	// Set Pathfinding Node Existence at Node Index to False
	ds_list_set(GameManager.pathfinding_node_exists_list, temp_node_index, false);
	
	// Add Deleted Pathfinding Node Index to Deleted Pathfinding Node Indexes DS List
	ds_list_add(GameManager.pathfinding_node_deleted_indexes_list, temp_node_index);
}

/// pathfinding_generate_edge_id(first_node_id, second_node_id);
/// @description Generates the Edge ID shared by the two given Nodes, based on the Node IDs being sorted (lowest ID comes first, highest ID comes second)
/// @param {any} first_node_id The first Node's ID to create the concatenated Edge ID off of
/// @param {any} second_node_id The second Node's ID to create the concatenated Edge ID off of
/// @returns {string} Returns the Edge ID of the two given Nodes
function pathfinding_generate_edge_id(first_node_id, second_node_id)
{
	if (is_string(first_node_id) or is_string(second_node_id))
	{
		var first_node_id_as_string = string(first_node_id);
		var second_node_id_as_string = string(second_node_id);
		
		return (first_node_id_as_string < second_node_id_as_string) ? $"[{first_node_id_as_string}][{second_node_id_as_string}]" : $"[{second_node_id_as_string}][{first_node_id_as_string}]";
	}
	else
	{
		return (first_node_id < second_node_id) ? $"[{first_node_id}][{second_node_id}]" : $"[{second_node_id}][{first_node_id}]";
	}
}

/// pathfinding_add_edge(first_node_id, second_node_id, edge_type);
function pathfinding_add_edge(first_node_id, second_node_id, edge_type)
{
	// Check if both Nodes Exist
	var temp_first_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, first_node_id);
	var temp_second_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, second_node_id);
	
	if (is_undefined(temp_first_node_index) or is_undefined(temp_second_node_index))
	{
		// One or More Node is missing or Invalid - Early Return
		return;
	}
	
	// Create Edge ID based on the given Node IDs
	var temp_edge_id = pathfinding_generate_edge_id(first_node_id, second_node_id);
	
	// Check if Pathfinding Edge already exists
	if (!is_undefined(ds_map_find_value(GameManager.pathfinding_edge_ids_map, temp_edge_id)))
	{
		// Edge already exists between these two Pathfinding Nodes - Early Return
		return;
	}
	
	// Create Edge Weight Struct between the two given Pathfinding Nodes
	var temp_edge_weight_struct = pathfinding_create_edge_weight(temp_first_node_index, temp_second_node_index, edge_type);
	
	// Check if Deleted Pathfinding Edge Index is available
	var temp_edge_index = -1;
	var temp_deleted_edge_index_available = false;
	
	if (ds_list_size(GameManager.pathfinding_edge_deleted_indexes_list) > 0)
	{
		// Get next available deleted index in Pathfinding Edges DS List
		temp_edge_index = ds_list_find_value(GameManager.pathfinding_edge_deleted_indexes_list, 0);
		temp_deleted_edge_index_available = true;
		
		// Remove available index now that the index has been taken
		ds_list_delete(GameManager.pathfinding_edge_deleted_indexes_list, 0);
	}
	else
	{
		// Get next available index in Pathfinding Edges DS List
		temp_edge_index = ds_list_size(GameManager.pathfinding_edge_exists_list);
	}
	
	// Add Pathfinding Edge ID to Pathfinding Edge ID DS Map
	ds_map_add(GameManager.pathfinding_edge_ids_map, temp_edge_id, temp_edge_index);
	
	// Create Edge at next available Pathfinding Edge DS List Index
	if (temp_deleted_edge_index_available)
	{
		// Set Pathfinding Edge's Data at the Available Deleted Edge Index within the Pathfinding Edges DS Lists
		ds_list_set(GameManager.pathfinding_edge_exists_list, temp_edge_index, true);
		ds_list_set(GameManager.pathfinding_edge_nodes_list, temp_edge_index, { first_node_id: first_node_id, second_node_id: second_node_id });
		ds_list_set(GameManager.pathfinding_edge_types_list, temp_edge_index, edge_type);
		ds_list_set(GameManager.pathfinding_edge_weights_list, temp_edge_index, temp_edge_weight_struct);
	}
	else
	{
		// Add New Pathfinding Edge's Data to Pathfinding Edges DS Lists
		ds_list_add(GameManager.pathfinding_edge_exists_list, true);
		ds_list_add(GameManager.pathfinding_edge_nodes_list, { first_node_id: first_node_id, second_node_id: second_node_id });
		ds_list_add(GameManager.pathfinding_edge_types_list, edge_type);
		ds_list_add(GameManager.pathfinding_edge_weights_list, temp_edge_weight_struct);
	}
}

/// pathfinding_remove_edge(first_node_id, second_node_id);
function pathfinding_remove_edge(first_node_id, second_node_id)
{
	// Check if both Nodes Exist
	var temp_first_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, first_node_id);
	var temp_second_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, second_node_id);
	
	if (is_undefined(temp_first_node_index) or is_undefined(temp_second_node_index))
	{
		// One or More Node is missing or Invalid - Early Return
		return;
	}
	
	// Create Edge ID based on the given Node IDs and Find Edge Index
	var temp_edge_id = pathfinding_generate_edge_id(first_node_id, second_node_id);
	var temp_edge_index = ds_map_find_value(GameManager.pathfinding_edge_ids_map, temp_edge_id);
	
	// Check if Pathfinding Edge already exists
	if (is_undefined(temp_edge_index))
	{
		// Edge does not exist between these two Pathfinding Nodes - Early Return
		return;
	}
	
	// Find First Node's Edge Reference to Second Node ID and Remove Second Node's ID from First Node's Edge Reference
	var temp_first_node_edges_list = ds_list_find_value(GameManager.pathfinding_node_edges_list, temp_first_node_index);
	var temp_second_node_within_first_node_edges_list_index = ds_list_find_index(temp_first_node_edges_list, second_node_id);
	
	ds_list_delete(temp_first_node_edges_list, temp_second_node_within_first_node_edges_list_index);
	
	// Find Second Node's Edge Reference to First Node ID and Remove First Node's ID from Second Node's Edge Reference
	var temp_second_node_edges_list = ds_list_find_value(GameManager.pathfinding_node_edges_list, temp_second_node_index);
	var temp_first_node_within_second_node_edges_list_index = ds_list_find_index(temp_second_node_edges_list, first_node_id);
	
	ds_list_delete(temp_second_node_edges_list, temp_first_node_within_second_node_edges_list_index);
	
	// Delete Edge ID from Edge ID DS Map
	ds_map_delete(GameManager.pathfinding_edge_ids_map, temp_edge_id);
	
	// Set Pathfinding Edge Existence at Edge Index to False
	ds_list_set(GameManager.pathfinding_edge_exists_list, temp_edge_index, false);
	
	// Add Deleted Pathfinding Edge Index to Deleted Pathfinding Edge Indexes DS List
	ds_list_add(GameManager.pathfinding_edge_deleted_indexes_list, temp_edge_index);
}

function pathfinding_create_edge_weight(first_node_index, second_node_index, edge_type)
{
	// Find Nodes
	var temp_first_node = ds_list_find_value(GameManager.pathfinding_node_struct_list, first_node_index);
	var temp_second_node = ds_list_find_value(GameManager.pathfinding_node_struct_list, second_node_index);
	
	// Find Weight between both Nodes
	var temp_weight_struct = 
	{
		distance_weight: point_distance(temp_first_node.anchor_position_x, temp_first_node.anchor_position_y, temp_second_node.anchor_position_x, temp_second_node.anchor_position_y),
		hazard_weight: 0
	}
	
	// Return Weight Struct
	return temp_weight_struct;
}

function pathfinding_find_edge_weight(first_node_id, second_node_id)
{
	// Create Edge ID based on the given Node IDs and Find Edge Index
	var temp_edge_id = pathfinding_generate_edge_id(first_node_id, second_node_id);
	var temp_edge_index = ds_map_find_value(GameManager.pathfinding_edge_ids_map, temp_edge_id);
	
	// Check if Pathfinding Edge exists
	if (is_undefined(temp_edge_index))
	{
		// Edge does not exist between these two Pathfinding Nodes - Early Return
		return undefined;
	}
	
	// Obtain Edge Struct
	var temp_node_edge_struct = ds_list_find_value(GameManager.pathfinding_edge_weights_list, temp_edge_index);
	
	// Return Cumulative Edge Weight
	return temp_node_edge_struct.distance_weight + temp_node_edge_struct.hazard_weight;
}

function pathfinding_find_path_weight(path_list)
{
	// Check if Path List contains less than 2 nodes
	if (ds_list_size(path_list) < 2)
	{
		return 0;
	}
	
	// Iterate through Path Edges to find Cumulative Weight
	var temp_weight = 0;
	var temp_path_index = 0;
	
	repeat (ds_list_size(path_list) - 1)
	{
		// Add Weight Between Edges
		temp_weight += pathfinding_find_edge_weight(ds_list_find_value(path_list, temp_path_index), ds_list_find_value(path_list, temp_path_index + 1));
		
		// Increment Path Index
		temp_path_index++;
	}
	
	// Return Cumulative Path Weight
	return temp_weight;
}

function pathfinding_recursive(start_node_id, end_node_id, path_list = ds_list_create())
{
	// Index Start Node in Array
	ds_list_add(path_list, start_node_id);
	
	// Check that Start Node and End Node Match - Early Return of Recursive Path Structure
	if (start_node_id == end_node_id)
	{
		return path_list;
	}
	
	// Find Node Index & Node Edges List
	var temp_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, start_node_id);
	var temp_node_edges_list = ds_list_find_value(GameManager.pathfinding_node_edges_list, temp_node_index);
	
	// Establish Path Comparison Variables
	var temp_path_weight = -1;
	var temp_path_list = undefined;
	
	// Iterate through all Node Edges
	var temp_node_edge_index = 0;
	
	repeat (ds_list_size(temp_node_edges_list))
	{
		// Find Edge Node ID
		var temp_edge_node_id = ds_list_find_index(temp_node_edges_list, temp_node_edge_index);
		
		// Check if Path contains Edge Node
		var temp_path_contains_edge_node = ds_list_find_index(path_list, temp_edge_node_id) != -1;
		
		// If Path does not contain Edge Node continue Recursive Pathfinding from there
		if (!temp_path_contains_edge_node)
		{
			// Duplicate Path List
			var temp_comparison_path = ds_list_create();
			ds_list_copy(path_list, temp_comparison_path);
			
			// Create Comparison Path List and Path Weight
			temp_comparison_path = pathfinding_recursive(temp_edge_node_id, end_node_id, temp_comparison_path);
			var temp_comparison_path_weight = pathfinding_find_path_weight(temp_comparison_path);
			
			// Check if Path List Exists and can be Compared
			if (!is_undefined(temp_path_list))
			{
				// Compare Path Weights
				if (temp_comparison_path_weight >= temp_path_weight)
				{
					// Comparison Path Weight is greater or equal than the current Path - Destroy Comparison Path List
					ds_list_destroy(temp_comparison_path);
					temp_comparison_path = -1;
					
					temp_comparison_path = temp_path_list;
					temp_comparison_path_weight = temp_path_weight;
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
		temp_node_edge_index++;
	}
	
	// Destroy Unused Given Path List
	ds_list_destroy(path_list);
	path_list = -1;
	
	// Return Compared Path List
	return temp_path_list;
}

/// pathfinder_get_closest_point_on_edge(x_position, y_position);
/// @description Finds the closest coordinate that exists on any oPathEdge that exists in the room
/// @param {real} x_position The X position to check for the closest coordinate to on a oPathEdge
/// @param {real} y_position The Y position to check for the closest coordinate to on a oPathEdge
/// @param {PathfindingEdgeType} edge_type Edge Type to pass as an optional argument, if this value is not undefined this function will only return a closest point on an edge that has a matching edge type to the one given
/// @returns {struct} A struct with the X coordinate [struct.return_x] and Y coordinate [struct.return_y] and the Edge id it exists on [struct.edge_id]
function pathfinder_get_closest_point_on_edge(x_position, y_position, edge_type = undefined)
{
	// Establish Return Variables
	var temp_position_x = x_position;
	var temp_position_y = y_position;
	var temp_distance = 0;
	var temp_position_edge = undefined;
	
	// Iterate through Edges to find closest point to given point
	for (var i = 0; i < ds_list_size(GameManager.pathfinding_edge_exists_list); i++)
	{
		// Check if Edge Exists
		if (ds_list_find_value(GameManager.pathfinding_edge_exists_list, i))
		{
			// Edge Type Discrimination
			if (!is_undefined(edge_type))
			{
				// Check Edge Type and compare to desired Pathfinding Edge Type
				var temp_edge_type = ds_list_find_value(GameManager.pathfinding_edge_types_list, i);
				
				// Edge Types do not match
				if (edge_type != temp_edge_type)
				{
					// Skip this Edge and Continue
					continue;
				}
			}
			
			// Find Edge's Node IDs and Node Indexes
			var temp_edge_nodes = ds_list_find_value(GameManager.pathfinding_edge_nodes_list, i);
			var temp_first_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_edge_nodes.first_node_id);
			var temp_second_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_edge_nodes.second_node_id);
			
			// Find Edge's Node Data
			var temp_first_node = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_first_node_index);
			var temp_second_node = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_second_node_index);
			
			// Find Closest Point on Edge
			var temp_closest_point_on_edge = point_closest_on_line(x_position, y_position, temp_first_node.anchor_position_x, temp_first_node.anchor_position_y, temp_second_node.anchor_position_x, temp_second_node.anchor_position_y);
			var temp_closest_point_on_edge_distance = point_distance(x_position, y_position, temp_closest_point_on_edge.return_x, temp_closest_point_on_edge.return_y);
			
			// Compare Closest Point on Old Edge to Closest Point on New Edge 
			if (is_undefined(temp_position_edge) or temp_closest_point_on_edge_distance < temp_distance)
			{
				temp_position_x = temp_closest_point_on_edge.return_x;
				temp_position_y = temp_closest_point_on_edge.return_y;
				temp_distance = temp_closest_point_on_edge_distance;
				temp_position_edge = pathfinding_generate_edge_id(temp_edge_nodes.first_node_id, temp_edge_nodes.second_node_id);
			}
		}
	}
	
	// Return Struct
	return { return_x: temp_position_x, return_y: temp_position_y, edge_id: temp_position_edge };
}

/// pathfinder_get_path(start_x_position, start_y_position, end_x_position, end_y_position);
/// @description Finds the path of least resistance between the start coordinate and the end coordinate
/// @param {real} start_x_position The X position in the world to start pathfinding from
/// @param {real} start_y_position The Y position in the world to start pathfinding from
/// @param {real} end_x_position The X position in the world to end the path at
/// @param {real} end_x_position The Y position in the world to end the path at
function pathfinding_get_path(start_x_position, start_y_position, end_x_position, end_y_position)
{
	// Find Edge Data for Start and End Coordinates
	var temp_start_edge_data = pathfinder_get_closest_point_on_edge(start_x_position, start_y_position);
	var temp_end_edge_data = pathfinder_get_closest_point_on_edge(end_x_position, end_y_position);
	
	// Check if Edge Data is Viable
	if (is_undefined(temp_start_edge_data.edge_id) or is_undefined(temp_end_edge_data.edge_id)) 
	{
		// Edges do not Exist
		return undefined;
	}
	
	// Check if Start Edge and End Edge share the same Edge ID
	if (temp_start_edge_data.edge_id == temp_end_edge_data.edge_id) 
	{
		// Find Edge Index, Type, and Weight
		var temp_same_edge_index = ds_map_find_value(GameManager.pathfinding_edge_ids_map, temp_start_edge_data.edge_id);
		var temp_same_edge_type = ds_list_find_value(GameManager.pathfinding_edge_types_list, temp_same_edge_index);
		var temp_same_edge_weight = ds_list_find_value(GameManager.pathfinding_edge_weights_list, temp_same_edge_index);
		
		// Create Path DS List with Edge Data
		var temp_same_edge_return_list = ds_list_create();
		ds_list_add(temp_same_edge_return_list, { position_x: temp_start_edge_data.return_x, position_y: temp_start_edge_data.return_y, edge_id: temp_start_edge_data.edge_id, edge_type: temp_same_edge_type });
		ds_list_add(temp_same_edge_return_list, { position_x: temp_end_edge_data.return_x, position_y: temp_end_edge_data.return_y, edge_id: temp_end_edge_data.edge_id, edge_type: temp_same_edge_type });
		
		// Return Same Edge Path DS List
		return temp_same_edge_return_list;
	}
	
	// Find Start and End Edge IDs
	var temp_start_edge_index = ds_map_find_value(GameManager.pathfinding_edge_ids_map, temp_start_edge_data.edge_id);
	var temp_end_edge_index = ds_map_find_value(GameManager.pathfinding_edge_ids_map, temp_end_edge_data.edge_id);
	
	// Create Node Path using Arbitrary Nodes
	var temp_start_edge_nodes = ds_list_find_value(GameManager.pathfinding_edge_nodes_list, temp_start_edge_index);
	var temp_end_edge_nodes = ds_list_find_value(GameManager.pathfinding_edge_nodes_list, temp_end_edge_index);
	
	var temp_path_nodes = pathfinding_recursive(temp_start_edge_nodes.first_node_id, temp_end_edge_nodes.first_node_id);
	
	// Check if Node Path is Viable
	if (is_undefined(temp_path_nodes)) 
	{
		// Node Path does not Exist
		return undefined;
	}
	
	// Remove Arbitrary Start Node
	var temp_path_first_node_id = ds_list_find_value(temp_path_nodes, 0);
	var temp_path_second_node_id = ds_list_find_value(temp_path_nodes, 1);
	var temp_path_first_second_node_edge_id = pathfinding_generate_edge_id(temp_path_first_node_id, temp_path_second_node_id);
	
	if (temp_start_edge_data.edge_id == temp_path_first_second_node_edge_id)
	{
		ds_list_delete(temp_path_nodes, 0);
	}
	
	// Remove Arbitrary End Node
	var temp_path_last_node_id = ds_list_find_value(temp_path_nodes, ds_list_size(temp_path_nodes) - 1);
	var temp_path_second_to_last_node_id = ds_list_find_value(temp_path_nodes, ds_list_size(temp_path_nodes) - 2);
	var temp_path_last_second_to_last_node_edge_id = pathfinding_generate_edge_id(temp_path_last_node_id, temp_path_second_to_last_node_id);
	
	if (temp_end_edge_data.edge_id == temp_path_last_second_to_last_node_edge_id)
	{
		ds_list_delete(temp_path_nodes, ds_list_size(temp_path_nodes) - 1);
	}
	
	// Create Pathfinding Path
	var temp_path = ds_list_create();
	
	// Add Start Position, Edge ID, and Edge Type
	var temp_start_edge_type = ds_list_find_value(GameManager.pathfinding_edge_types_list, temp_start_edge_index);
	ds_list_add(temp_path, { position_x: temp_start_edge_data.return_x, position_y: temp_start_edge_data.return_y, edge_id: temp_start_edge_data.edge_id, edge_type: temp_start_edge_type });
	
	// Add First Node Position, Edge ID, and Edge Type
	var temp_first_node_id = ds_list_find_value(temp_path_nodes, 0);
	var temp_first_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_first_node_id);
	var temp_first_node_struct = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_first_node_index);
	
	ds_list_add(temp_path, { position_x: temp_first_node_struct.anchor_position_x, position_y: temp_first_node_struct.anchor_position_y, edge_id: temp_start_edge_data.edge_id, edge_type: temp_start_edge_type });
	
	// Iterate through Node Path to create Cleaned Up and "detail rich" Pathfinding Path
	var temp_path_node_index = 1;
	
	repeat(ds_list_size(temp_path_nodes) - 1)
	{
		// Find Path Node IDs
		var temp_node_a_id = ds_list_find_value(temp_path_nodes, temp_path_node_index - 1);
		var temp_node_b_id = ds_list_find_value(temp_path_nodes, temp_path_node_index);
		
		// Find Path Node Index
		var temp_node_b_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_node_b_id);
		
		// Find Path Node Struct
		var temp_node_b_struct = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_node_b_index);
		
		// Find Path Edge ID
		var temp_path_edge_id = pathfinding_generate_edge_id(temp_node_a_id, temp_node_b_id);
		
		// Find Path Edge Index
		var temp_path_edge_index = ds_map_find_value(GameManager.pathfinding_edge_ids_map, temp_path_edge_id);
		
		// Find Path Edge Type
		var temp_path_edge_type = ds_list_find_value(GameManager.pathfinding_edge_types_list, temp_path_edge_index);
		
		// Index Pathfinding Data
		ds_list_add(temp_path, { position_x: temp_node_b_struct.anchor_position_x, position_y: temp_node_b_struct.anchor_position_y, edge_id: temp_path_edge_id, edge_type: temp_path_edge_type });
		
		// Increment Index
		temp_path_node_index++;
	}
	
	// Add End Position, Edge ID, and Edge Type
	var temp_end_edge_type = ds_list_find_value(GameManager.pathfinding_edge_types_list, temp_end_edge_index);
	ds_list_add(temp_path, { position_x: temp_end_edge_data.return_x, position_y: temp_end_edge_data.return_y, edge_id: temp_end_edge_data.edge_id, edge_type: temp_end_edge_type });
	
	// Destroy Node Path
	ds_list_destroy(temp_path_nodes);
	temp_path_nodes = -1;
	
	// Return Finalized Pathfinding Path
	return temp_path;
}

function pathfinding_save_level_data()
{
	// Establish Level File Directory
	var temp_level_file_directory = $"{GameManager.data_directory}Levels\\{room_get_name(room)}\\";
	
	// Create Level File Directory
	if (!directory_exists(temp_level_file_directory))
	{
	    directory_create(temp_level_file_directory);
	}
	
	// Create Pathfinding File Data
	var temp_pathfinding_data = $"// Pathfinding Level Data - Level: \"{room_get_name(room)}\"";
	
	// Add Nodes to Pathfinding File Data
	temp_pathfinding_data += "\n\n// Node Data";
	
	for (var temp_node_id = ds_map_find_first(GameManager.pathfinding_node_ids_map); !is_undefined(temp_node_id); temp_node_id = ds_map_find_next(GameManager.pathfinding_node_ids_map, temp_node_id)) 
	{
		// Find Node Index
		var temp_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_node_id);
		
		// Check if Node Exists
		if (!ds_list_find_value(GameManager.pathfinding_node_exists_list, temp_node_index))
		{
			continue;
		}
		
		// Find Node Data
		var temp_node_struct = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_node_index);
		
		// Add Node Data
		temp_pathfinding_data += $"\n[Node]\{node_id: {string(temp_node_id)}, node_position_x: {temp_node_struct.node_position_x}, node_position_y: {temp_node_struct.node_position_y}\}";
	}
	
	// Add Space
	temp_pathfinding_data += "\n\n// Edge Data";
	
	// Add Edges to Pathfinding File Data
	for (var temp_edge_index = 0; temp_edge_index < ds_list_size(GameManager.pathfinding_edge_exists_list); temp_edge_index++)
	{
		// Check if Edge Exists
		if (!ds_list_find_value(GameManager.pathfinding_edge_exists_list, temp_edge_index))
		{
			continue;
		}
		
		// Find Edge Nodes
		var temp_edge_nodes = ds_list_find_value(GameManager.pathfinding_edge_nodes_list, temp_edge_index);
		
		// Find Edge Type
		var temp_edge_type = ds_list_find_value(GameManager.pathfinding_edge_types_list, temp_edge_index);
		var temp_edge_type_as_string = "";
		
		switch (temp_edge_type)
		{
			case PathfindingEdgeType.JumpEdge:
				temp_edge_type_as_string = "Jump";
				break;
			case PathfindingEdgeType.TeleportEdge:
				temp_edge_type_as_string = "Teleport";
				break;
			default:
				temp_edge_type_as_string = "Default";
				break;
		}
		
		// Find Edge Weight
		var temp_edge_weights = ds_list_find_value(GameManager.pathfinding_edge_weights_list, temp_edge_index);
		
		// Add Edge Data
		temp_pathfinding_data += $"\n[Edge]\{first_node_id: {temp_edge_nodes.first_node_id}, second_node_id: {temp_edge_nodes.second_node_id}, edge_type: {temp_edge_type_as_string}\}";
	}
	
	temp_pathfinding_data += "\n";

	// Write Pathfinding File Data to File
	var temp_pathfinding_data_file = file_text_open_write($"{temp_level_file_directory}pathfinding_data.txt");
	file_text_write_string(temp_pathfinding_data_file, temp_pathfinding_data);
	file_text_close(temp_pathfinding_data_file);
}

function pathfinding_load_level_data()
{
	// Check if Pathfinding Level File Exists
	var temp_level_file_directory = $"{GameManager.data_directory}Levels\\{room_get_name(room)}\\";
	var temp_level_file_path = $"{temp_level_file_directory}pathfinding_data.txt";
	
	if (!directory_exists(temp_level_file_directory) or !file_exists(temp_level_file_path))
	{
	    show_debug_message($"Failed to read Pathfinding Level Data File - Missing File at \"{temp_level_file_path}\"");
	}
	
	// Open Pathfinding File
	var temp_pathfinding_data_file = file_text_open_read(temp_level_file_path);
	
	// Iterate and read through Pathfinding Level Data File
	var temp_pathfinding_data_line_index = 0;
	
	while (!file_text_eof(temp_pathfinding_data_file))
	{
		// Load Pathfinding Data Line by Line
	    var temp_pathfinding_data_line = file_text_readln(temp_pathfinding_data_file);
	    
	    // Clean Pathfinding Data Line of Whitespace Characters
	    temp_pathfinding_data_line = string_replace_all(temp_pathfinding_data_line, " ", "");
	    temp_pathfinding_data_line = string_replace_all(temp_pathfinding_data_line, "\t", "");
	    temp_pathfinding_data_line = string_replace_all(temp_pathfinding_data_line, "\n", "");
	    temp_pathfinding_data_line = string_replace_all(temp_pathfinding_data_line, "\r", "");
	    temp_pathfinding_data_line = string_replace_all(temp_pathfinding_data_line, "\f", "");
	    temp_pathfinding_data_line = string_replace_all(temp_pathfinding_data_line, "\v", "");
	    
	    // Remove Comments
	    var temp_comment_index = string_pos("//", temp_pathfinding_data_line);
	    
	    if (temp_comment_index != 0)
	    {
	    	temp_pathfinding_data_line = string_delete(temp_pathfinding_data_line, temp_comment_index, string_length(temp_pathfinding_data_line) - temp_comment_index + 1);
	    }
	    
	    // Check if Pathfinding Data is Node or Edge
	    var temp_pathfinding_data_type_start_index = string_pos("[", temp_pathfinding_data_line);
	    var temp_pathfinding_data_type_end_index = string_pos("]", temp_pathfinding_data_line);
	    
	    if (temp_pathfinding_data_type_start_index == 0 or temp_pathfinding_data_type_end_index == 0 or temp_pathfinding_data_type_end_index < temp_pathfinding_data_type_start_index)
	    {
	    	continue;
	    }
	    
	    var temp_pathfinding_data_type = string_copy(temp_pathfinding_data_line, temp_pathfinding_data_type_start_index + 1, temp_pathfinding_data_type_end_index - temp_pathfinding_data_type_start_index - 1);
	    
	    // Clean Pathfinding Data
	    var temp_pathfinding_data_start_index = string_pos("{", temp_pathfinding_data_line);
	    var temp_pathfinding_data_end_index = string_last_pos("}", temp_pathfinding_data_line);
	    
	    if (temp_pathfinding_data_start_index == 0 or temp_pathfinding_data_end_index == 0 or temp_pathfinding_data_end_index < temp_pathfinding_data_start_index)
	    {
	    	continue;
	    }
	    
	    var temp_pathfinding_data_raw = string_copy(temp_pathfinding_data_line, temp_pathfinding_data_start_index + 1, temp_pathfinding_data_end_index - temp_pathfinding_data_start_index - 1);
	    var temp_pathfinding_data_split = string_split(temp_pathfinding_data_raw, ",");
	    
	    // Use Pathfinding Type & Data to populate Level's Pathfinding Map
	    switch (temp_pathfinding_data_type)
	    {
	    	case "Node":
	    		// Establish Node Data
	    		var temp_node_id = undefined;
	    		var temp_node_position_x = undefined;
	    		var temp_node_position_y = undefined;
	    		
	    		// Parse Node Data
	    		for (var temp_node_data_index = 0; temp_node_data_index < array_length(temp_pathfinding_data_split); temp_node_data_index++)
	    		{
	    			// Find Colon
	    			var temp_colon_index = string_pos(":", temp_pathfinding_data_split[temp_node_data_index]);
	    			
	    			// Set Node Data
	    			if (temp_colon_index != 0)
	    			{
	    				// Seperate Node Data Type and Node Data Value
	    				var temp_node_data_type = string_copy(temp_pathfinding_data_split[temp_node_data_index], 1, temp_colon_index - 1);
	    				var temp_node_data_value = string_copy(temp_pathfinding_data_split[temp_node_data_index], temp_colon_index + 1, string_length(temp_pathfinding_data_split[temp_node_data_index]) - temp_colon_index);
	    				
	    				// Check Node Data Type and set according Node Data Value
	    				switch (temp_node_data_type)
	    				{
	    					case "node_id":
	    						temp_node_id = (string_digits(temp_node_data_value) == temp_node_data_value) ? int64(temp_node_data_value) : temp_node_data_value;
	    						break;
    						case "node_position_x":
    							temp_node_position_x = real(temp_node_data_value);
	    						break;
    						case "node_position_y":
    							temp_node_position_y = real(temp_node_data_value);
	    						break;
    						default:
    							show_debug_message($"Unsupported Node Data Type found while reading Pathfinding Level Data - Unsupported Node Data Type \"{temp_node_data_type}\"");
    							break;
	    				}
	    			}
	    		}
	    		
	    		// Check if Node Data is Valid
    			if (!is_undefined(temp_node_id) and !is_undefined(temp_node_position_x) and !is_undefined(temp_node_position_y))
    			{
    				pathfinding_add_node(temp_node_position_x, temp_node_position_y, temp_node_id);
    			}
    			else
    			{
    				show_debug_message($"Incomplete or Malformed Node Data found while reading Pathfinding Level Data - Invalid Node Data in File at \"{temp_level_file_path}\" at line #{temp_pathfinding_data_line_index}");
    			}
	    		break;
    		case "Edge":
    			// Establish Edge Data
    			var temp_edge_first_node_id = undefined;
	    		var temp_edge_second_node_id = undefined;
	    		var temp_edge_type = undefined;
    			
    			// Parse Edge Data
    			for (var temp_edge_data_index = 0; temp_edge_data_index < array_length(temp_pathfinding_data_split); temp_edge_data_index++)
	    		{
	    			// Find Colon
	    			var temp_colon_index = string_pos(":", temp_pathfinding_data_split[temp_edge_data_index]);
	    			
	    			// Set Edge Data
	    			if (temp_colon_index != 0)
	    			{
	    				// Seperate Edge Data Type and Edge Data Value
	    				var temp_edge_data_type = string_copy(temp_pathfinding_data_split[temp_edge_data_index], 1, temp_colon_index - 1);
	    				var temp_edge_data_value = string_copy(temp_pathfinding_data_split[temp_edge_data_index], temp_colon_index + 1, string_length(temp_pathfinding_data_split[temp_edge_data_index]) - temp_colon_index);
	    				
	    				// Check Edge Data Type and set according Edge Data Value
	    				switch (temp_edge_data_type)
	    				{
	    					case "first_node_id":
	    						temp_edge_first_node_id = (string_digits(temp_edge_data_value) == temp_edge_data_value) ? int64(temp_edge_data_value) : temp_edge_data_value;
	    						break;
    						case "second_node_id":
    							temp_edge_second_node_id = (string_digits(temp_edge_data_value) == temp_edge_data_value) ? int64(temp_edge_data_value) : temp_edge_data_value;
	    						break;
    						case "edge_type":
    							switch (temp_edge_data_value)
								{
									case "Jump":
										temp_edge_type = PathfindingEdgeType.JumpEdge;
										break;
									case "Teleport":
										temp_edge_type = PathfindingEdgeType.TeleportEdge;
										break;
									default:
										temp_edge_type = PathfindingEdgeType.DefaultEdge;
										break;
								}
	    						break;
    						default:
    							show_debug_message($"Unsupported Edge Data Type found while reading Pathfinding Level Data - Unsupported Edge Data Type \"{temp_node_data_type}\"");
    							break;
	    				}
	    			}
	    		}
	    		
	    		// Check if Edge Data is Valid
    			if (!is_undefined(temp_edge_first_node_id) and !is_undefined(temp_edge_second_node_id) and !is_undefined(temp_edge_type))
    			{
    				pathfinding_add_edge(temp_edge_first_node_id, temp_edge_second_node_id, temp_edge_type);
    			}
    			else
    			{
    				show_debug_message($"Incomplete or Malformed Node Data found while reading Pathfinding Level Data - Invalid Node Data in File at \"{temp_level_file_path}\" at line #{temp_pathfinding_data_line_index}");
    			}
    			break;
			default:
				show_debug_message($"Unsupported Pathfinding Data Type found while reading Pathfinding Level Data - Unsupported Pathfinding Data Type \"{temp_pathfinding_data_raw}\"");
				break;
	    }
	    
	    // Increment Pathfinding Line Number
	    temp_pathfinding_data_line_index++;
	}
	
	// Close Pathfinding File
	file_text_close(temp_pathfinding_data_file);
}
