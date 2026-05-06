

function celestial_battle_create_from_pathfinding_node(celestial_object, pathfinding_node_a_index, pathfinding_node_b_index) 
{
	// Check if Celestial Object has a Pathfinding Navigation Mesh
	if (!celestial_object.pathfinding_enabled)
	{
		// Celestial Object does not have a Pathfinding Navigation Mesh - Early Return
		return;
	}
	
	// Create new Celestial Battle Pathfinding Nodes Key
	var temp_battle_pathfinding_nodes_key = $"{min(pathfinding_node_a_index, pathfinding_node_b_index)}:{max(pathfinding_node_a_index, pathfinding_node_b_index)}";
	
	// Check if Pathfinding Nodes Key already exists
	if (ds_map_exists(celestial_object.pathfinding_node_battles_map, temp_battle_pathfinding_nodes_key))
	{
		// Celestial Battle already exists at the given Pathfinding Nodes - Early Return
		return;
	}
	
	// Create new Celestial Battle Instance
	var temp_celestial_battle_instance = instance_create_depth(0, 0, 0, oCelestialBattle);
	
	// Index Celestial Battle Instance in Celestial Object Battle Array
	array_push(celestial_object.battles, temp_celestial_battle_instance);
	
	// Index Celestial Battle in Celestial Object's Pathfinding Node Battles DS Map
	ds_map_set(celestial_object.pathfinding_node_battles_map, temp_battle_pathfinding_nodes_key, temp_celestial_battle_instance);
	
	// Iterate through Pathfinding Node A's Units Array
	var temp_pathfinding_node_a_units_array_index = 0;
	
	repeat (array_length(pathfinding_node_units_array[pathfinding_node_a_index]))
	{
		// Find Unit Instance from Pathfinding Node Units Array
		var temp_pathfinding_node_a_units_array_unit_instance = array_get(pathfinding_node_units_array[pathfinding_node_a_index], temp_pathfinding_node_a_units_array_index);
		
		// Check Unit Faction Index within Battle Instance
		var temp_pathfinding_node_a_unit_faction_index = array_get_index(temp_celestial_battle_instance.battle_factions, temp_pathfinding_node_a_units_array_unit_instance.unit_faction);
		
		// Check if Unit's Faction Instance was already indexed in Celestial Battle's Faction Array
		if (temp_pathfinding_node_a_unit_faction_index == -1)
		{
			// Find the index of the Unit's Faction Instance within the Celestial Battle's Faction Array
			temp_pathfinding_node_a_unit_faction_index = array_length(temp_celestial_battle_instance.battle_factions);
			
			// Index the Unit's Faction Instance within the Celestial Battle's Faction Array
			array_push(temp_celestial_battle_instance.battle_factions, temp_pathfinding_node_a_units_array_unit_instance.unit_faction);
		}
		
		// Index the Unit Instance within the Celestial Battle's Units Array
		array_push(temp_celestial_battle_instance.battle_units[temp_pathfinding_node_a_unit_faction_index], temp_pathfinding_node_a_units_array_unit_instance);
		
		// Increment Pathfinding Node Units Array Index
		temp_pathfinding_node_a_units_array_index++;
	}
	
	// Check if Pathfinding Node B's Index is different from Pathfinding Node A's Index
	if (pathfinding_node_a_index != pathfinding_node_b_index)
	{
		// Iterate through Pathfinding Node A's Units Array
		var temp_pathfinding_node_b_units_array_index = 0;
		
		repeat (array_length(pathfinding_node_units_array[pathfinding_node_b_index]))
		{
			// Find Unit Instance from Pathfinding Node Units Array
			var temp_pathfinding_node_b_units_array_unit_instance = array_get(pathfinding_node_units_array[pathfinding_node_b_index], temp_pathfinding_node_b_units_array_index);
			
			// Check Unit Faction Index within Battle Instance
			var temp_pathfinding_node_b_unit_faction_index = array_get_index(temp_celestial_battle_instance.battle_factions, temp_pathfinding_node_b_units_array_unit_instance.unit_faction);
			
			// Check if Unit's Faction Instance was already indexed in Celestial Battle's Faction Array
			if (temp_pathfinding_node_b_unit_faction_index == -1)
			{
				// Find the index of the Unit's Faction Instance within the Celestial Battle's Faction Array
				temp_pathfinding_node_b_unit_faction_index = array_length(temp_celestial_battle_instance.battle_factions);
				
				// Index the Unit's Faction Instance within the Celestial Battle's Faction Array
				array_push(temp_celestial_battle_instance.battle_factions, temp_pathfinding_node_b_units_array_unit_instance.unit_faction);
			}
			
			// Index the Unit Instance within the Celestial Battle's Units Array
			array_push(temp_celestial_battle_instance.battle_units[temp_pathfinding_node_b_unit_faction_index], temp_pathfinding_node_b_units_array_unit_instance);
			
			// Increment Pathfinding Node Units Array Index
			temp_pathfinding_node_b_units_array_index++;
		}
	}
}

