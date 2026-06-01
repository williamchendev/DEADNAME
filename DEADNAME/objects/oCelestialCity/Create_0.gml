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
celestial_cities_add_building(id, CelestialCityBuilding.TankFactory);

// Resources Array & DS Maps
resources = array_create(0);
resources_supply_amount_map = ds_map_create();
resources_supply_limit_map = ds_map_create();

// Notifications Array
notifications = array_create(0);
