/// @description Room Start Init Event
// Sets up Pathfinding Maps & Lists for the current Room

// Check if Room is Start Screen
if (room_get_name(room) == "_TitleScreen")
{
	return;
}

// Load Pathfinding Node and Edge Data from File int GameManager's Pathfinding DS Maps & Lists
pathfinding_load_level_data();
