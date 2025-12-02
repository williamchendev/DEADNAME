/// @description Celestial Rendering Event
// Render Behaviour for the Celestial Simulator - Draws the Celestial Bodies given the Celestial Simulator's Properties

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Check if Solar System exists and is being viewed
if (ds_list_size(solar_system_render_depth_instances_list) == 0)
{
	// Not currently viewing a Solar System - Early Return
	return;
}

// Establish Camera Properties
var temp_camera = camera_get_active();
var temp_camera_proj_matrix = camera_get_proj_mat(temp_camera);

// Calculate and set Camera Orientation
var temp_projection_matrix = matrix_build_projection_perspective(GameManager.game_width, GameManager.game_height, camera_z_near, camera_z_far);
//var temp_projection_matrix = matrix_build_projection_ortho(640, 360, camera_z_near, camera_z_far);
camera_set_proj_mat(temp_camera, temp_projection_matrix);

// Set Default Blendmode
gpu_set_blendmode(bm_normal);

// Enable Z-Depth Rendering
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);

// Set Celestial Simulation Depth Rendering Surface as Surface Target
surface_set_target(planets_depth_surface);

// Enable Planet Lithosphere Shader
shader_set(shd_planet_lithosphere_lit);

// Set Planet Lithosphere Shader Camera Properties
shader_set_uniform_f(planet_lithosphere_lit_shader_vsh_camera_position_index, camera_position_x, camera_position_y, camera_position_z);
shader_set_uniform_f(planet_lithosphere_lit_shader_fsh_camera_position_index, camera_position_x, camera_position_y, camera_position_z);
shader_set_uniform_matrix_array(planet_lithosphere_lit_shader_camera_rotation_index, camera_rotation_matrix);
shader_set_uniform_f(planet_lithosphere_lit_shader_camera_dimensions_index, GameManager.game_width, GameManager.game_height);

// (Forward Rendered Lighting) Planet Lithosphere Lit Shader Properties
shader_set_uniform_f_array(planet_lithosphere_lit_shader_light_exists_index, light_source_exists);

shader_set_uniform_f_array(planet_lithosphere_lit_shader_light_position_x_index, light_source_position_x);
shader_set_uniform_f_array(planet_lithosphere_lit_shader_light_position_y_index, light_source_position_y);
shader_set_uniform_f_array(planet_lithosphere_lit_shader_light_position_z_index, light_source_position_z);

shader_set_uniform_f_array(planet_lithosphere_lit_shader_light_color_r_index, light_source_color_r);
shader_set_uniform_f_array(planet_lithosphere_lit_shader_light_color_g_index, light_source_color_g);
shader_set_uniform_f_array(planet_lithosphere_lit_shader_light_color_b_index, light_source_color_b);

shader_set_uniform_f_array(planet_lithosphere_lit_shader_light_radius_index, light_source_radius);
shader_set_uniform_f_array(planet_lithosphere_lit_shader_light_falloff_index, light_source_falloff);
shader_set_uniform_f_array(planet_lithosphere_lit_shader_light_intensity_index, light_source_intensity);

// Draw Planet Lithospheres
var temp_planet_lithosphere_render_celestial_body_index = 0;

repeat (ds_list_size(solar_system_render_depth_instances_list))
{
	// Establish Celestial Body Instance at Index
	var temp_planet_lithosphere_render_celestial_body_depth = ds_list_find_value(solar_system_render_depth_values_list, temp_planet_lithosphere_render_celestial_body_index);
	var temp_planet_lithosphere_render_celestial_body_instance = ds_list_find_value(solar_system_render_depth_instances_list, temp_planet_lithosphere_render_celestial_body_index);
	
	// Check Celestial Body's Type
	switch (temp_planet_lithosphere_render_celestial_body_instance.celestial_body_type)
	{
		case CelestialBodyType.Planet:
			// Render Planet's Lithosphere
			with (temp_planet_lithosphere_render_celestial_body_instance)
			{
				// Set Planet Depth
				gpu_set_depth(temp_planet_lithosphere_render_celestial_body_depth);
				
				// Set Planet Render Properties
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_radius_index, radius);
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_elevation_index, elevation);
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_position_index, x, y, z);
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_euler_angles_index, euler_angle_x, euler_angle_y, euler_angle_z);
				
				// Set Planet Height Map Texture
				texture_set_stage(CelestialSimulator.planet_lithosphere_lit_shader_heightmap_texture_index, sprite_get_texture(height_map, 0));
				
				// Draw Planet from Icosphere Vertex Buffer
				vertex_submit(icosphere_vertex_buffer, pr_trianglelist, diffuse_texture);
			}
			break;
		default:
			// Celestial Body is not a Planet - Skip rendering Lithosphere
			break;
	}
	
	// Increment Celestial Body Index
	temp_planet_lithosphere_render_celestial_body_index++;
}

