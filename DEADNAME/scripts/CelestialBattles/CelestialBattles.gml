// Global Celestial Battle Properties
#macro CelestialBattlePriorityRankMax 10
#macro CelestialBattleAssassinationPriorityRank 7

// Battle Enums
enum CelestialBattlePlatformSide
{
	Left,
	None,
	Right
}

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
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		return;
	}
	
	// Check Unit Faction Index within Battle Instance
	var temp_unit_faction_index = array_get_index(battle_instance.battle_factions, unit_instance.unit_faction);
	
	// Check if Unit's Faction Instance was already indexed in Celestial Battle's Faction Array
	if (temp_unit_faction_index == -1)
	{
		// Find the index of the Unit's Faction Instance within the Celestial Battle's Faction Array
		temp_unit_faction_index = array_length(battle_instance.battle_factions);
		
		// Index the Unit's Faction Instance within the Celestial Battle's Faction Array
		array_push(battle_instance.battle_factions, unit_instance.unit_faction);
		
		// Index New Celestial Battle Faction's Unit, Hostile Factions, & Allied Factions Arrays
		array_push(battle_instance.battle_units, array_create(0));
		array_push(battle_instance.battle_hostile_factions, array_create(0));
		array_push(battle_instance.battle_allied_factions, array_create(0));
		
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

function celestial_battle_choreography_actors_sort(current, next) 
{
	return next.actor_vertical_depth > current.actor_vertical_depth ? -1 : 1;
}

//
function celestial_battle_shuffle_round(battle_instance)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		return;
	}
	
	// Clear Battle's Choreography Actors
	celestial_battle_clear_choreography_actors(battle_instance)
	
	// Reset Battle Choreography Actors Battle Column Sizes Array
	array_resize(battle_instance.battle_choreography_actors_battle_column_sizes, CelestialBattlePriorityRankMax * 2);
	
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
		
		// Check if Battle Faction Instance Exists
		if (instance_exists(temp_battle_faction_inst))
		{
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
							array_push(battle_instance.battle_matchups, { attacking_subunit: temp_battle_unit_subunit_instance, defending_subunit: noone, attacking_faction_index: temp_battle_faction_index, defending_faction_index: -1, skip_matchup: false });
							
							// Add Sub-Unit to Battle Choreography as an Actor
							celestial_battle_add_choreography_actor(battle_instance, temp_battle_unit_subunit_instance);
							break;
						case CelestialUnitTerrainType.Air:
							// Add Sub-Unit to Battle Faction's Air Priority Rank Sub-Unit Pools
							array_push(array_get(temp_battle_faction_air_priority_pool, temp_battle_unit_subunit_instance.unit_priority_rank), temp_battle_unit_subunit_instance);
							temp_faction_air_combat_size -= temp_battle_unit_subunit_instance.unit_size;
							
							// Add Sub-Unit to Battle Matchups
							array_push(battle_instance.battle_matchups, { attacking_subunit: temp_battle_unit_subunit_instance, defending_subunit: noone, attacking_faction_index: temp_battle_faction_index, defending_faction_index: -1, skip_matchup: false });
							
							// Add Sub-Unit to Battle Choreography as an Actor
							celestial_battle_add_choreography_actor(battle_instance, temp_battle_unit_subunit_instance);
							break;
						case CelestialUnitTerrainType.Sea:
							// Add Sub-Unit to Battle Faction's Sea Priority Rank Sub-Unit Pools
							array_push(array_get(temp_battle_faction_sea_priority_pool, temp_battle_unit_subunit_instance.unit_priority_rank), temp_battle_unit_subunit_instance);
							temp_faction_sea_combat_size -= temp_battle_unit_subunit_instance.unit_size;
							
							// Add Sub-Unit to Battle Matchups
							array_push(battle_instance.battle_matchups, { attacking_subunit: temp_battle_unit_subunit_instance, defending_subunit: noone, attacking_faction_index: temp_battle_faction_index, defending_faction_index: -1, skip_matchup: false });
							
							// Add Sub-Unit to Battle Choreography as an Actor
							celestial_battle_add_choreography_actor(battle_instance, temp_battle_unit_subunit_instance);
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
				array_push(battle_instance.battle_matchups, { attacking_subunit: temp_land_subunit_instance, defending_subunit: noone, attacking_faction_index: temp_battle_faction_index, defending_faction_index: -1, skip_matchup: false });
				
				// Add Sub-Unit to Battle Choreography as an Actor
				celestial_battle_add_choreography_actor(battle_instance, temp_land_subunit_instance);
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
				array_push(battle_instance.battle_matchups, { attacking_subunit: temp_air_subunit_instance, defending_subunit: noone, attacking_faction_index: temp_battle_faction_index, defending_faction_index: -1, skip_matchup: false });
				
				// Add Sub-Unit to Battle Choreography as an Actor
				celestial_battle_add_choreography_actor(battle_instance, temp_air_subunit_instance);
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
				array_push(battle_instance.battle_matchups, { attacking_subunit: temp_sea_subunit_instance, defending_subunit: noone, attacking_faction_index: temp_battle_faction_index, defending_faction_index: -1, skip_matchup: false });
				
				// Add Sub-Unit to Battle Choreography as an Actor
				celestial_battle_add_choreography_actor(battle_instance, temp_sea_subunit_instance);
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
		battle_instance.battle_exists = false;
		return;
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
		
		// Establish Matchup Variables
		var temp_matchup_exists = false;
		
		// Find Sub-Unit's Hostile Faction Relationships Array
		var temp_battle_matchup_hostile_factions_array = array_get(battle_instance.battle_hostile_factions, temp_battle_matchup_struct.attacking_faction_index);
		var temp_battle_matchup_hostile_factions_count = array_length(temp_battle_matchup_hostile_factions_array);
		
		// Check if Hostile Faction Relationship Exists
		if (temp_battle_matchup_hostile_factions_count > 0)
		{
			// Randomize Hostile Factions Array and Select Sub-Unit Target from Random Hostile Faction
			var temp_randomized_hostile_factions_array = array_shuffle(temp_battle_matchup_hostile_factions_array);
			var temp_randomized_hostile_factions_index = 0;
			
			repeat (temp_battle_matchup_hostile_factions_count)
			{
				// Find Index of Randomized Hostile Faction
				var temp_battle_hostile_faction_index = array_get(temp_battle_matchup_hostile_factions_array, temp_randomized_hostile_factions_index);
				
				// Find Randomized Hostile Faction's Priority Pools
				var temp_battle_hostile_faction_land_priority_pool = array_get(battle_instance.battle_land_priority_pools, temp_battle_hostile_faction_index);
				var temp_battle_hostile_faction_air_priority_pool = array_get(battle_instance.battle_air_priority_pools, temp_battle_hostile_faction_index);
				var temp_battle_hostile_faction_sea_priority_pool = array_get(battle_instance.battle_sea_priority_pools, temp_battle_hostile_faction_index);
				
				// Start Priority Pool Search Index at 0 by Default, or at the Celestial Battle Assassination Priority Rank if Attacking Sub-Unit has Attacks as Assassinations Enabled
				var temp_battle_priority_pool_search_index = temp_battle_matchup_struct.attacking_subunit.unit_attack_assassination ? CelestialBattleAssassinationPriorityRank : 0;
				
				// Iterate through Priority Pools to find Sub-Unit Matchup
				repeat (CelestialBattlePriorityRankMax)
				{
					// Check if Unit can engage in Anti-Air Combat
					if (temp_battle_matchup_struct.attacking_subunit.unit_attack_air)
					{
						// Check if Priority Pool is Populated at the Priority Rank Index
						if (array_length(array_get(temp_battle_hostile_faction_air_priority_pool, temp_battle_priority_pool_search_index)) > 0)
						{
							// Pull Random Sub-Unit from Priority Rank Index's Priority Pool
							var temp_air_priority_pool_array = array_get(temp_battle_hostile_faction_air_priority_pool, temp_battle_priority_pool_search_index);
							var temp_air_priority_pool_random_value = irandom(array_length(temp_air_priority_pool_array) - 1);
							
							temp_battle_matchup_struct.defending_subunit = array_get(temp_air_priority_pool_array, temp_air_priority_pool_random_value);
							temp_battle_matchup_struct.defending_faction_index = temp_battle_hostile_faction_index;
							
							// Toggle Matchup Found
							temp_matchup_exists = true;
							
							// Exit searching across Sub-Unit's Priority Rank ordered Priority Pools
							break;
						}
					}
					
					// Check if Unit can engage in Anti-Surface Combat
					if (temp_battle_matchup_struct.attacking_subunit.unit_attack_land)
					{
						// Check if Priority Pool is Populated at the Priority Rank Index
						if (array_length(array_get(temp_battle_hostile_faction_land_priority_pool, temp_battle_priority_pool_search_index)) > 0)
						{
							// Pull Random Sub-Unit from Priority Rank Index's Priority Pool
							var temp_land_priority_pool_array = array_get(temp_battle_hostile_faction_land_priority_pool, temp_battle_priority_pool_search_index);
							var temp_land_priority_pool_random_value = irandom(array_length(temp_land_priority_pool_array) - 1);
							
							temp_battle_matchup_struct.defending_subunit = array_get(temp_land_priority_pool_array, temp_land_priority_pool_random_value);
							temp_battle_matchup_struct.defending_faction_index = temp_battle_hostile_faction_index;
							
							// Toggle Matchup Found
							temp_matchup_exists = true;
							
							// Exit searching across Sub-Unit's Priority Rank ordered Priority Pools
							break;
						}
					}
					
					// Check if Unit can engage in Anti-Naval Combat
					if (temp_battle_matchup_struct.attacking_subunit.unit_attack_sea)
					{
						// Check if Priority Pool is Populated at the Priority Rank Index
						if (array_length(array_get(temp_battle_hostile_faction_sea_priority_pool, temp_battle_priority_pool_search_index)) > 0)
						{
							// Pull Random Sub-Unit from Priority Rank Index's Priority Pool
							var temp_sea_priority_pool_array = array_get(temp_battle_hostile_faction_sea_priority_pool, temp_battle_priority_pool_search_index);
							var temp_sea_priority_pool_random_value = irandom(array_length(temp_sea_priority_pool_array) - 1);
							
							temp_battle_matchup_struct.defending_subunit = array_get(temp_sea_priority_pool_array, temp_sea_priority_pool_random_value);
							temp_battle_matchup_struct.defending_faction_index = temp_battle_hostile_faction_index;
							
							// Toggle Matchup Found
							temp_matchup_exists = true;
							
							// Exit searching across Sub-Unit's Priority Rank ordered Priority Pools
							break;
						}
					}
					
					// Increment Priority Pool Search Index
					temp_battle_priority_pool_search_index++;
					temp_battle_priority_pool_search_index = temp_battle_priority_pool_search_index mod CelestialBattlePriorityRankMax;
				}
				
				// Check if Matchup was Found
				if (temp_matchup_exists)
				{
					// Exit searching across Sub-Unit's Hostile Factions Priority Pools
					break;
				}
				
				// Increment Randomized Hostile Factions Index
				temp_randomized_hostile_factions_index++;
			}
			
			// Delete Unused Array
			array_resize(temp_battle_matchup_hostile_factions_array, 0);
		}
		
		// Check if Matchup was Found
		if (!temp_matchup_exists)
		{
			// Toggle to Skip Matchup in future Battle Round Calculations
			temp_battle_matchup_struct.skip_matchup = true;
		}
		
		// Decrement Battle Matchup Index
		temp_battle_matchup_index--;
	}
	
	// Sort Battle's Choreography Actors and Index the Actors into the Battle's Choreography Actors DS Map
	celestial_battle_depth_sort_choreography_actors(battle_instance);
}

