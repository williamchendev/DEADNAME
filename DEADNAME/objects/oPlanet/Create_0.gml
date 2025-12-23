/// @description Default Planet Initialization
// Initializes the Celestial for Planet Simulator Behaviour and Rendering

// Initialize Celestial Body's Geodesic Icosphere
event_inherited();

// Update Celestial Object Type to Planet
celestial_object_type = CelestialObjectType.Planet;

// Initialize Empty Ocean Wave Settings
ocean_wave_direction_array = array_create(CelestialSimMaxHydrosphereWaves * 2);
ocean_wave_steepness_array = array_create(CelestialSimMaxHydrosphereWaves);
ocean_wave_length_array = array_create(CelestialSimMaxHydrosphereWaves);
ocean_wave_speed_array = array_create(CelestialSimMaxHydrosphereWaves);

// Initialize Default Ocean Wave Settings
ocean_wave_direction_array[0] = 1;
ocean_wave_direction_array[1] = 0;

ocean_wave_direction_array[2] = 0.5;
ocean_wave_direction_array[3] = -0.5;

ocean_wave_direction_array[4] = 0.1;
ocean_wave_direction_array[5] = 0.9;

ocean_wave_direction_array[6] = -0.3;
ocean_wave_direction_array[7] = 0.7;

ocean_wave_steepness_array[0] = 0.6;
ocean_wave_steepness_array[1] = 1.2;
ocean_wave_steepness_array[2] = 0.7;
ocean_wave_steepness_array[3] = 1.2;

ocean_wave_length_array[0] = 0.1;
ocean_wave_length_array[1] = 0.5;
ocean_wave_length_array[2] = 0.1;
ocean_wave_length_array[3] = 0.3;

ocean_wave_speed_array[0] = 1.0;
ocean_wave_speed_array[1] = 1.2;
ocean_wave_speed_array[2] = 0.8;
ocean_wave_speed_array[3] = 1.5;
