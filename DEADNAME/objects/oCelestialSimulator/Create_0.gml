/// @description Celestial Simulator Singleton Init Event
// Self-Creating Celestial Simulator Init Behaviour Event

// Global Celestial Simulator Properties
#macro CelestialSimulator global.celestial_simulator
#macro CelestialSimMaxLights 6
#macro CelestialSimMaxShadows 8
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

enum CelestialSubObjectType
{
	None,
	Unit,
	City,
	Satellite,
	Battle
}

enum CelestialSolarType
{
	Day = 0,
	Twilight = 1,
	Night = 2
}

enum CelestialTerrainType
{
	Land,
	Air,
	Sea
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
active = false;

// Camera Settings
camera_fov = 60;

camera_z_near = 1;
camera_z_far = 32000;

camera_z_near_depth_overpass = -(800 + camera_z_near);

camera_observing_instance_zoom_spd = 0.15;
camera_observing_instance_drag_spd_min = 0.2;
camera_observing_instance_drag_spd_max = 0.75;

camera_observing_instance_radius_offset_zoom_in_threshold = 0.1;

// Solar System Settings
background_star_sphere = geodesic_icosphere_create(2);

// Clock Settings
global_clock_delta_time_multiplier = 0.2;

global_clock_hydrosphere_delta_time_multiplier = 0.0037;

// Collision Settings
global_collision_check_interval = 8;

// Pathfinding Settings
global_pathfinding_queue_calculations_max = 5;

// Rendering Settings
global_noise_time_spd = 0.03;

global_hydrosphere_specular_intensity = 0.5;

global_clouds_scatter_point_samples_count = 8;
global_clouds_light_depth_samples_count = 8;
global_clouds_sample_scale = 0.008;
global_clouds_absorption = 0.25;
global_clouds_density = 1;
global_clouds_density_falloff = 5;
global_clouds_anisotropic_light_scattering_strength = 0.4;
global_clouds_alpha_blending_power = 1.5;
global_clouds_temporal_blue_noise_offset = 0.03;

global_atmosphere_scatter_point_samples_count = 10;
global_atmosphere_optical_depth_samples_count = 10;

global_no_atmosphere_radius_padding = 32;

global_sub_objects_unit_depth_offset = 5;
global_sub_objects_city_depth_offset = 10;
global_sub_objects_battle_depth_offset = -10;
global_sub_objects_default_depth_transparent_start = -0.4;
global_sub_objects_default_depth_transparent_end = -0.2;
global_sub_objects_satellite_depth_transparent_start = -0.3;
global_sub_objects_satellite_depth_transparent_end = 0.5;

global_render_path_depth_transparent_start = -0.4;
global_render_path_depth_transparent_end = -0.25;

// Bloom Settings
bloom_global_size = 3;
bloom_global_color = c_white;
bloom_global_intensity = 1.0;

// Sub Object UI Settings
sub_object_city_name_vertical_offset = -8;

// Battle UI Settings
battle_platform_animation_spd = 0.01;
battle_platform_animation_square_size = 42;
battle_platform_animation_cycle_count = 2;

battle_platform_top_horizontal_width = 420;
battle_platform_top_vertical_position = 240;
battle_platform_bottom_horizontal_width = 620;
battle_platform_bottom_vertical_position = 340;

battle_default_column_size = 9;

battle_tile_padding_horizontal = 0.0028;
battle_tile_padding_vertical = 0.01;

battle_camera_observing_lerp_spd = 0.05;
battle_camera_observing_lerp_multiplier = 1.8;

// Triangle UI Settings
triangle_angle = -105;
triangle_radius = 4;
triangle_offset = -5;

triangle_breath_padding = 5;

triangle_rotate_range = 30;
triangle_rotate_spd = 2;

triangle_animation_speed = 0.01;

// Player Variables
player_faction = noone;

// Camera Variables
camera_instance = camera_create();

camera_position_x = 0;
camera_position_y = 0;
camera_position_z = 0;

camera_view_matrix = matrix_build_lookat(0, 0, 0, 0, 0, 1, 0, 1, 0);
camera_projection_matrix = matrix_build_projection_perspective_fov(-camera_fov, -640 / 360, camera_z_near, camera_z_far);

camera_observing_instance = noone;
camera_observing_instance_radius_offset_value = 0.5;

camera_observing_polar_horizontal_angle = 0;
camera_observing_polar_vertical_angle = 0;

camera_observing_drag = false;
camera_observing_drag_start_x = 0;
camera_observing_drag_start_y = 0;
camera_observing_drag_polar_horizontal_angle = 0;
camera_observing_drag_polar_vertical_angle = 0;

// Solar System Variables
solar_system_index = -1;
solar_systems = array_create(0);
solar_systems_ids = array_create(0);
solar_systems_names = array_create(0);
solar_systems_suns = array_create(0);
solar_systems_orbit_update_order = array_create(0);
solar_systems_background_stars_vertex_buffer = array_create(0);

// Clock Variables
global_clock_delta_time = 0;

// Pathfinding Variables
pathfinding_queue_list = ds_list_create();

// Faction Variables
factions = array_create(0);

// Rendering Variables
global_noise_time = 0;
global_hydrosphere_time = 0;

solar_system_render_depth_sorting_index_array = array_create(0);
solar_system_render_depth_sorting_depth_array = array_create(0);

clouds_render_depth_sorting_index_array = array_create(0);
clouds_render_depth_sorting_depth_array = array_create(0);

sub_objects_back_render_depth_sorting_index_array = array_create(0);
sub_objects_back_render_depth_sorting_depth_array = array_create(0);

sub_objects_front_render_depth_sorting_index_array = array_create(0);
sub_objects_front_render_depth_sorting_depth_array = array_create(0);

// Input Variables
input_select = false;
input_action = false;

// Selection Variables
sub_object_selected_instance = noone;

selected_unit_movement_path_ui = false;
selected_unit_movement_path_entries = 0;
selected_unit_movement_path_depth_sorting_index_array = array_create(0);
selected_unit_movement_path_depth_sorting_depth_array = array_create(0);
selected_unit_movement_path_point_a_position_x_array = array_create(0);
selected_unit_movement_path_point_a_position_y_array = array_create(0);
selected_unit_movement_path_point_a_alpha_array = array_create(0);
selected_unit_movement_path_point_b_position_x_array = array_create(0);
selected_unit_movement_path_point_b_position_y_array = array_create(0);
selected_unit_movement_path_point_b_alpha_array = array_create(0);

// Battle UI Variables
battle_platform_animation = false;
battle_platform_animation_momentum = 0;
battle_platform_animation_value = 0;
battle_platform_animation_cycles = 0;

battle_camera_observing_lerp = 0;
battle_camera_observing_polar_horizontal_angle = 0;
battle_camera_observing_polar_vertical_angle = 0;

battle_choreography_stack = array_create(0);

// Triangle UI Variables
triangle_animation_value = 0;
triangle_breath_value = 0;
triangle_draw_angle = 0;

tri_x_1 = 0;
tri_y_1 = 0;
tri_x_2 = 0;
tri_y_2 = 0;
tri_x_3 = 0;
tri_y_3 = 0;

// Surfaces
background_surface = -1;

temp_surface = -1;

celestial_body_render_surface = -1;
celestial_body_diffuse_surface = -1;
celestial_body_emissive_surface = -1;
celestial_body_atmosphere_depth_mask_surface = -1;

clouds_render_surface = -1;

post_processing_surface = -1;

diffuse_surface = -1;
emissive_surface = -1;
bloom_premult_surface = -1;

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

// MRT (Unlit) Celestial Sprite Rendering Shader Indexes
celestial_sprite_unlit_shader_emissive_index = shader_get_uniform(shd_celestial_sprite_unlit, "u_Emissive");
celestial_sprite_unlit_shader_depth_index = shader_get_uniform(shd_celestial_sprite_unlit, "u_Depth");

// MRT (Unlit) Celestial Pathfinding Path Rendering Shader Indexes
celestial_path_unlit_shader_depth_index = shader_get_uniform(shd_celestial_path_unlit, "u_Depth");

// MRT (Forward Rendered Lighting) Planet Lithosphere Lit Rendering Shader Indexes
planet_lithosphere_lit_shader_vsh_camera_position_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_vsh_CameraPosition");
planet_lithosphere_lit_shader_fsh_camera_position_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_fsh_CameraPosition");

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
planet_lithosphere_lit_shader_light_emitter_size_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Light_Emitter_Size");

planet_lithosphere_lit_shader_shadow_exists_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Shadow_Exists");
planet_lithosphere_lit_shader_shadow_radius_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Shadow_Radius");

planet_lithosphere_lit_shader_shadow_position_x_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Shadow_Position_X");
planet_lithosphere_lit_shader_shadow_position_y_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Shadow_Position_Y");
planet_lithosphere_lit_shader_shadow_position_z_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_Shadow_Position_Z");

planet_lithosphere_lit_shader_emissive_index = shader_get_uniform(shd_planet_lithosphere_lit, "u_Emissive");

planet_lithosphere_lit_shader_planet_texture_index = shader_get_sampler_index(shd_planet_lithosphere_lit, "in_PlanetTexture");

// MRT (Forward Rendered Lighting) Planet Hydrosphere Lit Rendering Shader Indexes
planet_hydrosphere_lit_shader_vsh_camera_position_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_vsh_CameraPosition");
planet_hydrosphere_lit_shader_fsh_camera_position_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_fsh_CameraPosition");

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

planet_hydrosphere_lit_shader_vsh_atmosphere_radius_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_vsh_AtmosphereRadius");
planet_hydrosphere_lit_shader_fsh_atmosphere_radius_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_fsh_AtmosphereRadius");

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
planet_hydrosphere_lit_shader_light_emitter_size_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Light_Emitter_Size");

planet_hydrosphere_lit_shader_shadow_exists_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Shadow_Exists");
planet_hydrosphere_lit_shader_shadow_radius_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Shadow_Radius");

planet_hydrosphere_lit_shader_shadow_position_x_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Shadow_Position_X");
planet_hydrosphere_lit_shader_shadow_position_y_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Shadow_Position_Y");
planet_hydrosphere_lit_shader_shadow_position_z_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_Shadow_Position_Z");

planet_hydrosphere_lit_shader_emissive_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_Emissive");

// (Forward Rendered Lighting) Planet without Atmosphere Lit Rendering Shader Indexes
planet_no_atmosphere_lit_shader_planet_radius_index = shader_get_uniform(shd_planet_no_atmosphere_lit, "u_PlanetRadius");
planet_no_atmosphere_lit_shader_planet_position_index = shader_get_uniform(shd_planet_no_atmosphere_lit, "u_PlanetPosition");

planet_no_atmosphere_lit_shader_celestial_body_diffuse_surface_texture_index = shader_get_sampler_index(shd_planet_no_atmosphere_lit, "gm_CelestialBodyDiffuseSurface");
planet_no_atmosphere_lit_shader_celestial_body_emissive_surface_texture_index = shader_get_sampler_index(shd_planet_no_atmosphere_lit, "gm_CelestialBodyEmissiveSurface");

// (Forward Rendered Lighting) Planet Atmosphere Lit Rendering Shader Indexes
planet_atmosphere_lit_shader_camera_position_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_CameraPosition");
planet_atmosphere_lit_shader_camera_dimensions_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_CameraDimensions");

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
planet_atmosphere_lit_shader_light_emitter_size_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Light_Emitter_Size");

planet_atmosphere_lit_shader_shadow_exists_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Shadow_Exists");
planet_atmosphere_lit_shader_shadow_radius_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Shadow_Radius");

planet_atmosphere_lit_shader_shadow_position_x_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Shadow_Position_X");
planet_atmosphere_lit_shader_shadow_position_y_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Shadow_Position_Y");
planet_atmosphere_lit_shader_shadow_position_z_index = shader_get_uniform(shd_planet_atmosphere_lit, "in_Shadow_Position_Z");

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

planet_atmosphere_lit_shader_celestial_body_diffuse_surface_texture_index = shader_get_sampler_index(shd_planet_atmosphere_lit, "gm_CelestialBodyDiffuseSurface");
planet_atmosphere_lit_shader_celestial_body_emissive_surface_texture_index = shader_get_sampler_index(shd_planet_atmosphere_lit, "gm_CelestialBodyEmissiveSurface");

// MRT (Forward Rendered Lighting) Signed Distance Field Sphere-Shaped Volumetric Clouds Lit Rendering Shader Indexes
sdf_sphere_volumetric_clouds_lit_shader_camera_position = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_CameraPosition");

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
sdf_sphere_volumetric_clouds_lit_shader_light_emitter_size_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Light_Emitter_Size");

sdf_sphere_volumetric_clouds_lit_shader_shadow_exists_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Shadow_Exists");
sdf_sphere_volumetric_clouds_lit_shader_shadow_radius_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Shadow_Radius");

sdf_sphere_volumetric_clouds_lit_shader_shadow_position_x_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Shadow_Position_X");
sdf_sphere_volumetric_clouds_lit_shader_shadow_position_y_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Shadow_Position_Y");
sdf_sphere_volumetric_clouds_lit_shader_shadow_position_z_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "in_Shadow_Position_Z");

