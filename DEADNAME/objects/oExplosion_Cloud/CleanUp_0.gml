/// @description Default Dynamic Cloud Cleanup Event
// Removes and Destroys the Default Dynamic Cloud's DS Lists

// Cloud Cleanup Behaviour: Destroy Dynamic Cloud DS Lists
event_inherited();

// Destroy all Cloud DS Lists
ds_list_destroy(clouds_velocity_spd_list);
clouds_velocity_spd_list = -1;

ds_list_destroy(clouds_velocity_gravity_list);
clouds_velocity_gravity_list = -1;

ds_list_destroy(clouds_velocity_horizontal_direction_list);
clouds_velocity_horizontal_direction_list = -1;

ds_list_destroy(clouds_velocity_vertical_direction_list);
clouds_velocity_vertical_direction_list = -1;
