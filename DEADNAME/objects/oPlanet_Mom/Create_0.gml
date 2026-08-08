/// @description Default Celestial Body Initialization
// Initializes the Celestial Body for Celestial Simulator Behaviour and Rendering

// Initialize Geodesic Icosphere
event_inherited();

// DEBUG
if (pathfinding_enabled)
{
	repeat(100)
	{
		// Select Random Unit
		var temp_unit = instance_create_depth(0, 0, 0, oCelestialUnit);
		celestial_unit_join_faction(temp_unit, CelestialSimulator.factions[irandom(array_length(CelestialSimulator.factions) - 1)]);
		add_unit_node(temp_unit, irandom_range(0, pathfinding_nodes_count - 1));
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

