enum PathfindingEdgeType
{
	DefaultEdge,
	JumpEdge,
	TeleportEdge
}

/// pathfinding_add_node(node_position_x, node_position_y, node_edges, node_id);
function pathfinding_add_node(node_position_x, node_position_y, node_id = undefined)
{
	// Create Unique Pathfinding Node ID
	var temp_node_id = is_undefined(node_id) ? "" : node_id;
	var temp_node_id_found = !is_undefined(node_id) and ds_list_find_index(GameManager.pathfinding_node_ids_list, node_id) == -1;
	
	while (!temp_node_id_found)
	{
		// Generate New Pathfinding Node ID
		var temp_generated_node_id = pathfinding_generate_node_id();
		
		// Check if Generated Node ID already exists
		if (ds_list_find_index(GameManager.pathfinding_node_ids_list, temp_generated_node_id) == -1)
		{
			// Node ID is valid
			temp_node_id_found = true;
			temp_node_id = temp_generated_node_id;
			break;
		}
	}
	
	// Add New Pathfinding Node to Pathfinding DS Lists
	ds_list_add(GameManager.pathfinding_nodes_list, { position_x: node_position_x, position_y: node_position_y });
	ds_list_add(GameManager.pathfinding_node_ids_list, temp_node_id);
	ds_list_add_list(GameManager.pathfinding_edges_list, ds_list_create());
	ds_list_add_list(GameManager.pathfinding_edges_types_list, ds_list_create());
}

function pathfinding_remove_node(node_id)
{
	// Check if Node Exists
	var temp_node_index = ds_list_find_index(GameManager.pathfinding_node_ids_list, node_id);
	
	if (temp_node_index == -1)
	{
		// Node is missing or Invalid - Early Return
		return;
	}
	
	// Find Pathfinding Node Indexes
	var temp_node_edges_list = ds_list_find_value(GameManager.pathfinding_edges_list, temp_node_index);
	var temp_node_edges_types_list = ds_list_find_value(GameManager.pathfinding_edges_types_list, temp_node_index);
	
	for (var i = 0; i < ds_list_size(temp_node_edges_list); i++)
	{
		var temp_edge_node_id = ds_list_find_value(temp_node_edges_list, i);
		var temp_edge_node_index = ds_list_find_index(GameManager.pathfinding_node_ids_list, temp_edge_node_id);
		
		if (temp_edge_node_index != -1)
		{
			var temp_edge_node_edges_list = ds_list_find_value(GameManager.pathfinding_edges_list, temp_edge_node_index);
			var temp_edge_node_edges_types_list = ds_list_find_value(GameManager.pathfinding_edges_types_list, temp_edge_node_index);
			var temp_node_within_edge_node_edges_list_index = ds_list_find_index(temp_edge_node_edges_list, node_id);
			
			if (temp_node_within_edge_node_edges_list_index != -1)
			{
				// Delete Edges that contain this Node
				ds_list_delete(temp_edge_node_edges_list, temp_node_within_edge_node_edges_list_index);
				ds_list_delete(temp_edge_node_edges_types_list, temp_node_within_edge_node_edges_list_index);
			}
		}
	}
	
	// Delete Indexes of Node
	ds_list_delete(GameManager.pathfinding_nodes_list, temp_node_index);
	ds_list_delete(GameManager.pathfinding_node_ids_list, temp_node_index);
	ds_list_delete(GameManager.pathfinding_edges_list, temp_node_index);
	ds_list_delete(GameManager.pathfinding_edges_types_list, temp_node_index);
	
	// Destroy DS Lists
	ds_list_destroy(temp_node_edges_list);
	ds_list_destroy(temp_node_edges_types_list);
}

function pathfinding_generate_node_id(possible_characters = "0123456789ABCDEF", limit = 8)
{
	var temp_return_id = "Node_";
	
	repeat (limit)
	{
		temp_return_id = $"{temp_return_id}{string_char_at(possible_characters, random(string_length(possible_characters) - 1))}";
	}
	
	return temp_return_id;
}

/// pathfinding_add_edge(first_node_id, second_node_id, edge_type);
function pathfinding_add_edge(first_node_id, second_node_id, edge_type)
{
	// Check if both Nodes Exist
	var temp_first_node_index = ds_list_find_index(GameManager.pathfinding_node_ids_list, first_node_id);
	var temp_second_node_index = ds_list_find_index(GameManager.pathfinding_node_ids_list, second_node_id);
	
	if (temp_first_node_index == -1 or temp_second_node_index == -1)
	{
		// One or More Node is missing or Invalid - Early Return
		return;
	}
	
	// Add Pathfinding Edge to both Nodes
	ds_list_add(ds_list_find_value(GameManager.pathfinding_edges_list, temp_first_node_index), second_node_id);
	ds_list_add(ds_list_find_value(GameManager.pathfinding_edges_types_list, temp_first_node_index), edge_type);
	ds_list_add(ds_list_find_value(GameManager.pathfinding_edges_list, temp_second_node_index), first_node_id);
	ds_list_add(ds_list_find_value(GameManager.pathfinding_edges_types_list, temp_second_node_index), edge_type);
}

/// pathfinding_remove_edge(first_node_id, second_node_id);
function pathfinding_remove_edge(first_node_id, second_node_id)
{
	// Check if both Nodes Exist
	var temp_first_node_index = ds_list_find_index(GameManager.pathfinding_node_ids_list, first_node_id);
	var temp_second_node_index = ds_list_find_index(GameManager.pathfinding_node_ids_list, second_node_id);
	
	if (temp_first_node_index == -1 or temp_second_node_index == -1)
	{
		// One or More Node is missing or Invalid - Early Return
		return;
	}
	
	// Find Pathfinding Edge DS Lists and Indexes
	var temp_first_node_edges_list = ds_list_find_value(GameManager.pathfinding_edges_list, temp_first_node_index);
	var temp_second_node_edges_list = ds_list_find_value(GameManager.pathfinding_edges_list, temp_second_node_index);
	
	var temp_first_node_edges_types_list = ds_list_find_value(GameManager.pathfinding_edges_types_list, temp_first_node_index);
	var temp_second_node_edges_types_list = ds_list_find_value(GameManager.pathfinding_edges_types_list, temp_second_node_index);
	
	var temp_first_node_edge_index = ds_list_find_index(temp_first_node_edges_list, second_node_id);
	var temp_second_node_edge_index = ds_list_find_index(temp_second_node_edges_list, first_node_id);
	
	// Delete Pathfinding Edge Data from Pathfinding Node DS Lists
	ds_list_delete(temp_first_node_edges_list, temp_first_node_edge_index);
	ds_list_delete(temp_first_node_edges_types_list, temp_first_node_edge_index);
	
	ds_list_delete(temp_second_node_edges_list, temp_second_node_edge_index);
	ds_list_delete(temp_second_node_edges_types_list, temp_second_node_edge_index);
}

function pathfinding_recursive(path_array, start_node_id, end_node_id)
{
	
}

/// pathfinder_get_path(start_x_position, start_y_position, end_x_position, end_y_position);
/// @description Finds the path of least resistance between the start coordinate and the end coordinate
/// @param {real} start_x_position The X position in the world to start pathfinding from
/// @param {real} start_y_position The Y position in the world to start pathfinding from
/// @param {real} end_x_position The X position in the world to end the path at
/// @param {real} end_x_position The Y position in the world to end the path at
/// @returns {array} An array of nodes from the start coordinate to the end coordinate
function pathfinding_get_path()
{

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