sdf_sphere_volumetric_clouds_lit_shader_atmosphere_radius_index = shader_get_uniform(shd_sdf_sphere_volumetric_cloud_lit, "u_AtmosphereRadius");

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

// Bloom Effect Surface Rendering Shader Indexes
bloom_effect_render_shader_surface_texel_size_index  = shader_get_uniform(shd_celestial_bloom_effect_render, "in_TexelSize");
bloom_effect_render_shader_alpha_multiplier_index  = shader_get_uniform(shd_celestial_bloom_effect_render, "in_AlphaMult");

bloom_effect_render_shader_diffusemap_index  = shader_get_sampler_index(shd_celestial_bloom_effect_render, "in_DiffuseMap");
bloom_effect_render_shader_emissivemap_index  = shader_get_sampler_index(shd_celestial_bloom_effect_render, "in_EmissiveMap");

// Sun Unlit Rendering Shader Indexes
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
light_source_emitter_size = array_create(CelestialSimMaxLights);

// Render Depth Sort Type Functions
sub_objects_back_render_depth_sort = function(current, next) 
{
	return CelestialSimulator.sub_objects_back_render_depth_sorting_depth_array[next] < CelestialSimulator.sub_objects_back_render_depth_sorting_depth_array[current] ? -1 : 1;
}

sub_objects_front_render_depth_sort = function(current, next) 
{
	return CelestialSimulator.sub_objects_front_render_depth_sorting_depth_array[next] < CelestialSimulator.sub_objects_front_render_depth_sorting_depth_array[current] ? -1 : 1;
}

clouds_render_depth_sort = function(current, next) 
{
	return CelestialSimulator.clouds_render_depth_sorting_depth_array[next] < CelestialSimulator.clouds_render_depth_sorting_depth_array[current] ? -1 : 1;
}

selected_unit_movement_path_render_depth_sort = function(current, next) 
{
	return CelestialSimulator.selected_unit_movement_path_depth_sorting_depth_array[next] < CelestialSimulator.selected_unit_movement_path_depth_sorting_depth_array[current] ? -1 : 1;
}

solar_system_render_depth_sort = function(current, next) 
{
	return CelestialSimulator.solar_system_render_depth_sorting_depth_array[next] < CelestialSimulator.solar_system_render_depth_sorting_depth_array[current] ? -1 : 1;
}

battle_choreography_stack_depth_sort = function(current, next) 
{
	return next.vertical_depth > current.vertical_depth ? -1 : 1;
}

// Sub Object Methods
select_sub_object_instance = function(sub_object_instance)
{
	// Set given Sub Object Instance as the Celestial Simulator's Selected Sub Object Instance
	sub_object_selected_instance = sub_object_instance;
	
	// Check if New Select Input Sub Object Instance Exists
	if (instance_exists(sub_object_selected_instance))
	{
		// Select Input Sub Object Behaviour
		switch (sub_object_selected_instance.celestial_sub_object_type)
		{
			case CelestialSubObjectType.Battle:
				// Reset Battle Selection Animation Variables
				battle_platform_animation = true;
				battle_platform_animation_momentum = 0;
				battle_platform_animation_value = 0;
				battle_platform_animation_cycles = 0;
				
				battle_camera_observing_lerp = 0;
				battle_camera_observing_polar_horizontal_angle = camera_observing_polar_horizontal_angle;
				battle_camera_observing_polar_vertical_angle = camera_observing_polar_vertical_angle;
				break;
			case CelestialSubObjectType.Unit:
			case CelestialSubObjectType.City:
			case CelestialSubObjectType.Satellite:
			default:
				break;
		}
	}
}

// Solar System Methods
clear_celestial_sim = function()
{
	// Iterate through Solar Systems
	var temp_solar_system_count = array_length(CelestialSimulator.solar_systems_ids);
	var temp_solar_system_index = temp_solar_system_count - 1;
	
	repeat (temp_solar_system_count)
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
		
		array_resize(temp_solar_system, 0);
		array_delete(CelestialSimulator.solar_systems, temp_solar_system_index, 1);
		
		// Delete Solar System's Update Order Array from Celestial Simulator's Arrays
		var temp_solar_system_update_order = CelestialSimulator.solar_systems_orbit_update_order[temp_solar_system_index];
		array_resize(temp_solar_system_update_order, 0);
		array_delete(CelestialSimulator.solar_systems_orbit_update_order, temp_solar_system_index, 1);
		
		// Delete Background Stars Vertex Buffer from Background Stars Vertex Buffer Array
		vertex_delete_buffer(CelestialSimulator.solar_systems_background_stars_vertex_buffer[temp_solar_system_index]);
		CelestialSimulator.solar_systems_background_stars_vertex_buffer[temp_solar_system_index] = -1;
		
		// Decrement Solar System Index
		temp_solar_system_index--;
	}
	
	// Clear all Celestial Simulator's Solar System Arrays
	array_resize(CelestialSimulator.solar_systems, 0);
	array_resize(CelestialSimulator.solar_systems_ids, 0);
	array_resize(CelestialSimulator.solar_systems_names, 0);
	array_resize(CelestialSimulator.solar_systems_suns, 0);
	array_resize(CelestialSimulator.solar_systems_orbit_update_order, 0);
	array_resize(CelestialSimulator.solar_systems_background_stars_vertex_buffer, 0);
	
	// Clear Celestial Simulator's Faction Array
	array_resize(CelestialSimulator.factions, 0);
	
	// Destroy Remaining Celestial Instances
	with (oCelestialFaction)
	{
		instance_destroy();
	}
	
	with (oCelestialBody)
	{
		instance_destroy();
	}
	
	with (oCelestialSubObject)
	{
		instance_destroy();
	}
	
	with (oCelestialBattle)
	{
		instance_destroy();
	}
}

