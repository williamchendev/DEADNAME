/// @description MRT Scene & Lighting Draw
// Draws Scene MRT Objects and Light Sources to Deferred Lighting Surfaces

// Reset Color and Transparency
draw_set_alpha(1);
draw_set_color(c_white);

// Set Default MRT Blendmode - Correctly Layers Transparent Images over each other on Surfaces
gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

// (Back Layer) Enable MRT Layer Surfaces - Draw objects to three different surfaces simultaneously: Diffuse (Object Color), Normals (Object Surface Direction Lighting Vectors), PBR MetallicRoughness/Emissive/Depth (Object Lighting and Details Map)
surface_set_target_ext(0, diffuse_back_color_surface);
surface_set_target_ext(1, normalmap_vector_surface);
surface_set_target_ext(2, layered_prb_metalrough_emissive_depth_surface);

// (Back Layer) Iterate through all Objects assigned via Sub Layers to be draw sequentially (from back to front) in a Painter's Sorted List
lighting_engine_render_layer(LightingEngineRenderLayerType.Back);

// (Back Layer) Reset MRT Lighting Surfaces
surface_reset_target();

// (Mid Layer) Enable MRT Layer Surfaces - Draw objects to three different surfaces simultaneously: Diffuse (Object Color), Normals (Object Surface Direction Lighting Vectors), PBR MetallicRoughness/Emissive/Depth (Object Lighting and Details Map)
surface_set_target_ext(0, diffuse_mid_color_surface);
surface_set_target_ext(1, normalmap_vector_surface);
surface_set_target_ext(2, layered_prb_metalrough_emissive_depth_surface);

// (Mid Layer) Iterate through all Objects assigned via Sub Layers to be draw sequentially (from back to front) in a Painter's Sorted List
lighting_engine_render_layer(LightingEngineRenderLayerType.Mid);

// (Mid Layer) Reset MRT Lighting Surfaces
surface_reset_target();

// (Front Layer) Enable MRT Layer Surfaces - Draw objects to three different surfaces simultaneously: Diffuse (Object Color), Normals (Object Surface Direction Lighting Vectors), PBR MetallicRoughness/Emissive/Depth (Object Lighting and Details Map)
surface_set_target_ext(0, diffuse_front_color_surface);
surface_set_target_ext(1, normalmap_vector_surface);
surface_set_target_ext(2, layered_prb_metalrough_emissive_depth_surface);

// (Front Layer) Iterate through all Objects assigned via Sub Layers to be draw sequentially (from back to front) in a Painter's Sorted List
lighting_engine_render_layer(LightingEngineRenderLayerType.Front);

// (Front Layer) Reset MRT Lighting Surfaces
surface_reset_target();

// Set Additive MRT Blendmode - Add Normal Map Vectors to Directional (Single Color Channel) Surfaces
gpu_set_blendmode(bm_add);

// (Distortion Effect) Enable MRT Distortion Surfaces - Draw Normal Maps to the two Red Only Channel 16 bit Float Surfaces: The Distortion Horizontal Channel Effect Surface and The Distortion Vertical Channel Effect Surface
surface_set_target_ext(0, distortion_horizontal_effect_surface);
surface_set_target_ext(1, distortion_vertical_effect_surface);

// (Distortion Effect) Enable MRT Distortion Shader - Draws Normal Maps to the two Red Only Channel 16 bit Float Surfaces so the Distortion Effect Normal Map Vectors can be correctly added
shader_set(shd_mrt_distortion_sprite);

// Set Distortion Shader Camera Offset
shader_set_uniform_f(mrt_distortion_sprite_shader_camera_offset_index, render_x - render_border, render_y - render_border);

// MRT Render all Distortion Effects to Distortion Surfaces
with (oLighting_Distortion_Object)
{
	// Draw Distortion
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);
}

// Reset MRT Distortion Effect Surfaces & Shader
surface_reset_target();
shader_reset();

