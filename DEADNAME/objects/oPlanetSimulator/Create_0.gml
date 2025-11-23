//

// Global Planet Simulator Properties
#macro PlanetSimulator global.planet_simulator
#macro PlanetSimMaxLights 6

// Configure Planet Simulator - Global Init Event
gml_pragma("global", @"room_instance_add(room_first, 0, 0, oPlanetSimulator);");

// Delete to prevent multiple Planet Simulator Instances
if (instance_number(object_index) > 1) 
{
	instance_destroy(id, false);
	exit;
}

// Planet Simulator Singleton
global.planet_simulator = id;
sprite_index = -1;

// Planet Simulator Settings
camera_position_x = 0;
camera_position_y = 0;
camera_position_z = 0;

// Surfaces
planets_depth_surface = -1;

// Vertex Formats
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_color();
planet_render_vertex_format = vertex_format_end();

// (Forward Rendered Lighting) Planet Body Lit Rendering Shader Indexes
planet_body_lit_shader_radius_index = shader_get_uniform(shd_planet_body_lit, "u_Radius");
planet_body_lit_shader_position_index = shader_get_uniform(shd_planet_body_lit, "u_Position");
planet_body_lit_shader_euler_angles_index = shader_get_uniform(shd_planet_body_lit, "u_EulerAngles");

planet_body_lit_shader_camera_position_index = shader_get_uniform(shd_planet_body_lit, "in_camera_position");

planet_body_lit_shader_light_exists_index = shader_get_uniform(shd_planet_body_lit, "in_light_exists");

planet_body_lit_shader_light_position_x_index = shader_get_uniform(shd_planet_body_lit, "in_light_position_x");
planet_body_lit_shader_light_position_y_index = shader_get_uniform(shd_planet_body_lit, "in_light_position_y");
planet_body_lit_shader_light_position_z_index = shader_get_uniform(shd_planet_body_lit, "in_light_position_z");

planet_body_lit_shader_light_color_r_index = shader_get_uniform(shd_planet_body_lit, "in_light_color_r");
planet_body_lit_shader_light_color_g_index = shader_get_uniform(shd_planet_body_lit, "in_light_color_g");
planet_body_lit_shader_light_color_b_index = shader_get_uniform(shd_planet_body_lit, "in_light_color_b");

planet_body_lit_shader_light_radius_index = shader_get_uniform(shd_planet_body_lit, "in_light_radius");
planet_body_lit_shader_light_falloff_index = shader_get_uniform(shd_planet_body_lit, "in_light_falloff");
planet_body_lit_shader_light_intensity_index = shader_get_uniform(shd_planet_body_lit, "in_light_intensity");

planet_body_lit_shader_heightmap_texture_index = shader_get_sampler_index(shd_planet_body_lit, "in_heightmap_texture");

// Light Source Variables
light_source_exists = array_create(PlanetSimMaxLights);

light_source_position_x = array_create(PlanetSimMaxLights);
light_source_position_y = array_create(PlanetSimMaxLights);
light_source_position_z = array_create(PlanetSimMaxLights);

light_source_color_r = array_create(PlanetSimMaxLights);
light_source_color_g = array_create(PlanetSimMaxLights);
light_source_color_b = array_create(PlanetSimMaxLights);

light_source_radius = array_create(PlanetSimMaxLights);
light_source_falloff = array_create(PlanetSimMaxLights);
light_source_intensity = array_create(PlanetSimMaxLights);

for (var i = PlanetSimMaxLights - 1; i >= 0; i--)
{
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

// Light Source Methods
planet_simulator_add_light_source = function(light_x, light_y, light_z, light_color, light_radius, light_intensity, light_falloff)
{
	// Iterate through all Light Sources
	for (var i = 0; i < PlanetSimMaxLights; i++)
	{
		// Check if Light Source is Empty
		if (light_source_exists[i] == 1)
		{
			continue;
		}
		
		// Set Light Properties
		light_source_exists[i] = 1;
		
		light_source_position_x[i] = light_x;
		light_source_position_y[i] =light_y;
		light_source_position_z[i] =light_z;
		
		light_source_color_r[i] = color_get_red(light_color) / 255;
		light_source_color_g[i] = color_get_green(light_color) / 255;
		light_source_color_b[i] = color_get_blue(light_color) / 255;
		
		light_source_radius[i] = light_radius;
		light_source_falloff[i] = light_falloff;
		light_source_intensity[i] = light_intensity;
		
		// Break Loop and Return
		return;
	}
}

planet_simulator_reset_light_sources = function()
{
	// Iterate through all Light Sources
	for (var i = PlanetSimMaxLights - 1; i >= 0; i--)
	{
		// Reset Light Source to Default State
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
}

//
planet_simulator_add_light_source(-1500, 240, -2400, c_white, 8000, 1.2, 0.1);
//planet_simulator_add_light_source(-500, 240, -1400, make_color_rgb(206, 185, 240), 3000, 3, 2);
//planet_simulator_add_light_source(1000, 240, -1400, c_red, 100, 1, 2);
instance_create_depth(360, 240, 0, oPlanet, { image_blend: make_color_rgb(8, 0, 15) } );