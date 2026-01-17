/// @description Celestial Simulator Singleton Init Event
// Self-Creating Celestial Simulator Init Behaviour Event

// Global Celestial Simulator Properties
#macro CelestialSimulator global.celestial_simulator
#macro CelestialSimMaxLights 6
#macro CelestialSimMaxHydrosphereWaves 4

// Configure Celestial Simulator - Global Init Event
gml_pragma("global", @"room_instance_add(room_first, 0, 0, oCelestialSimulator);");

// Celestial Simulator Enums
enum CelestialObjectType
{
	None,
	Sun,
	Planet
}

// Delete to prevent multiple Celestial Simulator Instances
if (instance_number(object_index) > 1) 
{
	instance_destroy(id, false);
	exit;
}

// Celestial Simulator Singleton
global.celestial_simulator = id;
sprite_index = -1;

// Celestial Simulator Settings
active = true;

camera_position_x = 0;
camera_position_y = 0;
camera_position_z = 0;

camera_rotation_x = 0;
camera_rotation_y = 0;
camera_rotation_z = 0;

camera_rotation_matrix = rotation_matrix_from_euler_angles(0, 0, 0);

camera_fov = 60;

camera_z_near = 1;
camera_z_far = 32000;

camera_z_near_depth_overpass = -801;

// Solar System Variables
solar_system_index = -1;
solar_systems = array_create(0);
solar_systems_names = array_create(0);
solar_systems_background_stars_vertex_buffer = array_create(0);

solar_systems_background_star_sphere = geodesic_icosphere_create(3);

// Rendering Variables
solar_system_render_depth_values_list = ds_list_create();
solar_system_render_depth_instances_list = ds_list_create();

global_hydrosphere_time = 0;
global_hydrosphere_time_spd = 0.0037;
global_hydrosphere_specular_intensity = 0.5;

global_atmosphere_time = 0;
global_atmosphere_time_spd = 0.008;

global_clouds_scatter_point_samples_count = 8;
global_clouds_light_depth_samples_count = 8;
global_clouds_sample_scale = 0.008;
global_clouds_absorption = 0.25;
global_clouds_density = 1;
global_clouds_density_falloff = 5;
global_clouds_anisotropic_light_scattering_strength = 0.4;
global_clouds_alpha_blending_power = 2;

global_atmosphere_scatter_point_samples_count = 10;
global_atmosphere_optical_depth_samples_count = 10;

// Surfaces
background_surface = -1;
background_bloom_premult_surface = -1;

background_stars_surface = -1;
background_stars_emissive_surface = -1;

celestial_body_render_surface = -1;
celestial_body_atmosphere_depth_mask_surface = -1;

clouds_render_surface = -1;

final_render_surface = -1;

// Textures
cloud_noise_texture = sprite_get_texture(sSystem_CloudNoise, 0);

// Vertex Formats
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_texcoord();
icosphere_render_vertex_format = vertex_format_end();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
background_stars_render_vertex_format = vertex_format_end();

vertex_format_begin();
vertex_format_add_position();
square_uv_vertex_format = vertex_format_end();

// Vertex Buffers
square_uv_vertex_buffer = vertex_create_buffer();

vertex_begin(square_uv_vertex_buffer, square_uv_vertex_format);

vertex_position(square_uv_vertex_buffer, -1, -1);
vertex_position(square_uv_vertex_buffer, 1, -1);
vertex_position(square_uv_vertex_buffer, -1, 1);

vertex_position(square_uv_vertex_buffer, 1, 1);
vertex_position(square_uv_vertex_buffer, -1, 1);
vertex_position(square_uv_vertex_buffer, 1, -1);

vertex_end(square_uv_vertex_buffer);
vertex_freeze(square_uv_vertex_buffer);

// Solar System Background Stars Unlit Rendering Shader Indexes
background_stars_unlit_shader_camera_position_index = shader_get_uniform(shd_background_stars_unlit, "in_CameraPosition");
background_stars_unlit_shader_camera_rotation_index = shader_get_uniform(shd_background_stars_unlit, "in_CameraRotation");
background_stars_unlit_shader_camera_dimensions_index = shader_get_uniform(shd_background_stars_unlit, "in_CameraDimensions");