function celestial_battle_perform_round(battle_instance)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		return;
	}
	
	// Clear Battle's Choreography Actions
	celestial_battle_clear_choreography_actions(battle_instance);
	
	// Establish Battle's Combat Variables
	var temp_battle_combat_ongoing = false;
	
	// Iterate through and initialize Sub-Unit Matchups
	var temp_battle_matchup_count = array_length(battle_instance.battle_matchups);
	var temp_battle_matchup_index = temp_battle_matchup_count - 1;
	
	repeat (temp_battle_matchup_count)
	{
		// Find Battle Matchup Struct
		var temp_battle_matchup_struct = array_get(battle_instance.battle_matchups, temp_battle_matchup_index);
		
		// Check if Battle Matchup's Attacking Sub-Unit Instance Exists
		if (!instance_exists(temp_battle_matchup_struct.attacking_subunit))
		{
			// Delete Matchup from Battle Matchups Array
			array_delete(battle_instance.battle_matchups, temp_battle_matchup_index, 1);
			
			// Destroy Battle Matchup Struct
			delete temp_battle_matchup_struct;
			
			// Decrement Battle Matchup Index
			temp_battle_matchup_index--;
			continue;
		}
		
		// Check if Battle Matchup should be Skipped
		if (temp_battle_matchup_struct.skip_matchup)
		{
			// Decrement Battle Matchup Index
			temp_battle_matchup_index--;
			continue;
		}
		
		// Establish Matchup Variables
		var temp_matchup_exists = false;
		
		// Check if Matchup Defending Sub-Unit Exists
		if (!instance_exists(temp_battle_matchup_struct.defending_subunit))
		{
			// Find Sub-Unit's Hostile Faction Relationships Array
			var temp_battle_matchup_hostile_factions_array = array_get(battle_instance.battle_hostile_factions, temp_battle_matchup_struct.attacking_faction_index);
			var temp_battle_matchup_hostile_factions_count = array_length(temp_battle_matchup_hostile_factions_array);
			
			// Check if Hostile Faction Relationship Exists
			if (temp_battle_matchup_hostile_factions_count > 0)
			{
				// Randomize Hostile Factions Array and Select Sub-Unit Target from Random Hostile Faction
				var temp_randomized_hostile_factions_array = array_shuffle(temp_battle_matchup_hostile_factions_array);
				var temp_randomized_hostile_factions_index = 0;
				
				repeat (temp_battle_matchup_hostile_factions_count)
				{
					// Find Index of Randomized Hostile Faction
					var temp_battle_hostile_faction_index = array_get(temp_battle_matchup_hostile_factions_array, temp_randomized_hostile_factions_index);
					
					// Find Randomized Hostile Faction's Priority Pools
					var temp_battle_hostile_faction_land_priority_pool = array_get(battle_instance.battle_land_priority_pools, temp_battle_hostile_faction_index);
					var temp_battle_hostile_faction_air_priority_pool = array_get(battle_instance.battle_air_priority_pools, temp_battle_hostile_faction_index);
					var temp_battle_hostile_faction_sea_priority_pool = array_get(battle_instance.battle_sea_priority_pools, temp_battle_hostile_faction_index);
					
					// Start Priority Pool Search Index at 0 by Default, or at the Celestial Battle Assassination Priority Rank if Attacking Sub-Unit has Attacks as Assassinations Enabled
					var temp_battle_priority_pool_search_index = temp_battle_matchup_struct.attacking_subunit.unit_attack_assassination ? CelestialBattleAssassinationPriorityRank : 0;
					
					// Iterate through Priority Pools to find Sub-Unit Matchup
					repeat (CelestialBattlePriorityRankMax)
					{
						// Check if Unit can engage in Anti-Air Combat
						if (temp_battle_matchup_struct.attacking_subunit.unit_attack_air)
						{
							// Check if Priority Pool is Populated at the Priority Rank Index
							if (array_length(array_get(temp_battle_hostile_faction_air_priority_pool, temp_battle_priority_pool_search_index)) > 0)
							{
								// Iterate through Air Priority Pool Array
								var temp_air_priority_pool_array = array_get(temp_battle_hostile_faction_air_priority_pool, temp_battle_priority_pool_search_index);
								var temp_air_priority_pool_count = array_length(temp_air_priority_pool_array);
								
								repeat (temp_air_priority_pool_count)
								{
									// Pull Random Sub-Unit from Priority Rank Index's Priority Pool
									var temp_air_priority_pool_random_value = irandom(array_length(temp_air_priority_pool_array) - 1);
									var temp_air_priority_pool_random_subunit_inst = array_get(temp_air_priority_pool_array, temp_air_priority_pool_random_value);
									
									// Check if Random Sub-Unit Exists
									if (instance_exists(temp_air_priority_pool_random_subunit_inst))
									{
										// Set Battle Matchup's Defending Sub-Unit Properties
										temp_battle_matchup_struct.defending_subunit = array_get(temp_air_priority_pool_array, temp_air_priority_pool_random_value);
										temp_battle_matchup_struct.defending_faction_index = temp_battle_hostile_faction_index;
										
										// Toggle Matchup Found
										temp_matchup_exists = true;
										
										// Matchup was found - Exit Air Priority Pool Sub-Unit Search
										break;
									}
								}
								
								// Check if Matchup was Found
								if (temp_matchup_exists)
								{
									// Exit searching across Sub-Unit's Hostile Factions Priority Pools
									break;
								}
							}
						}
						
						// Check if Unit can engage in Anti-Surface Combat
						if (temp_battle_matchup_struct.attacking_subunit.unit_attack_land)
						{
							// Check if Priority Pool is Populated at the Priority Rank Index
							if (array_length(array_get(temp_battle_hostile_faction_land_priority_pool, temp_battle_priority_pool_search_index)) > 0)
							{
								// Iterate through Land Priority Pool Array
								var temp_land_priority_pool_array = array_get(temp_battle_hostile_faction_land_priority_pool, temp_battle_priority_pool_search_index);
								var temp_land_priority_pool_count = array_length(temp_land_priority_pool_array);
								
								repeat (temp_land_priority_pool_count)
								{
									// Pull Random Sub-Unit from Priority Rank Index's Priority Pool
									var temp_land_priority_pool_random_value = irandom(array_length(temp_land_priority_pool_array) - 1);
									var temp_land_priority_pool_random_subunit_inst = array_get(temp_land_priority_pool_array, temp_land_priority_pool_random_value);
									
									// Check if Random Sub-Unit Exists
									if (instance_exists(temp_land_priority_pool_random_subunit_inst))
									{
										// Set Battle Matchup's Defending Sub-Unit Properties
										temp_battle_matchup_struct.defending_subunit = array_get(temp_land_priority_pool_array, temp_land_priority_pool_random_value);
										temp_battle_matchup_struct.defending_faction_index = temp_battle_hostile_faction_index;
										
										// Toggle Matchup Found
										temp_matchup_exists = true;
										
										// Matchup was found - Exit Land Priority Pool Sub-Unit Search
										break;
									}
								}
								
								// Check if Matchup was Found
								if (temp_matchup_exists)
								{
									// Exit searching across Sub-Unit's Hostile Factions Priority Pools
									break;
								}
							}
						}
						
						// Check if Unit can engage in Anti-Naval Combat
						if (temp_battle_matchup_struct.attacking_subunit.unit_attack_sea)
						{
							// Check if Priority Pool is Populated at the Priority Rank Index
							if (array_length(array_get(temp_battle_hostile_faction_sea_priority_pool, temp_battle_priority_pool_search_index)) > 0)
							{
								// Iterate through Sea Priority Pool Array
								var temp_sea_priority_pool_array = array_get(temp_battle_hostile_faction_sea_priority_pool, temp_battle_priority_pool_search_index);
								var temp_sea_priority_pool_count = array_length(temp_sea_priority_pool_array);
								
								repeat (temp_sea_priority_pool_count)
								{
									// Pull Random Sub-Unit from Priority Rank Index's Priority Pool
									var temp_sea_priority_pool_random_value = irandom(array_length(temp_sea_priority_pool_array) - 1);
									var temp_sea_priority_pool_random_subunit_inst = array_get(temp_sea_priority_pool_array, temp_sea_priority_pool_random_value);
									
									// Check if Random Sub-Unit Exists
									if (instance_exists(temp_sea_priority_pool_random_subunit_inst))
									{
										// Set Battle Matchup's Defending Sub-Unit Properties
										temp_battle_matchup_struct.defending_subunit = array_get(temp_sea_priority_pool_array, temp_sea_priority_pool_random_value);
										temp_battle_matchup_struct.defending_faction_index = temp_battle_hostile_faction_index;
										
										// Toggle Matchup Found
										temp_matchup_exists = true;
										
										// Matchup was found - Exit Sea Priority Pool Sub-Unit Search
										break;
									}
								}
								
								// Check if Matchup was Found
								if (temp_matchup_exists)
								{
									// Exit searching across Sub-Unit's Hostile Factions Priority Pools
									break;
								}
							}
						}
						
						// Increment Priority Pool Search Index
						temp_battle_priority_pool_search_index++;
						temp_battle_priority_pool_search_index = temp_battle_priority_pool_search_index mod CelestialBattlePriorityRankMax;
					}
					
					// Check if Matchup was Found
					if (temp_matchup_exists)
					{
						// Exit searching across Sub-Unit's Hostile Factions Priority Pools
						break;
					}
					
					// Increment Randomized Hostile Factions Index
					temp_randomized_hostile_factions_index++;
				}
				
				// Delete Unused Array
				array_resize(temp_battle_matchup_hostile_factions_array, 0);
			}
		}
		else
		{
			// Defending Sub-Unit Exists
			temp_matchup_exists = true;
		}
		
		// Check if Matchup was Found
		if (!temp_matchup_exists)
		{
			// Toggle to Skip Matchup in future Battle Round Calculations
			temp_battle_matchup_struct.skip_matchup = true;
			
			// Set Matchup Defending Variables as Empty
			temp_battle_matchup_struct.defending_subunit = noone;
			temp_battle_matchup_struct.defending_faction_index = -1;
		}
		else
		{
			// Perform Matchup Combat Behaviour
			var temp_defending_subunit_destroyed = false;
			
			// Calculate Sub-Unit's Accuracy Hit Percentage
			var temp_attacking_accuracy_hit_percentage = clamp(0.5 + (temp_battle_matchup_struct.attacking_subunit.unit_accuracy - temp_battle_matchup_struct.defending_subunit.unit_evasion) * 0.05, 0, 1);
			
			// Calculate Damage to Micro-Units
			var temp_attacking_microunit_index = 0;
			
			repeat (temp_battle_matchup_struct.attacking_subunit.micro_unit_count)
			{
				// Iterate through Micro-Unit's Attacks
				repeat (temp_battle_matchup_struct.attacking_subunit.unit_attack_count)
				{
					// Check if Defending Micro-Units still Exist
					if (temp_battle_matchup_struct.defending_subunit.micro_unit_count <= 0)
					{
						break;
					}
					
					// Select random Defending Micro-Unit
					var temp_random_defending_microunit_index = irandom_range(0, temp_battle_matchup_struct.defending_subunit.micro_unit_count - 1);
					
					// Perform Micro-Unit's Attack on random Defending Micro-Unit
					var temp_micro_unit_health = array_get(temp_battle_matchup_struct.defending_subunit.micro_unit_health, temp_random_defending_microunit_index);
					var temp_micro_unit_armor = array_get(temp_battle_matchup_struct.defending_subunit.micro_unit_armor, temp_random_defending_microunit_index);
					
					// Check if Attack hits Defending Sub-Unit
					if (random(1.0) <= temp_attacking_accuracy_hit_percentage)
					{
						// Attack Hits
						var temp_health_attack_value = 0;
						var temp_armor_attack_value = 0;
						
						// Calculate Attack 
						var temp_attacking_attack = celestial_unit_attack_stat_to_value_conversion(temp_battle_matchup_struct.attacking_subunit.unit_attack);
						
						// Attack Hits
						if (temp_micro_unit_armor > 0)
						{
							// Calculate Attack Effect on Defending Micro-Unit Armor
							if (temp_attacking_attack > temp_micro_unit_armor * 2)
							{
								// Attack fucking shreds through Armor
								temp_health_attack_value = temp_attacking_attack;
								temp_armor_attack_value = temp_attacking_attack * 0.15;
							}
							if (temp_attacking_attack < temp_micro_unit_armor)
							{
								// Attack ineffective against Armor - Attack to Armor Penalty
								temp_armor_attack_value = temp_attacking_attack * 0.333;
							}
							else 
							{
								// Attack effective against Armor - Attack damages and penetrates Armor with a chance to damage Health as well
								temp_health_attack_value = random(1) < 0.5 ? temp_attacking_attack * random_range(0.25, 0.5) : temp_health_attack_value;
								temp_armor_attack_value = temp_attacking_attack * 0.25;
							}
						}
						else
						{
							// Unarmored Unit Damage
							temp_health_attack_value = temp_attacking_attack;
						}
						
						// Calculate Micro Unit Health & Armor post attack
						temp_micro_unit_health = clamp(temp_micro_unit_health - temp_health_attack_value, 0, temp_battle_matchup_struct.defending_subunit.unit_health);
						temp_micro_unit_armor = clamp(temp_micro_unit_armor - temp_armor_attack_value, 0, celestial_unit_armor_stat_to_value_conversion(temp_battle_matchup_struct.defending_subunit.unit_armor));
						
						// Set Micro Unit Health & Armor Values
						array_set(temp_battle_matchup_struct.defending_subunit.micro_unit_health, temp_random_defending_microunit_index, temp_micro_unit_health);
						array_set(temp_battle_matchup_struct.defending_subunit.micro_unit_armor, temp_random_defending_microunit_index, temp_micro_unit_armor);
						
						// Check if Micro-Unit was Destroyed
						if (temp_micro_unit_armor <= 0)
						{
							// Destroy Micro-Unit Behaviour
							temp_battle_matchup_struct.defending_subunit.micro_unit_count--;
							array_delete(temp_battle_matchup_struct.defending_subunit.micro_unit_health, temp_random_defending_microunit_index, 1);
							array_delete(temp_battle_matchup_struct.defending_subunit.micro_unit_armor, temp_random_defending_microunit_index, 1);
						}
					}
				}
				
				// Check if Defending Micro-Units still Exist
				if (temp_battle_matchup_struct.defending_subunit.micro_unit_count <= 0)
				{
					// Defending Sub-Unit was Destroyed
					temp_defending_subunit_destroyed = true;
					
					// Destroy Sub-Unit Behaviour
					instance_destroy(temp_battle_matchup_struct.defending_subunit);
					
					// Set Matchup Defending Variables as Empty
					temp_battle_matchup_struct.defending_subunit = noone;
					temp_battle_matchup_struct.defending_faction_index = -1;
					break;
				}
				
				// Increment Micro-Unit Index
				temp_attacking_microunit_index++;
			}
			
			// Check if Combat is still on-going
			if (!temp_defending_subunit_destroyed)
			{
				temp_battle_combat_ongoing = true;
			}
		}
		
		// Decrement Battle Matchup Index
		temp_battle_matchup_index--;
	}
	
	// Check if Combat is Ongoing
	if (!temp_battle_combat_ongoing)
	{
		// End Battle Behaviour
		battle_instance.battle_exists = false;
	}
}

