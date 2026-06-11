/// @description Default Celestial City Cleanup Event
// Celestial Celestial City Cleanup Behaviour Event

// Destroy City Buildings Array
var temp_buildings_count = array_length(buildings);
var temp_buildings_index = temp_buildings_count - 1;

repeat (temp_buildings_count)
{
	// Delete Buildings Struct
	delete buildings[temp_buildings_index];
	
	// Decrement Buildings Index
	temp_buildings_index--;
}

array_resize(buildings, 0);

// Destroy City Resources Arrays
array_resize(resources_supply, 0);
array_resize(resources_limit, 0);

// Destroy City Notifications Array
var temp_notification_count = array_length(notifications);
var temp_notification_index = temp_notification_count - 1;

repeat (temp_notification_count)
{
	// Delete Notifications Struct
	delete notifications[temp_notification_index];
	
	// Decrement Notifications Index
	temp_notification_index--;
}

array_resize(notifications, 0);