// MRT (Forward Rendered Lighting) Planet Lithosphere Lit Rendering Shader Indexes
planet_lithosphere_lit_shader_vsh_camera_position_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_vsh_CameraPosition");
planet_lithosphere_lit_shader_fsh_camera_position_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_fsh_CameraPosition");
planet_lithosphere_lit_shader_camera_rotation_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_CameraRotation");
planet_lithosphere_lit_shader_camera_dimensions_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_CameraDimensions");

planet_lithosphere_lit_shader_planet_radius_index = shader_get_uniform(shd_planet_lithosphere_lit, "u_PlanetRadius");
planet_lithosphere_lit_shader_planet_elevation_index = shader_get_uniform(shd_planet_lithosphere_lit, "u_PlanetElevation");
planet_lithosphere_lit_shader_planet_position_index = shader_get_uniform(shd_planet_lithosphere_lit, "u_PlanetPosition");
planet_lithosphere_lit_shader_planet_euler_angles_index = shader_get_uniform(shd_planet_lithosphere_lit, "u_PlanetEulerAngles");

planet_lithosphere_lit_shader_atmosphere_radius_index = shader_get_uniform(shd_planet_lithosphere_lit, "u_AtmosphereRadius");

planet_lithosphere_lit_shader_light_exists_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Light_Exists");

planet_lithosphere_lit_shader_light_position_x_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Light_Position_X");
planet_lithosphere_lit_shader_light_position_y_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Light_Position_Y");
planet_lithosphere_lit_shader_light_position_z_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Light_Position_Z");

planet_lithosphere_lit_shader_light_color_r_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Light_Color_R");
planet_lithosphere_lit_shader_light_color_g_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Light_Color_G");
planet_lithosphere_lit_shader_light_color_b_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Light_Color_B");

planet_lithosphere_lit_shader_light_radius_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Light_Radius");
planet_lithosphere_lit_shader_light_falloff_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Light_Falloff");
planet_lithosphere_lit_shader_light_intensity_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Light_Intensity");

planet_lithosphere_lit_shader_planet_texture_index = shader_get_sampler_index(shd_planet_lithosphere_lit, "in_PlanetTexture");

// MRT (Forward Rendered Lighting) Planet Hydrosphere Lit Rendering Shader Indexes
planet_hydrosphere_lit_shader_vsh_camera_position_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_vsh_CameraPosition");
planet_hydrosphere_lit_shader_fsh_camera_position_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_fsh_CameraPosition");
planet_hydrosphere_lit_shader_vsh_camera_rotation_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_vsh_CameraRotation");
planet_hydrosphere_lit_shader_fsh_camera_rotation_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_fsh_CameraRotation");
planet_hydrosphere_lit_shader_camera_dimensions_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_CameraDimensions");

planet_hydrosphere_lit_shader_planet_radius_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_PlanetRadius");
planet_hydrosphere_lit_shader_vsh_planet_elevation_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_vsh_PlanetElevation");
planet_hydrosphere_lit_shader_fsh_planet_elevation_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_fsh_PlanetElevation");
planet_hydrosphere_lit_shader_planet_position_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_PlanetPosition");
planet_hydrosphere_lit_shader_planet_euler_angles_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_PlanetEulerAngles");

planet_hydrosphere_lit_shader_planet_ocean_wave_time_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_PlanetOcean_WaveTime");
planet_hydrosphere_lit_shader_planet_ocean_wave_direction_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_PlanetOcean_WaveDirection");
planet_hydrosphere_lit_shader_planet_ocean_wave_steepness_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_PlanetOcean_WaveSteepness");
planet_hydrosphere_lit_shader_planet_ocean_wave_length_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_PlanetOcean_WaveLength");
planet_hydrosphere_lit_shader_planet_ocean_wave_speed_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_PlanetOcean_WaveSpeed");

planet_hydrosphere_lit_shader_vsh_planet_ocean_elevation_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_vsh_PlanetOceanElevation");
planet_hydrosphere_lit_shader_fsh_planet_ocean_elevation_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_fsh_PlanetOceanElevation");
planet_hydrosphere_lit_shader_planet_ocean_roughness_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_PlanetOceanRoughness");
planet_hydrosphere_lit_shader_planet_ocean_color_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_PlanetOceanColor");

