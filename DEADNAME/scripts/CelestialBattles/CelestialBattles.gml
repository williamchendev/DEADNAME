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

enum CelestialBattleChoreographyObjectType
{
	Actor,
	Prop,
	LinearProjectile,
	ArcProjectile,
	SmokeParticle
}

// Celestial Battle Sorting Functions
function celestial_battle_matchup_sort(current, next) 
{
	return next.attacking_combat_unit.unit_priority_rank == current.attacking_combat_unit.unit_priority_rank ? (next.attacking_combat_unit.unit_agility > current.attacking_combat_unit.unit_agility ? -1 : 1) : (next.attacking_combat_unit.unit_priority_rank < current.attacking_combat_unit.unit_priority_rank ? -1 : 1);
}

/// @function celestial_battle_create(celestial_object);
/// @description Creates and returns a Celestial Battle Instance within the Celestial Simulation with the given Celestial Object Instance
/// @param {real:Id.Instance} celestial_object The Celestial Object Instance the Celestial Battle will belong to
/// @returns {real:Id.Instance} Returns a Celestial Battle Instance
function celestial_battle_create(celestial_object)
{
	// Create Celestial Battle Instance
	var temp_celestial_battle_instance = instance_create_depth(0, 0, 0, oCelestialBattle);
	
	// Update Celestial Battle's Celestial Body Instance
	temp_celestial_battle_instance.celestial_body_instance = celestial_object;
	
	// Calculate Combat Engagement Threshold
	temp_celestial_battle_instance.battle_near_collision_threshold = cos(temp_celestial_battle_instance.battle_near_collision_radius / celestial_object.radius);
	temp_celestial_battle_instance.battle_far_collision_threshold = cos(temp_celestial_battle_instance.battle_far_collision_radius / celestial_object.radius);
	
	// Index Celestial Battle Instance in Celestial Object Battle Array
	array_push(celestial_object.battles, temp_celestial_battle_instance);
	
	// Return Celestial Battle Instance
	return temp_celestial_battle_instance;
}

/// @function celestial_battle_add_unit(battle_instance, unit_instance);
/// @description Adds a given Celestial Unit Instance to the ongoing Battle with the given Celestial Battle Instance (this function prevents Celestial Units from being redundantly "double added" to the Celestial Battle)
/// @param {oCelestialBattle} battle_instance The Celestial Battle the given Celestial Unit Instance will be added to
/// @param {real:Id.Instance} unit_instance The Celestial Unit Instance that will be added to the given Celestial Battle Instance
function celestial_battle_add_unit(battle_instance, unit_instance)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		// Battle Instance does not exist - Early Exit
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
		
		// Index New Celestial Battle Faction's Unit
		array_push(battle_instance.battle_units, array_create(0));
		
		// Initialize Empty Battle Priority Pools
		var temp_faction_battle_land_priority_pool = array_create(CelestialBattlePriorityRankMax);
		var temp_faction_battle_air_priority_pool = array_create(CelestialBattlePriorityRankMax);
		var temp_faction_battle_sea_priority_pool = array_create(CelestialBattlePriorityRankMax);
		
		// Iterate through Battle Priority Pools to create Empty Combat Unit Arrays
		var temp_priority_rank_index = 0;
		
		repeat (CelestialBattlePriorityRankMax)
		{
			// Create and Index Empty Priority Rank Combat Unit Array
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
	else if (array_get_index(battle_instance.battle_units[temp_unit_faction_index], unit_instance) != -1)
	{
		// Unit already Exists in Battle Instance - Early Exit
		return;
	}
	
	// Index the Unit Instance within the Celestial Battle's Units Array
	array_push(battle_instance.battle_units[temp_unit_faction_index], unit_instance);
	
	// Update that Unit Instance has entered Combat
	unit_instance.engaged_in_battle = true;
	
	// Update Unit Instance's Battle Popup
	unit_instance.emotion_battle_popup_timer = unit_instance.emotion_battle_popup_duration;
	
	// Randomize Unit Instance's Collision Check Timer
	unit_instance.collision_check_timer = random(CelestialSimulator.global_collision_check_interval);
}

