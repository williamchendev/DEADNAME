//
enum CelestialMicroclimateBiomeType
{
	None
}

//
function celestial_microclimate_biome_get_movement_cost_modifier(celestial_microclimate_biome_type)
{
	// Establish Default Microclimate Biome Movement Power Cost Modifier
	var temp_movement_cost_modifier = 1;
	
	// Find Microclimate Biome Movement Power Cost Modifier
	switch (celestial_microclimate_biome_type)
	{
		case CelestialMicroclimateBiomeType.None:
		default:
			temp_movement_cost_modifier = 2;
			break;
	}
	
	// Return Movement Power Cost Modifier
	return temp_movement_cost_modifier;
}