planet_hydrosphere_lit_shader_planet_ocean_foam_color_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_PlanetOceanFoamColor");
planet_hydrosphere_lit_shader_planet_ocean_foam_size_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_PlanetOceanFoamSize");

planet_hydrosphere_lit_shader_atmosphere_radius_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_AtmosphereRadius");

planet_hydrosphere_lit_shader_specular_intensity_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_SpecularIntensity");

planet_hydrosphere_lit_shader_light_exists_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Light_Exists");

planet_hydrosphere_lit_shader_light_position_x_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Light_Position_X");
planet_hydrosphere_lit_shader_light_position_y_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Light_Position_Y");
planet_hydrosphere_lit_shader_light_position_z_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Light_Position_Z");

planet_hydrosphere_lit_shader_light_color_r_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Light_Color_R");
planet_hydrosphere_lit_shader_light_color_g_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Light_Color_G");
planet_hydrosphere_lit_shader_light_color_b_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Light_Color_B");

planet_hydrosphere_lit_shader_light_radius_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Light_Radius");
planet_hydrosphere_lit_shader_light_falloff_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Light_Falloff");
planet_hydrosphere_lit_shader_light_intensity_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Light_Intensity");

// (Forward Rendered Lighting) Planet Atmosphere Lit Rendering Shader Indexes
planet_atmosphere_lit_shader_vsh_camera_position_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_vsh_CameraPosition");
planet_atmosphere_lit_shader_fsh_camera_position_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_fsh_CameraPosition");
planet_atmosphere_lit_shader_vsh_camera_rotation_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_vsh_CameraRotation");
planet_atmosphere_lit_shader_fsh_camera_rotation_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_fsh_CameraRotation");
planet_atmosphere_lit_shader_vsh_camera_dimensions_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_vsh_CameraDimensions");
planet_atmosphere_lit_shader_fsh_camera_dimensions_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_fsh_CameraDimensions");

planet_atmosphere_lit_shader_time_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_Time");

planet_atmosphere_lit_shader_scatter_point_samples_num_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_ScatterPointSamplesCount");
planet_atmosphere_lit_shader_optical_depth_samples_num_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_OpticalDepthSamplesCount");

planet_atmosphere_lit_shader_vsh_atmosphere_radius_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_vsh_AtmosphereRadius");
planet_atmosphere_lit_shader_fsh_atmosphere_radius_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_fsh_AtmosphereRadius");
planet_atmosphere_lit_shader_atmosphere_density_falloff_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_AtmosphereDensityFalloff");
planet_atmosphere_lit_shader_atmosphere_scattering_coefficients_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_AtmosphereScatteringCoefficients");

planet_atmosphere_lit_shader_clouds_alpha_blending_power_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_CloudsAlphaBlendingPower");

planet_atmosphere_lit_shader_planet_radius_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_PlanetRadius");
planet_atmosphere_lit_shader_vsh_planet_position_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_vsh_PlanetPosition");
planet_atmosphere_lit_shader_fsh_planet_position_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_fsh_PlanetPosition");

planet_atmosphere_lit_shader_clouds_surface_texture_index = shader_get_sampler_index(shd_planet_atmosphere_lit, "gm_AtmosphereCloudsSurface");
planet_atmosphere_lit_shader_planet_depth_mask_texture_index = shader_get_sampler_index(shd_planet_atmosphere_lit, "gm_AtmospherePlanetDepthMask");

// MRT (Forward Rendered Lighting) Signed Distance Field Sphere-Shaped Volumetric Clouds Lit Rendering Shader Indexes
sdf_sphere_volumetric_clouds_lit_shader_vsh_camera_position = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_vsh_CameraPosition");
sdf_sphere_volumetric_clouds_lit_shader_vsh_camera_rotation = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_vsh_CameraRotation");
sdf_sphere_volumetric_clouds_lit_shader_fsh_camera_rotation = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_fsh_CameraRotation");
sdf_sphere_volumetric_clouds_lit_shader_vsh_camera_dimensions = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_vsh_CameraDimensions");