/// @function celestial_battle_shuffle_round(battle_instance);
/// @description Initializes a Celestial Battle's Round by shuffling and randomly selecting available Celestial Units from the Celestial Battle's Faction Unit Pools and sorting them into Priority Rank Arrays to determine the Battle's Matchups between opposing Celestial Factions and their Units
/// @param {oCelestialBattle} battle_instance The Celestial Battle that will perform the Round Shuffle Behaviour
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
	var temp_battle_choreography_actors_battle_column_sizes_index = 0;
	
	repeat (CelestialBattlePriorityRankMax * 2)
	{
		battle_instance.battle_choreography_actors_battle_column_sizes[temp_battle_choreography_actors_battle_column_sizes_index] = 0;
		temp_battle_choreography_actors_battle_column_sizes_index++;
	}
	
	// Calculate Battle Instance's Terrain Combat Size
	var temp_battle_land_combat_size = 70;
	var temp_battle_air_combat_size = 70;
	var temp_battle_sea_combat_size = 70;
	
	/*
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
	*/
	
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
		if (!instance_exists(battle_instance.battle_factions[temp_battle_faction_cleanup_index]) or array_length(battle_instance.battle_units[temp_battle_faction_cleanup_index]) <= 0)
		{
			// Find Battle Faction Arrays
			var temp_battle_faction_cleanup_land_priority_pool = array_get(battle_instance.battle_land_priority_pools, temp_battle_faction_cleanup_index);
			var temp_battle_faction_cleanup_air_priority_pool = array_get(battle_instance.battle_air_priority_pools, temp_battle_faction_cleanup_index);
			var temp_battle_faction_cleanup_sea_priority_pool = array_get(battle_instance.battle_sea_priority_pools, temp_battle_faction_cleanup_index);
			
			// Empty Battle Faction's Priority Pools
			var temp_battle_faction_cleanup_priority_rank_index = 0;
			
			repeat (CelestialBattlePriorityRankMax)
			{
				// Empty Priority Rank Combat Unit Array
				array_resize(array_get(temp_battle_faction_cleanup_land_priority_pool, temp_battle_faction_cleanup_priority_rank_index), 0);
				array_resize(array_get(temp_battle_faction_cleanup_air_priority_pool, temp_battle_faction_cleanup_priority_rank_index), 0);
				array_resize(array_get(temp_battle_faction_cleanup_sea_priority_pool, temp_battle_faction_cleanup_priority_rank_index), 0);
				
				// Increment Battle Faction's Priority Rank Index
				temp_battle_faction_cleanup_priority_rank_index++;
			}
			
			// Resize Unused Arrays
			array_resize(array_get(battle_instance.battle_units, temp_battle_faction_cleanup_index), 0);
			
			array_resize(temp_battle_faction_cleanup_land_priority_pool, 0);
			array_resize(temp_battle_faction_cleanup_air_priority_pool, 0);
			array_resize(temp_battle_faction_cleanup_sea_priority_pool, 0);
			
			// Delete Battle Faction from Battle Instance
			array_delete(battle_instance.battle_factions, temp_battle_faction_cleanup_index, 1);
			array_delete(battle_instance.battle_units, temp_battle_faction_cleanup_index, 1);
			array_delete(battle_instance.battle_land_priority_pools, temp_battle_faction_cleanup_index, 1);
			array_delete(battle_instance.battle_air_priority_pools, temp_battle_faction_cleanup_index, 1);
			array_delete(battle_instance.battle_sea_priority_pools, temp_battle_faction_cleanup_index, 1);
		}
		
		// Decrement Battle Faction Index
		temp_battle_faction_cleanup_index--;
	}
	
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
		
		var temp_battle_faction_land_priority_pool = array_get(battle_instance.battle_land_priority_pools, temp_battle_faction_index);
		var temp_battle_faction_air_priority_pool = array_get(battle_instance.battle_air_priority_pools, temp_battle_faction_index);
		var temp_battle_faction_sea_priority_pool = array_get(battle_instance.battle_sea_priority_pools, temp_battle_faction_index);
		
		// Empty Battle Faction's Priority Pools
		var temp_battle_faction_priority_rank_index = 0;
		
		repeat (CelestialBattlePriorityRankMax)
		{
			// Empty Priority Rank Combat Unit Array
			array_resize(array_get(temp_battle_faction_land_priority_pool, temp_battle_faction_priority_rank_index), 0);
			array_resize(array_get(temp_battle_faction_air_priority_pool, temp_battle_faction_priority_rank_index), 0);
			array_resize(array_get(temp_battle_faction_sea_priority_pool, temp_battle_faction_priority_rank_index), 0);
			
			// Increment Battle Faction's Priority Rank Index
			temp_battle_faction_priority_rank_index++;
		}
		
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
					
					// Check if Faction Relationship Status is Hostile
					if (temp_faction_hostile_check)
					{
						// Increase Faction Hostile Relationships Count
						temp_faction_hostile_relationships_count++;
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
		
		// Initialize Faction Indexes & Combat Unit Pools
		var temp_land_indexes_pool = array_create(0);
		var temp_air_indexes_pool = array_create(0);
		var temp_sea_indexes_pool = array_create(0);
		
		var temp_land_combat_unit_pool = array_create(0);
		var temp_air_combat_unit_pool = array_create(0);
		var temp_sea_combat_unit_pool = array_create(0);
		
		// Populate Faction Combat Unit Pools
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
			
			// Iterate through Battle Unit's Combat Units Array
			var temp_battle_unit_combat_unit_count = array_length(temp_battle_unit_instance.combat_units);
			var temp_battle_unit_combat_unit_index = temp_battle_unit_combat_unit_count - 1;
			
			repeat (temp_battle_unit_combat_unit_count)
			{
				// Find Combat Unit Instance
				var temp_battle_unit_combat_unit_instance = temp_battle_unit_instance.combat_units[temp_battle_unit_combat_unit_index];
				
				// Check if Combat Unit Instance Exists
				if (!instance_exists(temp_battle_unit_combat_unit_instance))
				{
					// Battle Unit's Combat Unit Instance does not exist - Remove Battle Unit's Combat Unit Instance from Battle Unit's Combat Unit Array
					array_delete(temp_battle_unit_instance.combat_units, temp_battle_unit_combat_unit_index, 1);
					
					// Decrement Battle Unit's Combat Unit Index
					temp_battle_unit_combat_unit_index--;
					
					// Skip to next Battle Unit's Combat Unit Instance
					continue;
				}
				
				// Check if Combat Unit engages in Combat
				if (global.celestial_combat_units[temp_battle_unit_combat_unit_instance.combat_unit_type].unit_combat_attendance)
				{
					// Combat Unit has mandatory Combat Attendance - Add Combat Unit to Battle Faction's Priority Pools directly
					switch (global.celestial_combat_units[temp_battle_unit_combat_unit_instance.combat_unit_type].unit_terrain_type)
					{
						case CelestialTerrainType.Land:
							// Add Combat Unit to Battle Faction's Land Priority Rank Combat Unit Pools
							array_push(array_get(temp_battle_faction_land_priority_pool, global.celestial_combat_units[temp_battle_unit_combat_unit_instance.combat_unit_type].unit_priority_rank), temp_battle_unit_combat_unit_instance);
							temp_faction_land_combat_size -= global.celestial_combat_units[temp_battle_unit_combat_unit_instance.combat_unit_type].unit_size;
							
							// Add Combat Unit to Battle Choreography as an Actor
							celestial_battle_add_choreography_actor(battle_instance, temp_battle_unit_combat_unit_instance);
							break;
						case CelestialTerrainType.Air:
							// Add Combat Unit to Battle Faction's Air Priority Rank Combat Unit Pools
							array_push(array_get(temp_battle_faction_air_priority_pool, global.celestial_combat_units[temp_battle_unit_combat_unit_instance.combat_unit_type].unit_priority_rank), temp_battle_unit_combat_unit_instance);
							temp_faction_air_combat_size -= global.celestial_combat_units[temp_battle_unit_combat_unit_instance.combat_unit_type].unit_size;
							
							// Add Combat Unit to Battle Choreography as an Actor
							celestial_battle_add_choreography_actor(battle_instance, temp_battle_unit_combat_unit_instance);
							break;
						case CelestialTerrainType.Sea:
							// Add Combat Unit to Battle Faction's Sea Priority Rank Combat Unit Pools
							array_push(array_get(temp_battle_faction_sea_priority_pool, global.celestial_combat_units[temp_battle_unit_combat_unit_instance.combat_unit_type].unit_priority_rank), temp_battle_unit_combat_unit_instance);
							temp_faction_sea_combat_size -= global.celestial_combat_units[temp_battle_unit_combat_unit_instance.combat_unit_type].unit_size;
							
							// Add Combat Unit to Battle Choreography as an Actor
							celestial_battle_add_choreography_actor(battle_instance, temp_battle_unit_combat_unit_instance);
							break;
					}
				}
				else if (global.celestial_combat_units[temp_battle_unit_combat_unit_instance.combat_unit_type].unit_combat)
				{
					// Combat Unit engages in Combat - Add Combat Unit to Combat Terrain Pools for random selection
					switch (global.celestial_combat_units[temp_battle_unit_combat_unit_instance.combat_unit_type].unit_terrain_type)
					{
						case CelestialTerrainType.Land:
							// Add Combat Unit to Combat Land Pool for random selection
							array_push(temp_land_indexes_pool, array_length(temp_land_combat_unit_pool));
							array_push(temp_land_combat_unit_pool, temp_battle_unit_combat_unit_instance);
							break;
						case CelestialTerrainType.Air:
							// Add Combat Unit to Combat Air Pool for random selection
							array_push(temp_air_indexes_pool, array_length(temp_air_combat_unit_pool));
							array_push(temp_air_combat_unit_pool, temp_battle_unit_combat_unit_instance);
							break;
						case CelestialTerrainType.Sea:
							// Add Combat Unit to Combat Sea Pool for random selection
							array_push(temp_sea_indexes_pool, array_length(temp_sea_combat_unit_pool));
							array_push(temp_sea_combat_unit_pool, temp_battle_unit_combat_unit_instance);
							break;
					}
				}
				
				// Decrement Battle Unit's Combat Unit Index
				temp_battle_unit_combat_unit_index--;
			}
			
			// Decrement Battle Unit Index
			temp_battle_units_index--;
		}
		
		// Populate Faction Priority Rank Pools
		while (array_length(temp_land_indexes_pool) > 0 and temp_faction_land_combat_size > 0)
		{
			// Choose Random Combat Unit
			var temp_land_combat_unit_random_value = irandom(array_length(temp_land_indexes_pool) - 1);
			
			// Find Combat Unit Index and Instance from Combat Unit Pool
			var temp_land_combat_unit_index = array_get(temp_land_indexes_pool, temp_land_combat_unit_random_value);
			var temp_land_combat_unit_instance = array_get(temp_land_combat_unit_pool, temp_land_combat_unit_index);
			
			// Check if Combat Unit's Unit Size fits within Battle Terrain Combat Size
			if (global.celestial_combat_units[temp_land_combat_unit_instance.combat_unit_type].unit_size <= temp_faction_land_combat_size)
			{
				// Add Combat Unit to Battle Faction's Priority Rank Combat Unit Pools
				array_push(array_get(temp_battle_faction_land_priority_pool, global.celestial_combat_units[temp_land_combat_unit_instance.combat_unit_type].unit_priority_rank), temp_land_combat_unit_instance);
				temp_faction_land_combat_size -= global.celestial_combat_units[temp_land_combat_unit_instance.combat_unit_type].unit_size;
				
				// Add Combat Unit to Battle Choreography as an Actor
				celestial_battle_add_choreography_actor(battle_instance, temp_land_combat_unit_instance);
			}
			
			// Delete Combat Unit from Combat Unit Index Array
			array_delete(temp_land_indexes_pool, temp_land_combat_unit_random_value, 1);
		}
		
		while (array_length(temp_air_indexes_pool) > 0 and temp_faction_air_combat_size > 0)
		{
			// Choose Random Combat Unit
			var temp_air_combat_unit_random_value = irandom(array_length(temp_air_indexes_pool) - 1);
			
			// Find Combat Unit Index and Instance from Combat Unit Pool
			var temp_air_combat_unit_index = array_get(temp_air_indexes_pool, temp_air_combat_unit_random_value);
			var temp_air_combat_unit_instance = array_get(temp_air_combat_unit_pool, temp_air_combat_unit_index);
			
			// Check if Combat Unit's Unit Size fits within Battle Terrain Combat Size
			if (global.celestial_combat_units[temp_air_combat_unit_instance.combat_unit_type].unit_size <= temp_faction_air_combat_size)
			{
				// Add Combat Unit to Battle Faction's Priority Rank Combat Unit Pools
				array_push(array_get(temp_battle_faction_air_priority_pool, global.celestial_combat_units[temp_air_combat_unit_instance.combat_unit_type].unit_priority_rank), temp_air_combat_unit_instance);
				temp_faction_air_combat_size -= global.celestial_combat_units[temp_air_combat_unit_instance.combat_unit_type].unit_size;
				
				// Add Combat Unit to Battle Choreography as an Actor
				celestial_battle_add_choreography_actor(battle_instance, temp_air_combat_unit_instance);
			}
			
			// Delete Combat Unit from Combat Unit Index Array
			array_delete(temp_air_indexes_pool, temp_air_combat_unit_random_value, 1);
		}
		
		while (array_length(temp_sea_indexes_pool) > 0 and temp_faction_sea_combat_size > 0)
		{
			// Choose Random Combat Unit
			var temp_sea_combat_unit_random_value = irandom(array_length(temp_sea_indexes_pool) - 1);
			
			// Find Combat Unit Index and Instance from Combat Unit Pool
			var temp_sea_combat_unit_index = array_get(temp_sea_indexes_pool, temp_sea_combat_unit_random_value);
			var temp_sea_combat_unit_instance = array_get(temp_sea_combat_unit_pool, temp_sea_combat_unit_index);
			
			// Check if Combat Unit's Unit Size fits within Battle Terrain Combat Size
			if (global.celestial_combat_units[temp_sea_combat_unit_instance.combat_unit_type].unit_size <= temp_faction_sea_combat_size)
			{
				// Add Combat Unit to Battle Faction's Priority Rank Combat Unit Pools
				array_push(array_get(temp_battle_faction_sea_priority_pool, global.celestial_combat_units[temp_sea_combat_unit_instance.combat_unit_type].unit_priority_rank), temp_sea_combat_unit_instance);
				temp_faction_sea_combat_size -= global.celestial_combat_units[temp_sea_combat_unit_instance.combat_unit_type].unit_size;
				
				// Add Combat Unit to Battle Choreography as an Actor
				celestial_battle_add_choreography_actor(battle_instance, temp_sea_combat_unit_instance);
			}
			
			// Delete Combat Unit from Combat Unit Index Array
			array_delete(temp_sea_indexes_pool, temp_sea_combat_unit_random_value, 1);
		}
		
		// Destroy Unused Arrays
		array_resize(temp_land_indexes_pool, 0);
		array_resize(temp_air_indexes_pool, 0);
		array_resize(temp_sea_indexes_pool, 0);
		
		array_resize(temp_land_combat_unit_pool, 0);
		array_resize(temp_air_combat_unit_pool, 0);
		array_resize(temp_sea_combat_unit_pool, 0);
		
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
	
	// Sort Battle's Choreography Actors and Index the Actors into the Battle's Choreography Actors DS Map
	celestial_battle_assign_depth_choreography_actors(battle_instance);
}

