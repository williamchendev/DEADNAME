/// @description Celestial Simulator Singleton Init Event
// Self-Creating Celestial Simulator Init Behaviour Event

// Global Celestial Simulator Properties
#macro CelestialSimulator global.celestial_simulator
#macro CelestialSimMaxLights 6
#macro CelestialSimMaxHydrosphereWaves 4

// Celestial Simulator Singleton Global Initialization
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

// Solar System Settings
background_star_sphere = geodesic_icosphere_create(4);

// Rendering Settings
global_noise_time_spd = 0.03;

global_hydrosphere_time_spd = 0.0037;
global_hydrosphere_specular_intensity = 0.5;

global_clouds_scatter_point_samples_count = 8;
global_clouds_light_depth_samples_count = 8;
global_clouds_sample_scale = 0.008;
global_clouds_absorption = 0.25;
global_clouds_density = 1;
global_clouds_density_falloff = 5;
global_clouds_anisotropic_light_scattering_strength = 0.4;
global_clouds_alpha_blending_power = 2;
global_clouds_temporal_blue_noise_offset = 0.03;

global_atmosphere_scatter_point_samples_count = 10;
global_atmosphere_optical_depth_samples_count = 10;

// Solar System Variables
solar_system_index = -1;
solar_systems = array_create(0);
solar_systems_ids = array_create(0);
solar_systems_names = array_create(0);
solar_systems_orbit_update_order = array_create(0);
solar_systems_background_stars_vertex_buffer = array_create(0);

// Rendering Variables
global_noise_time = 0;
global_hydrosphere_time = 0;

solar_system_render_depth_sorting_index_array = array_create(0);
solar_system_render_depth_sorting_depth_array = array_create(0);

clouds_render_depth_sorting_index_array = array_create(1);
clouds_render_depth_sorting_depth_array = array_create(1);

// Surfaces
background_surface = -1;
background_bloom_premult_surface = -1;

background_stars_surface = -1;
background_stars_emissive_surface = -1;

temp_surface = -1;

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

planet_lithosphere_lit_shader_noise_time_index = shader_get_uniform(shd_planet_lithosphere_lit, "u_NoiseTime");

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

planet_hydrosphere_lit_shader_noise_time_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_NoiseTime");

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

planet_atmosphere_lit_shader_noise_time_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_NoiseTime");

planet_atmosphere_lit_shader_scatter_point_samples_num_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_ScatterPointSamplesCount");
planet_atmosphere_lit_shader_optical_depth_samples_num_index = shader_get_uniform(shd_planet_atmosphere_lit, "u_OpticalDepthSamplesCount");

planet_atmosphere_lit_shader_light_exists_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Light_Exists");

planet_atmosphere_lit_shader_light_position_x_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Light_Position_X");
planet_atmosphere_lit_shader_light_position_y_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Light_Position_Y");
planet_atmosphere_lit_shader_light_position_z_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Light_Position_Z");

planet_atmosphere_lit_shader_light_radius_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Light_Radius");
planet_atmosphere_lit_shader_light_falloff_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Light_Falloff");
planet_atmosphere_lit_shader_light_intensity_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Light_Intensity");

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

sdf_sphere_volumetric_clouds_lit_shader_noise_time_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_NoiseTime");

sdf_sphere_volumetric_clouds_lit_shader_cloud_noise_square_size_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudNoiseSquareSize");
sdf_sphere_volumetric_clouds_lit_shader_cloud_noise_cube_size_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudNoiseCubeSize");

sdf_sphere_volumetric_clouds_lit_shader_scatter_point_samples_count_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_ScatterPointSamplesCount");
sdf_sphere_volumetric_clouds_lit_shader_light_depth_samples_count_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_LightDepthSamplesCount");
sdf_sphere_volumetric_clouds_lit_shader_cloud_sample_scale_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_CloudSampleScale");

sdf_sphere_volumetric_clouds_lit_shader_light_exists_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Light_Exists");

sdf_sphere_volumetric_clouds_lit_shader_light_position_x_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Light_Position_X");
sdf_sphere_volumetric_clouds_lit_shader_light_position_y_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Light_Position_Y");
sdf_sphere_volumetric_clouds_lit_shader_light_position_z_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Light_Position_Z");

sdf_sphere_volumetric_clouds_lit_shader_light_color_r_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Light_Color_R");
sdf_sphere_volumetric_clouds_lit_shader_light_color_g_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Light_Color_G");
sdf_sphere_volumetric_clouds_lit_shader_light_color_b_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Light_Color_B");