sdf_sphere_volumetric_clouds_lit_shader_cloud_noise_square_size_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudNoiseSquareSize");
sdf_sphere_volumetric_clouds_lit_shader_cloud_noise_cube_size_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudNoiseCubeSize");

sdf_sphere_volumetric_clouds_lit_shader_scatter_point_samples_count_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_ScatterPointSamplesCount");
sdf_sphere_volumetric_clouds_lit_shader_light_depth_samples_count_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_LightDepthSamplesCount");
sdf_sphere_volumetric_clouds_lit_shader_cloud_sample_scale_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudSampleScale");

sdf_sphere_volumetric_clouds_lit_shader_vsh_atmosphere_radius_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_vsh_AtmosphereRadius");
sdf_sphere_volumetric_clouds_lit_shader_fsh_atmosphere_radius_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_fsh_AtmosphereRadius");

sdf_sphere_volumetric_clouds_lit_shader_vsh_planet_radius_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_vsh_PlanetRadius");
sdf_sphere_volumetric_clouds_lit_shader_fsh_planet_radius_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_fsh_PlanetRadius");
sdf_sphere_volumetric_clouds_lit_shader_vsh_planet_position_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_vsh_PlanetPosition");
sdf_sphere_volumetric_clouds_lit_shader_fsh_planet_position_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_fsh_PlanetPosition");
sdf_sphere_volumetric_clouds_lit_shader_planet_euler_angles_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_PlanetEulerAngles");

sdf_sphere_volumetric_clouds_lit_shader_cloud_uv_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudUV");
sdf_sphere_volumetric_clouds_lit_shader_cloud_height_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudHeight");
sdf_sphere_volumetric_clouds_lit_shader_vsh_cloud_radius_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_vsh_CloudRadius");
sdf_sphere_volumetric_clouds_lit_shader_fsh_cloud_radius_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_fsh_CloudRadius");

sdf_sphere_volumetric_clouds_lit_shader_cloud_absorption_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudAbsorption");
sdf_sphere_volumetric_clouds_lit_shader_cloud_density_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudDensity");
sdf_sphere_volumetric_clouds_lit_shader_cloud_density_falloff_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudDensityFalloff");
sdf_sphere_volumetric_clouds_lit_shader_cloud_anisotropic_light_scattering_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudAnisotropicLightScattering");

sdf_sphere_volumetric_clouds_lit_shader_cloud_color_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudColor");
sdf_sphere_volumetric_clouds_lit_shader_cloud_ambient_light_color_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudAmbientLightColor");

sdf_sphere_volumetric_clouds_lit_shader_planet_depth_mask_texture_index = shader_get_sampler_index(shd_sdf_sphere_volumetric_cloud_lit, "gm_AtmospherePlanetDepthMask");

// Sun Unlit Rendering Shader Indexes
sun_unlit_shader_camera_position_index = shader_get_uniform(shd_sun_unlit, "in_camera_position");
sun_unlit_shader_camera_rotation_index = shader_get_uniform(shd_sun_unlit, "in_camera_rotation");
sun_unlit_shader_camera_dimensions_index = shader_get_uniform(shd_sun_unlit, "in_camera_dimensions");

sun_unlit_shader_radius_index = shader_get_uniform(shd_sun_unlit, "u_Radius");
sun_unlit_shader_elevation_index = shader_get_uniform(shd_sun_unlit, "u_Elevation");
sun_unlit_shader_position_index = shader_get_uniform(shd_sun_unlit, "u_Position");
sun_unlit_shader_euler_angles_index = shader_get_uniform(shd_sun_unlit, "u_EulerAngles");

// (Forward Rendered Lighting) Light Source Variables
light_source_exists = array_create(CelestialSimMaxLights);

light_source_position_x = array_create(CelestialSimMaxLights);
light_source_position_y = array_create(CelestialSimMaxLights);
light_source_position_z = array_create(CelestialSimMaxLights);

light_source_color_r = array_create(CelestialSimMaxLights);
light_source_color_g = array_create(CelestialSimMaxLights);
light_source_color_b = array_create(CelestialSimMaxLights);

light_source_radius = array_create(CelestialSimMaxLights);
light_source_falloff = array_create(CelestialSimMaxLights);
light_source_intensity = array_create(CelestialSimMaxLights);

