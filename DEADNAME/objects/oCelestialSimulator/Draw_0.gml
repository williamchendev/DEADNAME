/// @description Celestial Rendering Event
// Render Behaviour for the Celestial Simulator - Draws the Celestial Objects given the Celestial Simulator's Properties

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

// Create and Set Perspective Camera Projection Matrix
var temp_projection_matrix = matrix_build_projection_perspective_fov(camera_fov, GameManager.game_width / GameManager.game_height, camera_z_near, camera_z_far);
camera_set_proj_mat(temp_camera, temp_projection_matrix);

// Iterate through Solar System's Depth Sorted Celestial Objects for Celestial Simulator Render Pass
var temp_celestial_object_depth_render_index = 0;

repeat (ds_list_size(solar_system_render_depth_instances_list))
{
	// Establish Celestial Object Instance at Index
	var temp_celestial_object_depth = ds_list_find_value(solar_system_render_depth_values_list, temp_celestial_object_depth_render_index);
	var temp_celestial_object_instance = ds_list_find_value(solar_system_render_depth_instances_list, temp_celestial_object_depth_render_index);
	
	// Compare Celestial Object's Type to determine Celestial Object's Render Behaviour
	switch (temp_celestial_object_instance.celestial_object_type)
	{
		case CelestialObjectType.Sun:
			// Render Unlit Sun
			with (temp_celestial_object_instance)
			{
				// Set Default Blendmode
				gpu_set_blendmode(bm_normal);
				
				// Enable Z-Depth Rendering
				gpu_set_zwriteenable(true);
				gpu_set_ztestenable(true);
				
				// Set Celestial Body Depth Render Surface as Surface Target
				surface_set_target(CelestialSimulator.celestial_body_render_surface);
				
				// Reset Celestial Body Depth Render Surface
				draw_clear_alpha(c_black, 0);
				draw_clear_depth(1);
				
				// Enable Sun Unlit Shader
				shader_set(shd_sun_unlit);
				
				// Set Sun Unlit Shader Camera Properties
				shader_set_uniform_f(CelestialSimulator.sun_unlit_shader_camera_position_index, CelestialSimulator.camera_position_x, CelestialSimulator.camera_position_y, CelestialSimulator.camera_position_z);
				shader_set_uniform_matrix_array(CelestialSimulator.sun_unlit_shader_camera_rotation_index, CelestialSimulator.camera_rotation_matrix);
				shader_set_uniform_f(CelestialSimulator.sun_unlit_shader_camera_dimensions_index, GameManager.game_width, GameManager.game_height);
				
				// Set Sun Physical Properties
				shader_set_uniform_f(CelestialSimulator.sun_unlit_shader_radius_index, radius);
				shader_set_uniform_f(CelestialSimulator.sun_unlit_shader_elevation_index, elevation);
				shader_set_uniform_f(CelestialSimulator.sun_unlit_shader_position_index, x, y, z);
				shader_set_uniform_f(CelestialSimulator.sun_unlit_shader_euler_angles_index, euler_angle_x, euler_angle_y, euler_angle_z);
				
				// Draw Sun from Icosphere Vertex Buffer
				//vertex_submit(icosphere_vertex_buffer, pr_trianglelist, diffuse_texture);
				
				// Reset Shader
				shader_reset();
				
				// Reset Surface Target
				surface_reset_target();
				
				// Disable Z-Depth Rendering
				gpu_set_zwriteenable(false);
				gpu_set_ztestenable(false);
				
				// Set Alpha Layering Blendmode - Correctly Layers Transparent Images over each other on Surfaces
				gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
			}
			
			// Render Celestial Object to Final Render Surface
			surface_set_target(final_render_surface);
			draw_surface_ext(celestial_body_render_surface, 0, 0, 1, 1, 0, c_white, 1);
			surface_reset_target();
			break;
		case CelestialObjectType.Planet:
			// Render Planet (Lithosphere, Hydrosphere, Atmosphere)
			with (temp_celestial_object_instance)
			{
				// Set Default Blendmode
				gpu_set_blendmode(bm_normal);
				
				// Enable Z-Depth Rendering
				gpu_set_zwriteenable(true);
				gpu_set_ztestenable(true);
				
				// (Multiple Render Targets) Set Celestial Body Render Surfaces as Surface Targets
				surface_set_target_ext(0, CelestialSimulator.celestial_body_render_surface);
				surface_set_target_ext(1, CelestialSimulator.celestial_body_atmosphere_depth_mask_surface);
				
				// Reset Celestial Body Depth Render Surface
				draw_clear_alpha(c_black, 0);
				draw_clear_depth(1);
				
				// Enable Planet Lithosphere Shader
				shader_set(shd_planet_lithosphere_lit);
				
				// Set Planet Lithosphere Shader Camera Properties
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_vsh_camera_position_index, CelestialSimulator.camera_position_x, CelestialSimulator.camera_position_y, CelestialSimulator.camera_position_z);
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_fsh_camera_position_index, CelestialSimulator.camera_position_x, CelestialSimulator.camera_position_y, CelestialSimulator.camera_position_z);
				shader_set_uniform_matrix_array(CelestialSimulator.planet_lithosphere_lit_shader_camera_rotation_index, CelestialSimulator.camera_rotation_matrix);
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_camera_dimensions_index, GameManager.game_width, GameManager.game_height);
				
				// Set Planet Lithosphere Time Clock for Spatiotemporal Blue Noise
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_noise_time_index, CelestialSimulator.global_noise_time);
				
				// (Forward Rendered Lighting) Planet Lithosphere Light Source Shader Properties
				shader_set_uniform_f_array(CelestialSimulator.planet_lithosphere_lit_shader_light_exists_index, CelestialSimulator.light_source_exists);
				
				shader_set_uniform_f_array(CelestialSimulator.planet_lithosphere_lit_shader_light_position_x_index, CelestialSimulator.light_source_position_x);
				shader_set_uniform_f_array(CelestialSimulator.planet_lithosphere_lit_shader_light_position_y_index, CelestialSimulator.light_source_position_y);
				shader_set_uniform_f_array(CelestialSimulator.planet_lithosphere_lit_shader_light_position_z_index, CelestialSimulator.light_source_position_z);
				
				shader_set_uniform_f_array(CelestialSimulator.planet_lithosphere_lit_shader_light_color_r_index, CelestialSimulator.light_source_color_r);
				shader_set_uniform_f_array(CelestialSimulator.planet_lithosphere_lit_shader_light_color_g_index, CelestialSimulator.light_source_color_g);
				shader_set_uniform_f_array(CelestialSimulator.planet_lithosphere_lit_shader_light_color_b_index, CelestialSimulator.light_source_color_b);
				
				shader_set_uniform_f_array(CelestialSimulator.planet_lithosphere_lit_shader_light_radius_index, CelestialSimulator.light_source_radius);
				shader_set_uniform_f_array(CelestialSimulator.planet_lithosphere_lit_shader_light_falloff_index, CelestialSimulator.light_source_falloff);
				shader_set_uniform_f_array(CelestialSimulator.planet_lithosphere_lit_shader_light_intensity_index, CelestialSimulator.light_source_intensity);
				
				// Set Planet Physical Properties
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_planet_radius_index, radius);
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_planet_elevation_index, elevation);
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_planet_position_index, x, y, z);
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_planet_euler_angles_index, euler_angle_x, euler_angle_y, euler_angle_z);
				
				// Set Planet Atmosphere Properties
				shader_set_uniform_f(CelestialSimulator.planet_lithosphere_lit_shader_atmosphere_radius_index, radius + elevation + sky_radius);
				
				// Set Planet Texture Data
				texture_set_stage(CelestialSimulator.planet_lithosphere_lit_shader_planet_texture_index, height_map != noone ? sprite_get_texture(height_map, 0) : sprite_get_texture(sPlanet_ElevationMap_Empty, 0));
				
				// Draw Planet from Icosphere Vertex Buffer
				vertex_submit(icosphere_vertex_buffer, pr_trianglelist, diffuse_texture);
				
				// Reset Shader
				shader_reset();
				
				// Reset Surface Target
				surface_reset_target();
				
				// Check if Planet's Ocean is Enabled and should be Rendered
				if (ocean)
				{
					// Set Alpha Layering Blendmode - Correctly Layers Transparent Images over each other on Surfaces
					gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
					
					// (Multiple Render Targets) Set Celestial Body Render Surfaces as Surface Targets
					surface_set_target_ext(0, CelestialSimulator.celestial_body_render_surface);
					surface_set_target_ext(1, CelestialSimulator.celestial_body_atmosphere_depth_mask_surface);
					
					// Enable Planet Hydrosphere Shader
					shader_set(shd_planet_hydrosphere_lit);
					
					// Set Planet Hydrosphere Shader Camera Properties
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_vsh_camera_position_index, CelestialSimulator.camera_position_x, CelestialSimulator.camera_position_y, CelestialSimulator.camera_position_z);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_fsh_camera_position_index, CelestialSimulator.camera_position_x, CelestialSimulator.camera_position_y, CelestialSimulator.camera_position_z);
					shader_set_uniform_matrix_array(CelestialSimulator.planet_hydrosphere_lit_shader_vsh_camera_rotation_index, CelestialSimulator.camera_rotation_matrix);
					shader_set_uniform_matrix_array(CelestialSimulator.planet_hydrosphere_lit_shader_fsh_camera_rotation_index, CelestialSimulator.camera_rotation_matrix);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_camera_dimensions_index, GameManager.game_width, GameManager.game_height);
					
					// Set Planet Hydrosphere Time Clock for Spatiotemporal Blue Noise
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_noise_time_index, CelestialSimulator.global_noise_time);
					
					// Set Planet Hydrosphere Lighting Render Properties
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_specular_intensity_index, CelestialSimulator.global_hydrosphere_specular_intensity);
					
					// (Forward Rendered Lighting) Planet Hydrosphere Light Source Shader Properties
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
					
					// Set Planet Physical Properties
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_planet_radius_index, radius);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_vsh_planet_elevation_index, elevation);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_fsh_planet_elevation_index, elevation);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_planet_position_index, x, y, z);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_planet_euler_angles_index, euler_angle_x, euler_angle_y, euler_angle_z);
					
					// Set Planet Hydrosphere Properties
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_vsh_planet_ocean_elevation_index, ocean_elevation);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_fsh_planet_ocean_elevation_index, ocean_elevation);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_planet_ocean_roughness_index, ocean_roughness);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_planet_ocean_color_index, color_get_red(ocean_color) / 255, color_get_green(ocean_color) / 255, color_get_blue(ocean_color) / 255, ocean_alpha);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_planet_ocean_foam_color_index, color_get_red(ocean_foam_color) / 255, color_get_green(ocean_foam_color) / 255, color_get_blue(ocean_foam_color) / 255, ocean_foam_alpha);
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_planet_ocean_foam_size_index, min(elevation * (1.0 - ocean_elevation), ocean_foam_size));
					
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_planet_ocean_wave_time_index, CelestialSimulator.global_hydrosphere_time);
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_planet_ocean_wave_direction_index, ocean_wave_direction_array);
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_planet_ocean_wave_steepness_index, ocean_wave_steepness_array);
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_planet_ocean_wave_length_index, ocean_wave_length_array);
					shader_set_uniform_f_array(CelestialSimulator.planet_hydrosphere_lit_shader_planet_ocean_wave_speed_index, ocean_wave_speed_array);
					
					// Set Planet Atmosphere Properties
					shader_set_uniform_f(CelestialSimulator.planet_hydrosphere_lit_shader_atmosphere_radius_index, radius + elevation + sky_radius);
					
					// Draw Planet from Icosphere Vertex Buffer
					vertex_submit(icosphere_vertex_buffer, pr_trianglelist, -1);
					
					// Reset Shader
					shader_reset();
					
					// Reset Surface Target
					surface_reset_target();
				}
				
				// Disable Z-Depth Rendering
				gpu_set_zwriteenable(false);
				gpu_set_ztestenable(false);
				
				// Set Alpha Layering Blendmode - Correctly Layers Transparent Images over each other on Surfaces
				gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
				
				// Check if Planet's Atmosphere is Enabled and should be Rendered
				if (sky)
				{
					// Set Clouds Depth Render Surface as Surface Target
					surface_set_target(CelestialSimulator.clouds_render_surface);
					
					// Reset Clouds Depth Render Surface
					draw_clear_alpha(c_black, 0);
					
					// Check if Planet's Atmosphere will contain Clouds
					if (clouds)
					{
						// Enable SDF Sphere Volumetric Cloud Lit Shader for Rendering Planet's Clouds within Atmosphere
						shader_set(shd_sdf_sphere_volumetric_cloud_lit);
						
						// Set Atmosphere Cloud Rendering Shader Camera Properties
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_vsh_camera_position, CelestialSimulator.camera_position_x, CelestialSimulator.camera_position_y, CelestialSimulator.camera_position_z);
						shader_set_uniform_matrix_array(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_vsh_camera_rotation, CelestialSimulator.camera_rotation_matrix);
						shader_set_uniform_matrix_array(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_fsh_camera_rotation, CelestialSimulator.camera_rotation_matrix);
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_vsh_camera_dimensions, GameManager.game_width, GameManager.game_height);
						
						// Set Atmosphere Cloud Noise Texture Sampling Properties
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_cloud_noise_square_size_index, 2048);
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_cloud_noise_cube_size_index, 256);
						
						// Set Atmosphere Global Cloud Lighting and Rendering Properties
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_scatter_point_samples_count_index, CelestialSimulator.global_clouds_scatter_point_samples_count);
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_light_depth_samples_count_index, CelestialSimulator.global_clouds_light_depth_samples_count);
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_cloud_sample_scale_index, CelestialSimulator.global_clouds_sample_scale);
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_cloud_density_falloff_index, CelestialSimulator.global_clouds_density_falloff);
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_cloud_anisotropic_light_scattering_index, CelestialSimulator.global_clouds_anisotropic_light_scattering_strength);
						
						// (Forward Rendered Lighting) Atmosphere Cloud Light Source Shader Properties
						shader_set_uniform_f_array(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_light_exists_index, CelestialSimulator.light_source_exists);
						
						shader_set_uniform_f_array(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_light_position_x_index, CelestialSimulator.light_source_position_x);
						shader_set_uniform_f_array(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_light_position_y_index, CelestialSimulator.light_source_position_y);
						shader_set_uniform_f_array(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_light_position_z_index, CelestialSimulator.light_source_position_z);
						
						shader_set_uniform_f_array(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_light_color_r_index, CelestialSimulator.light_source_color_r);
						shader_set_uniform_f_array(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_light_color_g_index, CelestialSimulator.light_source_color_g);
						shader_set_uniform_f_array(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_light_color_b_index, CelestialSimulator.light_source_color_b);
						
						shader_set_uniform_f_array(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_light_radius_index, CelestialSimulator.light_source_radius);
						shader_set_uniform_f_array(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_light_falloff_index, CelestialSimulator.light_source_falloff);
						shader_set_uniform_f_array(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_light_intensity_index, CelestialSimulator.light_source_intensity);
						
						// Set Planet Atmosphere Properties
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_vsh_atmosphere_radius_index, radius + elevation + sky_radius);
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_fsh_atmosphere_radius_index, radius + elevation + sky_radius);
						
						// Set Planet Physical Properties
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_vsh_planet_radius_index, radius);
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_fsh_planet_radius_index, radius);
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_vsh_planet_position_index, x, y, z);
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_fsh_planet_position_index, x, y, z);
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_planet_euler_angles_index, euler_angle_x, euler_angle_y, euler_angle_z);
						
						// Set Cloud Color
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_cloud_color_index, color_get_red(clouds_color) / 255, color_get_green(clouds_color) / 255, color_get_blue(clouds_color) / 255);
						
						// Set Cloud Ambient Light Color
						var temp_cloud_ambient_light_color_red = (color_get_red(image_blend) / 255) * (color_get_red(clouds_ambient_color) / 255);
						var temp_cloud_ambient_light_color_green = (color_get_green(image_blend) / 255) * (color_get_green(clouds_ambient_color) / 255);
						var temp_cloud_ambient_light_color_blue = (color_get_blue(image_blend) / 255) * (color_get_blue(clouds_ambient_color) / 255);
						
						shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_cloud_ambient_light_color_index, temp_cloud_ambient_light_color_red, temp_cloud_ambient_light_color_green, temp_cloud_ambient_light_color_blue);
						
						// Set the Atmosphere Mask Texture of the Planet's Depth Render
						texture_set_stage(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_planet_depth_mask_texture_index, surface_get_texture(CelestialSimulator.celestial_body_atmosphere_depth_mask_surface));
						
						// Iterate through all Clouds in Planet's Atmosphere
						var temp_cloud_depth_index = 0;
						
						repeat (ds_list_size(clouds_depth_list))
						{
							// Find Individual Cloud Render Properties from Planet Cloud Depth Sorted Render Property DS Lists
							var temp_cloud_u = ds_list_find_value(temp_celestial_object_instance.clouds_render_u_list, temp_cloud_depth_index);
							var temp_cloud_v = ds_list_find_value(temp_celestial_object_instance.clouds_render_v_list, temp_cloud_depth_index);
							var temp_cloud_height = ds_list_find_value(temp_celestial_object_instance.clouds_render_height_list, temp_cloud_depth_index);
							var temp_cloud_radius = ds_list_find_value(temp_celestial_object_instance.clouds_render_radius_list, temp_cloud_depth_index);
							var temp_cloud_density = ds_list_find_value(temp_celestial_object_instance.clouds_render_density_list, temp_cloud_depth_index);
							var temp_cloud_absorption = ds_list_find_value(temp_celestial_object_instance.clouds_render_absorption_list, temp_cloud_depth_index);
							
							// Set Atmosphere Time Clock for Spatiotemporal Blue Noise
							shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_noise_time_index, CelestialSimulator.global_noise_time + temp_cloud_depth_index * CelestialSimulator.global_clouds_temporal_blue_noise_offset);
							
							// Set Cloud Render Properties
							shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_vsh_cloud_radius_index, temp_cloud_radius);
							shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_fsh_cloud_radius_index, temp_cloud_radius);
							
							shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_cloud_uv_index, temp_cloud_u, temp_cloud_v);
							shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_cloud_height_index, temp_cloud_height);
							
							shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_cloud_density_index, CelestialSimulator.global_clouds_density * temp_cloud_density);
							shader_set_uniform_f(CelestialSimulator.sdf_sphere_volumetric_clouds_lit_shader_cloud_absorption_index, CelestialSimulator.global_clouds_absorption * temp_cloud_absorption);
							
							// Draw SDF Sphere Volumetric Cloud from Square UV Vertex Buffer
							vertex_submit(CelestialSimulator.square_uv_vertex_buffer, pr_trianglelist, CelestialSimulator.cloud_noise_texture);
							
							// Increment Cloud Depth Index
							temp_cloud_depth_index++;
						}
						
						// Reset Shader
						shader_reset();
					}
					
					// Reset Surface Target
					surface_reset_target();
					
					// Set Final Render Surface as Surface Target
					surface_set_target(CelestialSimulator.final_render_surface);
					
					// Enable Planet Atmosphere Shader
					shader_set(shd_planet_atmosphere_lit);
					
					// Set Planet Atmosphere Shader Camera Properties
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_vsh_camera_position_index, CelestialSimulator.camera_position_x, CelestialSimulator.camera_position_y, CelestialSimulator.camera_position_z);
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_fsh_camera_position_index, CelestialSimulator.camera_position_x, CelestialSimulator.camera_position_y, CelestialSimulator.camera_position_z);
					shader_set_uniform_matrix_array(CelestialSimulator.planet_atmosphere_lit_shader_vsh_camera_rotation_index, CelestialSimulator.camera_rotation_matrix);
					shader_set_uniform_matrix_array(CelestialSimulator.planet_atmosphere_lit_shader_fsh_camera_rotation_index, CelestialSimulator.camera_rotation_matrix);
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_vsh_camera_dimensions_index, GameManager.game_width, GameManager.game_height);
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_fsh_camera_dimensions_index, GameManager.game_width, GameManager.game_height);
					
					// Set Atmosphere Time Clock for Spatiotemporal Blue Noise
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_noise_time_index, CelestialSimulator.global_noise_time);
					
					// Set Planet Atmosphere Sampling Properties
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_scatter_point_samples_num_index, CelestialSimulator.global_atmosphere_scatter_point_samples_count);
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_optical_depth_samples_num_index, CelestialSimulator.global_atmosphere_optical_depth_samples_count);
					
					// (Forward Rendered Lighting) Planet Atmosphere Light Source Shader Properties
					shader_set_uniform_f_array(CelestialSimulator.planet_atmosphere_lit_shader_light_exists_index, CelestialSimulator.light_source_exists);
					
					shader_set_uniform_f_array(CelestialSimulator.planet_atmosphere_lit_shader_light_position_x_index, CelestialSimulator.light_source_position_x);
					shader_set_uniform_f_array(CelestialSimulator.planet_atmosphere_lit_shader_light_position_y_index, CelestialSimulator.light_source_position_y);
					shader_set_uniform_f_array(CelestialSimulator.planet_atmosphere_lit_shader_light_position_z_index, CelestialSimulator.light_source_position_z);
					
					shader_set_uniform_f_array(CelestialSimulator.planet_atmosphere_lit_shader_light_radius_index, CelestialSimulator.light_source_radius);
					shader_set_uniform_f_array(CelestialSimulator.planet_atmosphere_lit_shader_light_falloff_index, CelestialSimulator.light_source_falloff);
					shader_set_uniform_f_array(CelestialSimulator.planet_atmosphere_lit_shader_light_intensity_index, CelestialSimulator.light_source_intensity);
					
					// Set Planet Atmosphere Cloud Properties
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_clouds_alpha_blending_power_index, CelestialSimulator.global_clouds_alpha_blending_power);
					
					// Set Atmosphere Render Properties
					var temp_planet_atmosphere_scatter_r = power(400 / sky_light_wavelength_r, 4) * sky_light_scattering_strength;
					var temp_planet_atmosphere_scatter_g = power(400 / sky_light_wavelength_g, 4) * sky_light_scattering_strength;
					var temp_planet_atmosphere_scatter_b = power(400 / sky_light_wavelength_b, 4) * sky_light_scattering_strength;
					
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_vsh_atmosphere_radius_index, radius + elevation + sky_radius);
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_fsh_atmosphere_radius_index, radius + elevation + sky_radius);
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_atmosphere_density_falloff_index, sky_density_falloff);
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_atmosphere_scattering_coefficients_index, temp_planet_atmosphere_scatter_r, temp_planet_atmosphere_scatter_g, temp_planet_atmosphere_scatter_b);
					
					// Set Planet Render Properties
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_planet_radius_index, radius);
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_vsh_planet_position_index, x, y, z);
					shader_set_uniform_f(CelestialSimulator.planet_atmosphere_lit_shader_fsh_planet_position_index, x, y, z);
					
					// Set the Atmosphere Mask Texture of the Planet's Depth Render
					texture_set_stage(CelestialSimulator.planet_atmosphere_lit_shader_clouds_surface_texture_index, surface_get_texture(CelestialSimulator.clouds_render_surface));
					texture_set_stage(CelestialSimulator.planet_atmosphere_lit_shader_planet_depth_mask_texture_index, surface_get_texture(CelestialSimulator.celestial_body_atmosphere_depth_mask_surface));
					
					// Draw Final Planet Render with Atmosphere from Square UV Vertex Buffer
					vertex_submit(CelestialSimulator.square_uv_vertex_buffer, pr_trianglelist, surface_get_texture(CelestialSimulator.celestial_body_render_surface));
					
					// Reset Shader
					shader_reset();
					
					// Reset Surface Target
					surface_reset_target();
				}
				else
				{
					// Render Celestial Object to Final Render Surface
					surface_set_target(CelestialSimulator.final_render_surface);
					draw_surface_ext(CelestialSimulator.celestial_body_render_surface, 0, 0, 1, 1, 0, c_white, 1);
					surface_reset_target();
				}
			}
			break;
		default:
			// Celestial Object is not a Planet - Skip rendering Lithosphere
			break;
	}
	
	// Increment Celestial Object Index
	temp_celestial_object_depth_render_index++;
}

// Reset Camera Orientation
camera_set_proj_mat(temp_camera, temp_camera_proj_matrix);
