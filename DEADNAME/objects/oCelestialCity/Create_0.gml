/// @description Default Celestial City Initialization
// Initializes the Celestial City for Celestial Simulator Behaviour and Rendering

// Inherited Celestial Sub Object Initialization Behaviour
event_inherited();

// Initialize City Celestial Sub Object Type
celestial_sub_object_type = CelestialSubObjectType.City;

// Solar Variables
city_solar = CelestialSolarType.Twilight;

// Buildings Array
buildings = array_create(0);
celestial_cities_add_building(id, CelestialBuildingType.TankFactory);

// Resources Arrays
var temp_celestial_resources_index = 0;
var temp_celestial_resources_count = array_length(global.celestial_resources);

resources_supply = array_create(temp_celestial_resources_count);
resources_limit = array_create(temp_celestial_resources_count);

repeat(temp_celestial_resources_count)
{
	// Index Celestial Resources Limit
	resources_limit[temp_celestial_resources_index] = global.celestial_resources[temp_celestial_resources_index].city_default_supply_limit;
	
	// Increment Celestial Resources Index
	temp_celestial_resources_index++;
}

// Notifications Array
notifications = array_create(0);
