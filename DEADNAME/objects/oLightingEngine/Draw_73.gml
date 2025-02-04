/// @description Process Scene Lighting
// Processes Diffuse and Lighting Surfaces into the Final Render Surface along with Post Processing Effects

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