function celestial_battle_add_choreography_actor(battle_instance, actor_subunit_instance)
{
	// Establish Actor Battle Platform Side & Faction
	var temp_actor_platform_side = CelestialBattlePlatformSide.None;
	var temp_actor_faction_instance = instance_exists(actor_subunit_instance.unit_instance) ? actor_subunit_instance.unit_instance.unit_faction : noone;
	
	// Check what Battle Platform Side the Actor is participating on
	if (temp_actor_faction_instance == CelestialSimulator.player_faction)
	{
		// Establish Actor Battle Platform Side
		temp_actor_platform_side = CelestialBattlePlatformSide.Left;
	}
	else if (instance_exists(temp_actor_faction_instance) and instance_exists(CelestialSimulator.player_faction))
	{
		// Check the Player Faction's Relationship with the Actor Faction
		var temp_player_faction_hostile_check = ds_map_find_value(CelestialSimulator.player_faction.relationships, temp_actor_faction_instance) == CelestialFactionRelationshipType.Hostile;
		var temp_actor_faction_hostile_check = ds_map_find_value(temp_actor_faction_instance.relationships, CelestialSimulator.player_faction) == CelestialFactionRelationshipType.Hostile;
		
		var temp_player_faction_allied_check = ds_map_find_value(CelestialSimulator.player_faction.relationships, temp_actor_faction_instance) == CelestialFactionRelationshipType.Allied;
		var temp_actor_faction_allied_check = ds_map_find_value(temp_actor_faction_instance.relationships, CelestialSimulator.player_faction) == CelestialFactionRelationshipType.Allied;
		
		// Establish Actor Battle Platform Side
		if (temp_player_faction_hostile_check or temp_actor_faction_hostile_check)
		{
			temp_actor_platform_side = CelestialBattlePlatformSide.Right;
		}
		else if (temp_player_faction_allied_check or temp_actor_faction_allied_check)
		{
			temp_actor_platform_side = CelestialBattlePlatformSide.Left;
		}
	}
	else if (instance_exists(CelestialSimulator.player_faction))
	{
		// Check the Player Faction's Relationship with the Actor Faction
		var temp_player_faction_null_faction_hostile_check = ds_map_find_value(CelestialSimulator.player_faction.relationships, temp_actor_faction_instance) == CelestialFactionRelationshipType.Hostile;
		var temp_player_faction_null_faction_allied_check = ds_map_find_value(CelestialSimulator.player_faction.relationships, temp_actor_faction_instance) == CelestialFactionRelationshipType.Allied;
		
		// Establish Actor Battle Platform Side
		if (temp_player_faction_null_faction_hostile_check)
		{
			temp_actor_platform_side = CelestialBattlePlatformSide.Right;
		}
		else if (temp_player_faction_null_faction_allied_check)
		{
			temp_actor_platform_side = CelestialBattlePlatformSide.Left;
		}
	}
	
	// Check if Actor is participating in the Battle's Choreography
	if (temp_actor_platform_side != CelestialBattlePlatformSide.None)
	{
		// Initialize Actor Struct
		var temp_actor_struct =
		{
			actor_subunit: actor_subunit_instance,
			actor_faction: temp_actor_faction_instance,
			actor_platform_side: temp_actor_platform_side,
			actor_priority_rank: actor_subunit_instance.unit_priority_rank,
			actor_vertical_tile: 0,
			actor_vertical_depth: 0,
			actor_battle_sprite: actor_subunit_instance.unit_battle_sprite,
			actor_micro_unit_count: actor_subunit_instance.micro_unit_count,
		};
		
		// Increment Battle's Vertical Tile Count for Choreography Actor Vertical Placement
		if (temp_actor_platform_side == CelestialBattlePlatformSide.Left)
		{
			var temp_battle_choreography_actors_battle_column_size_left = array_get(battle_instance.battle_choreography_actors_battle_column_sizes, actor_subunit_instance.unit_priority_rank);
			array_set(battle_instance.battle_choreography_actors_battle_column_sizes, actor_subunit_instance.unit_priority_rank, temp_battle_choreography_actors_battle_column_size_left + 1);
		}
		else if (temp_actor_platform_side == CelestialBattlePlatformSide.Right)
		{
			var temp_battle_choreography_actors_battle_column_size_right = array_get(battle_instance.battle_choreography_actors_battle_column_sizes, (CelestialBattlePriorityRankMax * 2) - 1 - actor_subunit_instance.unit_priority_rank);
			array_set(battle_instance.battle_choreography_actors_battle_column_sizes, (CelestialBattlePriorityRankMax * 2) - 1 - actor_subunit_instance.unit_priority_rank, temp_battle_choreography_actors_battle_column_size_right + 1);
		}
		
		// Index Actor Struct into Battle's Choreography Actors Array
		array_push(battle_instance.battle_choreography_actors, temp_actor_struct);
	}
}

