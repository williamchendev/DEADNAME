/// @description Game End Cleanup Event
// Destroy and Cleanup GameManager's Pathfinding Lists

// Cleanup Pathfinding DS Lists
ds_list_destroy(pathfinding_nodes_list);
pathfinding_nodes_list = -1;

ds_list_destroy(pathfinding_node_ids_list);
pathfinding_node_ids_list = -1;

ds_list_destroy(pathfinding_edges_list);
pathfinding_edges_list = -1;

ds_list_destroy(pathfinding_edges_types_list);
pathfinding_edges_types_list = -1;