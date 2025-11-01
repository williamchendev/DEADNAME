/// @description Explosion Dynamic Cloud Initialization
// Initializes Explosion's Dynamic Cloud

// Cloud Gravity Properties
cloud_movement_gravity = 0.0001;
cloud_movement_gravity_limit = 2;

cloud_movement_wind_spd = 0.05;
cloud_movement_wind_horizontal_direction = 1;
cloud_movement_wind_vertical_direction = 0;

// Lighting Engine Behaviour: Initialize Dynamic Cloud
event_inherited();

// Cloud DS Lists
clouds_velocity_spd_list = ds_list_create();
clouds_velocity_gravity_list = ds_list_create();

clouds_velocity_horizontal_direction_list = ds_list_create();
clouds_velocity_vertical_direction_list = ds_list_create();