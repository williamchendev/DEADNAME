/// @description Room End Cleanup Event
// Reset GameManager's Pathfinding Maps & Lists and Set up for Next Room

// Reset Player Unit
player_unit = undefined;

// Reset Pathfinding Node and Edge DS Maps & Lists
pathfinding_clear_level_data();

// Destroy Previous Squad Behaviour Director
if (!is_undefined(squad_behaviour_director))
{
	instance_destroy(squad_behaviour_director);
	squad_behaviour_director = undefined;
}

// Initialize Squad Behaviour Director
squad_behaviour_director = instance_create_depth(x, y, depth, oSquadBehaviour_Director);