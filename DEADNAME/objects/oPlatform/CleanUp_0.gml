/// @description Platform Destroy Event
// Performs the necessary calculations to uninstantiate this platform

ds_list_destroy(units);
units = -1;

ds_list_destroy(collision_units_list);
collision_units_list = -1;

exit;