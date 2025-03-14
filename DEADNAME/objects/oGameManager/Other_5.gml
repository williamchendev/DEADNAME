/// @description Room End Cleanup Event
// Reset GameManager's Pathfinding Lists & Set up for Next Room

// Reset Pathfinding Node DS List
ds_list_clear(pathfinding_nodes_list);
ds_list_clear(pathfinding_node_ids_list);
ds_list_clear(pathfinding_edges_list);
ds_list_clear(pathfinding_edges_types_list);