/// @function celestial_battle_add_choreography_actor(battle_instance, actor_combat_unit_instance);
/// @description Adds a Celestial Combat Unit as an Actor to a Celestial Battle's choreography arrays
/// @param {oCelestialBattle} battle_instance The Celestial Battle to add a Choreography Actor to
/// @param {real:Id.Instance} actor_combat_unit_instance The Celestial Combat Unit to add as a Choreography Actor
function celestial_battle_add_choreography_actor(battle_instance, actor_combat_unit_instance)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		return;
	}
	
	// Establish Actor Battle Platform Side & Faction
	var temp_actor_platform_side = CelestialBattlePlatformSide.None;
	var temp_actor_faction_instance = instance_exists(actor_combat_unit_instance.unit_instance) ? actor_combat_unit_instance.unit_instance.unit_faction : noone;
	
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
		// Initialize (Actor) Battle Choreography Stack Struct
		var temp_actor_struct =
		{
			// Choreography Stack Object Type Variable
			choreography_object_type: CelestialBattleChoreographyObjectType.Actor,
			
			// Choreography Stack Object Depth Sorting Variable
			vertical_depth: 0,
			
			// Choreography Stack Rendering Variables
			draw_sprite_index: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_idle_sprite,
			draw_image_index: 0,
			
			draw_x: 0,
			draw_y: 0,
			
			draw_xscale: 1,
			
			draw_color: instance_exists(temp_actor_faction_instance) ? temp_actor_faction_instance.faction_color : c_white,
			draw_alpha: 0,
			
			facing_direction: temp_actor_platform_side == CelestialBattlePlatformSide.Left ? 1 : -1,
			
			//
			draw_image_index_value: random(sprite_get_number(global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_move_sprite)),
			
			draw_offset_x: 0,
			draw_offset_y: 0,
			
			draw_random_offset_x: irandom_range(-3, 3),
			draw_random_offset_y: irandom_range(-1, 3),
			
			// Actor Combat Unit & Faction Variables
			actor_combat_unit: actor_combat_unit_instance,
			actor_faction: temp_actor_faction_instance,
			
			target_combat_unit: noone,
			target_faction: noone,
			
			action_enabled: true,
			action_delay_timer: random(1.0) + (celestial_unit_check_status_effect(actor_combat_unit_instance.unit_instance, CelestialUnitStatusEffectType.CombatActionStun) ? -3.5 : -1.5),
			action_duration_timer: -1,
			
			// Actor Battle Variables
			actor_platform_side: temp_actor_platform_side,
			actor_priority_rank: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_priority_rank,
			actor_vertical_tile: 0,
			
			// Actor Tile Variables
			battle_tile_ax: 0,
			battle_tile_ay: 0,
			
			battle_tile_bx: 0,
			battle_tile_by: 0,
			
			battle_tile_cx: 0,
			battle_tile_cy: 0,
			
			battle_tile_dx: 0,
			battle_tile_dy: 0,
			
			//
			actor_idle_sprite_index: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_idle_sprite,
			actor_move_sprite_index: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_move_sprite,
			actor_attack_sprite_index: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_attack_sprite,
			
			//
			actor_action_type: -1,
			actor_action_animation_delay: 0,
			
			actor_action_animation_count: 0,
			actor_action_animation_success: array_create(0),
			
			//
			actor_weapon_enabled: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_weapon_enabled,
			actor_weapon_sprite: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_weapon_sprite,
			
			actor_weapon_pivot_x: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_weapon_pivot_x,
			actor_weapon_pivot_y: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_weapon_pivot_y,
			
			actor_weapon_aim_pivot_x: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_weapon_aim_pivot_x,
			actor_weapon_aim_pivot_y: global.celestial_combat_units[actor_combat_unit_instance.combat_unit_type].unit_weapon_aim_pivot_y,
			
			actor_weapon_aim: 0,
			
			actor_weapon_offset_x: 0,
			actor_weapon_offset_y: 0,
			
			actor_weapon_target_x: 0,
			actor_weapon_target_y: 0,
			
			actor_weapon_angle: 270,
			
			actor_weapon_angle_recoil: 0,
			actor_weapon_horizontal_recoil: 0,
			actor_weapon_vertical_recoil: 0,
			
			actor_weapon_vertical_bobbing_height: -1,
			actor_weapon_vertical_bobbing_y_offset: 0,
			
			//
			actor_weapon_attack_sprite_index: -1,
			actor_weapon_attack_image_index: 0,
			actor_weapon_attack_image_angle: 0,
			actor_weapon_attack_x: 0,
			actor_weapon_attack_y: 0,
			actor_weapon_attack_timer: 0,
			
			// Actor Entry Animation Variables
			actor_entry_animation: true,
			actor_entry_animation_value: 0,
			actor_entry_delay_duration: random(18),
			
			// Actor Exit Animation Variables
			actor_exit_animation: false,
			actor_exit_animation_value: 1,
			actor_exit_delay_duration: random(18),
		};
		
		// Increment Battle's Vertical Tile Count for Choreography Actor Vertical Placement
		if (temp_actor_platform_side == CelestialBattlePlatformSide.Left)
		{
			battle_instance.battle_choreography_actors_battle_column_sizes[CelestialBattlePriorityRankMax - temp_actor_struct.actor_priority_rank - 1] += 1;
		}
		else if (temp_actor_platform_side == CelestialBattlePlatformSide.Right)
		{
			battle_instance.battle_choreography_actors_battle_column_sizes[CelestialBattlePriorityRankMax + temp_actor_struct.actor_priority_rank] += 1;
		}
		
		// Index Actor Struct into Battle's Choreography Actors Array
		array_push(battle_instance.battle_choreography_actors, temp_actor_struct);
	}
}