// Reset Shader
shader_reset();

// Set Alpha Layering Blendmode - Correctly Layers Transparent Images over each other on Surfaces
gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

// Depth Sorted Render Pass
var temp_planet_depth_render_celestial_body_index = 0;

repeat (ds_list_size(solar_system_render_depth_instances_list))
{
	// Establish Celestial Body Instance at Index
	var temp_planet_depth_render_celestial_body_depth = ds_list_find_value(solar_system_render_depth_values_list, temp_planet_depth_render_celestial_body_index);
	var temp_planet_depth_render_celestial_body_instance = ds_list_find_value(solar_system_render_depth_instances_list, temp_planet_depth_render_celestial_body_index);
	
	// Check Celestial Body's Type
	switch (temp_planet_depth_render_celestial_body_instance.celestial_body_type)
	{
		case CelestialBodyType.Planet:
			// Render Planet's Depth Sorted Visual Effects
			with (temp_planet_depth_render_celestial_body_instance)
			{
				// Set Planet Depth
				gpu_set_depth(temp_planet_depth_render_celestial_body_depth);
				
				// Check if Planet's Ocean is Enabled and should be Rendered
				if (ocean)
				{
					// Enable Planet Hydrosphere Shader
					shader_set(shd_planet_hydrosphere_lit);
					
					// Set Planet Hydrosphere Shader Camera Properties
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_camera_position_index, CelestialSimulator.camera_position_x, CelestialSimulator.camera_position_y, CelestialSimulator.camera_position_z);
					shader_set_uniform_matrix_array(CelestialSimulator.planet_hydrosphere_lit_shader_camera_rotation_index, CelestialSimulator.camera_rotation_matrix);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_camera_dimensions_index, GameManager.game_width, GameManager.game_height);
					
					// (Forward Rendered Lighting) Planet Hydrosphere Lit Shader Properties
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_light_exists_index, CelestialSimulator.light_source_exists);
					
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_light_position_x_index, CelestialSimulator.light_source_position_x);
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_light_position_y_index, CelestialSimulator.light_source_position_y);
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_light_position_z_index, CelestialSimulator.light_source_position_z);
					
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_light_color_r_index, CelestialSimulator.light_source_color_r);
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_light_color_g_index, CelestialSimulator.light_source_color_g);
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_light_color_b_index, CelestialSimulator.light_source_color_b);
					
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_light_radius_index, CelestialSimulator.light_source_radius);
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_light_falloff_index, CelestialSimulator.light_source_falloff);
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_light_intensity_index, CelestialSimulator.light_source_intensity);
					
					// Set Planet Render Properties
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_radius_index, radius);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_elevation_index, elevation);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_felevation_index, elevation);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_ocean_elevation_index, ocean_elevation);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_ocean_roughness_index, ocean_roughness);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_ocean_color_index, color_get_red(ocean_color) / 255, color_get_green(ocean_color) / 255, color_get_blue(ocean_color) / 255, ocean_alpha);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_ocean_foam_color_index, color_get_red(ocean_foam_color) / 255, color_get_green(ocean_foam_color) / 255, color_get_blue(ocean_foam_color) / 255, ocean_foam_alpha);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_ocean_foam_size_index, ocean_foam_size);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_position_index, x, y, z);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_euler_angles_index, euler_angle_x, euler_angle_y, euler_angle_z);
					
					// Set Planet Height Map Texture
					texture_set_stage(CelestialSimulator.planet_hydrosphere_lit_shader_heightmap_texture_index, sprite_get_texture(height_map, 0));
					
					// Draw Planet from Icosphere Vertex Buffer
					vertex_submit(icosphere_vertex_buffer, pr_trianglelist, -1);
					
					// Reset Shader
					shader_reset();
				}
			}
			break;
		default:
			// Celestial Body is not a Planet - Skip rendering Lithosphere
			break;
	}
	
	// Increment Celestial Body Index
	temp_planet_depth_render_celestial_body_index++;
}

// Reset Surface Target
surface_reset_target();

// Disable Z-Depth Rendering
gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);

// Reset Camera Orientation
camera_set_proj_mat(temp_camera, temp_camera_proj_matrix);
