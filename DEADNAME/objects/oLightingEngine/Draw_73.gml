/// @description Process Scene Lighting
// Processes Diffuse and Lighting Surfaces into the Final Render Surface along with Post Processing Effects

// Enable Deferred Lighting & Bloom Post Process Render Shader and Surface Target
shader_set(shd_post_process_render);
surface_set_target_ext(0, post_processing_surface);
surface_set_target_ext(1, bloom_first_pass_surface);

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
texture_set_stage(post_process_lighting_render_shader_depth_specular_bloom_map_index, surface_get_texture(depth_specular_bloom_surface));

// Set Bloom Render Color and Intensity
shader_set_uniform_f(post_process_lighting_render_shader_bloom_color_index, color_get_red(render_bloom_color) / 255, color_get_green(render_bloom_color) / 255, color_get_blue(render_bloom_color) / 255, render_bloom_intensity);

// Render Lit Surface with Background to Post Processing Surface
draw_surface(diffuse_mid_color_surface, 0, 0);

// Reset Surface & Shader
surface_reset_target();
shader_reset();

// 
shader_set(shd_bloom_boxblur);
surface_set_target(bloom_second_pass_surface);

//
shader_set_uniform_f(bloom_box_blur_shader_texel_size_index, 1 / (GameManager.game_width + (render_border * 2)), 1 / (GameManager.game_height + (render_border * 2)));

//
draw_surface(bloom_first_pass_surface, 0, 0);

// Reset Surface & Shader
surface_reset_target();
shader_reset();

//
surface_set_target(post_processing_surface);

// Overlay Original Bloom Map over Bloom Third Pass Surface
gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);

//
draw_surface(bloom_second_pass_surface, -1, -1);
draw_surface(bloom_second_pass_surface, 1, -1);
draw_surface(bloom_second_pass_surface, -1, 1);
draw_surface(bloom_second_pass_surface, 1, 1);
draw_surface(bloom_second_pass_surface, -1, 0);
draw_surface(bloom_second_pass_surface, 1, 0);
draw_surface(bloom_second_pass_surface, 0, -1);
draw_surface(bloom_second_pass_surface, 0, 1);
draw_surface(bloom_second_pass_surface, 0, 0);

// Reset Surface & Shader
surface_reset_target();

/*
// Enable Surface Horizontal Blur Shader for Bloom Blur First Pass
shader_set(shd_surface_blur_horizontal);
surface_set_target(bloom_second_pass_surface);

// Set Horizontal Blur Properties
shader_set_uniform_f(surface_horizontal_blur_shader_blur_width_index, 3);
shader_set_uniform_f(surface_horizontal_blur_shader_texel_width_index, 1 / (GameManager.game_width + (render_border * 2)));

// Create Bloom First Pass Horizontal Blur
draw_surface(bloom_first_pass_surface, 0, 0);

// Reset Surface & Shader
surface_reset_target();
shader_reset();

// Enable Surface Vertical Blur Shader for Bloom Blur Second Pass
shader_set(shd_surface_blur_vertical);
surface_set_target(bloom_third_pass_surface);

// Set Vertical Blur Properties
shader_set_uniform_f(surface_vertical_blur_shader_blur_height_index, render_bloom_blur_size);
shader_set_uniform_f(surface_vertical_blur_shader_texel_height_index, 1 / (GameManager.game_height + (render_border * 2)));

// Create Bloom Second Pass Vertical Blur
draw_surface(bloom_second_pass_surface, 0, 0);

// Reset Shader
shader_reset();

// Overlay Original Bloom Map over Bloom Third Pass Surface
gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
draw_set_alpha(0.3);
draw_surface(bloom_first_pass_surface, 0, 0);

// Reset Surface & Shader
surface_reset_target();

// Enable Alpha Layering Blendmode for drawing Bloom Surface over Post Process Surface
gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

// Set Post Processing Surface Target for Bloom Layering
surface_set_target(post_processing_surface);

// Create Bloom First Pass Horizontal Blur
draw_set_alpha(0.3);

draw_surface(bloom_third_pass_surface, -1, -1);
draw_surface(bloom_third_pass_surface, 1, -1);
draw_surface(bloom_third_pass_surface, -1, 1);
draw_surface(bloom_third_pass_surface, 1, 1);
draw_surface(bloom_third_pass_surface, -1, 0);
draw_surface(bloom_third_pass_surface, 1, 0);
draw_surface(bloom_third_pass_surface, 0, -1);
draw_surface(bloom_third_pass_surface, 0, 1);
draw_surface(bloom_third_pass_surface, 0, 0);

// Reset Surface & Shader
surface_reset_target();

*/

// Reset Blendmode
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