sdf_sphere_volumetric_clouds_lit_shader_light_radius_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Light_Radius");
sdf_sphere_volumetric_clouds_lit_shader_light_falloff_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Light_Falloff");
sdf_sphere_volumetric_clouds_lit_shader_light_intensity_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Light_Intensity");

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

// Render Depth Sort Type Functions
clouds_render_depth_sort = function(current, next) 
{
	return CelestialSimulator.clouds_render_depth_sorting_depth_array[next] < CelestialSimulator.clouds_render_depth_sorting_depth_array[current] ? -1 : 1;
}

solar_system_render_depth_sort = function(current, next) 
{
	return CelestialSimulator.solar_system_render_depth_sorting_depth_array[next] < CelestialSimulator.solar_system_render_depth_sorting_depth_array[current] ? -1 : 1;
}

// Solar System Methods
clear_celestial_sim = function()
{
	// Iterate through Solar Systems
	var temp_solar_system_index = array_length(CelestialSimulator.solar_systems_ids) - 1
	
	repeat (array_length(CelestialSimulator.solar_systems_ids))
	{
		// Delete Solar System
		var temp_solar_system = CelestialSimulator.solar_systems[temp_solar_system_index];
		
		for (var l = array_length(temp_solar_system) - 1; l >= 0; l--)
		{
			// Find Celestial Object Instance
			var temp_celestial_object = temp_solar_system[l];
			
			// Destroy Celestial Object Instance
			instance_destroy(temp_celestial_object);
			
			// Reset Solar System Array Index
			temp_solar_system[l] = noone;
		}
		
		array_clear(temp_solar_system);
		array_delete(CelestialSimulator.solar_systems, temp_solar_system_index, 1);
		
		// Delete Solar System's Update Order Array from Celestial Simulator's Arrays
		var temp_solar_system_update_order = CelestialSimulator.solar_systems_orbit_update_order[temp_solar_system_index];
		array_clear(temp_solar_system_update_order);
		array_delete(CelestialSimulator.solar_systems_orbit_update_order, temp_solar_system_index, 1);
		
		// Delete Background Stars Vertex Buffer from Background Stars Vertex Buffer Array
		vertex_delete_buffer(CelestialSimulator.solar_systems_background_stars_vertex_buffer[temp_solar_system_index]);
		CelestialSimulator.solar_systems_background_stars_vertex_buffer[temp_solar_system_index] = -1;
		
		// Decrement Solar System Index
		temp_solar_system_index--;
	}
	
	// Clear all Celestial Simulator's Arrays
	array_clear(CelestialSimulator.solar_systems);
	array_clear(CelestialSimulator.solar_systems_ids);
	array_clear(CelestialSimulator.solar_systems_names);
	array_clear(CelestialSimulator.solar_systems_orbit_update_order);
	array_clear(CelestialSimulator.solar_systems_background_stars_vertex_buffer);
}

add_solar_system = function(solar_system_id, solar_system_name)
{
	// Check if Solar System ID already exists
	for (var q = 0; q < array_length(CelestialSimulator.solar_systems_ids); q++)
	{
		// Solar System ID comparison
		if (solar_system_id == CelestialSimulator.solar_systems_ids[q])
		{
			// Solar System already exists - Early Return
			return;
		}
	}
	
	// Create Solar System and Index Solar System in Celestial Simulator's Solar System Arrays
	var temp_solar_system_index = array_length(CelestialSimulator.solar_systems);
	
	array_push(CelestialSimulator.solar_systems, array_create(0));
	array_push(CelestialSimulator.solar_systems_ids, solar_system_id);
	array_push(CelestialSimulator.solar_systems_names, solar_system_name);
	array_push(CelestialSimulator.solar_systems_orbit_update_order, array_create(0));
	array_push(CelestialSimulator.solar_systems_background_stars_vertex_buffer, -1);
}

