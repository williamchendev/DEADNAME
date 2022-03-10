/// @description Lantern Init
// Creates the variables and settings of the Lantern Object

// Basic Lighting Inheritance
event_inherited();

// Light Source
lantern_light_source = instance_create_layer(x, y, layer, oPointLight);

// Light Source Properties
lantern_range = 64;
lantern_intensity = 0.8;
lantern_color = c_white;

// Light Source Flicker Settings
lantern_flicker_intensity_size = 0.2;

lantern_flicker_range_size = 3;
lantern_flicker_range_limit = 8;
lantern_flicker_range_min_spd = 0.1;
lantern_flicker_range_max_spd = 0.5;

// Light Source Flicker Variables
lantern_flicker_range_spd = 0;
lantern_flicker_range_time = 0;
lantern_flicker_range_value = 0;