function celestial_battle_assign_depth_choreography_actors(battle_instance)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		return;
	}
	
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
			// Index the Battle Column Possible Position in the Battle Column Possible Positions Array
			temp_battle_column_possible_positions_array[temp_battle_column_possible_positions_index] = temp_battle_column_possible_positions_index;
			
			// Increment Battle Column Possible Positions Index
			temp_battle_column_possible_positions_index++;
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
		var temp_battle_actor_column_index = CelestialBattlePriorityRankMax - 1 - temp_battle_choreography_actor_struct.actor_priority_rank;
		temp_battle_actor_column_index = temp_battle_choreography_actor_struct.actor_platform_side == CelestialBattlePlatformSide.Right ? CelestialBattlePriorityRankMax + temp_battle_choreography_actor_struct.actor_priority_rank : temp_battle_choreography_actor_struct.actor_priority_rank;
		var temp_battle_actor_column_size = battle_instance.battle_choreography_actors_battle_column_sizes[temp_battle_actor_column_index];
		var temp_battle_actor_column_possible_positions_array = array_get(temp_battle_choreography_actors_battle_column_possible_positions, temp_battle_actor_column_index);
		
		if (array_length(temp_battle_actor_column_possible_positions_array) > 0)
		{
			var temp_random_column_possible_positions_index = irandom(array_length(temp_battle_actor_column_possible_positions_array) - 1);
			temp_battle_choreography_actor_struct.actor_vertical_tile = temp_battle_actor_column_possible_positions_array[temp_random_column_possible_positions_index];
			array_delete(temp_battle_actor_column_possible_positions_array, temp_random_column_possible_positions_index, 1);
		}
		
		// Increment Battle Choreography Actors Index
		temp_battle_choreography_actors_index++;
	}
	
	// Iterate through Battle's Choreography Actors and Index them into Battle Choreography Actors DS Map
	temp_battle_choreography_actors_index = 0;
	
	repeat (temp_battle_choreography_actors_count)
	{
		// Index Battle Choreography Actor into Battle Choreography Actors DS Map
		ds_map_add(battle_instance.battle_choreography_actors_map, battle_instance.battle_choreography_actors[temp_battle_choreography_actors_index].actor_combat_unit, temp_battle_choreography_actors_index);
		
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
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		return;
	}
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
	
	// Clear Battle's Choreography Actors DS Map
	ds_map_clear(battle_instance.battle_choreography_actors_map);
}

/// @function celestial_battle_clear_choreography_actions(battle_instance);
/// @description Clears the Choreography Actions array with the given Celestial Battle Instance
/// @param {oCelestialBattle} battle_instance The Celestial Battle to clear and reset the Choreography Actions array of
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

