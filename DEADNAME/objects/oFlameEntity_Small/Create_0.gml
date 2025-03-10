/// @description Flame Dynamic Object Init
// Initializes Flame Dynamic Object & Point Light

// Instantiate Smoke Particle
smoke_particle_source = instance_create_depth(x, y, depth, oFlameEntity_Smoke_Particle);

// Lighting Engine Behaviour: Initialize Dynamic Object
event_inherited();

// Create Point Light Source
point_light_source = instance_create_depth(x, y, depth, oLightingEngine_Source_PointLight);

// Assign Point Light Source Properties
point_light_source.image_blend = make_color_hex("#FF8319");
point_light_source.point_light_distance_fade = 0.8;
point_light_source.point_light_penumbra_size = 12;

// Point Light Source Size and Intensity
flame_light_radius = 164;
flame_light_intensity = 2;

// Point Light Source Flicker Settings
flame_flicker_intensity_size = 0.6;

flame_flicker_range_size = 5;
flame_flicker_range_limit = 20;
flame_flicker_range_min_spd = 0.2;
flame_flicker_range_max_spd = 0.5;

// Point Light Source Flicker Variables
flame_flicker_range_spd = 0;
flame_flicker_range_time = 0;
flame_flicker_range_value = 0;