function celestial_battle_depth_sort_choreography_actors(battle_instance)
{
	// Check if Celestial Battle should perform Depth Sort for the Battle's Choreography Actors Arrays and Data Structures
	if (!instance_exists(CelestialSimulator.player_faction) or array_get_index(battle_instance.battle_factions, CelestialSimulator.player_faction) == -1)
	{
		return;
	}
	
	// Create and Populate Battle Choreography's Column Possible Positions Array with Possible Positions
	var temp_battle_choreography_actors_battle_column_possible_positions = array_create(0);
	var temp_battle_choreography_actors_battle_column_sizes_index = 0;
	
	repeat (array_length(battle_instance.battle_choreography_actors_battle_column_sizes))
	{
		// Find Battle Column's Size
		var temp_battle_column_size = max(battle_instance.battle_choreography_actors_battle_column_sizes[temp_battle_choreography_actors_battle_column_sizes_index], CelestialSimulator.battle_default_column_size);
		
		// Update Battle's Column Size
		battle_instance.battle_choreography_actors_battle_column_sizes[temp_battle_choreography_actors_battle_column_sizes_index] = temp_battle_column_size;
		
		// Create and Populate Battle Column Possible Positions Array with Possible Positions
		var temp_battle_column_possible_positions_array = array_create(temp_battle_column_size);
		var temp_battle_column_possible_positions_index = 0;
		
		repeat (temp_battle_column_size)
		{
			temp_battle_column_possible_positions_array[temp_battle_column_possible_positions_index] = temp_battle_column_possible_positions_index;
		}
		
		// Add Battle Column Possible Positions Array to Battle Choreography's Column Possible Positions Array
		array_push(temp_battle_choreography_actors_battle_column_possible_positions, temp_battle_column_possible_positions_array);
		
		// Increment Battle Choreography Column Sizes Index
		temp_battle_choreography_actors_battle_column_sizes_index++;
	}
	
	// Increment through Battle's Choreography Actors Array
	var temp_battle_choreography_actors_count = array_length(battle_instance.battle_choreography_actors);
	var temp_battle_choreography_actors_index = 0;
	
	repeat (temp_battle_choreography_actors_count)
	{
		// Find Battle Choreography Actor Struct
		var temp_battle_choreography_actor_struct = array_get(battle_instance.battle_choreography_actors, temp_battle_choreography_actors_index);
		
		// Assign Random Vertical Column Position
		var temp_battle_actor_column_index = temp_battle_choreography_actor_struct.actor_platform_side == CelestialBattlePlatformSide.Left ? temp_battle_choreography_actor_struct.actor_priority_rank : (CelestialBattlePriorityRankMax * 2) - 1 - temp_battle_choreography_actor_struct.actor_priority_rank;
		var temp_battle_actor_column_size = battle_instance.battle_choreography_actors_battle_column_sizes[temp_battle_actor_column_index];
		var temp_battle_actor_column_possible_positions_array = array_get(temp_battle_choreography_actors_battle_column_possible_positions, temp_battle_actor_column_index);
		var temp_random_column_possible_positions_index = irandom(array_length(temp_battle_actor_column_possible_positions_array) - 1);
		temp_battle_choreography_actor_struct.actor_vertical_tile = temp_battle_actor_column_possible_positions_array[temp_random_column_possible_positions_index];
		array_delete(temp_battle_actor_column_possible_positions_array, temp_random_column_possible_positions_index, 1);
		
		// Calculate the Battle Column's Vertical Alignment
		var temp_battle_column_start = 0;
		var temp_battle_tile_height = 1 / temp_battle_actor_column_size;
		
		if (temp_battle_actor_column_size == CelestialSimulator.battle_default_column_size - 1)
		{
			// Battle Column Size is one less than the Default Size - Shift vertical alignment slightly up to preserve the Isosceles Trapezoid Perspective
			temp_battle_column_start = 0.5 - (temp_battle_tile_height * temp_battle_actor_column_size * 0.5) - temp_battle_tile_height * 0.25;
		}
		else if (temp_battle_actor_column_size < CelestialSimulator.battle_default_column_size)
		{
			// Battle Column Size is less than the Default Size - Shift vertical alignment by one tile's height up to preserve the Isosceles Trapezoid Perspective
			temp_battle_column_start = 0.5 - (temp_battle_tile_height * temp_battle_actor_column_size * 0.5) - temp_battle_tile_height * 0.5;
		}
		
		// Update Battle Actor's Vertical Depth
		temp_battle_choreography_actor_struct.actor_vertical_depth = temp_battle_column_start + (temp_battle_choreography_actor_struct.actor_vertical_tile * temp_battle_tile_height);
		
		// Increment Battle Choreography Actors Index
		temp_battle_choreography_actors_index++;
	}
	
	// Sort Battle's Choreography Actors Array by Vertical Depth
	array_sort(battle_instance.battle_choreography_actors, celestial_battle_choreography_actors_sort);
	
	// Iterate through Battle's Choreography Actors and Index them into Battle Choreography Actors DS Map
	temp_battle_choreography_actors_index = 0;
	
	repeat (temp_battle_choreography_actors_count)
	{
		// Index Battle Choreography Actor into Battle Choreography Actors DS Map
		ds_map_add(battle_instance.battle_choreography_actors_map, battle_instance.battle_choreography_actors[temp_battle_choreography_actors_index].actor_subunit, temp_battle_choreography_actors_index);
		
		// Increment Battle Choreography Actors Index
		temp_battle_choreography_actors_index++;
	}
	
	// Cleanup Unused Battle Choreography's Column Possible Positions Array
	temp_battle_choreography_actors_battle_column_sizes_index = 0;
	
	repeat (array_length(battle_instance.battle_choreography_actors_battle_column_sizes))
	{
		// Clear Unused Array
		array_resize(temp_battle_choreography_actors_battle_column_possible_positions[temp_battle_choreography_actors_battle_column_sizes_index], 0);
		
		// Increment Battle Choreography Column Sizes Index
		temp_battle_choreography_actors_battle_column_sizes_index++;
	}
	
	array_resize(temp_battle_choreography_actors_battle_column_possible_positions, 0);
}

