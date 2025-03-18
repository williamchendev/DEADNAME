/// @description Insert description here
// You can write your code in this editor

pathfinding_load_level_data();

for (var temp_node_id = ds_map_find_first(GameManager.pathfinding_node_ids_map); !is_undefined(temp_node_id); temp_node_id = ds_map_find_next(GameManager.pathfinding_node_ids_map, temp_node_id)) 
{
	// Find Node Index
	var temp_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_node_id);
	
	// Find Node Data
	var temp_node_struct = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_node_index);
	
	// Add Node Data
	show_debug_message($"Node_ID:{temp_node_id}, Node_X:{temp_node_struct.node_position_x}, Node_Y:{temp_node_struct.node_position_y}");
}

for (var temp_edge_id = ds_map_find_first(GameManager.pathfinding_edge_ids_map); !is_undefined(temp_edge_id); temp_edge_id = ds_map_find_next(GameManager.pathfinding_edge_ids_map, temp_edge_id)) 
{
	// Find Edge Index
	var temp_edge_index = ds_map_find_value(GameManager.pathfinding_edge_ids_map, temp_edge_id);
	
	// Add Node Data
	show_debug_message($"Edge_ID:{temp_edge_id}, Edge_Type:{ds_list_find_value(GameManager.pathfinding_edge_types_list, temp_edge_index)}");
}
