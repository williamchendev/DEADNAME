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

function planet_pathfinding_add_node(planet, position_x, position_y, position_z, node_id = undefined, node_name = "")
{
	
}

function planet_pathfinding_add_edge(planet, first_node_id, second_node_id)
{
	
}

function planet_pathfinding_recursive(planet, start_node_id, end_node_id, path_list = ds_list_create())
{
	
}

function planet_platfinding_find_path_weight(planet, path_list)
{
	
}

function planet_pathfinding_get_closest_point_on_edge(x_position, y_position, position_z)
{
	
}

function planet_pathfinding_create_path(planet, start_x_position, start_y_position, start_z_position, end_x_position, end_y_position, end_z_position)
{
	
}