/// @description Insert description here
// You can write your code in this editor

var temp_array = array_create(0);

for (var i = 0; i < 20; i++)
{
	var node_id;
	
	while (true)
	{
		node_id = irandom(50000) + 600000;
		if (!array_contains(temp_array, node_id))
		{
			break;
		}
	}
	
	pathfinding_add_node(random_range(-500, 500), random_range(-500, 500), node_id);
	temp_array[array_length(temp_array)] = node_id;
}

for (var q = 0; q < 15; q++)
{
	pathfinding_add_edge(temp_array[irandom(array_length(temp_array) - 1)], temp_array[irandom(array_length(temp_array) - 1)], irandom(2) == 0 ? PathfindingEdgeType.JumpEdge : PathfindingEdgeType.DefaultEdge);
}

pathfinding_save_level_data();
