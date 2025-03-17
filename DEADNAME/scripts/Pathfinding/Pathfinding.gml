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
		// Generate New Pathfinding Node ID
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
		var temp_edge_id = (node_id < temp_edge_node_id) ? $"[{node_id}][{temp_edge_node_id}]" : $"[{temp_edge_node_id}][{node_id}]";
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
	var temp_edge_id = (first_node_id < second_node_id) ? $"[{first_node_id}][{second_node_id}]" : $"[{second_node_id}][{first_node_id}]";
	
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
	var temp_edge_id = (first_node_id < second_node_id) ? $"[{first_node_id}][{second_node_id}]" : $"[{second_node_id}][{first_node_id}]";
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
	var temp_edge_id = (first_node_id < second_node_id) ? $"[{first_node_id}][{second_node_id}]" : $"[{second_node_id}][{first_node_id}]";
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
	
	repeat (ds_list_size(path_list) - 2)
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
/// @returns {struct} A struct with the X coordinate [struct.return_x] and Y coordinate [struct.return_y] and the Edge id it exists on [struct.edge_id]
function pathfinder_get_closest_point_on_edge(x_position, y_position)
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
				temp_position_edge = (temp_edge_nodes.first_node_id < temp_edge_nodes.second_node_id) ? $"[{temp_edge_nodes.first_node_id}][{temp_edge_nodes.second_node_id}]" : $"[{temp_edge_nodes.second_node_id}][{temp_edge_nodes.first_node_id}]";
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
/// @returns 
function pathfinding_get_path(start_x_position, start_y_position, end_x_position, end_y_position)
{
	// Find Edge Data for Start and End Coordinates
	var temp_start_edge_data = pathfinder_get_closest_point_on_edge(start_x_position, start_y_position);
	var temp_end_edge_data = pathfinder_get_closest_point_on_edge(end_x_position, end_y_position);
	
	// Check if Edge Data is Viable
	if (is_undefined(temp_start_edge_data.edge_id) or is_undefined(temp_end_edge_data.edge_id)) 
	{
		// Edges Don't Exist
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
	
	// Remove Arbitrary Start Node
	var temp_path_first_node_id = ds_list_find_value(temp_path_nodes, 0);
	var temp_path_second_node_id = ds_list_find_value(temp_path_nodes, 1);
	var temp_path_first_second_node_edge_id = (temp_path_first_node_id < temp_path_second_node_id) ? $"[{temp_path_first_node_id}][{temp_path_second_node_id}]" : $"[{temp_path_second_node_id}][{temp_path_first_node_id}]";
	
	if (temp_start_edge_data.edge_id == temp_path_first_second_node_edge_id)
	{
		ds_list_delete(temp_path_nodes, 0);
	}
	
	// Remove Arbitrary End Node
	var temp_path_last_node_id = ds_list_find_value(temp_path_nodes, ds_list_size(temp_path_nodes) - 1);
	var temp_path_second_to_last_node_id = ds_list_find_value(temp_path_nodes, ds_list_size(temp_path_nodes) - 2);
	var temp_path_last_second_to_last_node_edge_id = (temp_path_last_node_id < temp_path_second_to_last_node_id) ? $"[{temp_path_last_node_id}][{temp_path_second_to_last_node_id}]" : $"[{temp_path_second_to_last_node_id}][{temp_path_last_node_id}]";
	
	if (temp_end_edge_data.edge_id == temp_path_last_second_to_last_node_edge_id)
	{
		ds_list_delete(temp_path_nodes, ds_list_size(temp_path_nodes) - 1);
	}
	
	// Iterate through Node Path to create Cleaned Up and "detail rich" Pathfinding Path
	
}

/*

/// pathfind_get_path(start_x_position, start_y_position, end_x_position, end_y_position);



// Establish Variables
#args temp_start_x
var temp_start_y = argument1;

var temp_end_x = argument2;
var temp_end_y = argument3;

// Find Edge Data for Start and End Coordinates
var temp_start_edge_data = pathfind_get_closest_point(temp_start_x, temp_start_y);
var temp_end_edge_data = pathfind_get_closest_point(temp_end_x, temp_end_y);

// Check if Edge Data is Viable
if (temp_start_edge_data[2] == noone or temp_start_edge_data[2] == noone) {
	// Edges Don't Exist
	return noone;
}

if (temp_start_edge_data[2] == temp_end_edge_data[2]) {
	// Same Edge
	var temp_early_return = noone;
	temp_early_return[0, 0] = temp_start_edge_data[2];
	temp_early_return[0, 1] = temp_start_edge_data[0];
	temp_early_return[0, 2] = temp_start_edge_data[1];
	temp_early_return[1, 0] = temp_end_edge_data[2];
	temp_early_return[1, 1] = temp_end_edge_data[0];
	temp_early_return[1, 2] = temp_end_edge_data[1];
	return temp_early_return;
}

// Find Nearest Nodes
var temp_start_node = temp_start_edge_data[2].nodes[0];
var temp_start_node_a_distance = point_distance(temp_start_x, temp_start_y, temp_start_edge_data[2].nodes[0].x, temp_start_edge_data[2].nodes[0].y);
var temp_start_node_b_distance = point_distance(temp_start_x, temp_start_y, temp_start_edge_data[2].nodes[1].x, temp_start_edge_data[2].nodes[1].y);
if (temp_start_node_b_distance < temp_start_node_a_distance) {
	temp_start_node = temp_start_edge_data[2].nodes[1];
}

var temp_end_node = temp_end_edge_data[2].nodes[0];
var temp_end_node_a_distance = point_distance(temp_end_x, temp_end_y, temp_end_edge_data[2].nodes[0].x, temp_end_edge_data[2].nodes[0].y);
var temp_end_node_b_distance = point_distance(temp_end_x, temp_end_y, temp_end_edge_data[2].nodes[1].x, temp_end_edge_data[2].nodes[1].y);
if (temp_end_node_b_distance < temp_end_node_a_distance) {
	temp_end_node = temp_end_edge_data[2].nodes[1];
}

// Establish Path
var temp_path_array = pathfind_recursive(noone, temp_start_node, temp_end_node);

// Clean Path
if (array_length_1d(temp_path_array) > 1) {
	var temp_remove_first_index = 0;
	if (temp_path_array[0] == temp_start_edge_data[2].nodes[0]) {
		if (temp_path_array[1] == temp_start_edge_data[2].nodes[1]) {
			temp_remove_first_index = 1;
		}
	}
	else if (temp_path_array[0] == temp_start_edge_data[2].nodes[1]) {
		if (temp_path_array[1] == temp_start_edge_data[2].nodes[0]) {
			temp_remove_first_index = 1;
		}
	}
	
	var temp_remove_last_index = array_length_1d(temp_path_array);
	if (temp_path_array[array_length_1d(temp_path_array) - 1] == temp_end_edge_data[2].nodes[0]) {
		if (temp_path_array[array_length_1d(temp_path_array) - 2] == temp_end_edge_data[2].nodes[1]) {
			temp_remove_last_index = array_length_1d(temp_path_array) - 1;
		}
	}
	else if (temp_path_array[array_length_1d(temp_path_array) - 1] == temp_end_edge_data[2].nodes[1]) {
		if (temp_path_array[array_length_1d(temp_path_array) - 2] == temp_end_edge_data[2].nodes[0]) {
			temp_remove_last_index = array_length_1d(temp_path_array) - 1;
		}
	}
	
	var temp_cutoff_index = 0;
	var temp_cutoff_array = noone;
	for (var q = temp_remove_first_index; q < temp_remove_last_index; q++) {
		temp_cutoff_array[temp_cutoff_index] = temp_path_array[q];
		temp_cutoff_index++;
	}
	
	temp_path_array = temp_cutoff_array;
}

// Assemble Path Data
var temp_return = noone;
temp_return[0, 0] = temp_start_edge_data[2];
temp_return[0, 1] = temp_start_edge_data[0];
temp_return[0, 2] = temp_start_edge_data[1];

for (var k = 0; k < array_length_1d(temp_path_array); k++) {
	var temp_array_height = array_height_2d(temp_return);
	temp_return[temp_array_height, 0] = temp_path_array[k];
	temp_return[temp_array_height, 1] = temp_path_array[k].x_position;
	temp_return[temp_array_height, 2] = temp_path_array[k].y_position;
}

var temp_array_height_again = array_height_2d(temp_return);
temp_return[temp_array_height_again, 0] = temp_end_edge_data[2];
temp_return[temp_array_height_again, 1] = temp_end_edge_data[0];
temp_return[temp_array_height_again, 2] = temp_end_edge_data[1];

return temp_return;