remove_solar_system = function(solar_system_id)
{
	// Iterate through Solar System IDs to check if Solar System exists
	for (var q = 0; q < array_length(CelestialSimulator.solar_systems_ids); q++)
	{
		// Solar System ID comparison
		if (solar_system_id == CelestialSimulator.solar_systems_ids[q])
		{
			// Solar System exists - Delete Solar System
			var temp_solar_system = CelestialSimulator.solar_systems[q];
			
			for (var l = array_length(temp_solar_system) - 1; l >= 0; l--)
			{
				// Find Celestial Object Instance
				var temp_celestial_object = temp_solar_system[l];
				
				// Destroy Celestial Object Instance
				instance_destroy(temp_celestial_object);
				
				// Reset Solar System Array Index
				temp_solar_system[l] = noone;
			}
			
			array_clear(temp_solar_system);
			array_delete(CelestialSimulator.solar_systems, q, 1);
			
			// Delete Solar System's ID and Name from Celestial Simulator's Arrays
			array_delete(CelestialSimulator.solar_systems_ids, q, 1);
			array_delete(CelestialSimulator.solar_systems_names, q, 1);
			
			// Delete Solar System's Update Order Array from Celestial Simulator's Arrays
			var temp_solar_system_update_order = CelestialSimulator.solar_systems_orbit_update_order[q];
			array_clear(temp_solar_system_update_order);
			array_delete(CelestialSimulator.solar_systems_orbit_update_order, q, 1);
			
			// Delete Background Stars Vertex Buffer from Background Stars Vertex Buffer Array
			vertex_delete_buffer(CelestialSimulator.solar_systems_background_stars_vertex_buffer[q]);
			CelestialSimulator.solar_systems_background_stars_vertex_buffer[q] = -1;
			array_delete(CelestialSimulator.solar_systems_background_stars_vertex_buffer, q, 1);
			return;
		}
	}
}

add_celestial_object = function(solar_system_id, celestial_object)
{
	// Establish empty Solar System Index
	var temp_solar_system_index = -1;
	
	// Iterate through Solar System IDs to check if Solar System exists
	for (var q = 0; q < array_length(CelestialSimulator.solar_systems_ids); q++)
	{
		// Solar System ID comparison
		if (solar_system_id == CelestialSimulator.solar_systems_ids[q])
		{
			// Solar System exists - Index Celestial Object
			temp_solar_system_index = q;
			break;
		}
	}
	
	// Check if Solar System ID exists
	if (temp_solar_system_index != -1)
	{
		// Find Solar System Array
		var temp_solar_system = CelestialSimulator.solar_systems[temp_solar_system_index];
		
		// Index Celestial Object in Solar System Array
		var temp_solar_system_celestial_object_index = array_length(temp_solar_system);
		temp_solar_system[temp_solar_system_celestial_object_index] = celestial_object;
		
		// Set Celestial Object's Solar System ID
		celestial_object.solar_system_id = CelestialSimulator.solar_systems_ids[temp_solar_system_index];
		
		// Find Solar System Update Order Array
		var temp_solar_system_update_order = CelestialSimulator.solar_systems_orbit_update_order[temp_solar_system_index];
		
		// Index Celestial Object into Solar System's Update Order Array
		array_push(temp_solar_system_update_order, temp_solar_system_celestial_object_index);
		
		// Update the Orbit Parent Instance of every Celestial Object in the Solar System connected to the added Celestial Object
		for (var n = 0; n < array_length(temp_solar_system); n++)
		{
			if (temp_solar_system[n].celestial_id == celestial_object.orbit_id)
			{
				celestial_object.orbit_parent_instance = temp_solar_system[n];
			}
			else if (temp_solar_system[n].orbit_id == celestial_object.celestial_id)
			{
				temp_solar_system[n].orbit_parent_instance = celestial_object;
			}
		}
	}
}

remove_celestial_object = function(solar_system_id, celestial_object)
{
	// Establish empty Solar System Index
	var temp_solar_system_index = -1;
	
	// Iterate through Solar System IDs to check if Solar System exists
	for (var q = 0; q < array_length(CelestialSimulator.solar_systems_ids); q++)
	{
		// Solar System ID comparison
		if (solar_system_id == CelestialSimulator.solar_systems_ids[q])
		{
			// Solar System exists - Index Celestial Object
			temp_solar_system_index = q;
			break;
		}
	}
	
	// Check if Solar System ID exists
	if (temp_solar_system_index != -1)
	{
		// Find Solar System Array
		var temp_solar_system = CelestialSimulator.solar_systems[temp_solar_system_index];
		
		// Index Celestial Object in Solar System Array
		var temp_solar_system_celestial_object_index = array_get_index(temp_solar_system, celestial_object);
		
		// Check if Celestial Object existed in Solar System
		if (temp_solar_system_celestial_object_index != -1)
		{
			// Find Solar System Update Order Array
			var temp_solar_system_update_order = CelestialSimulator.solar_systems_orbit_update_order[temp_solar_system_index];
			
			// Remove Celestial Object from the Solar System and Solar System Orbit Update Order
			array_delete(temp_solar_system, temp_solar_system_celestial_object_index, 1);
			array_delete(temp_solar_system_update_order, temp_solar_system_celestial_object_index, 1);
			
			// Update the Orbit Parent Instance of every Celestial Object in the Solar System connected to the added Celestial Object
			for (var n = 0; n < array_length(temp_solar_system); n++)
			{
				if (temp_solar_system[n].orbit_id == celestial_object.celestial_id)
				{
					temp_solar_system[n].orbit_parent_instance = noone;
				}
			}
		}
	}
}

