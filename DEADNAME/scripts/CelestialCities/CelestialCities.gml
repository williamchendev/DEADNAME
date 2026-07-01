// Celestial City Enums
enum CelestialBuildingType
{
	HousingDistrict,
	TankFactory
}

// Global Celestial Buildings
global.celestial_buildings[CelestialBuildingType.HousingDistrict] =
{
	building_name: "Housing District",
};

global.celestial_buildings[CelestialBuildingType.TankFactory] =
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

// Celestial City Methods
/// @function celestial_cities_add_building(city_instance, celestial_city_building);
/// @description Adds a Building to the given Celestial City Instance
/// @param {oCelestialCity} city_instance The Celestial City to add a Building to
/// @param {int<CelestialBuildingType>} celestial_building The Building Type of the Celestial Building to add to the Celestial City Instance
function celestial_cities_add_building(city_instance, celestial_building)
{
	// Initalize Building Struct
	var temp_building_struct =
	{
		building: celestial_building,
		production_cycle_timer: 0
	};
	
	// Add Building Struct to City Instance's Buildings Array
	array_push(city_instance.buildings, temp_building_struct);
}

/// @function celestial_cities_add_resource(city_instance, celestial_resource, amount)
/// @description Adds Resources to the given Celestial City Instance
/// @param {oCelestialCity} city_instance The Celestial City to add Resources to
/// @param {int<CelestialResource>} celestial_resource The Resource Type of the Celestial Resource being added to the Celestial City Instance
/// @param {int} amount The amount of the quantity of Resources being added to the Celestial City Instance
function celestial_cities_add_resource(city_instance, celestial_resource, amount)
{
	// Establish Amount Added
	var temp_new_amount = 0;
	var temp_amount_added = 0;
	
	// Establish Supply Limit & Supply Amount
	var temp_resource_entry_supply_limit = city_instance.resources_limit[celestial_resource];
	var temp_resource_entry_supply_amount = city_instance.resources_supply[celestial_resource];
	
	// Update Amount Added
	temp_new_amount = clamp(temp_resource_entry_supply_amount + amount, 0, temp_resource_entry_supply_limit);
	temp_amount_added = temp_new_amount - temp_resource_entry_supply_amount;
	
	// Add Resource Amount to City's Supply Amount without going over City's Supply Limit
	city_instance.resources_supply[celestial_resource] = temp_new_amount;
	
	// Return Amount Added
	return temp_amount_added;
}

/// @function celestial_cities_add_notification(city_instance, notification_text, notification_duration)
/// @description Adds a Notification Popup to the given Celestial City Instance
/// @param {oCelestialCity} city_instance The Celestial City to add a Notification Popup to
/// @param {string} notification_text The Display Text of the Notification Popup
/// @param {real} notification_duration The duration of the Notification Popup's lifespan existing above the Celestial City Instance
function celestial_cities_add_notification(city_instance, notification_text, notification_duration)
{
	array_push(city_instance.notifications, { text: notification_text, duration: notification_duration });
}

