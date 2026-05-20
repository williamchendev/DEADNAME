// Global Celestial Battle Properties
#macro CelestialBattlePriorityRankMax 10

//
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
		
		// Add Unit Instance to Battle
		celestial_battle_add_unit(temp_celestial_battle_instance, temp_pathfinding_node_a_units_array_unit_instance);
		
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
			
			// Add Unit Instance to Battle
			celestial_battle_add_unit(temp_celestial_battle_instance, temp_pathfinding_node_b_units_array_unit_instance);
			
			// Increment Pathfinding Node Units Array Index
			temp_pathfinding_node_b_units_array_index++;
		}
	}
}

//
function celestial_battle_add_unit(battle_instance, unit_instance)
{
	// Check Unit Faction Index within Battle Instance
	var temp_unit_faction_index = array_get_index(battle_instance.battle_factions, unit_instance.unit_faction);
	
	// Check if Unit's Faction Instance was already indexed in Celestial Battle's Faction Array
	if (temp_unit_faction_index == -1)
	{
		// Find the index of the Unit's Faction Instance within the Celestial Battle's Faction Array
		temp_unit_faction_index = array_length(battle_instance.battle_factions);
		
		// Index the Unit's Faction Instance within the Celestial Battle's Faction Array
		array_push(battle_instance.battle_factions, unit_instance.unit_faction);
		
		// Initialize Empty Battle Priority Pools
		var temp_faction_battle_land_priority_pool = array_create(CelestialBattlePriorityRankMax);
		var temp_faction_battle_air_priority_pool = array_create(CelestialBattlePriorityRankMax);
		var temp_faction_battle_sea_priority_pool = array_create(CelestialBattlePriorityRankMax);
		
		// Iterate through Battle Priority Pools to create Empty Sub-Unit Arrays
		var temp_priority_rank_index = 0;
		
		repeat (CelestialBattlePriorityRankMax)
		{
			// Create and Index Empty Priority Rank Sub-Unit Array
			array_set(temp_faction_battle_land_priority_pool, temp_priority_rank_index, array_create(0));
			array_set(temp_faction_battle_air_priority_pool, temp_priority_rank_index, array_create(0));
			array_set(temp_faction_battle_sea_priority_pool, temp_priority_rank_index, array_create(0));
			
			// Increment Priority Rank Index
			temp_priority_rank_index++;
		}
		
		// Index Battle Priority Pools in Battle Instance
		array_push(battle_instance.battle_land_priority_pools, temp_faction_battle_land_priority_pool);
		array_push(battle_instance.battle_air_priority_pools, temp_faction_battle_air_priority_pool);
		array_push(battle_instance.battle_sea_priority_pools, temp_faction_battle_sea_priority_pool);
	}
	
	// Index the Unit Instance within the Celestial Battle's Units Array
	array_push(battle_instance.battle_units[temp_unit_faction_index], unit_instance);
	
	// Update that Unit Instance has entered Combat
	unit_instance.engaged_in_battle = true;
}

//
function celestial_battle_matchup_sort(current, next) 
{
	return next.attacking_subunit.unit_priority_rank == current.attacking_subunit.unit_priority_rank ? (next.attacking_subunit.unit_agility > current.attacking_subunit.unit_agility ? -1 : 1) : (next.attacking_subunit.unit_priority_rank < current.attacking_subunit.unit_priority_rank ? -1 : 1);
}

