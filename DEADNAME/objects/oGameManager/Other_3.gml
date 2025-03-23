/// @description Game End Cleanup Event
// Destroy and Cleanup GameManager's Pathfinding Maps & Lists

// Cleanup Pathfinding Node DS Map & Lists
ds_map_destroy(pathfinding_node_ids_map);
pathfinding_node_ids_map = -1;

ds_list_destroy(pathfinding_node_exists_list);
pathfinding_node_exists_list = -1;

ds_list_destroy(pathfinding_node_edges_list);
pathfinding_node_edges_list = -1;

ds_list_destroy(pathfinding_node_struct_list);
pathfinding_node_struct_list = -1;

ds_list_destroy(pathfinding_node_name_list);
pathfinding_node_name_list = -1;

ds_list_destroy(pathfinding_node_deleted_indexes_list);
pathfinding_node_deleted_indexes_list = -1;

// Cleanup Pathfinding Edge DS Map & Lists
ds_map_destroy(pathfinding_edge_ids_map);
pathfinding_edge_ids_map = -1;

ds_list_destroy(pathfinding_edge_exists_list);
pathfinding_edge_exists_list = -1;

ds_list_destroy(pathfinding_edge_nodes_list);
pathfinding_edge_nodes_list = -1;

ds_list_destroy(pathfinding_edge_types_list);
pathfinding_edge_types_list = -1;

ds_list_destroy(pathfinding_edge_weights_list);
pathfinding_edge_weights_list = -1;

ds_list_destroy(pathfinding_edge_name_list);
pathfinding_edge_name_list = -1;

ds_list_destroy(pathfinding_edge_deleted_indexes_list);
pathfinding_edge_deleted_indexes_list = -1;