load_solar_system = function(solar_system_id)
{
	// Check if Solar System is an Empty Index
	if (solar_system_id == -1)
	{
		// Load Empty Solar System
		CelestialSimulator.solar_system_index = solar_system_id;
		return;
	}
	
	// Check if Solar System ID exists
	for (var q = 0; q < array_length(CelestialSimulator.solar_systems_ids); q++)
	{
		// Solar System ID comparison
		if (solar_system_id == CelestialSimulator.solar_systems_ids[q])
		{
			// Solar System with Solar System ID exists - Load Solar System
			CelestialSimulator.solar_system_index = q;
			return;
		}
	}
}

reset_solar_system_orbit_update_order = function(solar_system_id)
{
	// Establish empty Solar System Index
	var temp_solar_system_index = -1;
	
	// Iterate through Solar System IDs to check if Solar System exists
	for (var q = 0; q < array_length(CelestialSimulator.solar_systems_ids); q++)
	{
		// Solar System ID comparison
		if (solar_system_id == CelestialSimulator.solar_systems_ids[q])
		{
			// Solar System exists - Reset Solar System's Update Order
			temp_solar_system_index = q;
			break;
		}
	}
	
	// Check if Solar System ID exists
	if (temp_solar_system_index != -1)
	{
		// Find Solar System Array
		var temp_solar_system = CelestialSimulator.solar_systems[temp_solar_system_index];
		
		// Find Solar System Orbit Update Order Array
		var temp_solar_system_update_order = CelestialSimulator.solar_systems_orbit_update_order[temp_solar_system_index];
		
		// Clear Solar System Orbit Update Order Array
		array_clear(temp_solar_system_update_order);
		
		// Create Orbit Update Order Sorting DS Lists
		var temp_solar_system_index_list = ds_list_create();
		var temp_solar_system_orbit_id_list = ds_list_create();
		var temp_solar_system_celestial_id_list = ds_list_create();
		
		// Iterate through Solar System Celestial Objects to index Orbit Parents
		for (var l = array_length(temp_solar_system) - 1; l >= 0; l--)
		{
			// Check if Orbit ID is valid
			if (string_length(temp_solar_system[l].orbit_id) == 0)
			{
				// Celestial Object does not have an Orbit Parent - Add Celestial Object Index to Execution Order
				array_push(temp_solar_system_update_order, l);
			}
			else
			{
				// Index Celestial Object in Orbit Update Order Sorting Lists
				ds_list_add(temp_solar_system_index_list, l);
				ds_list_add(temp_solar_system_orbit_id_list, temp_solar_system[l].orbit_id);
				ds_list_add(temp_solar_system_celestial_id_list, temp_solar_system[l].celestial_id);
			}
		}
		
		// Add all remaining unsorted Celestial Objects in Solar System to Orbit Update Order Array
		while (ds_list_size(temp_solar_system_index_list) > 0)
		{
			// Iterate through all Celestial Objects 
			for (var n = ds_list_size(temp_solar_system_index_list) - 1; n >= 0; n--)
			{
				// Check if Celestial Object has an Orbit Parent still waiting to be Indexed
				if (ds_list_find_index(temp_solar_system_celestial_id_list, ds_list_find_value(temp_solar_system_orbit_id_list, n)) == -1)
				{
					// Index Celestial Object in Solar System's Orbit Update Order Array
					array_push(temp_solar_system_update_order, ds_list_find_value(temp_solar_system_index_list, n));
					
					// Remove Celestial Object from Orbit Update Order Sorting Lists
					ds_list_delete(temp_solar_system_index_list, n);
					ds_list_delete(temp_solar_system_orbit_id_list, n);
					ds_list_delete(temp_solar_system_celestial_id_list, n);
				}
			}
		}
		
		// Destroy Unused Solar System Orbit Update Order Sorting DS Lists
		ds_list_destroy(temp_solar_system_index_list);
		ds_list_destroy(temp_solar_system_orbit_id_list);
		ds_list_destroy(temp_solar_system_celestial_id_list);
		
		temp_solar_system_index_list = -1;
		temp_solar_system_orbit_id_list = -1;
		temp_solar_system_celestial_id_list = -1;
	}
}

