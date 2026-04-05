//
enum CelestialMicroclimateBiomeType
{
	None
}

//
function celestial_microclimate_biome_get_movement_cost(celestial_microclimate_biome_type)
{
	// Establish Default Microclimate Biome Movement Power Cost
	var temp_movement_cost = 0;
	
	// Find Microclimate Biome Movement Power Cost
	switch (celestial_microclimate_biome_type)
	{
		case CelestialMicroclimateBiomeType.None:
		default:
			temp_movement_cost = 30;
			break;
	}
	
	// Return Movement Power Cost
	return temp_movement_cost;
}
