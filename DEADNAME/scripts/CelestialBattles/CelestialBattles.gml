

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
	
	// Update Celestial Battle Celestial Body Instance
	temp_celestial_battle_instance.celestial_body_instance = celestial_object;
	
	// Update Celestial Battle Pathfinding Node Indexes
	temp_celestial_battle_instance.pathfinding_node_a_index = pathfinding_node_a_index;
	temp_celestial_battle_instance.pathfinding_node_b_index = pathfinding_node_b_index;
	
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
		
		// Update that Unit Instance has entered Combat
		temp_pathfinding_node_a_units_array_unit_instance.engaged_in_battle = true;
		
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
			
			// Update that Unit Instance has entered Combat
			temp_pathfinding_node_b_units_array_unit_instance.engaged_in_battle = true;
			
			// Increment Pathfinding Node Units Array Index
			temp_pathfinding_node_b_units_array_index++;
		}
	}
}

function celestial_battle_shuffle_round(battle_instance)
{
	// Calculate Battle Instance's Terrain Combat Size
	var temp_battle_combat_size = 70;
	
	if (battle_instance.celestial_body_instance.pathfinding_enabled)
	{
		// Find Battle Instance's Pathfinding Node Microclimate Biome Types
		var temp_battle_pathfinding_node_a_microclimate_index = battle_instance.celestial_body_instance.pathfinding_node_microclimate_array[battle_instance.pathfinding_node_a_index];
		var temp_battle_pathfinding_node_b_microclimate_index = battle_instance.celestial_body_instance.pathfinding_node_microclimate_array[battle_instance.pathfinding_node_b_index];
		var temp_battle_pathfinding_node_a_microclimate_biome_type = battle_instance.celestial_body_instance.microclimate_biome_type_array[temp_battle_pathfinding_node_a_microclimate_index];
		var temp_battle_pathfinding_node_b_microclimate_biome_type = battle_instance.celestial_body_instance.microclimate_biome_type_array[temp_battle_pathfinding_node_b_microclimate_index];
		
		// Calculate Combat Size from Microclimate Biome Types
		temp_battle_combat_size = celestial_microclimate_biome_get_combat_size(temp_battle_pathfinding_node_a_microclimate_biome_type) + celestial_microclimate_biome_get_combat_size(temp_battle_pathfinding_node_b_microclimate_biome_type);
	}
	
	// Erase Battle's Previous Matchups
	var temp_battle_matchup_count = array_length(battle_instance.battle_matchups);
	var temp_battle_matchup_index = temp_battle_matchup_count - 1;
	
	repeat (temp_battle_matchup_count)
	{
		// Delete Battle Matchup Struct
		delete battle_instance.battle_matchups[temp_battle_matchup_index];
		
		// Decrement Battle Matchup Index
		temp_battle_matchup_index--;
	}
	
	array_resize(battle_instance.battle_matchups, 0);
	
	// Iterate through Battle's Active Factions
	var temp_battle_faction_count = array_length(battle_instance.battle_factions);
	var temp_battle_faction_index = temp_battle_faction_count - 1;
	
	repeat (temp_battle_faction_count)
	{
		// Find Battle Faction Instance
		var temp_battle_faction_inst = array_get(battle_instance.battle_factions, temp_battle_faction_index);
		var temp_battle_units_array = array_get(battle_instance.battle_units, temp_battle_faction_index);
		
		// Check if Battle Faction exists
		if (!instance_exists(temp_battle_faction_inst) or array_length(temp_battle_units_array) <= 0)
		{
			// Decrement Battle Faction Index
			temp_battle_faction_index--;
			
			// Skip Battle Shuffle Matchmaking for non-existant Faction
			continue;
		}
		
		// Create Empty Hostile & Allied Faction Arrays
		var temp_hostile_factions = array_create(0);
		var temp_allied_factions = array_create(0);
		
		// Increment through all of the Battle's Factions to compare this Faction's Relationship to the rest
		var temp_comparison_faction_index = temp_battle_faction_count - 1;
		
		repeat (temp_battle_faction_count)
		{
			// Check if Comparison Faction index matches the current Faction's Index
			if (temp_comparison_faction_index == temp_battle_faction_index)
			{
				// Decrement Comparison Faction Index
				temp_comparison_faction_index--;
				
				// Skip Comparison Faction - Can't compare the same Faction with itself
				continue;
			}
			
			// Check if Faction Exists and has Units participating in the current Battle
			if (instance_exists(array_get(battle_instance.battle_factions, temp_comparison_faction_index)) and array_length(array_get(battle_instance.battle_units, temp_comparison_faction_index)) > 0)
			{
				// Find the Comparison Faction's Index
				var temp_comparison_faction = array_get(battle_instance.battle_factions, temp_comparison_faction_index);
				
				// Check the current Faction's Relationship with the Comparison Factions
				var temp_faction_hostile_check = ds_map_find_value(temp_battle_faction_inst.relationships, temp_comparison_faction) == CelestialFactionRelationshipType.Hostile;
				var temp_faction_allied_check = ds_map_find_value(temp_comparison_faction.relationships, temp_battle_faction_inst) == CelestialFactionRelationshipType.Allied;
				
				// Add Factions to the Relationship Lists based on their Relationship Status
				if (temp_faction_hostile_check)
				{
					// Hostile Faction Relationship
					array_push(temp_hostile_factions, temp_comparison_faction_index);
				}
				else if (temp_faction_allied_check)
				{
					// Allied Faction Relationship
					array_push(temp_allied_factions, temp_comparison_faction_index);
				}
			}
			
			// Decrement Comparison Faction Index
			temp_comparison_faction_index--;
		}
		
		// Calculate Faction Combat Width
		var temp_faction_combat_width = battle_instance.battle_faction_combat_width;
		
		// Create Faction Unit Pool
		var temp_battle_units_index = 0;
		var temp_faction_combat_unit_pool = array_create(0);
		
		repeat (array_length(temp_battle_units_array))
		{
			
		}
		
		// Create Faction Battle Matchups
		
		
		// Destroy Unused Arrays
		array_resize(temp_hostile_factions, 0);
		array_resize(temp_allied_factions, 0);
		
		// Decrement Battle Faction Index
		temp_battle_faction_index--;
	}
}

function celestial_battle_perform_round(battle_instance)
{
	// Iterate through Battle Matchups
}