for (var i = CelestialSimMaxLights - 1; i >= 0; i--)
{
	// Initialize Empty Light Sources
	light_source_exists[i] = 0;

	light_source_position_x[i] = 0;
	light_source_position_y[i] = 0;
	light_source_position_z[i] = 0;
	
	light_source_color_r[i] = 0;
	light_source_color_g[i] = 0;
	light_source_color_b[i] = 0;
	
	light_source_radius[i] = 0;
	light_source_falloff[i] = 0;
	light_source_intensity[i] = 0;
}

// Solar System Methods
load_solar_system = function(index)
{
	
}

generate_solar_system_background_stars_vertex_buffer = function(stars)
{
	// Begin Initialization of Background Stars Vertex Buffer
	var temp_background_stars_vertex_buffer = vertex_create_buffer();
	vertex_begin(temp_background_stars_vertex_buffer, CelestialSimulator.background_stars_render_vertex_format);
	
	// Star Color Classes
	var temp_star_class_m_color = make_color_rgb(230, 129, 118);	// Light Red
	var temp_star_class_k_color = make_color_rgb(242, 185, 151);	// Light Orange
	var temp_star_class_g_color = make_color_rgb(242, 212, 109);	// Light Yellow
	var temp_star_class_f_color = make_color_rgb(247, 238, 204);	// White-ish Pale Yellow
	var temp_star_class_a_color = make_color_rgb(211, 247, 250);	// White-ish Blue
	var temp_star_class_b_color = make_color_rgb(151, 214, 255);	// Light Blue
	var temp_star_class_o_color = make_color_rgb(55, 145, 255);		// Very Blue
	
	// Iterate through creation of the given number of Background Stars
	repeat (stars)
	{
		// Generate Star Radius
		var temp_star_radius = 0.35;
		
		// Generate Star Color
		var temp_star_alpha = random_range(0.95, 1);
		var temp_star_color = c_white;
		var temp_star_color_value = random(1);
		
		if (temp_star_color_value < 0.2)
		{
			temp_star_color = merge_color(c_white, temp_star_class_m_color, sqr(random(1.0)));
			temp_star_radius *= random_range(2, 3);
		}
		else if (temp_star_color_value < 0.4)
		{
			temp_star_color = merge_color(c_white, temp_star_class_k_color, sqr(random(1.0)));
			temp_star_radius *= random_range(2, 3);
		}
		else if (temp_star_color_value < 0.6)
		{
			temp_star_color = merge_color(c_white, temp_star_class_g_color, sqr(random(1.0)));
			temp_star_radius *= random_range(3, 5);
		}
		else if (temp_star_color_value < 0.9)
		{
			temp_star_color = merge_color(c_white, temp_star_class_f_color, sqr(random(1.0)));
			temp_star_radius *= random_range(3, 5);
		}
		else if (temp_star_color_value < 0.95)
		{
			temp_star_color = merge_color(c_white, temp_star_class_a_color, sqr(random(1.0)));
			temp_star_radius *= random_range(3, 5);
		}
		else if (temp_star_color_value < 0.99)
		{
			temp_star_color = merge_color(c_white, temp_star_class_b_color, sqr(random(1.0)));
			temp_star_radius *= random_range(3, 6);
		}
		else
		{
			temp_star_color = merge_color(c_white, temp_star_class_o_color, sqr(random(1.0)));
			temp_star_radius *= random_range(3, 6);
		}
		
		// Generate Star Position
		var temp_star_position_radius = random_range(580, 720);
		var temp_star_position_vector = random_sphere_vector();
		
		var temp_star_x = temp_star_position_radius * temp_star_position_vector[0];
		var temp_star_y = temp_star_position_radius * temp_star_position_vector[1];
		var temp_star_z = temp_star_position_radius * temp_star_position_vector[2];
		
		// Iterate through Icosphere Triangles and assemble Vertex Buffer
		var temp_triangle_index = 0;
		
		repeat (array_length(CelestialSimulator.solar_systems_background_star_sphere.triangles))
		{
			// Retreive Triangle Data
			var temp_triangle = CelestialSimulator.solar_systems_background_star_sphere.triangles[temp_triangle_index];
			
			// Obtain Triangle Vertex Positions
			var temp_triangle1_pos = CelestialSimulator.solar_systems_background_star_sphere.vertices[temp_triangle[0]];
			var temp_triangle2_pos = CelestialSimulator.solar_systems_background_star_sphere.vertices[temp_triangle[1]];
			var temp_triangle3_pos = CelestialSimulator.solar_systems_background_star_sphere.vertices[temp_triangle[2]];
			
			// Create first Triangle Vertex Data
			vertex_position_3d(temp_background_stars_vertex_buffer, temp_triangle1_pos[0] * temp_star_radius + temp_star_x, temp_triangle1_pos[1] * temp_star_radius + temp_star_y, temp_triangle1_pos[2] * temp_star_radius + temp_star_z);
			vertex_color(temp_background_stars_vertex_buffer, temp_star_color, temp_star_alpha);
			
			// Create second Triangle Vertex Data
			vertex_position_3d(temp_background_stars_vertex_buffer, temp_triangle2_pos[0] * temp_star_radius + temp_star_x, temp_triangle2_pos[1] * temp_star_radius + temp_star_y, temp_triangle2_pos[2] * temp_star_radius + temp_star_z);
			vertex_color(temp_background_stars_vertex_buffer, temp_star_color, temp_star_alpha);
			
			// Create third Triangle Vertex Data
			vertex_position_3d(temp_background_stars_vertex_buffer, temp_triangle3_pos[0] * temp_star_radius + temp_star_x, temp_triangle3_pos[1] * temp_star_radius + temp_star_y, temp_triangle3_pos[2] * temp_star_radius + temp_star_z);
			vertex_color(temp_background_stars_vertex_buffer, temp_star_color, temp_star_alpha);
			
			// Increment Triangle Index
			temp_triangle_index++;
		}
	}
	
	// Finish Initializing Vertex Buffer
	vertex_end(temp_background_stars_vertex_buffer);
	vertex_freeze(temp_background_stars_vertex_buffer);
	
	// Return Background Stars Vertex Buffer
	return temp_background_stars_vertex_buffer;
}