add_solar_system = function(solar_system_id, solar_system_name)
{
	// Check if Solar System ID already exists
	if (array_contains(CelestialSimulator.solar_systems_ids, solar_system_id))
	{
		// Solar System already exists - Early Return
		return;
	}
	
	// Create Solar System and Index Solar System in Celestial Simulator's Solar System Arrays
	var temp_solar_system_index = array_length(CelestialSimulator.solar_systems);
	
	array_push(CelestialSimulator.solar_systems, array_create(0));
	array_push(CelestialSimulator.solar_systems_ids, solar_system_id);
	array_push(CelestialSimulator.solar_systems_names, solar_system_name);
	array_push(CelestialSimulator.solar_systems_suns, noone);
	array_push(CelestialSimulator.solar_systems_orbit_update_order, array_create(0));
	array_push(CelestialSimulator.solar_systems_background_stars_vertex_buffer, -1);
}

remove_solar_system = function(solar_system_id)
{
	// Find Solar System's Index based on Solar System ID
	var temp_solar_system_index = array_get_index(CelestialSimulator.solar_systems_ids, solar_system_id);
	
	// Check if Solar System ID exists in Celestial Simulator's Solar Systems 
	if (temp_solar_system_index != -1)
	{
		// Solar System exists - Delete Solar System
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
		
		array_resize(temp_solar_system, 0);
		array_delete(CelestialSimulator.solar_systems, temp_solar_system_index, 1);
		
		// Delete Solar System's ID, Name, and Sun Instance from Celestial Simulator's Arrays
		array_delete(CelestialSimulator.solar_systems_ids, temp_solar_system_index, 1);
		array_delete(CelestialSimulator.solar_systems_names, temp_solar_system_index, 1);
		array_delete(CelestialSimulator.solar_systems_suns, temp_solar_system_index, 1);
		
		// Delete Solar System's Update Order Array from Celestial Simulator's Arrays
		var temp_solar_system_update_order = CelestialSimulator.solar_systems_orbit_update_order[temp_solar_system_index];
		array_resize(temp_solar_system_update_order, 0);
		array_delete(CelestialSimulator.solar_systems_orbit_update_order, temp_solar_system_index, 1);
		
		// Delete Background Stars Vertex Buffer from Background Stars Vertex Buffer Array
		vertex_delete_buffer(CelestialSimulator.solar_systems_background_stars_vertex_buffer[temp_solar_system_index]);
		CelestialSimulator.solar_systems_background_stars_vertex_buffer[temp_solar_system_index] = -1;
		array_delete(CelestialSimulator.solar_systems_background_stars_vertex_buffer, temp_solar_system_index, 1);
	}
}

add_celestial_object = function(solar_system_id, celestial_object)
{
	// Find Solar System's Index based on Solar System ID
	var temp_solar_system_index = array_get_index(CelestialSimulator.solar_systems_ids, solar_system_id);
	
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
		
		// Update Solar System Sun Instance if Sun
		if (celestial_object.celestial_object_type == CelestialObjectType.Sun and !instance_exists(CelestialSimulator.solar_systems_suns[temp_solar_system_index]))
		{
			CelestialSimulator.solar_systems_suns[temp_solar_system_index] = celestial_object;
		}
	}
}

remove_celestial_object = function(solar_system_id, celestial_object)
{
	// Find Solar System's Index based on Solar System ID
	var temp_solar_system_index = array_get_index(CelestialSimulator.solar_systems_ids, solar_system_id);
	
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
			
			// Remove Celestial Object as Solar System Sun Instance if it was the active Sun in the Solar System
			if (CelestialSimulator.solar_systems_suns[temp_solar_system_index] == celestial_object)
			{
				CelestialSimulator.solar_systems_suns[temp_solar_system_index] = noone;
			}
		}
	}
}

load_solar_system = function(solar_system_id)
{
	// Check if Solar System is an Empty Index
	if (solar_system_id == -1 or !array_contains(CelestialSimulator.solar_systems_ids, solar_system_id))
	{
		// Load Empty Solar System
		CelestialSimulator.solar_system_index = -1;
		return;
	}
	
	// Solar System with Solar System ID exists - Load Solar System
	CelestialSimulator.solar_system_index = array_get_index(CelestialSimulator.solar_systems_ids, solar_system_id);
	
	// Reset Celestial Simulator Selected Celestial Sub-Object
	CelestialSimulator.select_sub_object_instance(noone);
	
	// Reset Celestial Simulator Camera Observing Instance
	CelestialSimulator.camera_observing_instance = noone;
	
	// Reset Celestial Unit Notifications
	with (oCelestialUnit)
	{
		// Reset Unit Notification Timers
		emotion_battle_popup_timer = -1;
	}
	
	// Reset Celestial City Notifications
	with (oCelestialCity)
	{
		// Destroy City Notifications Array
		var temp_notification_count = array_length(notifications);
		var temp_notification_index = temp_notification_count - 1;
		
		repeat (temp_notification_count)
		{
			// Delete Notifications Struct
			delete notifications[temp_notification_index];
			
			// Decrement Notifications Index
			temp_notification_index--;
		}
		
		array_resize(notifications, 0);
	}
}

