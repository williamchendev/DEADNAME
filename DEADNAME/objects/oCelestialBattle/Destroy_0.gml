/// @description Battle Destroy Event
// Celestial Battle Destroy Behaviour Event

// Check if Celestial Body Instance exists
if (instance_exists(celestial_body_instance))
{
	// Remove Celestial Battle Instance from Celestial Body's Battles Array
	var temp_battle_index = array_get_index(celestial_body_instance.battles, id);
	
	if (temp_battle_index != -1)
	{
		array_delete(celestial_body_instance.battles, temp_battle_index, 1);
	}
	
	// Check if Celestial Battle Instance needs to be de-indexed from Celestial Body's Pathfinding Navigation Mesh
	if (celestial_body_instance.pathfinding_enabled)
	{
		// Create Celestial Battle Pathfinding Nodes Key
		var temp_battle_pathfinding_nodes_key = $"{min(pathfinding_node_a_index, pathfinding_node_b_index)}:{max(pathfinding_node_a_index, pathfinding_node_b_index)}";
		
		// Check if Celestial Battle was indexed in the Celestial Body's Pathfinding Navigation Mesh Battles DS Map
		if (ds_map_exists(celestial_body_instance.pathfinding_node_battles_map, temp_battle_pathfinding_nodes_key))
		{
			ds_map_delete(celestial_body_instance.pathfinding_node_battles_map, temp_battle_pathfinding_nodes_key);
		}
	}
	
	// Delete Unused Arrays
	var temp_factions_count = array_length(battle_factions);
	var temp_factions_index = temp_factions_count - 1;
	
	repeat (temp_factions_count)
	{
		// Resize and Delete Faction Units Array
		array_resize(battle_units[temp_factions_index], 0);
		array_delete(battle_units, temp_factions_index, 1);
		
		// Decrement Factions Index
		temp_factions_index--;
	}
	
	array_resize(battle_factions, 0);
	array_resize(battle_units, 0);
}
