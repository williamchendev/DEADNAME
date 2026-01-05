/// @description Default Planet Initialization
// Initializes the Celestial for Planet Simulator Behaviour and Rendering

// Initialize Celestial Body's Geodesic Icosphere
event_inherited();

// Initialize Planet Cloud System
var temp_clouds_spawn_sphere = geodesic_icosphere_create(clouds_spawn_resolution);
clouds_spawn_sphere_uvs = temp_clouds_spawn_sphere.vertex_uvs;

show_debug_message(array_length(temp_clouds_spawn_sphere.vertices));

clouds_active_array = array_create(clouds_spawn_limit);
clouds_u_position_array = array_create(clouds_spawn_limit);
clouds_v_position_array = array_create(clouds_spawn_limit);
clouds_radius_array = array_create(clouds_spawn_limit);
clouds_height_array = array_create(clouds_spawn_limit);
clouds_moisture_array = array_create(clouds_spawn_limit);
clouds_temperature_array = array_create(clouds_spawn_limit);

var temp_cloud_spawn_num = 80;

for (var i = 0; i < temp_cloud_spawn_num; i++)
{
	clouds_active_array[i] = 1;
	clouds_radius_array[i] = 5;
	clouds_height_array[i] = random_range(12, 18);
	
	var temp_random_cloud_uv = clouds_spawn_sphere_uvs[irandom_range(0, array_length(temp_clouds_spawn_sphere.vertices) - 1)];
	clouds_u_position_array[i] = temp_random_cloud_uv[0];
	clouds_v_position_array[i] = temp_random_cloud_uv[1];
	
	clouds_u_position_array[i] = random_range(0, 1);
	clouds_v_position_array[i] = random_range(0, 1);
}

// Initialize Clouds Depth Sorted Rendering DS List
clouds_depth_list = ds_list_create();
clouds_render_list = ds_list_create();

// Update Celestial Object Type to Planet
celestial_object_type = CelestialObjectType.Planet;

// Initialize Empty Ocean Wave Settings
ocean_wave_direction_array = array_create(CelestialSimMaxHydrosphereWaves * 2);
ocean_wave_steepness_array = array_create(CelestialSimMaxHydrosphereWaves);
ocean_wave_length_array = array_create(CelestialSimMaxHydrosphereWaves);
ocean_wave_speed_array = array_create(CelestialSimMaxHydrosphereWaves);

// Initialize Default Ocean Wave Settings
ocean_wave_direction_array[0] =		1;
ocean_wave_direction_array[1] =		0;
ocean_wave_steepness_array[0] =		0.6;
ocean_wave_length_array[0] =		0.1;
ocean_wave_speed_array[0] = 		1.0;

ocean_wave_direction_array[2] = 	0.5;
ocean_wave_direction_array[3] = 	-0.5;
ocean_wave_steepness_array[1] = 	1.2;
ocean_wave_length_array[1] =		0.5;
ocean_wave_speed_array[1] = 		1.2;

ocean_wave_direction_array[4] = 	0.1;
ocean_wave_direction_array[5] = 	0.9;
ocean_wave_steepness_array[2] = 	0.7;
ocean_wave_length_array[2] =		0.1;
ocean_wave_speed_array[2] = 		0.8;

ocean_wave_direction_array[6] = 	-0.3;
ocean_wave_direction_array[7] = 	0.7;
ocean_wave_steepness_array[3] = 	1.2;
ocean_wave_length_array[3] =		0.3;
ocean_wave_speed_array[3] = 		1.5;
