//
enum PlanetBiome
{
	Terrestrial_Rainforest,
	Terrestrial_Forest,
	Terrestrial_Woodland,
	Terrestrial_Shrubland,
	Terrestrial_Savannah,
	Terrestrial_Grassland,
	Terrestrial_Wetlands,
	Terrestrial_SaltMarsh,
	Terrestrial_Bog,
	Terrestrial_Tundra,
	Terrestrial_Desert,
	Terrestrial_Arcology,
	Marine_ShallowOcean,
	Marine_Estuary,
	Marine_Reef,
	Marine_DeepOcean,
	Marine_Abyssal
}

enum PlanetTemperature
{
	CosmicCold,
	InhospitablyCold,
	ExtremeCold,
	BrutalCold,
	UncomfortablyCold,
	Chilly,
	WilliamIdeal,
	Warm,
	UncomfortablyHot,
	BrutalHot,
	ExtremeHot,
	InhospitablyHot,
	CosmicHot
}

//
function geodesic_icosphere_biome_is_marine(biome)
{
	switch (biome)
	{ 
		case PlanetBiome.Marine_ShallowOcean:
		case PlanetBiome.Marine_Estuary:
		case PlanetBiome.Marine_Reef:
		case PlanetBiome.Marine_DeepOcean:
		case PlanetBiome.Marine_Abyssal:
			return true;
		default:
			return false;
	}
}

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

//
function celestial_microclimate_biome_get_combat_size(celestial_microclimate_biome_type)
{
	// Establish Default Microclimate Biome Combat Size
	var temp_combat_size = 30;
	
	// Find Microclimate Biome Combat Size
	switch (celestial_microclimate_biome_type)
	{
		case CelestialMicroclimateBiomeType.None:
		default:
			temp_combat_size = 30;
			break;
	}
	
	// Return Combat Size
	return temp_combat_size;
}

