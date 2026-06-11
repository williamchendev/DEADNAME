/// @description Default Planet Initialization
// Initializes the Celestial for Planet Simulator Behaviour and Rendering

// Initialize Celestial Body's Geodesic Icosphere
event_inherited();

// Update Celestial Object Type to Planet
celestial_object_type = CelestialObjectType.Planet;

// Initialize Empty Sphere Soft Shadow Settings
sphere_shadow_instance = array_create(CelestialSimMaxShadows, noone);

sphere_shadow_exists = array_create(CelestialSimMaxShadows);
sphere_shadow_radius = array_create(CelestialSimMaxShadows);

sphere_shadow_position_x = array_create(CelestialSimMaxShadows);
sphere_shadow_position_y = array_create(CelestialSimMaxShadows);
sphere_shadow_position_z = array_create(CelestialSimMaxShadows);

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

// Initialize Planet Cloud Spawn Sphere
var temp_clouds_spawn_sphere = geodesic_icosphere_create(clouds_spawn_resolution);
clouds_spawn_sphere_uvs = temp_clouds_spawn_sphere.vertex_uvs;

// Initialize Planet Clouds Depth Sorting Arrays
clouds_index_array = array_create(0);

// Initialize Planet Clouds Rendering DS Lists
clouds_render_u_list = ds_list_create();
clouds_render_v_list = ds_list_create();
clouds_render_height_list = ds_list_create();
clouds_render_radius_list = ds_list_create();
clouds_render_density_list = ds_list_create();
clouds_render_absorption_list = ds_list_create();

// Initialize Planet Clouds Behavioural Properties & Group Arrays
clouds_density_array = array_create(clouds_count);
clouds_absorption_array = array_create(clouds_count);
clouds_position_u_array = array_create(clouds_count);
clouds_position_v_array = array_create(clouds_count);
clouds_position_height_array = array_create(clouds_count);
clouds_rotation_array = array_create(clouds_count);

clouds_group_count_array = array_create(clouds_count);
clouds_group_radius_array = array_create(clouds_count, -1);
clouds_group_height_array = array_create(clouds_count, -1);
clouds_group_bearing_array = array_create(clouds_count, -1);
clouds_group_distance_array = array_create(clouds_count, -1);

// (DEBUG, FIND ANOTHER WAY TO DO THIS LATER) Spawn Planet Clouds via Groups to create Naturalistic Clustering
if (clouds)
{
	// Populate Planet Clouds Behavioural Properties & Group Arrays
	var temp_cloud_index = 0;
	
	repeat (clouds_count)
	{
		// Initialize Cloud Group's Behavioural Properties
		clouds_density_array[temp_cloud_index] = 1.0;
		clouds_absorption_array[temp_cloud_index] = 1.0;
		
		// Initialize Cloud Group's Sphere UV Position and Height
		var temp_cloud_group_position_uv = clouds_spawn_sphere_uvs[irandom_range(0, array_length(temp_clouds_spawn_sphere.vertices) - 1)];
		var temp_cloud_group_position_height = random_range(16, 18);
		
		clouds_position_u_array[temp_cloud_index] = temp_cloud_group_position_uv[0];
		clouds_position_v_array[temp_cloud_index] = temp_cloud_group_position_uv[1];
		clouds_position_height_array[temp_cloud_index] = temp_cloud_group_position_height;
		clouds_rotation_array[temp_cloud_index] = random(360);
		
		// Initialize Cloud Group's Individual Count
		var temp_cloud_group_count = irandom_range(5, 12);
		
		clouds_group_count_array[temp_cloud_index] = temp_cloud_group_count;
		
		// Initialize Cloud Group's Cluster Arrays
		var temp_cloud_group_radius_array = array_create(temp_cloud_group_count);
		var temp_cloud_group_height_array = array_create(temp_cloud_group_count);
		var temp_cloud_group_bearing_array = array_create(temp_cloud_group_count);
		var temp_cloud_group_distance_array = array_create(temp_cloud_group_count);
		
		// Populate Cloud Group's Cluster Arrays
		var temp_cloud_group_individual_index = 0;
		
		repeat (temp_cloud_group_count)
		{
			// Initialize Cloud Cluster Individual's Behavioural Properties within Cloud Group
			var temp_cloud_individual_radius = random_range(16, 30);
			var temp_cloud_individual_height = random_range(-3, 3);
			var temp_cloud_individual_bearing = random(360);
			var temp_cloud_individual_distance = random_range(3, 10);
			
			// Index Cloud Cluster Individual's Behavioural Properties to Cloud Group's Cluster Arrays
			temp_cloud_group_radius_array[temp_cloud_group_individual_index] = temp_cloud_individual_radius;
			temp_cloud_group_height_array[temp_cloud_group_individual_index] = temp_cloud_individual_height;
			temp_cloud_group_bearing_array[temp_cloud_group_individual_index] = temp_cloud_individual_bearing;
			temp_cloud_group_distance_array[temp_cloud_group_individual_index] = temp_cloud_individual_distance;
			
			// Increment Cloud Group's Individual Index
			temp_cloud_group_individual_index++;
		}
		
		// Index Cloud Group's Cluster Lists within Planet's Cloud Group Arrays
		clouds_group_radius_array[temp_cloud_index] = temp_cloud_group_radius_array;
		clouds_group_height_array[temp_cloud_index] = temp_cloud_group_height_array;
		clouds_group_bearing_array[temp_cloud_index] = temp_cloud_group_bearing_array;
		clouds_group_distance_array[temp_cloud_index] = temp_cloud_group_distance_array;
		
		// Increment Cloud Index
		temp_cloud_index++;
	}
}