function celestial_battle_add_choreography_action(battle_instance)
{
	
}

function celestial_battle_clear_choreography_actors(battle_instance)
{
	// Check if Celestial Battle Instance Exists
	if (!instance_exists(battle_instance))
	{
		return;
	}
	
	// Increment through Battle's Choreography Actors Array and Erase Battle's Choreography Actors Structs
	var temp_battle_choreography_actors_count = array_length(battle_instance.battle_choreography_actors);
	var temp_battle_choreography_actors_index = temp_battle_choreography_actors_count - 1;
	
	repeat (temp_battle_choreography_actors_count)
	{
		// Delete Battle Choreography Actors Struct
		delete battle_instance.battle_choreography_actors[temp_battle_choreography_actors_index];
		
		// Decrement Battle Choreography Actors Index
		temp_battle_choreography_actors_index--;
	}
	
	array_resize(battle_instance.battle_choreography_actors, 0);
	
	// Clear Battle Choreography Actors Battle Column Sizes Array
	array_resize(battle_instance.battle_choreography_actors_battle_column_sizes, 0);
	
	// Clear Battle's Choreography Actors DS Map
	ds_map_clear(battle_instance.battle_choreography_actors_map);
}

function celestial_battle_clear_choreography_actions(battle_instance)
{
	// Check if Celestial Battle Instance Exists
	if (!instance_exists(battle_instance))
	{
		return;
	}
	
	// Increment through Battle's Choreography Actions Array and Erase Battle's Choreography Actions Structs
	var temp_battle_choreography_actions_count = array_length(battle_instance.battle_choreography_actions);
	var temp_battle_choreography_actions_index = temp_battle_choreography_actions_count - 1;
	
	repeat (temp_battle_choreography_actions_count)
	{
		// Delete Battle Choreography Actions Struct
		delete battle_instance.battle_choreography_actions[temp_battle_choreography_actions_index];
		
		// Decrement Battle Choreography Actions Index
		temp_battle_choreography_actions_index--;
	}
	
	array_resize(battle_instance.battle_choreography_actions, 0);
}

