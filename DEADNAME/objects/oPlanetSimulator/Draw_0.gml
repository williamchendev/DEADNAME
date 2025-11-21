//

//
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);

// Set Planet Simulation Depth Rendering Surface as Surface Target
surface_set_target(planets_depth_surface);

//
shader_set(shd_planet_body_lit);

//
shader_set_uniform_f(planet_body_lit_shader_camera_position_index, camera_position_x, camera_position_y, camera_position_z);

// (Forward Rendered Lighting) Planet Body Lit Shader Properties
shader_set_uniform_f_array(planet_body_lit_shader_light_exists_index, light_source_exists);

shader_set_uniform_f_array(planet_body_lit_shader_light_position_x_index, light_source_position_x);
shader_set_uniform_f_array(planet_body_lit_shader_light_position_y_index, light_source_position_y);
shader_set_uniform_f_array(planet_body_lit_shader_light_position_z_index, light_source_position_z);

shader_set_uniform_f_array(planet_body_lit_shader_light_color_r_index, light_source_color_r);
shader_set_uniform_f_array(planet_body_lit_shader_light_color_g_index, light_source_color_g);
shader_set_uniform_f_array(planet_body_lit_shader_light_color_b_index, light_source_color_b);

shader_set_uniform_f_array(planet_body_lit_shader_light_radius_index, light_source_radius);
shader_set_uniform_f_array(planet_body_lit_shader_light_falloff_index, light_source_falloff);
shader_set_uniform_f_array(planet_body_lit_shader_light_intensity_index, light_source_intensity);

//
with (oPlanet)
{
	//
	shader_set_uniform_f(PlanetSimulator.planet_body_lit_shader_radius_index, radius);
	shader_set_uniform_f(PlanetSimulator.planet_body_lit_shader_position_index, x, y, z);
	shader_set_uniform_f(PlanetSimulator.planet_body_lit_shader_euler_angles_index, euler_angle_x, euler_angle_y, euler_angle_z);
	
	//
	texture_set_stage(PlanetSimulator.planet_body_lit_shader_heightmap_texture_index, sprite_get_texture(heightmap_texture, 0));
	
	//
	vertex_submit(icosphere_vertex_buffer, pr_trianglelist, icosphere_texture);
}

//
shader_reset();

// Reset Surface Target
surface_reset_target();

//
gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);