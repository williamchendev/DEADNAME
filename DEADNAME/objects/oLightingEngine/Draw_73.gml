/// @description Process Scene Lighting
// Processes Diffuse and Lighting Surfaces into the Final Render Surface along with Post Processing Effects

// Enable Deferred Lighting Post Process Render Shader and Surface Target
shader_set(shd_post_process_render);
surface_set_target(post_processing_surface);

//
draw_clear(c_black);

// Set Deferred Lighting Post Process Render Shader's Background Texture
texture_set_stage(post_process_lighting_render_shader_background_texture_index, surface_get_texture(background_surface));

// Set Deferred Lighting Post Process Render Shader's Diffuse Map Textures
texture_set_stage(post_process_lighting_render_shader_diffusemap_back_layer_texture_index, surface_get_texture(diffuse_back_color_surface));
texture_set_stage(post_process_lighting_render_shader_diffusemap_front_layer_texture_index, surface_get_texture(diffuse_front_color_surface));

// Set Deferred Lighting Post Process Render Shader's Light Blend Textures
texture_set_stage(post_process_lighting_render_shader_lightblend_back_layer_texture_index, surface_get_texture(lights_back_color_surface));
texture_set_stage(post_process_lighting_render_shader_lightblend_mid_layer_texture_index, surface_get_texture(lights_mid_color_surface));
texture_set_stage(post_process_lighting_render_shader_lightblend_front_layer_texture_index, surface_get_texture(lights_front_color_surface));

// Set Deferred Lighting Post Process Render Shader's Specular Map
texture_set_stage(post_process_lighting_render_shader_specular_map_index, surface_get_texture(depth_specular_bloom_surface));

// Render Lit Surface with Background to Post Processing Surface
draw_surface(diffuse_mid_color_surface, 0, 0);

// Reset Surface & Shader
surface_reset_target();
shader_reset();

// Enable Bloom Effect Shader and Surface Target
shader_set(shd_bloom_effect_render);
surface_set_target(bloom_effect_surface);

// Set Bloom Effect Surface Texel Size & Set Bloom Texture
shader_set_uniform_f(bloom_effect_render_shader_surface_texel_size_index, 1 / (GameManager.game_width + (render_border * 2)), 1 / (GameManager.game_height + (render_border * 2)));
texture_set_stage(bloom_effect_render_shader_bloom_texture_index, surface_get_texture(depth_specular_bloom_surface));

// Set Bloom Render Color and Intensity
draw_set_color(render_bloom_color);
draw_set_alpha(render_bloom_intensity);

// Use Post Process Surface for Bloom Effect
draw_surface(post_processing_surface, 0, 0);

// Reset Surface & Shader
surface_reset_target();
shader_reset();

// Create Bloom Render
gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
surface_set_target(post_processing_surface);

//
draw_set_alpha(0.2);
draw_set_color(c_white);

//
for (var w = -2; w <= 2; w++)
{
	for (var h = -2; h <= 2; h++)
	{
		draw_surface(bloom_effect_surface, w, h);
	}
}

// Reset Surface & Blendmode
surface_reset_target();
gpu_set_blendmode(bm_normal);

// Reset Draw Alpha
draw_set_alpha(1.0);

// Create Final Render
shader_set(shd_distortion_effect_render);
surface_set_target(final_render_surface);

// Reset Final Render Surface with Neutral Color
draw_clear(c_black);

// Set Final Render Shader's Distortion Properties
shader_set_uniform_f(distortion_effect_render_shader_distortion_strength_index, universal_distortion_strength);
shader_set_uniform_f(distortion_effect_render_shader_distortion_aspect_index, (GameManager.game_height + (render_border * 2)) / (GameManager.game_width + (render_border * 2)));

// Set Final Render Shader's Distortion Texture
texture_set_stage(distortion_effect_render_shader_distortion_texture_index, surface_get_texture(distortion_effect_surface));

//
draw_surface(post_processing_surface, -render_border, -render_border);

// Reset Surface
surface_reset_target();
shader_reset();

//#####

/*
// Enable Final Render Shader and Surface
shader_set(shd_final_render_lighting);
surface_set_target(final_render_surface);

// Reset Final Render Surface with Neutral Color
draw_clear(c_black);

// Set Final Render Shader's Distortion Properties
shader_set_uniform_f(final_render_lighting_shader_distortion_strength_index, universal_distortion_strength);
shader_set_uniform_f(final_render_lighting_shader_distortion_aspect_index, (GameManager.game_height + (render_border * 2)) / (GameManager.game_width + (render_border * 2)));

// Set Final Render Shader's Distortion Texture
texture_set_stage(final_render_lighting_shader_distortion_texture_index, surface_get_texture(distortion_effect_surface));

// Set Final Render Shader's Background Texture
texture_set_stage(final_render_lighting_shader_background_texture_index, surface_get_texture(background_surface));

// Set Final Render Shader's Diffuse Map Textures
texture_set_stage(final_render_lighting_shader_diffusemap_back_layer_texture_index, surface_get_texture(diffuse_back_color_surface));
texture_set_stage(final_render_lighting_shader_diffusemap_front_layer_texture_index, surface_get_texture(diffuse_front_color_surface));

// Set Final Render Shader's Light Blend Textures
texture_set_stage(final_render_lighting_shader_lightblend_back_layer_texture_index, surface_get_texture(lights_back_color_surface));
texture_set_stage(final_render_lighting_shader_lightblend_mid_layer_texture_index, surface_get_texture(lights_mid_color_surface));
texture_set_stage(final_render_lighting_shader_lightblend_front_layer_texture_index, surface_get_texture(lights_front_color_surface));

// Draw Lit Surface with Post Processing
draw_surface(diffuse_mid_color_surface, -render_border, -render_border);

// Reset Surface & Shader
surface_reset_target();
shader_reset();
*/