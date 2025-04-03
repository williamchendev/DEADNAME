/// @description Insert description here
// You can write your code in this editor

// Check if Scene Type is a Platformer
switch (scene_get_type())
{
	case SceneType.Platformer:
		// Ignore Self-Destruct - Scene is a Platformer Level & needs Squad Director
		break;
	case SceneType.Title:
	case SceneType.WorldMap:
	default:
		// Destroy Instance and Exit Behaviour
		instance_destroy();
		return;
		break;
}