// Universe Campaign Generation
generate_default_solar_system = function()
{
	//
	var temp_grandmom_solar_system = array_create(0);
	temp_grandmom_solar_system[0] = instance_create_depth(0, 0, 0, oSun, { image_blend: c_red, radius: 60 });
	temp_grandmom_solar_system[1] = instance_create_depth(0, 0, 0, oPlanet_Mom, {  image_blend: make_color_rgb(8, 0, 15), ocean_elevation: 0.2, orbit_size: 400, orbit_speed: 0, orbit_angle: 270, rotation_speed: 0.3 } );
	camera_position_z = 0;
	//temp_grandmom_solar_system[1] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(8, 0, 15), orbit_size: 400 } );
	
	//temp_grandmom_solar_system[0] = instance_create_depth(0, 0, 0, oSun, { image_blend: c_red, radius: 60, orbit_size: 1600, orbit_speed: 0, orbit_angle: 90 });
	//temp_grandmom_solar_system[1] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(8, 0, 15), orbit_size: 0, rotation_speed: 0 } );
	
	//temp_grandmom_solar_system[1] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(8, 0, 15), ocean_roughness: 0, orbit_size: 500 } );
	//temp_grandmom_solar_system[2] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(50, 50, 50), orbit_size: 300, orbit_speed: 2  } );
	//temp_grandmom_solar_system[3] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(50, 50, 50), orbit_size: 500, orbit_speed: -0.5 } );
	//temp_grandmom_solar_system[4] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(50, 50, 50), orbit_size: 800, orbit_speed: -1 } );
	
	solar_systems[0] = temp_grandmom_solar_system;
	solar_systems_background_stars_vertex_buffer[0] = generate_solar_system_background_stars_vertex_buffer(3000);
	
	//
	solar_system_index = 0;
}

// DEBUG
//planet_simulator_add_light_source(-500, 240, -1400, make_color_rgb(206, 185, 240), 3000, 3, 2);
//planet_simulator_add_light_source(1000, 240, -1400, c_red, 100, 1, 2);
generate_default_solar_system();

//cloud_noise(2048, 256);
