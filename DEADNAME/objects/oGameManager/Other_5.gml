/// @description Room End Cleanup Event
// Reset GameManager's Pathfinding Maps & Lists and Set up for Next Room

// Reset Pathfinding Node DS Map & Lists
ds_map_clear(pathfinding_node_ids_map);

ds_list_clear(pathfinding_node_exists_list);
ds_list_clear(pathfinding_node_edges_list);
ds_list_clear(pathfinding_node_struct_list);

ds_list_clear(pathfinding_node_deleted_indexes_list);

// Reset Pathfinding Edge DS Map & Lists
ds_map_clear(pathfinding_edge_ids_map);

ds_list_clear(pathfinding_edge_exists_list);
ds_list_clear(pathfinding_edge_nodes_list);
ds_list_clear(pathfinding_edge_types_list);
ds_list_clear(pathfinding_edge_weights_list);

ds_list_clear(pathfinding_edge_deleted_indexes_list);