// Render Point Lights with Shadows
with (oLightingEngine_Source_PointLight)
{
	if (point_light_render_enabled)
	{
		// GPU Blending: Surface retains the Alpha Maximum for Overlapping Black Shadows
		gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_one, bm_one);
		
		// Prepare Shader and Surface for Point Light Shadows
		shader_set(shd_point_light_and_spot_light_shadows);
		surface_set_target(LightingEngine.shadowmap_surface);
		
		// Reset Light Shadow Surface
		draw_clear_alpha(c_black, 0);
		
		// Set Point Light Shadow Shader Camera Offset
		shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
		
		// Set Point Light Shadow Shader Properties
		shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_light_source_radius_index, point_light_penumbra_size);
		shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_light_source_position_index, x, y);
		
		// Iterate through all Solid Object Box Colliders to draw their Shadows
		var temp_point_light_source_contact_solid_index = 0;
		
		repeat (ds_list_size(point_light_collisions_list))
		{
			var temp_point_light_source_contact_solid = ds_list_find_value(point_light_collisions_list, temp_point_light_source_contact_solid_index);
			
			if (temp_point_light_source_contact_solid.shadows_enabled)
			{
				// Set Solid Object's Box Collider Center Position, Scale, and Rotation
				shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_center_position_index, temp_point_light_source_contact_solid.center_xpos, temp_point_light_source_contact_solid.center_ypos);
				shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_scale_index, 1, 1);
				shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_rotation_index, 0);
				
				// Draw Solid Object's Shadow Vertex Buffer
				vertex_submit(temp_point_light_source_contact_solid.shadow_vertex_buffer, pr_trianglelist, -1);
			}
			
			temp_point_light_source_contact_solid_index++;
		}
		
		// Iterate through all Box Shadow Colliders to draw their Shadows
		with (oLightingEngine_BoxShadow_Static)
		{
			if (shadows_enabled and point_light_shadows_enabled)
			{
				// Set Box Shadow Collider Center Position, Scale, and Rotation
				if (dynamic_shadows)
				{
					shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_center_position_index, x, y);
					shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_scale_index, image_xscale, image_yscale);
					shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_rotation_index, image_angle);
				}
				else
				{
					shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_center_position_index, center_xpos, center_ypos);
					shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_scale_index, 1, 1);
					shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_rotation_index, 0);
				}
				
				// Draw Box Shadow Vertex Buffer
				vertex_submit(shadow_vertex_buffer, pr_trianglelist, -1);
			}
		}
		
		// Reset Shader and Surface
		shader_reset();
		surface_reset_target();
		
		// GPU Blending: Additive Blending for Lighting
		gpu_set_blendmode(bm_add);
		
		// Prepare Shader and Surface for Point Light Blending
		shader_set(shd_point_light_blend);
		surface_set_target_ext(0, LightingEngine.pbr_lighting_back_color_surface);
		surface_set_target_ext(1, LightingEngine.pbr_lighting_mid_color_surface);
		surface_set_target_ext(2, LightingEngine.pbr_lighting_front_color_surface);
		
		// Set Point Light Blend Shader Camera Offset
		shader_set_uniform_f(LightingEngine.point_light_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
		
		// Set Lighting Engine Light Blending Settings
		shader_set_uniform_f(LightingEngine.point_light_shader_global_illumination_multiplier_index, LightingEngine.global_illumination_multiplier);
		shader_set_uniform_f(LightingEngine.point_light_shader_highlight_strength_multiplier_index, LightingEngine.highlight_strength_multiplier);
		shader_set_uniform_f(LightingEngine.point_light_shader_broadlight_strength_multiplier_index, LightingEngine.broadlight_strength_multiplier);
		shader_set_uniform_f(LightingEngine.point_light_shader_highlight_to_broadlight_ratio_max_index, LightingEngine.highlight_to_broadlight_ratio_max);
		
		// Set Shader Surface Width, Height, and Texture Properties
		shader_set_uniform_f(LightingEngine.point_light_shader_surface_size_index, GameManager.game_width + (LightingEngine.render_border * 2), GameManager.game_height + (LightingEngine.render_border * 2));
		
		texture_set_stage(LightingEngine.point_light_shader_diffusemap_texture_back_layer_index, surface_get_texture(LightingEngine.diffuse_back_color_surface));
		texture_set_stage(LightingEngine.point_light_shader_diffusemap_texture_mid_layer_index, surface_get_texture(LightingEngine.diffuse_mid_color_surface));
		texture_set_stage(LightingEngine.point_light_shader_diffusemap_texture_front_layer_index, surface_get_texture(LightingEngine.diffuse_front_color_surface));
		
		texture_set_stage(LightingEngine.point_light_shader_normalmap_texture_index, surface_get_texture(LightingEngine.normalmap_vector_surface));
		texture_set_stage(LightingEngine.point_light_shader_shadowmap_texture_index, surface_get_texture(LightingEngine.shadowmap_surface));
		
		texture_set_stage(LightingEngine.point_light_shader_prb_metalrough_emissive_depth_texture_index, surface_get_texture(LightingEngine.layered_prb_metalrough_emissive_depth_surface));
		
		// Set Point Light Blend Shader Properties
		shader_set_uniform_f(LightingEngine.point_light_shader_radius_index, point_light_radius);
    	shader_set_uniform_f(LightingEngine.point_light_shader_centerpoint_index, x, y);
    	
    	shader_set_uniform_f(LightingEngine.point_light_shader_light_color_index, color_get_red(image_blend) / 255, color_get_green(image_blend) / 255, color_get_blue(image_blend) / 255);
    	shader_set_uniform_f(LightingEngine.point_light_shader_light_alpha_index, image_alpha);
    	shader_set_uniform_f(LightingEngine.point_light_shader_light_intensity_index, point_light_intensity);
    	shader_set_uniform_f(LightingEngine.point_light_shader_light_falloff_index, point_light_distance_fade);
    	
    	// Set Point Light Shader MRT Render Layer Properties
		shader_set_uniform_f(LightingEngine.point_light_shader_light_layers_index, point_light_render_background_layer ? 1 : 0, point_light_render_midground_layer ? 1 : 0, point_light_render_foreground_layer ? 1 : 0);
		shader_set_uniform_f(LightingEngine.point_light_shader_shadow_layers_index, LightingEngine.lighting_engine_back_render_layer_shadows_enabled ? 1 : 0, LightingEngine.lighting_engine_mid_render_layer_shadows_enabled ? 1 : 0, LightingEngine.lighting_engine_front_render_layer_shadows_enabled ? 1 : 0);
    	
    	// Draw Point Light Vertex Buffer
		vertex_submit(LightingEngine.simple_light_vertex_buffer, pr_trianglelist, -1);
		
		// Reset Shader and Surface
		shader_reset();
		surface_reset_target();
	}
}

