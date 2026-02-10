/// @description Default Planet Initialization
// Initializes the Celestial for Planet Simulator Behaviour and Rendering

// Initialize Celestial Body's Geodesic Icosphere
event_inherited();

// Update Celestial Object Type to Planet
celestial_object_type = CelestialObjectType.Planet;

// Initialize Planet Cloud Spawn Sphere
var temp_clouds_spawn_sphere = geodesic_icosphere_create(clouds_spawn_resolution);
clouds_spawn_sphere_uvs = temp_clouds_spawn_sphere.vertex_uvs;

// Initialize Planet Clouds Depth Sorting Arrays
clouds_index_array = array_create(1);

// Initialize Planet Clouds Rendering DS Lists
clouds_render_u_list = ds_list_create();
clouds_render_v_list = ds_list_create();
clouds_render_height_list = ds_list_create();
clouds_render_radius_list = ds_list_create();
clouds_render_density_list = ds_list_create();
clouds_render_absorption_list = ds_list_create();

// Initialize Planet Clouds Behavioural Properties & Group DS Lists
clouds_density_list = ds_list_create();
clouds_absorption_list = ds_list_create();
clouds_position_u_list = ds_list_create();
clouds_position_v_list = ds_list_create();
clouds_position_height_list = ds_list_create();

clouds_group_radius_list = ds_list_create();
clouds_group_height_list = ds_list_create();
clouds_group_bearing_list = ds_list_create();
clouds_group_distance_list = ds_list_create();

// (DEBUG, FIND ANOTHER WAY TO DO THIS LATER) Spawn Planet Clouds via Groups to create Naturalistic Clustering
if (clouds)
{
	var temp_cloud_spawn_num = 64;
	
	for (var temp_cloud_spawn_index = 0; temp_cloud_spawn_index < temp_cloud_spawn_num; temp_cloud_spawn_index++)
	{
		// Initialize Cloud Group's Behavioural Properties
		ds_list_add(clouds_density_list, 1.0);
		ds_list_add(clouds_absorption_list, 1.0);
		
		// Initialize Cloud Group's Sphere UV Position and Height
		var temp_cloud_group_position_uv = clouds_spawn_sphere_uvs[irandom_range(0, array_length(temp_clouds_spawn_sphere.vertices) - 1)];
		var temp_cloud_group_position_height = random_range(16, 18);
		
		ds_list_add(clouds_position_u_list, temp_cloud_group_position_uv[0]);
		ds_list_add(clouds_position_v_list, temp_cloud_group_position_uv[1]);
		ds_list_add(clouds_position_height_list, temp_cloud_group_position_height);
		
		// Initialize Cloud Group's Cluster DS Lists
		var temp_cloud_group_radius_list = ds_list_create();
		var temp_cloud_group_height_list = ds_list_create();
		var temp_cloud_group_bearing_list = ds_list_create();
		var temp_cloud_group_distance_list = ds_list_create();
		
		// Populate Cloud Group's Cluster DS Lists
		var temp_cloud_group_spawn_num = irandom_range(5, 12);
		
		for (var temp_cloud_cluster_spawn_index = 0; temp_cloud_cluster_spawn_index < temp_cloud_group_spawn_num; temp_cloud_cluster_spawn_index++)
		{
			// Initialize Cloud Cluster Individual's Behavioural Properties within Cloud Group
			var temp_cloud_individual_radius = random_range(16, 24);
			var temp_cloud_individual_height = random_range(-3, 3);
			var temp_cloud_individual_bearing = random(360);
			var temp_cloud_individual_distance = random_range(3, 10);
			
			// Index Cloud Cluster Individual's Behavioural Properties to Cloud Group's Cluster DS Lists
			ds_list_add(temp_cloud_group_radius_list, temp_cloud_individual_radius);
			ds_list_add(temp_cloud_group_height_list, temp_cloud_individual_height);
			ds_list_add(temp_cloud_group_bearing_list, temp_cloud_individual_bearing);
			ds_list_add(temp_cloud_group_distance_list, temp_cloud_individual_distance);
		}
		
		// Index Cloud Group's Cluster Lists within Planet's Cloud Group DS Lists
		ds_list_add(clouds_group_radius_list, temp_cloud_group_radius_list);
		ds_list_add(clouds_group_height_list, temp_cloud_group_height_list);
		ds_list_add(clouds_group_bearing_list, temp_cloud_group_bearing_list);
		ds_list_add(clouds_group_distance_list, temp_cloud_group_distance_list);
	}
}

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