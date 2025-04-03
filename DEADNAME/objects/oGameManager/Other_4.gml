/// @description Room Start Init Event
// Sets up Pathfinding Maps & Lists for the current Room

// Check Scene Type & Perform appropriate Scene Init Behaviour
switch (scene_get_type())
{
	case SceneType.Platformer:
		// Load Pathfinding Node and Edge Data from File int GameManager's Pathfinding DS Maps & Lists
		pathfinding_load_level_data();
		break;
	case SceneType.Title:
	case SceneType.WorldMap:
	default:
		break;
}