generate_solar_system_background_stars_vertex_buffer = function(solar_system_id, stars)
{
	// Establish empty Solar System Index
	var temp_solar_system_index = -1;
	
	// Iterate through Solar System IDs to check if Solar System exists
	for (var q = 0; q < array_length(CelestialSimulator.solar_systems_ids); q++)
	{
		// Solar System ID comparison
		if (solar_system_id == CelestialSimulator.solar_systems_ids[q])
		{
			// Solar System exists - Create Solar System Background Stars Vertex Buffer
			temp_solar_system_index = q;
			break;
		}
	}
	
	// Check if Solar System ID exists
	if (temp_solar_system_index == -1)
	{
		// Solar System does not exist - Early Return
		return;
	}
	
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
		
		repeat (array_length(CelestialSimulator.background_star_sphere.triangles))
		{
			// Retreive Triangle Data
			var temp_triangle = CelestialSimulator.background_star_sphere.triangles[temp_triangle_index];
			
			// Obtain Triangle Vertex Positions
			var temp_triangle1_pos = CelestialSimulator.background_star_sphere.vertices[temp_triangle[0]];
			var temp_triangle2_pos = CelestialSimulator.background_star_sphere.vertices[temp_triangle[1]];
			var temp_triangle3_pos = CelestialSimulator.background_star_sphere.vertices[temp_triangle[2]];
			
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
	
	// Index Background Stars Vertex Buffer within Celestial Simulator's Solar Systems Array
	CelestialSimulator.solar_systems_background_stars_vertex_buffer[temp_solar_system_index] = temp_background_stars_vertex_buffer;
}

// Universe Campaign Generation
generate_default_solar_system = function()
{
	//
	camera_position_z = 0;
	
	//
	add_solar_system("grandmom", "Grandmother");
	add_celestial_object("grandmom", instance_create_depth(0, 0, 0, oPlanet_Mom, {  image_blend: make_color_rgb(8, 0, 15), ocean_elevation: 0.2, orbit_size: 400, orbit_speed: 0, orbit_rotation: 270, rotation_speed: 0.3 }));
	add_celestial_object("grandmom", instance_create_depth(0, 0, 0, oMoon_Dad, {  image_blend: make_color_rgb(8, 0, 15) }));
	//add_celestial_object("grandmom", instance_create_depth(0, 0, 0, oSun, { image_blend: c_red, radius: 60}));
	add_celestial_object("grandmom", instance_create_depth(0, 0, 0, oSun, { image_blend: c_red, radius: 60, orbit_size: 1000, orbit_speed: 0, orbit_rotation: 90 }));
	generate_solar_system_background_stars_vertex_buffer("grandmom", 3000);
	
	//temp_grandmom_solar_system[2] = instance_create_depth(0, 0, 0, oSun, { image_blend: c_red, radius: 60, orbit_speed: 0 });
	//temp_grandmom_solar_system[2] = instance_create_depth(0, 0, 0, oSun, { image_blend: c_red, radius: 60, orbit_size: 8000, orbit_speed: 0, orbit_angle: 270 });
	
	//temp_grandmom_solar_system[1] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(8, 0, 15), orbit_size: 400 } );
	
	//temp_grandmom_solar_system[0] = instance_create_depth(0, 0, 0, oSun, { image_blend: c_red, radius: 60, orbit_size: 1600, orbit_speed: 0, orbit_angle: 90 });
	//temp_grandmom_solar_system[1] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(8, 0, 15), orbit_size: 0, rotation_speed: 0 } );
	
	//temp_grandmom_solar_system[1] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(8, 0, 15), ocean_roughness: 0, orbit_size: 500 } );
	//temp_grandmom_solar_system[2] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(50, 50, 50), orbit_size: 300, orbit_speed: 2  } );
	//temp_grandmom_solar_system[3] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(50, 50, 50), orbit_size: 500, orbit_speed: -0.5 } );
	//temp_grandmom_solar_system[4] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(50, 50, 50), orbit_size: 800, orbit_speed: -1 } );
	
	//
	for (var q = 0; q < array_length(CelestialSimulator.solar_systems_ids); q++)
	{
		//
		reset_solar_system_orbit_update_order(CelestialSimulator.solar_systems_ids[q]);
	}
	
	//
	load_solar_system("grandmom");
}

// DEBUG
//planet_simulator_add_light_source(-500, 240, -1400, make_color_rgb(206, 185, 240), 3000, 3, 2);
//planet_simulator_add_light_source(1000, 240, -1400, c_red, 100, 1, 2);
generate_default_solar_system();

//cloud_noise(2048, 256);
