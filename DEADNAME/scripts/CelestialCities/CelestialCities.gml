//
enum CelestialCityBuilding
{
	HousingDistrict,
	TankFactory
}

//
global.celestial_buildings[CelestialCityBuilding.HousingDistrict] =
{
	building_name: "Housing District",
};

global.celestial_buildings[CelestialCityBuilding.TankFactory] =
{
	// Building Variables
	building_name: "Coal Mine",
	
	// Production Variables
	production_resource: CelestialResource.Coal,
	
	production_cycle_duration: 15,
	production_cycle_resource_count: 3,
	
	production_cycle_day_enabled: true,
	production_cycle_twilight_enabled: false,
	production_cycle_night_enabled: false,
};

//
function celestial_cities_add_building(city_instance, celestial_city_building)
{
	// Initalize Building Struct
	var temp_building_struct =
	{
		building: celestial_city_building,
		production_cycle_timer: 0
	};
	
	// Add Building Struct to City Instance's Buildings Array
	array_push(city_instance.buildings, temp_building_struct);
}

function celestial_cities_add_resource(city_instance, celestial_resource, amount)
{
	// Establish Amount Added
	var temp_new_amount = 0;
	var temp_amount_added = 0;
	
	// Check if Celestial City has the Resource already
	if (ds_map_exists(city_instance.resources_supply_amount_map, celestial_resource))
	{
		// Establish Supply Limit & Supply Amount
		var temp_resource_entry_supply_limit = ds_map_find_value(city_instance.resources_supply_limit_map, celestial_resource);
		var temp_resource_entry_supply_amount = ds_map_find_value(city_instance.resources_supply_amount_map, celestial_resource);
		
		// Update Amount Added
		temp_new_amount = clamp(temp_resource_entry_supply_amount + amount, 0, temp_resource_entry_supply_limit);
		temp_amount_added = temp_new_amount - temp_resource_entry_supply_amount;
		
		// Add Resource Amount to City's Supply Amount without going over City's Supply Limit
		ds_map_set(city_instance.resources_supply_amount_map, celestial_resource, temp_new_amount);
	}
	else
	{
		// Establish Supply Limit
		var temp_new_resource_entry_supply_limit = global.celestial_resources[celestial_resource].city_default_supply_limit;
		
		// Update Amount Added
		temp_new_amount = clamp(amount, 0, temp_new_resource_entry_supply_limit);
		temp_amount_added = temp_new_amount - temp_new_resource_entry_supply_limit;
		
		// Add New City Resource Entries
		array_push(city_instance.resources, celestial_resource);
		ds_map_add(city_instance.resources_supply_limit_map, celestial_resource, temp_new_resource_entry_supply_limit);
		ds_map_add(city_instance.resources_supply_amount_map, celestial_resource, temp_new_amount);
		
		// Sort City Resource Entries
		array_sort(city_instance.resources, true);
	}
	
	// Return Amount Added
	return temp_amount_added;
}

function celestial_cities_add_notification(city_instance, notification_text, notification_duration)
{
	array_push(city_instance.notifications, { text: notification_text, duration: notification_duration });
}