create_celestial_shadows = function(solar_system_id, celestial_ids_array)
{
	// Find Solar System's Index based on Solar System ID
	var temp_solar_system_index = array_get_index(CelestialSimulator.solar_systems_ids, solar_system_id);
	
	// Check if Solar System ID exists
	if (temp_solar_system_index != -1)
	{
		// Find Solar System Array
		var temp_solar_system = CelestialSimulator.solar_systems[temp_solar_system_index];
		
		// Create Empty Celestial Objects Array
		var temp_celestial_objects_array = array_create(0);
		
		// Iterate through Celestial Objects within Solar System to check if they 
		for (var n = 0; n < array_length(temp_solar_system); n++)
		{
			// Check if Celestial Object's Celestial ID matches any Celestial ID in the given Celestial IDs Array
			if (!array_contains(celestial_ids_array, temp_solar_system[n].celestial_id))
			{
				continue;
			}
			
			// Celestial Object Type Behaviour
			switch (temp_solar_system[n].celestial_object_type)
			{
				case CelestialObjectType.Planet:
					// Celestial Object Type does support Shadows - Add Celestial Object for Shadow Indexing
					array_push(temp_celestial_objects_array, temp_solar_system[n]);
					break;
				default:
					// Celestial Object Type does not support Shadows - Skip Behaviour
					break;
			}
		}
		
		// Iterate through Celestial Object Array to add Shadows to each other
		for (var j = array_length(temp_celestial_objects_array) - 1; j >= 0; j--)
		{
			// Nested Loop to add each others' Shadows
			for (var l = array_length(temp_celestial_objects_array) - 1; l >= 0; l--)
			{
				// Check if on the same index - Can't add your own shadow
				if (j == l)
				{
					continue;
				}
				
				// Check if this Celestial Object already has the Celestial Object about to be added as a Shadow
				if (array_contains(temp_celestial_objects_array[j].sphere_shadow_instance, temp_celestial_objects_array[l].sphere_shadow_instance))
				{
					continue;
				}
				
				// Iterate through Celestial Object's Shadow Array to add Shadow
				for (var m = 0; m < CelestialSimMaxShadows; m++)
				{
					if (!instance_exists(temp_celestial_objects_array[j].sphere_shadow_instance[m]) or !temp_celestial_objects_array[j].sphere_shadow_exists[m])
					{
						// Add Shadow Instance
						temp_celestial_objects_array[j].sphere_shadow_exists[m] = true;
						temp_celestial_objects_array[j].sphere_shadow_instance[m] = temp_celestial_objects_array[l];
						
						// Exit Loop
						break;
					}
				}
			}
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
		array_resize(temp_solar_system_update_order, 0);
		
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
		var temp_triangle_count = array_length(CelestialSimulator.background_star_sphere.triangles);
		
		repeat (temp_triangle_count)
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

// Rendering Methods
render_celestial_object_sub_object_layer = function(celestial_object, front_layer = true)
{
	// (Multiple Render Targets) Set Celestial Body Render, Diffuse, Emissive, & Atmospheric Depth Surfaces as Surface Targets
	surface_set_target_ext(0, CelestialSimulator.celestial_body_render_surface);
	surface_set_target_ext(1, CelestialSimulator.celestial_body_diffuse_surface);
	surface_set_target_ext(2, CelestialSimulator.celestial_body_emissive_surface);
	surface_set_target_ext(3, CelestialSimulator.celestial_body_atmosphere_depth_mask_surface);
	
	// Reset Camera Orientation
	camera_set_view_mat(GameManager.camera_instance, GameManager.view_matrix);
	camera_set_proj_mat(GameManager.camera_instance, GameManager.projection_matrix);
	camera_apply(GameManager.camera_instance);
	
	// Reset Matrix World Identity
	matrix_set(matrix_world, GameManager.identity_matrix);
	
	// Enable Celestial Sprite Unlit Rendering Shader
	shader_set(shd_celestial_sprite_unlit);
	
	// Check if Celestial Simulator should Render the Miniature Version of the Sub Object's Sprite
	var temp_sub_object_miniature_icon = CelestialSimulator.camera_observing_instance_radius_offset_value > CelestialSimulator.camera_observing_instance_radius_offset_zoom_in_threshold or CelestialSimulator.camera_observing_instance != celestial_object;
	
	// Establish Sub Objects Arrays based on if Rendering the Front or Back Layer of the Celestial Object
	var temp_sub_objects_index_array = front_layer ? celestial_object.sub_objects_front_layer_index_array : celestial_object.sub_objects_back_layer_index_array;
	var temp_sub_objects_depth_array = front_layer ? celestial_object.sub_objects_front_layer_depth_array : celestial_object.sub_objects_back_layer_depth_array;
	var temp_sub_objects_instance_array = front_layer ? celestial_object.sub_objects_front_layer_instance_array : celestial_object.sub_objects_back_layer_instance_array;
	
	// Iterate through Celestial Object's Depth Sorted Celestial Sub Objects
	var temp_sub_object_index = 0;
	var temp_sub_object_count = array_length(temp_sub_objects_index_array);
	
	repeat (temp_sub_object_count)
	{
		// Find Celestial Object's Sub Object Index
		var temp_index = temp_sub_objects_index_array[temp_sub_object_index];
		
		// Find Celestial Object's Sub Object Depth & Instance from Sub Object Index
		var temp_depth = temp_sub_objects_depth_array[temp_index];
		var temp_instance = temp_sub_objects_instance_array[temp_index];
		
		// Establish Sub Object's Unlit Sprite Index and Image Index
		var temp_sprite_index = temp_sub_object_miniature_icon and temp_instance != CelestialSimulator.sub_object_selected_instance ? temp_instance.miniature_sprite_index : temp_instance.sprite_index;
		var temp_image_index = temp_sub_object_miniature_icon and temp_instance != CelestialSimulator.sub_object_selected_instance ? 0 : temp_instance.image_index;
		
		// Calculate Sprite Vertical Offset
		var temp_sprite_vertical_offset = -sprite_get_yoffset(temp_sprite_index) + sprite_get_bbox_top(temp_sprite_index);
		
		// Establish Sub Object's Unlit Sprite Alpha
		var temp_alpha = temp_instance.image_alpha;
		
		// Check Celestial Sub Object's Sub Object Type to perform appropriate Render Behaviour
		switch (temp_instance.celestial_sub_object_type)
		{
			case CelestialSubObjectType.City:
			case CelestialSubObjectType.Unit:
			case CelestialSubObjectType.Battle:
				// Establish Sub Object's Unlit Sprite Alpha Transparency
				var temp_default_depth_alpha = inverse_lerp(celestial_object.render_depth_radius * CelestialSimulator.global_sub_objects_default_depth_transparent_end, celestial_object.render_depth_radius * CelestialSimulator.global_sub_objects_default_depth_transparent_start, temp_depth);
				temp_alpha *= power(temp_default_depth_alpha, 3);
				
				// Establish Sub Object's Unlit Sprite Shader Depth Rendering Properties
				shader_set_uniform_f(CelestialSimulator.celestial_sprite_unlit_shader_depth_index, lerp(celestial_object.render_depth_radius, temp_depth + celestial_object.render_depth_radius, temp_alpha) + 50);
				break;
			case CelestialSubObjectType.Satellite:
				// Establish Sub Object's Unlit Sprite Alpha Transparency
				var temp_satellite_depth_alpha = inverse_lerp(celestial_object.render_depth_radius * CelestialSimulator.global_sub_objects_satellite_depth_transparent_end, celestial_object.render_depth_radius * CelestialSimulator.global_sub_objects_satellite_depth_transparent_start, temp_depth);
				temp_alpha *= power(temp_satellite_depth_alpha, 3);
				
				// Establish Sub Object's Unlit Sprite Shader Depth Rendering Properties
				shader_set_uniform_f(CelestialSimulator.celestial_sprite_unlit_shader_depth_index, lerp(celestial_object.render_depth_radius * 2, temp_depth + celestial_object.render_depth_radius, temp_alpha));
				break;
			case CelestialSubObjectType.None:
			default:
				// Sub Object Instance is Invalid - Skip Render
				break;
		}
		
		// Establish Sub Object's Unlit Sprite Shader Emissive Rendering Properties
		shader_set_uniform_f(CelestialSimulator.celestial_sprite_unlit_shader_emissive_index, temp_instance.emissive * temp_instance.emissive_multiplier);
		
		// Sub Object Draw Sprite Behaviour
		draw_sprite_ext(temp_sprite_index, temp_image_index, temp_instance.x, temp_instance.y, temp_instance.image_xscale, temp_instance.image_yscale, temp_instance.image_angle, temp_instance.image_blend, temp_alpha);
		
		// Celestial Unit UI Drawing Behaviour
		if (temp_instance.celestial_sub_object_type == CelestialSubObjectType.Unit)
		{
			// Unit Emotion Sprite Animation Rendering Behaviour
			if (!temp_sub_object_miniature_icon and temp_instance.emotion_sprite_index != -1)
			{
				// Unit Emotion Animation Draw Sprite Behaviour
				draw_sprite_ext(temp_instance.emotion_sprite_index, temp_instance.emotion_image_index, temp_instance.x, temp_instance.y + temp_sprite_vertical_offset, 1, 1, 0, c_white, temp_alpha);
			}
		}
		
		// Increment Celestial Object's Sub Object Index
		temp_sub_object_index++;
	}
	
	// Reset Shader
	shader_reset();
	
	// Reset Surface Target
	surface_reset_target();
}

calculate_celestial_battle_choreography_stack = function()
{
	// Iterate through Battle's Choreography Actions
	var temp_battle_choreography_actions_count = array_length(CelestialSimulator.sub_object_selected_instance.battle_choreography_actions);
	var temp_battle_choreography_actions_index = 0;
	
	repeat (temp_battle_choreography_actions_count)
	{
		// Find Battle Choreography Action Struct
		var temp_action_struct = CelestialSimulator.sub_object_selected_instance.battle_choreography_actions[temp_battle_choreography_actions_index];
		
		//
		switch (temp_action_struct.choreography_object_type)
		{
			case CelestialBattleChoreographyObjectType.LinearProjectile:
				//
				temp_action_struct.linear_projectile_timer -= frame_delta;
				
				//
				if (temp_action_struct.linear_projectile_timer <= 0)
				{
					//
					array_delete(CelestialSimulator.sub_object_selected_instance.battle_choreography_actions, temp_battle_choreography_actions_index, 1);
					
					//
					delete temp_action_struct;
					
					//
					continue;
				}
				
				//
				temp_action_struct.linear_projectile_start_x = lerp(temp_action_struct.linear_projectile_start_x, temp_action_struct.linear_projectile_end_x, 0.2 * frame_delta);
				temp_action_struct.linear_projectile_start_y = lerp(temp_action_struct.linear_projectile_start_y, temp_action_struct.linear_projectile_end_y, 0.2 * frame_delta);
				
				// Calculate and Update Linear Projectile's Vertical Depth
				var temp_linear_projectile_depth_calculation_y = temp_action_struct.linear_projectile_vertical_depth_y + temp_action_struct.linear_projectile_vertical_depth_offset;
				temp_action_struct.vertical_depth = inverse_lerp(CelestialSimulator.battle_platform_top_vertical_position, CelestialSimulator.battle_platform_bottom_vertical_position, temp_linear_projectile_depth_calculation_y);
				
				// Add Battle Choreography Linear Projectile to Battle Choreography Stack
				array_push(CelestialSimulator.battle_choreography_stack, temp_action_struct);
				break;
			case CelestialBattleChoreographyObjectType.ArcProjectile:
				break;
		}
		
		// Increment Battle Choreography Actions Index
		temp_battle_choreography_actions_index++;
	}
	
	// Iterate through Battle's Choreography Actors and Populate Battle Choreography Stack
	var temp_battle_choreography_actors_count = array_length(CelestialSimulator.sub_object_selected_instance.battle_choreography_actors);
	var temp_battle_choreography_actors_index = temp_battle_choreography_actors_count - 1;
	
	repeat (temp_battle_choreography_actors_count)
	{
		// Find Battle Choreography Actor Struct
		var temp_actor_struct = CelestialSimulator.sub_object_selected_instance.battle_choreography_actors[temp_battle_choreography_actors_index];
		
		// Calculate Battle Choreography Actor Behaviour
		if (temp_actor_struct.actor_entry_delay_duration > 0)
		{
			// Actor is Performing their Battle Entry Delay - Skip Battle Actor's Rendering Behaviour
			temp_actor_struct.actor_entry_delay_duration -= frame_delta;
			
			// Decrement Battle Choreography Actors Index
			temp_battle_choreography_actors_index--;
			continue;
		}
		
		// Establish Battle Actor's Render Variables
		temp_actor_struct.draw_sprite_index = temp_actor_struct.actor_idle_sprite_index;
		temp_actor_struct.draw_offset_x = 0;
		temp_actor_struct.draw_offset_y = 0;
		temp_actor_struct.draw_xscale = temp_actor_struct.facing_direction;
		temp_actor_struct.draw_alpha = 1;
		
		//
		temp_actor_struct.actor_weapon_angle_recoil = lerp(temp_actor_struct.actor_weapon_angle_recoil, 0, 0.1 * frame_delta);
		temp_actor_struct.actor_weapon_horizontal_recoil = lerp(temp_actor_struct.actor_weapon_horizontal_recoil, 0, 0.1 * frame_delta);
		temp_actor_struct.actor_weapon_vertical_recoil = lerp(temp_actor_struct.actor_weapon_vertical_recoil, 0, 0.1 * frame_delta);
		
		// Establish Battle Actor's Weapon Variables
		var temp_actor_weapon_attacking_phase = false;
		var temp_actor_weapon_target_angle = temp_actor_struct.draw_xscale > 0 ? 0 : 180;
		
		// Check if Battle Actor has an Animation Condition
		if (temp_actor_struct.actor_entry_animation)
		{
			// Actor is Performing their Battle Entry Animation - Increment the Actor's Entry Animation Values
			temp_actor_struct.actor_entry_animation_value += 0.037 * frame_delta;
			temp_actor_struct.actor_entry_animation_value = clamp(temp_actor_struct.actor_entry_animation_value, 0, 1);
			
			// Check Toggle if Battle Actor has finished their Battle Entry Animation
			temp_actor_struct.actor_entry_animation = temp_actor_struct.actor_entry_animation_value != 1;
			
			// Calculate Battle Entry Animation Value & Horizontal Offset
			var temp_entry_animation_value = temp_actor_struct.actor_entry_animation_value * temp_actor_struct.actor_entry_animation_value;
			var temp_entry_horizontal_offset = -18 * temp_actor_struct.facing_direction * (1 - power(temp_actor_struct.actor_entry_animation_value, 1.6));
			
			// Update Battle Actor's Render Variables
			temp_actor_struct.draw_sprite_index = temp_actor_struct.actor_move_sprite_index;
			temp_actor_struct.draw_offset_x = temp_entry_horizontal_offset;
			temp_actor_struct.draw_alpha = temp_entry_animation_value;
			
			// Update Battle Actor's Weapon Variables
			temp_actor_weapon_target_angle = 90 + (temp_actor_struct.draw_xscale * -135);
		}
		else if (temp_actor_struct.actor_exit_animation)
		{
			// Check if Actor Exit Animation Delay is Active
			if (temp_actor_struct.actor_exit_delay_duration > 0)
			{
				// Decrement Actor Exit Animation Delay Duration
				temp_actor_struct.actor_exit_delay_duration -= frame_delta;
			}
			else
			{
				// Actor is Performing their Battle Exit Animation - Increment the Actor's Exit Animation Values
				temp_actor_struct.actor_exit_animation_value -= 0.037 * frame_delta;
				temp_actor_struct.actor_exit_animation_value = clamp(temp_actor_struct.actor_exit_animation_value, 0, 1);
				
				//
				temp_actor_struct.draw_sprite_index = temp_actor_struct.actor_move_sprite_index;
			}
			
			// Calculate Battle Exit Animation Value & Horizontal Offset
			var temp_exit_animation_value = temp_actor_struct.actor_exit_animation_value * temp_actor_struct.actor_exit_animation_value;
			var temp_exit_horizontal_offset = -18 * temp_actor_struct.facing_direction * (1 - power(temp_actor_struct.actor_exit_animation_value, 0.5));
			
			// Update Battle Actor's Render Variables
			temp_actor_struct.draw_offset_x = temp_exit_horizontal_offset;
			temp_actor_struct.draw_xscale = -temp_actor_struct.facing_direction;
			temp_actor_struct.draw_alpha = temp_exit_animation_value;
			
			// Update Battle Actor's Weapon Variables
			temp_actor_weapon_target_angle = 90 + (temp_actor_struct.draw_xscale * -135);
		}
		else if (temp_actor_struct.actor_action_animation_type != -1)
		{
			//
			var temp_actor_target_subunit_exists = false;
			
			var temp_target_actor_index = -1;
			var temp_target_actor_struct = noone;
			
			//
			if (instance_exists(temp_actor_struct.target_subunit))
			{
				//
				temp_target_actor_index = ds_map_find_value(sub_object_selected_instance.battle_choreography_actors_map, temp_actor_struct.target_subunit);
				temp_target_actor_struct = array_get(sub_object_selected_instance.battle_choreography_actors, temp_target_actor_index);
				
				//
				if (!is_undefined(temp_target_actor_struct))
				{
					//
					temp_actor_target_subunit_exists = true;
					
					// Calculate the Target Sub-Unit Sprite's Vertical Offset
					var temp_actor_target_sprite_vertical_offset = -sprite_get_yoffset(temp_target_actor_struct.draw_sprite_index) + sprite_get_bbox_top(temp_target_actor_struct.draw_sprite_index);
					
					//
					temp_actor_struct.actor_weapon_target_x = temp_target_actor_struct.draw_x + temp_target_actor_struct.draw_offset_x + temp_target_actor_struct.draw_random_offset_x;
					temp_actor_struct.actor_weapon_target_y = temp_target_actor_struct.draw_y + temp_target_actor_struct.draw_offset_y + temp_target_actor_struct.draw_random_offset_y + temp_actor_target_sprite_vertical_offset * 0.5;
				}
			}
			
			//
			if (temp_actor_struct.actor_weapon_enabled and temp_actor_target_subunit_exists)
			{
				//
				var temp_actor_weapon_pivot_x = lerp(temp_actor_struct.actor_weapon_pivot_x, temp_actor_struct.actor_weapon_aim_pivot_x, temp_actor_struct.actor_weapon_aim) * temp_actor_struct.draw_xscale;
				var temp_actor_weapon_pivot_y = lerp(temp_actor_struct.actor_weapon_pivot_y, temp_actor_struct.actor_weapon_aim_pivot_y, temp_actor_struct.actor_weapon_aim);
				
				//
				var temp_actor_weapon_x = temp_actor_struct.draw_x + temp_actor_struct.draw_offset_x + temp_actor_struct.draw_random_offset_x + temp_actor_weapon_pivot_x;
				var temp_actor_weapon_y = temp_actor_struct.draw_y + temp_actor_struct.draw_offset_y + temp_actor_struct.draw_random_offset_y + temp_actor_weapon_pivot_y;
				
				//
				temp_actor_weapon_target_angle = point_direction(temp_actor_weapon_x, temp_actor_weapon_y, temp_actor_struct.actor_weapon_target_x, temp_actor_struct.actor_weapon_target_y);
				
				//
				switch (temp_actor_struct.actor_action_animation_type)
				{
					default:
					case CelestialUnitActionAnimationType.DefaultFirearm:
						//
						if (temp_actor_struct.actor_weapon_aim > 0.9 and angle_difference(temp_actor_weapon_target_angle, temp_actor_struct.actor_weapon_angle) <= 5)
						{
							temp_actor_struct.actor_action_animation_delay += 0.1 * frame_delta;
						}
						
						//
						if (temp_actor_struct.actor_action_animation_delay >= 1)
						{
							//
							temp_actor_struct.actor_action_animation_delay = 0;
							
							//
							var temp_actor_action_success = array_get(temp_actor_struct.actor_action_animation_success, 0);
							
							//
							temp_actor_struct.actor_weapon_angle_recoil = random_range(3, 13) * temp_actor_struct.facing_direction;
							temp_actor_struct.actor_weapon_horizontal_recoil = random_range(-6, -4);
							temp_actor_struct.actor_weapon_vertical_recoil = random_range(-3, -1) * temp_actor_struct.facing_direction;
							
							//
							rot_prefetch(temp_actor_struct.actor_weapon_angle);
							
							var temp_actor_weapon_attack_offset_x = rot_point_x(8, -2 * temp_actor_struct.facing_direction);
							var temp_actor_weapon_attack_offset_y = rot_point_y(8, -2 * temp_actor_struct.facing_direction);
							
							//
							temp_actor_struct.actor_weapon_target_x += random_range(-3, 3);
							temp_actor_struct.actor_weapon_target_y += random_range(-3, 3);
							
							//
							temp_actor_struct.actor_weapon_attack_sprite_index = sOverworld_Unit_William_Firearm_MuzzleFlash;
							temp_actor_struct.actor_weapon_attack_image_index = irandom(sprite_get_number(temp_actor_struct.actor_weapon_attack_sprite_index) - 1);
							temp_actor_struct.actor_weapon_attack_image_angle = temp_actor_struct.actor_weapon_angle;
							temp_actor_struct.actor_weapon_attack_x = temp_actor_weapon_x + temp_actor_weapon_attack_offset_x;
							temp_actor_struct.actor_weapon_attack_y = temp_actor_weapon_y + temp_actor_weapon_attack_offset_y;
							temp_actor_struct.actor_weapon_attack_timer = 4;
							
							//
							var temp_linear_projectile_hitmarker_sprite = temp_actor_action_success ? sOverworld_Hitmarker : sOverworld_HitmarkerMiss;
							
							//
							if (!temp_actor_action_success)
							{
								//
								var temp_linear_projectile_overshoot = random_range(-32, 64);
								
								//
								temp_actor_struct.actor_weapon_target_x += rot_point_x(temp_linear_projectile_overshoot, 0);
								temp_actor_struct.actor_weapon_target_y += rot_point_y(temp_linear_projectile_overshoot, 0);
								
								//
								if (temp_actor_struct.actor_weapon_target_y < CelestialSimulator.battle_platform_top_vertical_position or  temp_actor_struct.actor_weapon_target_y > CelestialSimulator.battle_platform_bottom_vertical_position)
								{
									temp_actor_struct.actor_weapon_target_x += rot_point_x(640, 0);
									temp_actor_struct.actor_weapon_target_y += rot_point_y(640, 0);
								}
							}
							
							//
							var temp_actor_weapon_linear_projectile_struct = 
							{
								// Choreography Stack Object Type Variable
								choreography_object_type: CelestialBattleChoreographyObjectType.LinearProjectile,
								
								// Choreography Stack Object Depth Sorting Variable
								vertical_depth: inverse_lerp(CelestialSimulator.battle_platform_top_vertical_position, CelestialSimulator.battle_platform_bottom_vertical_position, 0),
								
								// Choreography Stack Rendering Variables
								draw_sprite_index: temp_linear_projectile_hitmarker_sprite,
								draw_image_index: irandom(sprite_get_number(temp_linear_projectile_hitmarker_sprite) - 1),
								
								draw_x: temp_actor_struct.actor_weapon_target_x,
								draw_y: temp_actor_struct.actor_weapon_target_y,
								
								draw_xscale: random(1.0) > 0.5 ? 1 : -1,
								draw_yscale: temp_actor_action_success ? (random(1.0) > 0.5 ? 1 : -1) : 1,
								
								draw_color: temp_actor_action_success ? c_white : c_grey,
								draw_alpha: 1,
								
								//
								linear_projectile_start_x: temp_actor_struct.actor_weapon_attack_x,
								linear_projectile_start_y: temp_actor_struct.actor_weapon_attack_y,
								
								linear_projectile_end_x: temp_actor_struct.actor_weapon_target_x,
								linear_projectile_end_y: temp_actor_struct.actor_weapon_target_y,
								
								linear_projectile_width: 1,
								
								//
								linear_projectile_vertical_depth_y: temp_actor_action_success ? temp_target_actor_struct.draw_y + temp_target_actor_struct.draw_offset_y + temp_target_actor_struct.draw_random_offset_y : temp_actor_struct.actor_weapon_target_y,
								linear_projectile_vertical_depth_offset: temp_actor_action_success ? 2 : 0,
								
								//
								linear_projectile_timer: 5,
							};
							
							//
							array_push(CelestialSimulator.sub_object_selected_instance.battle_choreography_actions, temp_actor_weapon_linear_projectile_struct);
							array_push(CelestialSimulator.battle_choreography_stack, temp_actor_weapon_linear_projectile_struct);
							
							//
							temp_actor_struct.actor_action_animation_count--;
							array_delete(temp_actor_struct.actor_action_animation_success, 0, 1);
							
							//
							if (temp_actor_struct.actor_action_animation_count <= 0)
							{
								//
								temp_actor_struct.actor_action_animation_type = -1;
							}
						}
						break;
				}
				
				//
				temp_actor_weapon_attacking_phase = true;
			}
		}
		
		//
		temp_actor_struct.draw_image_index_value += sprite_get_speed_real(temp_actor_struct.draw_sprite_index) * frame_delta;
		temp_actor_struct.draw_image_index_value = temp_actor_struct.draw_image_index_value mod sprite_get_number(temp_actor_struct.draw_sprite_index);
		temp_actor_struct.draw_image_index = floor(temp_actor_struct.draw_image_index_value);
		
		//
		if (temp_actor_struct.actor_weapon_enabled)
		{
			//
			temp_actor_struct.actor_weapon_angle = temp_actor_struct.actor_weapon_angle + (angle_difference(temp_actor_weapon_target_angle, temp_actor_struct.actor_weapon_angle) * 0.25 * frame_delta);
			
			//
			rot_prefetch(temp_actor_struct.actor_weapon_angle);
			
			temp_actor_struct.actor_weapon_offset_x = rot_point_x(temp_actor_struct.actor_weapon_horizontal_recoil, temp_actor_struct.actor_weapon_vertical_recoil);
			temp_actor_struct.actor_weapon_offset_y = rot_point_y(temp_actor_struct.actor_weapon_horizontal_recoil, temp_actor_struct.actor_weapon_vertical_recoil);
			
			//
			if (temp_actor_weapon_attacking_phase)
			{
				temp_actor_struct.actor_weapon_aim = lerp(temp_actor_struct.actor_weapon_aim, 1, 0.1 * frame_delta);
				temp_actor_struct.actor_weapon_vertical_bobbing_y_offset = lerp(temp_actor_struct.actor_weapon_vertical_bobbing_y_offset, 0, 0.1 * frame_delta);
			}
			else
			{
				temp_actor_struct.actor_weapon_aim = lerp(temp_actor_struct.actor_weapon_aim, 0, 0.15 * frame_delta);
				temp_actor_struct.actor_weapon_vertical_bobbing_y_offset = (cos((temp_actor_struct.draw_image_index_value / sprite_get_number(temp_actor_struct.draw_sprite_index)) * 2 * pi) + 1) * 0.5 * temp_actor_struct.actor_weapon_vertical_bobbing_height;
			}
			
			//
			if (temp_actor_struct.actor_weapon_attack_timer > 0)
			{
				temp_actor_struct.actor_weapon_attack_timer -= frame_delta;
			}
		}
		
		// Calculate and Update Actor's Vertical Depth
		var temp_actor_depth_calculation_y = temp_actor_struct.draw_y + temp_actor_struct.draw_offset_y + temp_actor_struct.draw_random_offset_y;
		temp_actor_struct.vertical_depth = inverse_lerp(CelestialSimulator.battle_platform_top_vertical_position, CelestialSimulator.battle_platform_bottom_vertical_position, temp_actor_depth_calculation_y);
		
		// Add Battle Choreography Actor Struct to Battle Choreography Stack
		array_push(CelestialSimulator.battle_choreography_stack, temp_actor_struct);
		
		// Decrement Battle Choreography Actors Index
		temp_battle_choreography_actors_index--;
	}
	
	//
	var temp_prop_struct = 
	{
		// Choreography Stack Object Type Variable
		choreography_object_type: CelestialBattleChoreographyObjectType.Prop,
		
		// Choreography Stack Object Depth Sorting Variable
		vertical_depth: inverse_lerp(CelestialSimulator.battle_platform_top_vertical_position, CelestialSimulator.battle_platform_bottom_vertical_position, mouse_y),
		
		// Choreography Stack Rendering Variables
		draw_sprite_index: sOverworld_Unit_William_Idle,
		draw_image_index: 0,
		
		draw_x: mouse_x,
		draw_y: mouse_y,
		
		draw_xscale: 1,
		
		draw_color: c_white,
		draw_alpha: 1,
		
		facing_direction: 1,
		
		//
		draw_image_index_value: 0,
		
		draw_offset_x: 0,
		draw_offset_y: 0,
		
		draw_random_offset_x: 0,
		draw_random_offset_y: 0,
	};
	
	array_push(CelestialSimulator.battle_choreography_stack, temp_prop_struct);
	
	// Depth Sort the Celestial Simulator's Battle Choreography Stack by Vertical Depth
	array_sort(CelestialSimulator.battle_choreography_stack, CelestialSimulator.battle_choreography_stack_depth_sort);
}

render_celestial_battle_choreography_stack = function()
{
	// Iterate through Battle's Choreography Stack
	var temp_battle_choreography_stack_count = array_length(CelestialSimulator.battle_choreography_stack);
	var temp_battle_choreography_stack_index = 0;
	
	repeat (temp_battle_choreography_stack_count)
	{
		// Establish Choreography Stack Object Struct
		var temp_stack_obj = CelestialSimulator.battle_choreography_stack[temp_battle_choreography_stack_index];
		
		// Perform Battle Choreography Stack Render Behaviour based on Choreography Instance's Object Type
		switch (temp_stack_obj.choreography_object_type)
		{
			case CelestialBattleChoreographyObjectType.Actor:
				//
				var temp_actor_x = temp_stack_obj.draw_x + temp_stack_obj.draw_offset_x + temp_stack_obj.draw_random_offset_x;
				var temp_actor_y = temp_stack_obj.draw_y + temp_stack_obj.draw_offset_y + temp_stack_obj.draw_random_offset_y;
				
				// Calculate Sprite Vertical Offset
				var temp_actor_sprite_vertical_offset = -sprite_get_yoffset(temp_stack_obj.draw_sprite_index) + sprite_get_bbox_top(temp_stack_obj.draw_sprite_index);
				
				// Draw Battle Choreography Actor Sprite
				draw_sprite_ext(temp_stack_obj.draw_sprite_index, temp_stack_obj.draw_image_index, temp_actor_x, temp_actor_y, temp_stack_obj.draw_xscale, 1, 0, temp_stack_obj.draw_color, temp_stack_obj.draw_alpha);
				
				// Check to Draw Weapon
				if (temp_stack_obj.actor_weapon_enabled)
				{
					//
					var temp_actor_weapon_pivot_x = lerp(temp_stack_obj.actor_weapon_pivot_x, temp_stack_obj.actor_weapon_aim_pivot_x, temp_stack_obj.actor_weapon_aim) * temp_stack_obj.draw_xscale;
					var temp_actor_weapon_pivot_y = lerp(temp_stack_obj.actor_weapon_pivot_y, temp_stack_obj.actor_weapon_aim_pivot_y, temp_stack_obj.actor_weapon_aim);
					
					//
					var temp_actor_weapon_x = temp_actor_x + temp_actor_weapon_pivot_x + temp_stack_obj.actor_weapon_offset_x;
					var temp_actor_weapon_y = temp_actor_y + temp_actor_weapon_pivot_y + temp_stack_obj.actor_weapon_offset_y + temp_stack_obj.actor_weapon_vertical_bobbing_y_offset;
					
					//
					var temp_actor_weapon_angle = temp_stack_obj.actor_weapon_angle + temp_stack_obj.actor_weapon_angle_recoil;
					
					//
					draw_sprite_ext(temp_stack_obj.actor_weapon_sprite, 0, temp_actor_weapon_x, temp_actor_weapon_y, 1, temp_stack_obj.draw_xscale, temp_actor_weapon_angle, temp_stack_obj.draw_color, temp_stack_obj.draw_alpha);
					
					//
					if (temp_stack_obj.actor_weapon_attack_timer > 0)
					{
						draw_sprite_ext(temp_stack_obj.actor_weapon_attack_sprite_index, temp_stack_obj.actor_weapon_attack_image_index, temp_stack_obj.actor_weapon_attack_x, temp_stack_obj.actor_weapon_attack_y, 1, 1, temp_stack_obj.actor_weapon_attack_image_angle, c_white, 1);
					}
				}
				
				// Unit Emotion Sprite Animation Rendering Behaviour
				if (instance_exists(temp_stack_obj.actor_subunit))
				{
					if (instance_exists(temp_stack_obj.actor_subunit.unit_instance) and temp_stack_obj.actor_subunit.unit_instance.emotion_sprite_index != -1)
					{
						//
						var temp_actor_unit_emotion_sprite_index = temp_stack_obj.actor_subunit.unit_instance.emotion_sprite_index;
						var temp_actor_unit_emotion_image_index = temp_stack_obj.actor_subunit.unit_instance.emotion_image_index;
						
						// Unit Emotion Animation Draw Sprite Behaviour
						draw_sprite_ext(temp_actor_unit_emotion_sprite_index, temp_actor_unit_emotion_image_index, temp_actor_x, temp_actor_y + temp_actor_sprite_vertical_offset, 1, 1, 0, c_white, temp_stack_obj.draw_alpha);
					}
					else if (temp_stack_obj.action_delay_timer > 0 and temp_stack_obj.action_duration_timer <= 0)
					{
						//
						var temp_action_timer_rect_w = 22;
						var temp_action_timer_rect_h = 1;
						
						var temp_action_timer_rect_h_offset = -4;
						
						//
						var temp_action_timer_rect_x1 = temp_actor_x - (temp_action_timer_rect_w * 0.5);
						var temp_action_timer_rect_y1 = temp_actor_y + temp_actor_sprite_vertical_offset - temp_action_timer_rect_h + temp_action_timer_rect_h_offset;
						var temp_action_timer_rect_x2 = temp_actor_x + (temp_action_timer_rect_w * 0.5);
						var temp_action_timer_rect_y2 = temp_actor_y + temp_actor_sprite_vertical_offset + temp_action_timer_rect_h_offset;
						
						var temp_action_timer_rect_xvalue = temp_actor_x - (temp_action_timer_rect_w * 0.5) + (temp_action_timer_rect_w * temp_stack_obj.action_delay_timer);
						
						//
						draw_set_color(c_white);
						draw_rectangle(temp_action_timer_rect_x1 - 2, temp_action_timer_rect_y1 - 2, temp_action_timer_rect_x2 + 2, temp_action_timer_rect_y2 + 2, false);
						draw_set_color(c_black);
						draw_rectangle(temp_action_timer_rect_x1 - 1, temp_action_timer_rect_y1 - 1, temp_action_timer_rect_x2 + 1, temp_action_timer_rect_y2 + 1, false);
						
						//
						draw_set_color(c_white);
						draw_rectangle(temp_action_timer_rect_x1, temp_action_timer_rect_y1, temp_action_timer_rect_xvalue, temp_action_timer_rect_y2, false);
					}
				}
				break;
			case CelestialBattleChoreographyObjectType.Prop:
				//
				var temp_prop_x = temp_stack_obj.draw_x + temp_stack_obj.draw_offset_x + temp_stack_obj.draw_random_offset_x;
				var temp_prop_y = temp_stack_obj.draw_y + temp_stack_obj.draw_offset_y + temp_stack_obj.draw_random_offset_y;
				
				// Draw Battle Choreography Actor Sprite
				draw_sprite_ext(temp_stack_obj.draw_sprite_index, temp_stack_obj.draw_image_index, temp_prop_x, temp_prop_y, temp_stack_obj.draw_xscale, 1, 0, temp_stack_obj.draw_color, temp_stack_obj.draw_alpha);
				
				//
				break;
			case CelestialBattleChoreographyObjectType.LinearProjectile:
				//
				draw_line_width_color(temp_stack_obj.linear_projectile_start_x, temp_stack_obj.linear_projectile_start_y, temp_stack_obj.linear_projectile_end_x, temp_stack_obj.linear_projectile_end_y, temp_stack_obj.linear_projectile_width + 2, c_black, c_black);
				draw_line_width_color(temp_stack_obj.linear_projectile_start_x, temp_stack_obj.linear_projectile_start_y, temp_stack_obj.linear_projectile_end_x, temp_stack_obj.linear_projectile_end_y, temp_stack_obj.linear_projectile_width, temp_stack_obj.draw_color, temp_stack_obj.draw_color);
				
				//
				draw_sprite_ext(temp_stack_obj.draw_sprite_index, temp_stack_obj.draw_image_index, temp_stack_obj.draw_x, temp_stack_obj.draw_y, temp_stack_obj.draw_xscale, temp_stack_obj.draw_yscale, 0, temp_stack_obj.draw_color, temp_stack_obj.draw_alpha);
				break;
		}
		
		// Increment Battle Choreography Stack Index
		temp_battle_choreography_stack_index++;
	}
}

render_selected_unit_movement_path_ui = function()
{
	// Set Celestial Temporary Render Surface as Surface Targets
	surface_set_target(CelestialSimulator.temp_surface);
	
	// Reset Celestial Temporary Render Surface
	draw_clear_alpha(c_black, 0);
	
	// Reset Camera Orientation
	camera_set_view_mat(GameManager.camera_instance, GameManager.view_matrix);
	camera_set_proj_mat(GameManager.camera_instance, GameManager.projection_matrix);
	camera_apply(GameManager.camera_instance);
	
	// Reset Matrix World Identity
	matrix_set(matrix_world, GameManager.identity_matrix);
	
	// Iterate through and Draw all Selected Unit Movement Path Entries
	var temp_selected_unit_movement_path_entry_index = 0;
	
	repeat (CelestialSimulator.selected_unit_movement_path_entries)
	{
		// Find Selected Unit Movement Path Entry's Sorted Index
		var temp_selected_unit_movement_path_entry_sorted_index = CelestialSimulator.selected_unit_movement_path_depth_sorting_index_array[temp_selected_unit_movement_path_entry_index];
		
		// Find Selected Unit Movement Path Point Positions and Alphas
		var temp_movement_path_point_a_position_x = CelestialSimulator.selected_unit_movement_path_point_a_position_x_array[temp_selected_unit_movement_path_entry_sorted_index];
		var temp_movement_path_point_a_position_y = CelestialSimulator.selected_unit_movement_path_point_a_position_y_array[temp_selected_unit_movement_path_entry_sorted_index];
		var temp_movement_path_point_a_alpha = CelestialSimulator.selected_unit_movement_path_point_a_alpha_array[temp_selected_unit_movement_path_entry_sorted_index];
		
		var temp_movement_path_point_b_position_x = CelestialSimulator.selected_unit_movement_path_point_b_position_x_array[temp_selected_unit_movement_path_entry_sorted_index];
		var temp_movement_path_point_b_position_y = CelestialSimulator.selected_unit_movement_path_point_b_position_y_array[temp_selected_unit_movement_path_entry_sorted_index];
		var temp_movement_path_point_b_alpha = CelestialSimulator.selected_unit_movement_path_point_b_alpha_array[temp_selected_unit_movement_path_entry_sorted_index];
		
		// Create Selected Unit Movement Path Point's Render Color based on the Point Alphas
		var temp_movement_path_color_a = make_color_rgb(temp_movement_path_point_a_alpha * 255, 0, 0);
		var temp_movement_path_color_b = make_color_rgb(temp_movement_path_point_b_alpha * 255, 0, 0);
		
		// Draw Line Width of the given Path Points
		draw_line_width_color(temp_movement_path_point_a_position_x, temp_movement_path_point_a_position_y, temp_movement_path_point_b_position_x, temp_movement_path_point_b_position_y, 2, temp_movement_path_color_a, temp_movement_path_color_b);
		
		// Check if Path Entry is the Last Index in the Selected Unit's Movement Path Array
		if (temp_selected_unit_movement_path_entry_sorted_index == CelestialSimulator.selected_unit_movement_path_entries - 1)
		{
			// Establish Breathing Ellipse Horizontal and Vertical Radius Variables
			var temp_ellipse_horizontal_radius = CelestialSimulator.triangle_breath_value * 0.4 + 4;
			var temp_ellipse_vertical_radius = CelestialSimulator.triangle_breath_value * 0.3 + 2;
			
			// Establish Ellipse Rectangular Dimension Variables
			var temp_ellipse_left = temp_movement_path_point_b_position_x - temp_ellipse_horizontal_radius;
			var temp_ellipse_top = temp_movement_path_point_b_position_y - temp_ellipse_vertical_radius;
			var temp_ellipse_right = temp_movement_path_point_b_position_x + temp_ellipse_horizontal_radius;
			var temp_ellipse_bottom = temp_movement_path_point_b_position_y + temp_ellipse_vertical_radius;
			
			// Draw a "Shadowed" Ellipse at the end of the Movement Path
			draw_ellipse_color(temp_ellipse_left, temp_ellipse_top, temp_ellipse_right, temp_ellipse_bottom, temp_movement_path_color_b, temp_movement_path_color_b, false);
		}
		
		// Increment Movement Path Entry Index
		temp_selected_unit_movement_path_entry_index++;
	}
	
	// Reset Surface Target
	surface_reset_target();
	
	// (Multiple Render Targets) Set Celestial Body Render, Diffuse, & Emissive Surfaces as Surface Targets
	surface_set_target_ext(0, CelestialSimulator.celestial_body_render_surface);
	surface_set_target_ext(1, CelestialSimulator.celestial_body_diffuse_surface);
	surface_set_target_ext(2, CelestialSimulator.celestial_body_emissive_surface);
	
	// Enable Celestial Path Unlit Rendering Shader
	shader_set(shd_celestial_path_unlit);
	
	// Establish Unlit Pathfinding Path Shader Depth Rendering Properties
	shader_set_uniform_f(CelestialSimulator.celestial_path_unlit_shader_depth_index, CelestialSimulator.camera_observing_instance.render_depth_radius);
	
	// Draw Celestial Temporary Render Surface to Observing Celestial Object Render
	draw_surface_ext(CelestialSimulator.temp_surface, 0, 0, 1, 1, 0, c_white, 1);
	
	// Reset Shader
	shader_reset();
	
	// Reset Surface Target
	surface_reset_target();
}

render_triangle_ui = function(triangle_x, triangle_y, triangle_alpha)
{
	// Establish Triangle Draw Position Variables
	var temp_tri_x = triangle_x - 1;
	var temp_tri_y = triangle_y + CelestialSimulator.triangle_offset - CelestialSimulator.triangle_breath_value;
	
	// Set Draw Transparency to Triangle's Alpha
	draw_set_alpha(triangle_alpha);
	
	// Draw Triangle's Black Outline
	draw_set_color(c_black);
	
	draw_triangle(temp_tri_x + CelestialSimulator.tri_x_1 + 2, temp_tri_y + CelestialSimulator.tri_y_1 + 1, temp_tri_x + CelestialSimulator.tri_x_2 + 2, temp_tri_y + CelestialSimulator.tri_y_2 + 1, temp_tri_x + CelestialSimulator.tri_x_3 + 2, temp_tri_y + CelestialSimulator.tri_y_3 + 1, false);
	draw_triangle(temp_tri_x + CelestialSimulator.tri_x_1 + 1, temp_tri_y + CelestialSimulator.tri_y_1 + 2, temp_tri_x + CelestialSimulator.tri_x_2 + 1, temp_tri_y + CelestialSimulator.tri_y_2 + 2, temp_tri_x + CelestialSimulator.tri_x_3 + 1, temp_tri_y + CelestialSimulator.tri_y_3 + 2, false);
	
	draw_triangle(temp_tri_x + CelestialSimulator.tri_x_1 - 1, temp_tri_y + CelestialSimulator.tri_y_1, temp_tri_x + CelestialSimulator.tri_x_2 - 1, temp_tri_y + CelestialSimulator.tri_y_2, temp_tri_x + CelestialSimulator.tri_x_3 - 1, temp_tri_y + CelestialSimulator.tri_y_3, false);
	draw_triangle(temp_tri_x + CelestialSimulator.tri_x_1 + 1, temp_tri_y + CelestialSimulator.tri_y_1, temp_tri_x + CelestialSimulator.tri_x_2 + 1, temp_tri_y + CelestialSimulator.tri_y_2, temp_tri_x + CelestialSimulator.tri_x_3 + 1, temp_tri_y + CelestialSimulator.tri_y_3, false);
	draw_triangle(temp_tri_x + CelestialSimulator.tri_x_1, temp_tri_y + CelestialSimulator.tri_y_1 - 1, temp_tri_x + CelestialSimulator.tri_x_2, temp_tri_y + CelestialSimulator.tri_y_2 - 1, temp_tri_x + CelestialSimulator.tri_x_3, temp_tri_y + CelestialSimulator.tri_y_3 - 1, false);
	draw_triangle(temp_tri_x + CelestialSimulator.tri_x_1, temp_tri_y + CelestialSimulator.tri_y_1 + 1, temp_tri_x + CelestialSimulator.tri_x_2, temp_tri_y + CelestialSimulator.tri_y_2 + 1, temp_tri_x + CelestialSimulator.tri_x_3, temp_tri_y + CelestialSimulator.tri_y_3 + 1, false);
	
	// Draw Triangle's Contrast Drop Shadow
	draw_set_color(c_gray);
	
	draw_triangle(temp_tri_x + CelestialSimulator.tri_x_1 + 1, temp_tri_y + CelestialSimulator.tri_y_1 + 1, temp_tri_x + CelestialSimulator.tri_x_2 + 1, temp_tri_y + CelestialSimulator.tri_y_2 + 1, temp_tri_x + CelestialSimulator.tri_x_3 + 1, temp_tri_y + CelestialSimulator.tri_y_3 + 1, false);
	
	// Draw Triangle's Main Shape
	draw_set_color(c_white);
	
	draw_triangle(temp_tri_x + CelestialSimulator.tri_x_1, temp_tri_y + CelestialSimulator.tri_y_1, temp_tri_x + CelestialSimulator.tri_x_2, temp_tri_y + CelestialSimulator.tri_y_2, temp_tri_x + CelestialSimulator.tri_x_3, temp_tri_y + CelestialSimulator.tri_y_3, false);
	
	// Reset Draw Alpha
	draw_set_alpha(1);
}

// Universe Campaign Generation
generate_default_solar_system = function()
{
	// Create Factions
	player_faction = instance_create_depth(0, 0, 0, oFactionMoralist);
	var temp_enemy_faction = instance_create_depth(0, 0, 0, oFactionNorthernBrigade);
	
	// Initialize Hostilities between Factions
	celestial_faction_set_relationship(player_faction, temp_enemy_faction, CelestialFactionRelationshipType.Hostile);
	
	//
	camera_position_z = 0;
	
	//
	add_solar_system("grandmom", "Grandmother");
	add_celestial_object("grandmom", instance_create_depth(0, 0, 0, oPlanet_Mom, {  image_blend: make_color_rgb(8, 0, 15), radius: 200, ocean_elevation: 0.2, orbit_size: 5000, orbit_speed: 0.1, orbit_rotation: 270, rotation_speed: 0.3, clouds: true, sky: true}));
	add_celestial_object("grandmom", instance_create_depth(0, 0, 0, oMoon_Dad, {  image_blend: make_color_rgb(8, 0, 15), orbit_size: 2200 }));
	//add_celestial_object("grandmom", instance_create_depth(0, 0, 0, oSun, { image_blend: c_red, radius: 60}));
	add_celestial_object("grandmom", instance_create_depth(0, 0, 0, oSun, { image_blend: c_white, radius: 800 }));
	//add_celestial_object("grandmom", instance_create_depth(0, 0, 0, oPlanet, {  sprite_index: sDebug_Mother_MicroclimatesMap, clouds: false, ocean:false, sky: false, orbit_size: 200, orbit_speed: 0, orbit_rotation: 270, rotation_speed: 0.3 }));
	create_celestial_shadows("grandmom", [ "planet_mom", "moon_dad" ]);
	generate_solar_system_background_stars_vertex_buffer("grandmom", 3000);
	
	/*
	for (var i = 0; i < 9; i++)
	{
		add_solar_system($"grandmom_{i}", $"Grandmother_{i}");
		add_celestial_object($"grandmom_{i}", instance_create_depth(0, 0, 0, oPlanet_Mom, {  image_blend: make_color_rgb(8, 0, 15), radius: 200, ocean_elevation: 0.2, orbit_size: 5000, orbit_speed: 0.1, orbit_rotation: 270, rotation_speed: 0.3, clouds: true, sky: true}));
		add_celestial_object($"grandmom_{i}", instance_create_depth(0, 0, 0, oMoon_Dad, {  image_blend: make_color_rgb(8, 0, 15), orbit_size: 2200 }));
		add_celestial_object($"grandmom_{i}", instance_create_depth(0, 0, 0, oSun, { image_blend: c_white, radius: 800 }));
		create_celestial_shadows($"grandmom_{i}", [ "planet_mom", "moon_dad" ]);
		generate_solar_system_background_stars_vertex_buffer($"grandmom_{i}", 3000);
	}
	*/
	
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
	
	camera_observing_instance = instance_find(oPlanet_Mom, 0);
}

// DEBUG
generate_default_solar_system();

// DEBUG DEBUG DEBUG
look_dir = 0;
look_pitch = 0;
