/// @description Celestial Simulator Singleton Init Event
// Self-Creating Celestial Simulator Init Behaviour Event

// Global Celestial Simulator Properties
#macro CelestialSimulator global.celestial_simulator
#macro CelestialSimMaxLights 6

// Configure Celestial Simulator - Global Init Event
gml_pragma("global", @"room_instance_add(room_first, 0, 0, oCelestialSimulator);");

// Celestial Simulator Enums
enum CelestialBodyType
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
camera_position_z = -1100;

camera_rotation_x = 0;
camera_rotation_y = 0;
camera_rotation_z = 0;

camera_rotation_matrix = rotation_matrix_from_euler_angles(0, 0, 0);

camera_z_near = 1;
camera_z_far = 32000;

camera_z_near_depth_overpass = -801;

// Solar System Variables
solar_system_index = -1;
solar_systems = array_create(0);
solar_systems_names = array_create(0);

// Rendering Variables
solar_system_render_depth_values_list = ds_list_create();
solar_system_render_depth_instances_list = ds_list_create();

// Surfaces
planets_depth_surface = -1;

// Vertex Formats
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_texcoord();
icosphere_render_vertex_format = vertex_format_end();

// (Forward Rendered Lighting) Planet Lithosphere Lit Rendering Shader Indexes
planet_lithosphere_lit_shader_radius_index = shader_get_uniform(shd_planet_lithosphere_lit, "u_Radius");
planet_lithosphere_lit_shader_elevation_index = shader_get_uniform(shd_planet_lithosphere_lit, "u_Elevation");
planet_lithosphere_lit_shader_position_index = shader_get_uniform(shd_planet_lithosphere_lit, "u_Position");
planet_lithosphere_lit_shader_euler_angles_index = shader_get_uniform(shd_planet_lithosphere_lit, "u_EulerAngles");

planet_lithosphere_lit_shader_vsh_camera_position_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_vsh_camera_position");
planet_lithosphere_lit_shader_fsh_camera_position_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_fsh_camera_position");
planet_lithosphere_lit_shader_camera_rotation_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_camera_rotation");
planet_lithosphere_lit_shader_camera_dimensions_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_camera_dimensions");

planet_lithosphere_lit_shader_light_exists_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_light_exists");

planet_lithosphere_lit_shader_light_position_x_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_light_position_x");
planet_lithosphere_lit_shader_light_position_y_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_light_position_y");
planet_lithosphere_lit_shader_light_position_z_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_light_position_z");

planet_lithosphere_lit_shader_light_color_r_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_light_color_r");
planet_lithosphere_lit_shader_light_color_g_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_light_color_g");
planet_lithosphere_lit_shader_light_color_b_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_light_color_b");

planet_lithosphere_lit_shader_light_radius_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_light_radius");
planet_lithosphere_lit_shader_light_falloff_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_light_falloff");
planet_lithosphere_lit_shader_light_intensity_index = shader_get_uniform(shd_planet_lithosphere_lit, "in_light_intensity");

planet_lithosphere_lit_shader_heightmap_texture_index = shader_get_sampler_index(shd_planet_lithosphere_lit, "in_heightmap_texture");

// (Forward Rendered Lighting) Planet Hydrosphere Lit Rendering Shader Indexes
planet_hydrosphere_lit_shader_radius_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_Radius");
planet_hydrosphere_lit_shader_elevation_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_Elevation");
planet_hydrosphere_lit_shader_felevation_index = shader_get_uniform(shd_planet_hydrosphere_lit, "f_Elevation");
planet_hydrosphere_lit_shader_ocean_elevation_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_Ocean_Elevation");
planet_hydrosphere_lit_shader_ocean_roughness_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_Ocean_Roughness");
planet_hydrosphere_lit_shader_ocean_color_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_Ocean_Color");
planet_hydrosphere_lit_shader_ocean_foam_color_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_Ocean_Foam_Color");
planet_hydrosphere_lit_shader_ocean_foam_size_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_Ocean_Foam_Size");
planet_hydrosphere_lit_shader_position_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_Position");
planet_hydrosphere_lit_shader_euler_angles_index = shader_get_uniform(shd_planet_hydrosphere_lit, "u_EulerAngles");

planet_hydrosphere_lit_shader_camera_position_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_camera_position");
planet_hydrosphere_lit_shader_camera_rotation_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_camera_rotation");
planet_hydrosphere_lit_shader_camera_dimensions_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_camera_dimensions");

planet_hydrosphere_lit_shader_light_exists_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_light_exists");

planet_hydrosphere_lit_shader_light_position_x_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_light_position_x");
planet_hydrosphere_lit_shader_light_position_y_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_light_position_y");
planet_hydrosphere_lit_shader_light_position_z_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_light_position_z");

planet_hydrosphere_lit_shader_light_color_r_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_light_color_r");
planet_hydrosphere_lit_shader_light_color_g_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_light_color_g");
planet_hydrosphere_lit_shader_light_color_b_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_light_color_b");

planet_hydrosphere_lit_shader_light_radius_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_light_radius");
planet_hydrosphere_lit_shader_light_falloff_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_light_falloff");
planet_hydrosphere_lit_shader_light_intensity_index = shader_get_uniform(shd_planet_hydrosphere_lit, "in_light_intensity");

planet_hydrosphere_lit_shader_heightmap_texture_index = shader_get_sampler_index(shd_planet_hydrosphere_lit, "in_heightmap_texture");

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

// Universe Campaign Generation
generate_default_solar_system = function()
{
	//
	var temp_grandmom_solar_system = array_create(0);
	temp_grandmom_solar_system[0] = instance_create_depth(0, 0, 0, oSun);
	temp_grandmom_solar_system[1] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(8, 0, 15) } );
	temp_grandmom_solar_system[2] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(50, 50, 50), orbit_size: 300, orbit_speed: 2  } );
	temp_grandmom_solar_system[3] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(50, 50, 50), orbit_size: 500, orbit_speed: -0.5 } );
	temp_grandmom_solar_system[4] = instance_create_depth(0, 0, 0, oPlanet_Mom, { image_blend: make_color_rgb(50, 50, 50), orbit_size: 800, orbit_speed: -1 } );
	
	solar_systems[0] = temp_grandmom_solar_system;
	
	//
	solar_system_index = 0;
}

// DEBUG
//planet_simulator_add_light_source(-500, 240, -1400, make_color_rgb(206, 185, 240), 3000, 3, 2);
//planet_simulator_add_light_source(1000, 240, -1400, c_red, 100, 1, 2);
generate_default_solar_system();