// Render Spot Lights with Shadows
with (oLightingEngine_Source_SpotLight)
{
	if (spot_light_render_enabled and spot_light_fov > 0)
	{
		// GPU Blending: Surface retains the Alpha Maximum for Overlapping Black Shadows
		gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_one, bm_one);
		
		// Prepare Shader and Surface for Spot Light Shadows
		shader_set(shd_point_light_and_spot_light_shadows);
		surface_set_target(LightingEngine.shadowmap_surface);
		
		// Reset Light Shadow Surface
		draw_clear_alpha(c_black, 0);
		
		// Set Spot Light Shadow Shader Camera Offset
		shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
		
		// Set Spot Light Shadow Shader Properties
		shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_light_source_radius_index, spot_light_penumbra_size);
		shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_light_source_position_index, x, y);
		
		// Iterate through all Solid Object Box Colliders to Draw their Shadows
		var temp_spot_light_source_contact_solid_index = 0;
		
		repeat (ds_list_size(spot_light_collisions_list))
		{
			var temp_spot_light_source_contact_solid = ds_list_find_value(spot_light_collisions_list, temp_spot_light_source_contact_solid_index);
			
			if (temp_spot_light_source_contact_solid.shadows_enabled)
			{
				// Set Solid Object's Box Collider Center Position, Scale, and Rotation
				shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_center_position_index, temp_spot_light_source_contact_solid.center_xpos, temp_spot_light_source_contact_solid.center_ypos);
				shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_scale_index, 1, 1);
				shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_rotation_index, 0);
				
				// Draw Solid Object's Shadow Vertex Buffer
				vertex_submit(temp_spot_light_source_contact_solid.shadow_vertex_buffer, pr_trianglelist, -1);
			}
			
			temp_spot_light_source_contact_solid_index++;
		}
		
		// Iterate through all Box Shadow Colliders to draw their Shadows
		with (oLightingEngine_BoxShadow_Static)
		{
			if (shadows_enabled and spot_light_shadows_enabled)
			{
				// Set Box Shadow Collider Center Position, Scale, and Rotation
				if (dynamic_shadows)
				{
					shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_center_position_index, x, y);
					shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_scale_index, image_xscale, image_yscale);
					shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_rotation_index, image_angle);
				}
				else
				{
					shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_center_position_index, center_xpos, center_ypos);
					shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_scale_index, 1, 1);
					shader_set_uniform_f(LightingEngine.point_light_and_spot_light_shadow_shader_collider_rotation_index, 0);
				}
				
				// Draw Box Shadow Vertex Buffer
				vertex_submit(shadow_vertex_buffer, pr_trianglelist, -1);
			}
		}
		
		// Reset Shader and Surface
		shader_reset();
		surface_reset_target();
		
		// GPU Blending: Additive Blending for Lighting
		gpu_set_blendmode(bm_add);
		
		// Prepare Shader and Surface for Spot Light Blending
		shader_set(shd_spot_light_blend);
		surface_set_target_ext(0, LightingEngine.pbr_lighting_back_color_surface);
		surface_set_target_ext(1, LightingEngine.pbr_lighting_mid_color_surface);
		surface_set_target_ext(2, LightingEngine.pbr_lighting_front_color_surface);
		
		// Set Spot Light Blend Shader Camera Offset
		shader_set_uniform_f(LightingEngine.spot_light_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
		
		// Set Lighting Engine Light Blending Settings
		shader_set_uniform_f(LightingEngine.spot_light_shader_global_illumination_multiplier_index, LightingEngine.global_illumination_multiplier);
		shader_set_uniform_f(LightingEngine.spot_light_shader_highlight_strength_multiplier_index, LightingEngine.highlight_strength_multiplier);
		shader_set_uniform_f(LightingEngine.spot_light_shader_broadlight_strength_multiplier_index, LightingEngine.broadlight_strength_multiplier);
		shader_set_uniform_f(LightingEngine.spot_light_shader_highlight_to_broadlight_ratio_max_index, LightingEngine.highlight_to_broadlight_ratio_max);
		
		// Set Shader Surface Width, Height, and Texture Properties
		shader_set_uniform_f(LightingEngine.spot_light_shader_surface_size_index, GameManager.game_width + (LightingEngine.render_border * 2), GameManager.game_height + (LightingEngine.render_border * 2));
		
		texture_set_stage(LightingEngine.spot_light_shader_diffusemap_texture_back_layer_index, surface_get_texture(LightingEngine.diffuse_back_color_surface));
		texture_set_stage(LightingEngine.spot_light_shader_diffusemap_texture_mid_layer_index, surface_get_texture(LightingEngine.diffuse_mid_color_surface));
		texture_set_stage(LightingEngine.spot_light_shader_diffusemap_texture_front_layer_index, surface_get_texture(LightingEngine.diffuse_front_color_surface));
		
		texture_set_stage(LightingEngine.spot_light_shader_normalmap_texture_index, surface_get_texture(LightingEngine.normalmap_vector_surface));
		texture_set_stage(LightingEngine.spot_light_shader_shadows_texture_index, surface_get_texture(LightingEngine.shadowmap_surface));
		
		texture_set_stage(LightingEngine.spot_light_shader_prb_metalrough_emissive_depth_texture_index, surface_get_texture(LightingEngine.layered_prb_metalrough_emissive_depth_surface));
		
		// Set Spot Light Blend Shader Properties
		shader_set_uniform_f(LightingEngine.spot_light_shader_radius_index, spot_light_radius);
    	shader_set_uniform_f(LightingEngine.spot_light_shader_centerpoint_index, x, y);
    	
    	shader_set_uniform_f(LightingEngine.spot_light_shader_light_color_index, color_get_red(image_blend) / 255, color_get_green(image_blend) / 255, color_get_blue(image_blend) / 255);
    	shader_set_uniform_f(LightingEngine.spot_light_shader_light_alpha_index, image_alpha);
    	shader_set_uniform_f(LightingEngine.spot_light_shader_light_intensity_index, spot_light_intensity);
    	shader_set_uniform_f(LightingEngine.spot_light_shader_light_falloff_index, spot_light_distance_fade);
    	
    	shader_set_uniform_f(LightingEngine.spot_light_shader_light_direction_index, cos(degtorad(image_angle)), sin(degtorad(image_angle)));
		shader_set_uniform_f(LightingEngine.spot_light_shader_light_angle_index, spot_light_fov / 360);
		
		// Set Spot Light Shader MRT Render Layer Properties
		shader_set_uniform_f(LightingEngine.spot_light_shader_light_layers_index, spot_light_render_background_layer ? 1 : 0, spot_light_render_midground_layer ? 1 : 0, spot_light_render_foreground_layer ? 1 : 0);
		shader_set_uniform_f(LightingEngine.spot_light_shader_shadow_layers_index, LightingEngine.lighting_engine_back_render_layer_shadows_enabled ? 1 : 0, LightingEngine.lighting_engine_mid_render_layer_shadows_enabled ? 1 : 0, LightingEngine.lighting_engine_front_render_layer_shadows_enabled ? 1 : 0);
    	
    	// Draw Spot Light Vertex Buffer
		vertex_submit(LightingEngine.simple_light_vertex_buffer, pr_trianglelist, -1);
		
		// Reset Shader and Surface
		shader_reset();
		surface_reset_target();
	}
}