//
function celestial_battle_shuffle_round(battle_instance)
{
	// Calculate Battle Instance's Terrain Combat Size
	var temp_battle_land_combat_size = 70;
	var temp_battle_air_combat_size = 70;
	var temp_battle_sea_combat_size = 70;
	
	if (battle_instance.celestial_body_instance.pathfinding_enabled)
	{
		// Find Battle Instance's Pathfinding Node Microclimate Biome Types
		var temp_battle_pathfinding_node_a_microclimate_index = battle_instance.celestial_body_instance.pathfinding_node_microclimate_array[battle_instance.pathfinding_node_a_index];
		var temp_battle_pathfinding_node_b_microclimate_index = battle_instance.celestial_body_instance.pathfinding_node_microclimate_array[battle_instance.pathfinding_node_b_index];
		var temp_battle_pathfinding_node_a_microclimate_biome_type = battle_instance.celestial_body_instance.microclimate_biome_type_array[temp_battle_pathfinding_node_a_microclimate_index];
		var temp_battle_pathfinding_node_b_microclimate_biome_type = battle_instance.celestial_body_instance.microclimate_biome_type_array[temp_battle_pathfinding_node_b_microclimate_index];
		
		// Calculate Combat Size from Microclimate Biome Types
		temp_battle_land_combat_size = celestial_microclimate_biome_get_land_combat_size(temp_battle_pathfinding_node_a_microclimate_biome_type) + celestial_microclimate_biome_get_land_combat_size(temp_battle_pathfinding_node_b_microclimate_biome_type);
		temp_battle_air_combat_size = celestial_microclimate_biome_get_air_combat_size(temp_battle_pathfinding_node_a_microclimate_biome_type) + celestial_microclimate_biome_get_air_combat_size(temp_battle_pathfinding_node_b_microclimate_biome_type);
		temp_battle_sea_combat_size = celestial_microclimate_biome_get_sea_combat_size(temp_battle_pathfinding_node_a_microclimate_biome_type) + celestial_microclimate_biome_get_sea_combat_size(temp_battle_pathfinding_node_b_microclimate_biome_type);
	}
	
	// Cleanup and erase Battle's unused Factions 
	var temp_battle_faction_cleanup_count = array_length(battle_instance.battle_factions);
	var temp_battle_faction_cleanup_index = temp_battle_faction_cleanup_count - 1;
	
	repeat (temp_battle_faction_cleanup_count)
	{
		// Skip check if Battle Faction is the Default Faction
		if (temp_battle_faction_cleanup_index == 0)
		{
			break;
		}
		
		// Check if Battle Faction exists and has Units participating in Combat - if not, delete Faction from Battle
		if (!instance_exists(array_get(battle_instance.battle_factions, temp_battle_faction_cleanup_index)) or array_length(array_get(battle_instance.battle_units, temp_battle_faction_cleanup_index)) <= 0)
		{
			// Find Battle Faction Arrays
			var temp_battle_faction_cleanup_land_priority_pool = array_get(battle_instance.battle_land_priority_pools, temp_battle_faction_cleanup_index);
			var temp_battle_faction_cleanup_air_priority_pool = array_get(battle_instance.battle_air_priority_pools, temp_battle_faction_cleanup_index);
			var temp_battle_faction_cleanup_sea_priority_pool = array_get(battle_instance.battle_sea_priority_pools, temp_battle_faction_cleanup_index);
			
			// Empty Battle Faction's Priority Pools
			var temp_battle_faction_cleanup_priority_rank_index = 0;
			
			repeat (CelestialBattlePriorityRankMax)
			{
				// Empty Priority Rank Sub-Unit Array
				array_resize(array_get(temp_battle_faction_cleanup_land_priority_pool, temp_battle_faction_cleanup_priority_rank_index), 0);
				array_resize(array_get(temp_battle_faction_cleanup_air_priority_pool, temp_battle_faction_cleanup_priority_rank_index), 0);
				array_resize(array_get(temp_battle_faction_cleanup_sea_priority_pool, temp_battle_faction_cleanup_priority_rank_index), 0);
				
				// Increment Battle Faction's Priority Rank Index
				temp_battle_faction_cleanup_priority_rank_index++;
			}
			
			// Resize Unused Arrays
			array_resize(array_get(battle_instance.battle_units, temp_battle_faction_cleanup_index), 0);
			array_resize(array_get(battle_instance.battle_hostile_factions, temp_battle_faction_cleanup_index), 0);
			array_resize(array_get(battle_instance.battle_allied_factions, temp_battle_faction_cleanup_index), 0);
			
			array_resize(temp_battle_faction_cleanup_land_priority_pool, 0);
			array_resize(temp_battle_faction_cleanup_air_priority_pool, 0);
			array_resize(temp_battle_faction_cleanup_sea_priority_pool, 0);
			
			// Delete Battle Faction from Battle Instance
			array_delete(battle_instance.battle_factions, temp_battle_faction_cleanup_index, 1);
			array_delete(battle_instance.battle_units, temp_battle_faction_cleanup_index, 1);
			array_delete(battle_instance.battle_hostile_factions, temp_battle_faction_cleanup_index, 1);
			array_delete(battle_instance.battle_allied_factions, temp_battle_faction_cleanup_index, 1);
			array_delete(battle_instance.battle_land_priority_pools, temp_battle_faction_cleanup_index, 1);
			array_delete(battle_instance.battle_air_priority_pools, temp_battle_faction_cleanup_index, 1);
			array_delete(battle_instance.battle_sea_priority_pools, temp_battle_faction_cleanup_index, 1);
		}
		
		// Decrement Battle Faction Index
		temp_battle_faction_cleanup_index--;
	}
	
	// Cleanup and erase Battle's unused previous Matchups
	var temp_battle_matchup_cleanup_count = array_length(battle_instance.battle_matchups);
	var temp_battle_matchup_cleanup_index = temp_battle_matchup_cleanup_count - 1;
	
	repeat (temp_battle_matchup_cleanup_count)
	{
		// Delete Battle Matchup Struct
		delete battle_instance.battle_matchups[temp_battle_matchup_cleanup_index];
		
		// Decrement Battle Matchup Index
		temp_battle_matchup_cleanup_index--;
	}
	
	array_resize(battle_instance.battle_matchups, 0);
	
	// Establish Empty Count of Total Hostile Faction Relationships
	var temp_faction_hostile_relationships_count = 0;
	
	// Iterate through Battle's Active Factions
	var temp_battle_faction_count = array_length(battle_instance.battle_factions);
	var temp_battle_faction_index = temp_battle_faction_count - 1;
	
	repeat (temp_battle_faction_count)
	{
		// Find Battle Faction Instance & Faction Arrays
		var temp_battle_faction_inst = array_get(battle_instance.battle_factions, temp_battle_faction_index);
		var temp_battle_units_array = array_get(battle_instance.battle_units, temp_battle_faction_index);
		
		var temp_battle_hostile_factions_array = array_get(battle_instance.battle_hostile_factions, temp_battle_faction_index);
		var temp_battle_allied_factions_array = array_get(battle_instance.battle_allied_factions, temp_battle_faction_index);
		
		var temp_battle_faction_land_priority_pool = array_get(battle_instance.battle_land_priority_pools, temp_battle_faction_index);
		var temp_battle_faction_air_priority_pool = array_get(battle_instance.battle_air_priority_pools, temp_battle_faction_index);
		var temp_battle_faction_sea_priority_pool = array_get(battle_instance.battle_sea_priority_pools, temp_battle_faction_index);
		
		// Empty Battle Faction's Priority Pools
		var temp_battle_faction_priority_rank_index = 0;
		
		repeat (CelestialBattlePriorityRankMax)
		{
			// Empty Priority Rank Sub-Unit Array
			array_resize(array_get(temp_battle_faction_land_priority_pool, temp_battle_faction_priority_rank_index), 0);
			array_resize(array_get(temp_battle_faction_air_priority_pool, temp_battle_faction_priority_rank_index), 0);
			array_resize(array_get(temp_battle_faction_sea_priority_pool, temp_battle_faction_priority_rank_index), 0);
			
			// Increment Battle Faction's Priority Rank Index
			temp_battle_faction_priority_rank_index++;
		}
		
		// Empty Battle Faction's Hostile & Allied Faction Arrays
		array_resize(temp_battle_hostile_factions_array, 0);
		array_resize(temp_battle_allied_factions_array, 0);
		
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
			if (instance_exists(array_get(battle_instance.battle_factions, temp_comparison_faction_index)))
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
					array_push(temp_battle_hostile_factions_array, temp_comparison_faction_index);
					
					// Increase Faction Hostile Relationships Count
					temp_faction_hostile_relationships_count++;
				}
				else if (temp_faction_allied_check)
				{
					// Allied Faction Relationship
					array_push(temp_battle_allied_factions_array, temp_comparison_faction_index);
				}
			}
			
			// Decrement Comparison Faction Index
			temp_comparison_faction_index--;
		}
		
		// Calculate Faction Combat Width
		var temp_faction_land_combat_size = temp_battle_land_combat_size;
		var temp_faction_air_combat_size = temp_battle_air_combat_size;
		var temp_faction_sea_combat_size = temp_battle_sea_combat_size;
		
		// Initialize Faction Indexes & Sub-Unit Pools
		var temp_land_indexes_pool = array_create(0);
		var temp_air_indexes_pool = array_create(0);
		var temp_sea_indexes_pool = array_create(0);
		
		var temp_land_subunit_pool = array_create(0);
		var temp_air_subunit_pool = array_create(0);
		var temp_sea_subunit_pool = array_create(0);
		
		// Populate Faction Sub-Unit Pools
		var temp_battle_units_count = array_length(temp_battle_units_array);
		var temp_battle_units_index = temp_battle_units_count - 1;
		
		repeat (temp_battle_units_count)
		{
			// Find Unit Instance
			var temp_battle_unit_instance = temp_battle_units_array[temp_battle_units_index];
			
			// Check if Battle Unit Exists
			if (!instance_exists(temp_battle_unit_instance))
			{
				// Battle Unit does not exist - Remove Battle Unit from Battle Factions Unit Array
				array_delete(temp_battle_units_array, temp_battle_units_index, 1);
				
				// Decrement Battle Unit Index
				temp_battle_units_index--;
				
				// Skip to next Battle Unit Instance
				continue;
			}
			
			// Iterate through Battle Unit's Sub-Units Array
			var temp_battle_unit_subunit_count = array_length(temp_battle_unit_instance.sub_units);
			var temp_battle_unit_subunit_index = temp_battle_unit_subunit_count - 1;
			
			repeat (temp_battle_unit_subunit_count)
			{
				// Find Sub-Unit Instance
				var temp_battle_unit_subunit_instance = temp_battle_unit_instance.sub_units[temp_battle_unit_subunit_index];
				
				// Check if Sub-Unit Instance Exists
				if (!instance_exists(temp_battle_unit_subunit_instance))
				{
					// Battle Unit's Sub-Unit Instance does not exist - Remove Battle Unit's Sub-Unit Instance from Battle Unit's Sub-Unit Array
					array_delete(temp_battle_unit_instance.sub_units, temp_battle_unit_subunit_index, 1);
					
					// Decrement Battle Unit's Sub-Unit Index
					temp_battle_unit_subunit_index--;
					
					// Skip to next Battle Unit's Sub-Unit Instance
					continue;
				}
				
				// Check if Sub-Unit engages in Combat
				if (temp_battle_unit_subunit_instance.unit_combat_attendance)
				{
					// Sub-Unit has mandatory Combat Attendance - Add Sub-Unit to Battle Faction's Priority Pools directly
					switch (temp_battle_unit_subunit_instance.unit_terrain_type)
					{
						case CelestialUnitTerrainType.Land:
							// Add Sub-Unit to Battle Faction's Land Priority Rank Sub-Unit Pools
							array_push(array_get(temp_battle_faction_land_priority_pool, temp_battle_unit_subunit_instance.unit_priority_rank), temp_battle_unit_subunit_instance);
							temp_faction_land_combat_size -= temp_battle_unit_subunit_instance.unit_size;
							
							// Add Sub-Unit to Battle Matchups
							array_push(battle_instance.battle_matchups, { attacking_subunit: temp_battle_unit_subunit_instance, defending_subunit: noone, faction_index: temp_battle_faction_index });
							break;
						case CelestialUnitTerrainType.Air:
							// Add Sub-Unit to Battle Faction's Air Priority Rank Sub-Unit Pools
							array_push(array_get(temp_battle_faction_air_priority_pool, temp_battle_unit_subunit_instance.unit_priority_rank), temp_battle_unit_subunit_instance);
							temp_faction_air_combat_size -= temp_battle_unit_subunit_instance.unit_size;
							
							// Add Sub-Unit to Battle Matchups
							array_push(battle_instance.battle_matchups, { attacking_subunit: temp_battle_unit_subunit_instance, defending_subunit: noone, faction_index: temp_battle_faction_index });
							break;
						case CelestialUnitTerrainType.Sea:
							// Add Sub-Unit to Battle Faction's Sea Priority Rank Sub-Unit Pools
							array_push(array_get(temp_battle_faction_sea_priority_pool, temp_battle_unit_subunit_instance.unit_priority_rank), temp_battle_unit_subunit_instance);
							temp_faction_sea_combat_size -= temp_battle_unit_subunit_instance.unit_size;
							
							// Add Sub-Unit to Battle Matchups
							array_push(battle_instance.battle_matchups, { attacking_subunit: temp_battle_unit_subunit_instance, defending_subunit: noone, faction_index: temp_battle_faction_index });
							break;
					}
				}
				else if (temp_battle_unit_subunit_instance.unit_combat)
				{
					// Sub-Unit engages in Combat - Add Sub-Unit to Combat Terrain Pools for random selection
					switch (temp_battle_unit_subunit_instance.unit_terrain_type)
					{
						case CelestialUnitTerrainType.Land:
							// Add Sub-Unit to Combat Land Pool for random selection
							array_push(temp_land_indexes_pool, array_length(temp_land_subunit_pool));
							array_push(temp_land_subunit_pool, temp_battle_unit_subunit_instance);
							break;
						case CelestialUnitTerrainType.Air:
							// Add Sub-Unit to Combat Air Pool for random selection
							array_push(temp_air_indexes_pool, array_length(temp_air_subunit_pool));
							array_push(temp_air_subunit_pool, temp_battle_unit_subunit_instance);
							break;
						case CelestialUnitTerrainType.Sea:
							// Add Sub-Unit to Combat Sea Pool for random selection
							array_push(temp_sea_indexes_pool, array_length(temp_sea_subunit_pool));
							array_push(temp_sea_subunit_pool, temp_battle_unit_subunit_instance);
							break;
					}
				}
				
				// Decrement Battle Unit's Sub-Unit Index
				temp_battle_unit_subunit_index--;
			}
			
			// Decrement Battle Unit Index
			temp_battle_units_index--;
		}
		
		// Populate Faction Priority Rank Pools
		while (array_length(temp_land_indexes_pool) > 0 and temp_faction_land_combat_size > 0)
		{
			// Choose Random Sub-Unit
			var temp_land_subunit_random_value = irandom(array_length(temp_land_indexes_pool) - 1);
			
			// Find Sub-Unit Index and Instance from Sub-Unit Pool
			var temp_land_subunit_index = array_get(temp_land_indexes_pool, temp_land_subunit_random_value);
			var temp_land_subunit_instance = array_get(temp_land_subunit_pool, temp_land_subunit_index);
			
			// Check if Sub-Unit's Unit Size fits within Battle Terrain Combat Size
			if (temp_land_subunit_instance.unit_size <= temp_faction_land_combat_size)
			{
				// Add Sub-Unit to Battle Faction's Priority Rank Sub-Unit Pools
				array_push(array_get(temp_battle_faction_land_priority_pool, temp_land_subunit_instance.unit_priority_rank), temp_land_subunit_instance);
				temp_faction_land_combat_size -= temp_land_subunit_instance.unit_size;
				
				// Add Sub-Unit to Battle Matchups
				array_push(battle_instance.battle_matchups, { attacking_subunit: temp_land_subunit_instance, defending_subunit: noone, faction_index: temp_battle_faction_index });
			}
			
			// Delete Sub-Unit from Sub-Unit Index Array
			array_delete(temp_land_indexes_pool, temp_land_subunit_random_value, 1);
		}
		
		while (array_length(temp_air_indexes_pool) > 0 and temp_faction_air_combat_size > 0)
		{
			// Choose Random Sub-Unit
			var temp_air_subunit_random_value = irandom(array_length(temp_air_indexes_pool) - 1);
			
			// Find Sub-Unit Index and Instance from Sub-Unit Pool
			var temp_air_subunit_index = array_get(temp_air_indexes_pool, temp_air_subunit_random_value);
			var temp_air_subunit_instance = array_get(temp_air_subunit_pool, temp_air_subunit_index);
			
			// Check if Sub-Unit's Unit Size fits within Battle Terrain Combat Size
			if (temp_air_subunit_instance.unit_size <= temp_faction_air_combat_size)
			{
				// Add Sub-Unit to Battle Faction's Priority Rank Sub-Unit Pools
				array_push(array_get(temp_battle_faction_air_priority_pool, temp_air_subunit_instance.unit_priority_rank), temp_air_subunit_instance);
				temp_faction_air_combat_size -= temp_air_subunit_instance.unit_size;
				
				// Add Sub-Unit to Battle Matchups
				array_push(battle_instance.battle_matchups, { attacking_subunit: temp_air_subunit_instance, defending_subunit: noone, faction_index: temp_battle_faction_index });
			}
			
			// Delete Sub-Unit from Sub-Unit Index Array
			array_delete(temp_air_indexes_pool, temp_air_subunit_random_value, 1);
		}
		
		while (array_length(temp_sea_indexes_pool) > 0 and temp_faction_sea_combat_size > 0)
		{
			// Choose Random Sub-Unit
			var temp_sea_subunit_random_value = irandom(array_length(temp_sea_indexes_pool) - 1);
			
			// Find Sub-Unit Index and Instance from Sub-Unit Pool
			var temp_sea_subunit_index = array_get(temp_sea_indexes_pool, temp_sea_subunit_random_value);
			var temp_sea_subunit_instance = array_get(temp_sea_subunit_pool, temp_sea_subunit_index);
			
			// Check if Sub-Unit's Unit Size fits within Battle Terrain Combat Size
			if (temp_sea_subunit_instance.unit_size <= temp_faction_sea_combat_size)
			{
				// Add Sub-Unit to Battle Faction's Priority Rank Sub-Unit Pools
				array_push(array_get(temp_battle_faction_sea_priority_pool, temp_sea_subunit_instance.unit_priority_rank), temp_sea_subunit_instance);
				temp_faction_sea_combat_size -= temp_sea_subunit_instance.unit_size;
				
				// Add Sub-Unit to Battle Matchups
				array_push(battle_instance.battle_matchups, { attacking_subunit: temp_sea_subunit_instance, defending_subunit: noone, faction_index: temp_battle_faction_index });
			}
			
			// Delete Sub-Unit from Sub-Unit Index Array
			array_delete(temp_sea_indexes_pool, temp_sea_subunit_random_value, 1);
		}
		
		// Destroy Unused Arrays
		array_resize(temp_land_indexes_pool, 0);
		array_resize(temp_air_indexes_pool, 0);
		array_resize(temp_sea_indexes_pool, 0);
		
		array_resize(temp_land_subunit_pool, 0);
		array_resize(temp_air_subunit_pool, 0);
		array_resize(temp_sea_subunit_pool, 0);
		
		// Decrement Battle Faction Index
		temp_battle_faction_index--;
	}
	
	// Check if Hostile Faction Relationships Exist
	if (temp_faction_hostile_relationships_count <= 0)
	{
		// End Battle Behaviour
	}
	
	// Sort Matchups by Rank & Agility
	array_sort(battle_instance.battle_matchups, celestial_battle_matchup_sort);
	
	// Iterate through and initialize Sub-Unit Matchups
	var temp_battle_matchup_count = array_length(battle_instance.battle_matchups);
	var temp_battle_matchup_index = temp_battle_matchup_count - 1;
	
	repeat (temp_battle_matchup_count)
	{
		// Find Battle Matchup Struct
		var temp_battle_matchup_struct = array_get(battle_instance.battle_matchups, temp_battle_matchup_index);
		
		// Find Sub-Unit's Hostile Faction Relationships Array
		var temp_battle_matchup_hostile_factions_array = array_get(battle_instance.battle_hostile_factions, temp_battle_matchup_struct.faction_index);
		
		// Check if Hostile Faction Relationship Exists
		if (array_length(temp_battle_matchup_hostile_factions_array) > 0)
		{
			
		}
		else
		{
			
		}
		
		// Decrement Battle Matchup Index
		temp_battle_matchup_index--;
	}
}

function celestial_battle_perform_round(battle_instance)
{
	// Iterate through Battle Matchups
}