function celestial_battle_check_participation(battle_instance)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		return;
	}
	
	// Cleanup Battle's unused Priority Rank Pool Sub-Units 
	var temp_battle_faction_count = array_length(battle_instance.battle_factions);
	var temp_battle_faction_index = temp_battle_faction_count - 1;
	
	repeat (temp_battle_faction_count)
	{
		// Find Battle Faction Arrays
		var temp_battle_faction_units = array_get(battle_instance.battle_units, temp_battle_faction_index);
		
		var temp_battle_faction_land_priority_pool = array_get(battle_instance.battle_land_priority_pools, temp_battle_faction_index);
		var temp_battle_faction_air_priority_pool = array_get(battle_instance.battle_air_priority_pools, temp_battle_faction_index);
		var temp_battle_faction_sea_priority_pool = array_get(battle_instance.battle_sea_priority_pools, temp_battle_faction_index);
		
		// Iterate through Battle Faction's Priority Pools
		var temp_battle_faction_priority_rank_index = 0;
		
		repeat (CelestialBattlePriorityRankMax)
		{
			// Establish Priority Rank Terrain Sub-Unit Pool Arrays
			var temp_battle_faction_land_priority_rank_pool_array = array_get(temp_battle_faction_land_priority_pool, temp_battle_faction_priority_rank_index);
			var temp_battle_faction_air_priority_rank_pool_array = array_get(temp_battle_faction_air_priority_pool, temp_battle_faction_priority_rank_index);
			var temp_battle_faction_sea_priority_rank_pool_array = array_get(temp_battle_faction_sea_priority_pool, temp_battle_faction_priority_rank_index);
			
			// Iterate through Land Priority Rank Sub-Unit Arrays
			var temp_battle_land_pool_count = array_length(temp_battle_faction_land_priority_rank_pool_array);
			var temp_battle_land_pool_index = temp_battle_land_pool_count - 1;
			
			repeat (temp_battle_land_pool_count)
			{
				// Find Sub-Unit Instance
				var temp_battle_land_pool_subunit_inst = array_get(temp_battle_faction_land_priority_rank_pool_array, temp_battle_land_pool_index);
				
				// Check if Sub-Unit is participating in Battle
				if (!array_contains(temp_battle_faction_units, temp_battle_land_pool_subunit_inst.unit_instance))
				{
					// Sub-Unit is NOT participating - Delete Sub-Unit from Priority Rank Sub-Unit Pool Array
					array_delete(temp_battle_faction_land_priority_rank_pool_array, temp_battle_land_pool_index, 1);
				}
				
				// Decrement Land Pool Index
				temp_battle_land_pool_index--;
			}
			
			// Iterate through Air Priority Rank Sub-Unit Arrays
			var temp_battle_air_pool_count = array_length(temp_battle_faction_air_priority_rank_pool_array);
			var temp_battle_air_pool_index = temp_battle_air_pool_count - 1;
			
			repeat (temp_battle_air_pool_count)
			{
				// Find Sub-Unit Instance
				var temp_battle_air_pool_subunit_inst = array_get(temp_battle_faction_air_priority_rank_pool_array, temp_battle_air_pool_index);
				
				// Check if Sub-Unit is participating in Battle
				if (!array_contains(temp_battle_faction_units, temp_battle_air_pool_subunit_inst.unit_instance))
				{
					// Sub-Unit is NOT participating - Delete Sub-Unit from Priority Rank Sub-Unit Pool Array
					array_delete(temp_battle_faction_air_priority_rank_pool_array, temp_battle_air_pool_index, 1);
				}
				
				// Decrement Air Pool Index
				temp_battle_air_pool_index--;
			}
			
			// Iterate through Sea Priority Rank Sub-Unit Arrays
			var temp_battle_sea_pool_count = array_length(temp_battle_faction_sea_priority_rank_pool_array);
			var temp_battle_sea_pool_index = temp_battle_sea_pool_count - 1;
			
			repeat (temp_battle_sea_pool_count)
			{
				// Find Sub-Unit Instance
				var temp_battle_sea_pool_subunit_inst = array_get(temp_battle_faction_sea_priority_rank_pool_array, temp_battle_sea_pool_index);
				
				// Check if Sub-Unit is participating in Battle
				if (!array_contains(temp_battle_faction_units, temp_battle_sea_pool_subunit_inst.unit_instance))
				{
					// Sub-Unit is NOT participating - Delete Sub-Unit from Priority Rank Sub-Unit Pool Array
					array_delete(temp_battle_faction_sea_priority_rank_pool_array, temp_battle_sea_pool_index, 1);
				}
				
				// Decrement Sea Pool Index
				temp_battle_sea_pool_index--;
			}
			
			// Increment Battle Faction's Priority Rank Index
			temp_battle_faction_priority_rank_index++;
		}
		
		// Decrement Battle Faction Index
		temp_battle_faction_index--;
	}
	
	// Iterate through and initialize Sub-Unit Matchups
	var temp_battle_matchup_count = array_length(battle_instance.battle_matchups);
	var temp_battle_matchup_index = temp_battle_matchup_count - 1;
	
	repeat (temp_battle_matchup_count)
	{
		// Find Battle Matchup Struct
		var temp_battle_matchup_struct = array_get(battle_instance.battle_matchups, temp_battle_matchup_index);
		
		// Establish Attacking Sub-Unit Check Variable
		var temp_attacking_subunit_exists = true;
		
		// Check if Attacking Sub-Unit Exists
		if (!instance_exists(temp_battle_matchup_struct.attacking_subunit))
		{
			temp_attacking_subunit_exists = false;
		}
		else if (instance_exists(temp_battle_matchup_struct.attacking_subunit.unit_instance))
		{
			if (array_get_index(battle_instance.battle_factions, temp_battle_matchup_struct.attacking_subunit.unit_instance.unit_faction) == -1)
			{
				temp_attacking_subunit_exists = false;
			}
			else if (array_get_index(array_get(battle_instance.battle_units, array_get_index(battle_instance.battle_factions, temp_battle_matchup_struct.attacking_subunit.unit_instance.unit_faction)), temp_battle_matchup_struct.attacking_subunit.unit_instance) == -1)
			{
				temp_attacking_subunit_exists = false;
			}
		}
		
		// Check if Battle Matchup Structs are Valid
		if (!temp_attacking_subunit_exists)
		{
			// Delete Matchup from Battle Matchups Array
			array_delete(battle_instance.battle_matchups, temp_battle_matchup_index, 1);
			
			// Destroy Battle Matchup Struct
			delete temp_battle_matchup_struct;
		}
		else
		{
			// Establish Defending Sub-Unit Check Variable
			var temp_defending_subunit_exists = true;
			
			// Check if Defending Sub-Unit Exists
			if (!instance_exists(temp_battle_matchup_struct.defending_subunit))
			{
				temp_defending_subunit_exists = false;
			}
			else if (instance_exists(temp_battle_matchup_struct.defending_subunit.unit_instance))
			{
				if (array_get_index(battle_instance.battle_factions, temp_battle_matchup_struct.defending_subunit.unit_instance.unit_faction) == -1)
				{
					temp_defending_subunit_exists = false;
				}
				else if (array_get_index(array_get(battle_instance.battle_units, array_get_index(battle_instance.battle_factions, temp_battle_matchup_struct.defending_subunit.unit_instance.unit_faction)), temp_battle_matchup_struct.defending_subunit.unit_instance) == -1)
				{
					temp_defending_subunit_exists = false;
				}
			}
			
			// Check to delete Defending Sub-Unit from Battle Matchup
			if (!temp_defending_subunit_exists)
			{
				// Remove Defending Sub-Unit from Battle Matchup Struct
				temp_battle_matchup_struct.defending_subunit = noone;
				temp_battle_matchup_struct.defending_faction_index = -1;
			}
		}
		
		// Decrement Battle Matchup Index
		temp_battle_matchup_index--;
	}
}