// Render Directional Lights with Shadows
with (oLightingEngine_Source_DirectionalLight)
{
	if (directional_light_render_enabled)
	{
		// Get Directional Light's Normalized Vector
		var temp_directional_light_vector_x = cos(degtorad(image_angle));
		var temp_directional_light_vector_y = sin(degtorad(image_angle));
		
		// GPU Blending: Surface retains the Alpha Maximum for Overlapping Black Shadows
		gpu_set_blendmode_ext_sepalpha(bm_zero, bm_one, bm_one, bm_one);
		
		// Prepare Shader and Surface for Directional Light Shadows
		shader_set(shd_directional_light_shadows);
		surface_set_target(LightingEngine.shadowmap_surface);
		
		// Reset Light Shadow Surface
		draw_clear_alpha(c_black, 0);
		
		// Set Directional Light Shadow Shader Camera Offset
		shader_set_uniform_f(LightingEngine.directional_light_shadow_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);
		
		// Set Directional Light Shadow Shader Properties
		shader_set_uniform_f(LightingEngine.directional_light_shadow_shader_light_source_radius_index, directional_light_penumbra_radius);
		shader_set_uniform_f(LightingEngine.directional_light_shadow_shader_light_source_vector_index, temp_directional_light_vector_x, temp_directional_light_vector_y);
		
		// Directional Light Shadow Rendering Behaviour
		if (LightingEngine.directional_light_collisions_exist)
		{
			// Iterate through all Solid Object Box Colliders to Draw their Shadows
			var temp_directional_light_view_contact_solid_index = 0;
			
			repeat (ds_list_size(LightingEngine.directional_light_collisions_list))
			{
				var temp_directional_light_source_contact_solid = ds_list_find_value(LightingEngine.directional_light_collisions_list, temp_directional_light_view_contact_solid_index);
				
				if (temp_directional_light_source_contact_solid.shadows_enabled)
				{
					// Set Solid Object's Box Collider Center Position, Scale, and Rotation
					shader_set_uniform_f(LightingEngine.directional_light_shadow_shader_collider_center_position_index, temp_directional_light_source_contact_solid.center_xpos, temp_directional_light_source_contact_solid.center_ypos);
					shader_set_uniform_f(LightingEngine.directional_light_shadow_shader_collider_scale_index, 1, 1);
					shader_set_uniform_f(LightingEngine.directional_light_shadow_shader_collider_rotation_index, 0);
					
					// Draw Solid Object's Shadow Vertex Buffer
					vertex_submit(temp_directional_light_source_contact_solid.shadow_vertex_buffer, pr_trianglelist, -1);
				}
				
				temp_directional_light_view_contact_solid_index++;
			}
		}
		
		// Iterate through all Box Shadow Colliders to draw their Shadows
		with (oLightingEngine_BoxShadow_Static)
		{
			if (shadows_enabled and directional_light_shadows_enabled)
			{
				// Set Box Shadow Collider Center Position, Scale, and Rotation
				if (dynamic_shadows)
				{
					shader_set_uniform_f(LightingEngine.directional_light_shadow_shader_collider_center_position_index, x, y);
					shader_set_uniform_f(LightingEngine.directional_light_shadow_shader_collider_scale_index, image_xscale, image_yscale);
					shader_set_uniform_f(LightingEngine.directional_light_shadow_shader_collider_rotation_index, image_angle);
				}
				else
				{
					shader_set_uniform_f(LightingEngine.directional_light_shadow_shader_collider_center_position_index, center_xpos, center_ypos);
					shader_set_uniform_f(LightingEngine.directional_light_shadow_shader_collider_scale_index, 1, 1);
					shader_set_uniform_f(LightingEngine.directional_light_shadow_shader_collider_rotation_index, 0);
				}
				
				// Draw Box Shadow Vertex Buffer
				vertex_submit(shadow_vertex_buffer, pr_trianglelist, -1);
			}
		}
		
		// Reset Shader and Surface
		surface_reset_target();
		shader_reset();
		
		// GPU Blending: Additive Blending for Lighting
		gpu_set_blendmode(bm_add);
		
		// Prepare Shader and Surface for Directional Light Blending
		shader_set(shd_directional_light_blend);
		surface_set_target_ext(0, LightingEngine.pbr_lighting_back_color_surface);
		surface_set_target_ext(1, LightingEngine.pbr_lighting_mid_color_surface);
		surface_set_target_ext(2, LightingEngine.pbr_lighting_front_color_surface);
		
		// Set Lighting Engine Light Blending Settings
		shader_set_uniform_f(LightingEngine.directional_light_shader_global_illumination_multiplier_index, LightingEngine.global_illumination_multiplier);
		shader_set_uniform_f(LightingEngine.directional_light_shader_highlight_strength_multiplier_index, LightingEngine.highlight_strength_multiplier);
		shader_set_uniform_f(LightingEngine.directional_light_shader_broadlight_strength_multiplier_index, LightingEngine.broadlight_strength_multiplier);
		shader_set_uniform_f(LightingEngine.directional_light_shader_highlight_to_broadlight_ratio_max_index, LightingEngine.highlight_to_broadlight_ratio_max);
		
		// Set Directional Light Blend Shader Properties
		shader_set_uniform_f(LightingEngine.directional_light_shader_light_intensity_index, directional_light_intensity);
		shader_set_uniform_f(LightingEngine.directional_light_shader_light_source_vector_index, temp_directional_light_vector_x, temp_directional_light_vector_y);
		
		// Set Shader Surface Normal Map Texture Properties
		texture_set_stage(LightingEngine.directional_light_shader_diffusemap_texture_back_layer_index, surface_get_texture(LightingEngine.diffuse_back_color_surface));
		texture_set_stage(LightingEngine.directional_light_shader_diffusemap_texture_mid_layer_index, surface_get_texture(LightingEngine.diffuse_mid_color_surface));
		texture_set_stage(LightingEngine.directional_light_shader_diffusemap_texture_front_layer_index, surface_get_texture(LightingEngine.diffuse_front_color_surface));
		
		texture_set_stage(LightingEngine.directional_light_shader_normalmap_texture_index, surface_get_texture(LightingEngine.normalmap_vector_surface));
		
		texture_set_stage(LightingEngine.directional_light_shader_prb_metalrough_emissive_depth_texture_index, surface_get_texture(LightingEngine.layered_prb_metalrough_emissive_depth_surface));
		
		// Set Directional Light Shader MRT Render Layer Properties
		shader_set_uniform_f(LightingEngine.directional_light_shader_light_layers_index, directional_light_render_background_layer ? 1 : 0, directional_light_render_midground_layer ? 1 : 0, directional_light_render_foreground_layer ? 1 : 0);
		shader_set_uniform_f(LightingEngine.directional_light_shader_shadow_layers_index, LightingEngine.lighting_engine_back_render_layer_shadows_enabled ? 1 : 0, LightingEngine.lighting_engine_mid_render_layer_shadows_enabled ? 1 : 0, LightingEngine.lighting_engine_front_render_layer_shadows_enabled ? 1 : 0);
		
		// Render Directional Light Blending using the Directional Light's Shadow Surface
		draw_surface_ext(LightingEngine.shadowmap_surface, 0, 0, 1, 1, 0, image_blend, image_alpha);
		
		// Reset Shader and Surface
		surface_reset_target();
		shader_reset();
	}
}

