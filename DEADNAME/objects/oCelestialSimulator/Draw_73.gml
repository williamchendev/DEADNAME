/// @description Final Render Event
// Renders the Final Celestial Simulation Surface to the Screen

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Layer Background & Object Render Depth, Specular, Bloom in combined Map stored on the Temp Surface
gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

// Enable Bloom Effect Shader and Surface Target
surface_set_target(bloom_premult_surface);

// Reset Solar System's Background Stars Render Surface
draw_clear_alpha(c_black, 0);

// Set Bloom Effect Shader
shader_set(shd_celestial_bloom_effect_render);

// Set Bloom Textures
texture_set_stage(bloom_effect_render_shader_diffusemap_index, surface_get_texture(diffuse_surface));
texture_set_stage(bloom_effect_render_shader_emissivemap_index, surface_get_texture(emissive_surface));

// Set Bloom Effect Surface Texel Size & Alpha Multiplier
shader_set_uniform_f(bloom_effect_render_shader_surface_texel_size_index, 1 / GameManager.game_width, 1 / GameManager.game_height);
shader_set_uniform_f(bloom_effect_render_shader_alpha_multiplier_index, 1 / bloom_global_size);

// Set Bloom Render Color and Intensity
draw_set_color(bloom_global_color);
draw_set_alpha(bloom_global_intensity);

// Use Post Process Surface for Bloom Effect
draw_surface(post_processing_surface, 0, 0);

// Reset Surface & Shader
surface_reset_target();
shader_reset();

// Render Bloom Surface over Celestial Simulator's Final Render Surface
surface_set_target(final_render_surface);

// Reset Celestial Simulator's Final Render Surface
draw_clear_alpha(c_black, 1);

// Render Bloom Surface over Post Processing's Deferred Lighting Surface
draw_surface(post_processing_surface, 0, 0);

// Set Premultiply Blendmode - Correctly Layers Premultiplied Transparent Bloom Surface over other Surfaces
gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);

// Reset Color & Alpha
draw_set_alpha(1);
draw_set_color(c_white);

// Draw Bloom Effect Surface - pixel offset in each direction
for (var i = bloom_global_size; i > 0; i--)
{
	draw_surface(bloom_premult_surface, -i, -i);
	draw_surface(bloom_premult_surface, i, -i);
	draw_surface(bloom_premult_surface, -i, i);
	draw_surface(bloom_premult_surface, i, i);
	draw_surface(bloom_premult_surface, -i, 0);
	draw_surface(bloom_premult_surface, i, 0);
	draw_surface(bloom_premult_surface, 0, -i);
	draw_surface(bloom_premult_surface, 0, i);
}

draw_surface(bloom_premult_surface, 0, 0);

// Reset Surface Target
surface_reset_target();

// Set Default Blendmode
gpu_set_blendmode(bm_normal);

// DEBUG Draw Final Render Surface to UI Surface (this is incorrect but I'll do it for now)
surface_set_target(LightingEngine.ui_surface);
//surface_set_target(LightingEngine.final_render_surface);
draw_clear_alpha(c_black, 0);
draw_surface(final_render_surface, 0, 0);
//draw_surface(celestial_body_atmosphere_depth_mask_surface, 0, 0);

surface_reset_target();

// DEBUG DEBUG DEBUG NOISE TEST HERE
/*
surface_set_target(LightingEngine.ui_surface);
draw_clear_alpha(c_black, 0);
shader_set(shd_sdf_sphere_volumetric_cloud_lit);

shader_set_uniform_f(sdf_sphere_volumetric_clouds_lit_shader_time_index, current_time);

draw_sprite_ext(sSystem_PerlinNoise, 0, 0, 0, 1, 1, 0, c_white, 1);

shader_reset();
surface_reset_target();
*/