/// @description Default Celestial Body Initialization
// Initializes the Celestial Body for Celestial Simulator Behaviour and Rendering

// Initialize Geodesic Icosphere
event_inherited();

// DEBUG
if (pathfinding_enabled)
{
	repeat(100)
	{
		// Find Random Pathfinding Node Index
		var temp_unit_pathfinding_node_index = irandom_range(0, pathfinding_nodes_count - 1);
		var temp_unit_terrain_type = pathfinding_node_elevation_array[temp_unit_pathfinding_node_index] > ocean_elevation ? CelestialUnitTerrainType.Terrestrial : CelestialUnitTerrainType.Aquatic;
		
		// Initialize Random Celestial Unit Instance
		var temp_unit = instance_create_depth(0, 0, 0, oCelestialUnit);
		celestial_unit_join_faction(temp_unit, CelestialSimulator.factions[irandom(array_length(CelestialSimulator.factions) - 1)]);
		
		// Update Celestial Unit's Terrain Type
		temp_unit.unit_terrain_type = temp_unit_terrain_type;
		
		if (temp_unit_terrain_type == CelestialUnitTerrainType.Aquatic)
		{
			temp_unit.sprite_index = sOverworld_Unit_Ship_Carrier;
		}
		
		// Add Celestial Unit to the Planet
		add_unit_node(temp_unit, temp_unit_pathfinding_node_index);
	}
	
	repeat(50)
	{
		add_satellite_node(instance_create_depth(0, 0, 0, oCelestialSatellite), irandom_range(0, pathfinding_nodes_count - 1));
	}
	
	repeat(100)
	{
		add_city_node(instance_create_depth(0, 0, 0, oCelestialCity), irandom_range(0, pathfinding_nodes_count - 1));
	}
}