// Render Ambient Occlusion Lights
gpu_set_blendmode(bm_add);

shader_set(shd_ambient_occlusion_light_blend);

shader_set_uniform_f(ambient_light_shader_surface_size_index, GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2));

texture_set_stage(LightingEngine.ambient_light_shader_diffusemap_texture_back_layer_index, surface_get_texture(LightingEngine.diffuse_back_color_surface));
texture_set_stage(LightingEngine.ambient_light_shader_diffusemap_texture_mid_layer_index, surface_get_texture(LightingEngine.diffuse_mid_color_surface));
texture_set_stage(LightingEngine.ambient_light_shader_diffusemap_texture_front_layer_index, surface_get_texture(LightingEngine.diffuse_front_color_surface));

texture_set_stage(LightingEngine.ambient_light_shader_normalmap_texture_index, surface_get_texture(LightingEngine.normalmap_vector_surface));

surface_set_target_ext(0, pbr_lighting_back_color_surface);
surface_set_target_ext(1, pbr_lighting_mid_color_surface);
surface_set_target_ext(2, pbr_lighting_front_color_surface);

with (oLightingEngine_Source_AmbientLight)
{
	if (ambient_light_render_enabled)
	{
		// Set Ambient Occlusion Light Color
		shader_set_uniform_f(LightingEngine.ambient_light_shader_light_color_index, color_get_red(image_blend) / 255, color_get_green(image_blend) / 255, color_get_blue(image_blend) / 255);
		
		// Set Ambient Occlusion Light Intensity
		shader_set_uniform_f(LightingEngine.ambient_light_shader_light_intensity_index, ambient_light_intensity);
		
		// Set Ambient Occlusion Shadow Grading Intensity
		shader_set_uniform_f(LightingEngine.ambient_light_shader_light_surface_tangent_exponent_index, ambient_light_shadow_grading_intensity);
		
		// Draw Screen Space Ambient Occlusion Light Color to Light Blend Surface
		vertex_submit(LightingEngine.screen_space_vertex_buffer, pr_trianglelist, -1);
	}
}

gpu_set_blendmode(bm_normal);

shader_reset();
surface_reset_target();