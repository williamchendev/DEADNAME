/// @description Surfaces Initialization
// Creates the Surfaces for the Celestial Simulator

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Set Default Blendmode
gpu_set_blendmode(bm_normal);

// Enable Depth for Celestial Simulation Pipeline Surfaces
surface_depth_disable(false);

// Pre-Draw Check and Create Celestial Simulator Utilized Depth Enabled Surfaces Event
if (!surface_exists(celestial_body_render_surface))
{
    celestial_body_render_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(celestial_body_atmosphere_depth_mask_surface))
{
    celestial_body_atmosphere_depth_mask_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_r16float);
}

if (!surface_exists(clouds_render_surface))
{
    clouds_render_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

// Disable Depth for Celestial Simulation Pipeline Surfaces
surface_depth_disable(true);

// Pre-Draw Check and Create Celestial Simulator Utilized Surfaces Event
if (!surface_exists(background_surface))
{
    background_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(background_bloom_premult_surface))
{
    background_bloom_premult_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(background_stars_surface))
{
    background_stars_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(background_stars_emissive_surface))
{
    background_stars_emissive_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(final_render_surface))
{
    final_render_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

//
surface_set_target(background_surface);
draw_clear_alpha(c_black, 1);
surface_reset_target();

// Check if Solar System exists and is being viewed
if (solar_system_index == -1 or solar_systems_background_stars_vertex_buffer[solar_system_index] == -1)
{
	// Reset Celestial Simulator's Final Rendering Surface
	surface_set_target(final_render_surface);
	draw_clear_alpha(c_black, 1);
	surface_reset_target();
}
else
{
	// Render Solar System's Background Stars to Background Stars Surface
	surface_set_target_ext(0, background_stars_surface);
	surface_set_target_ext(1, background_stars_emissive_surface);
	
	// Reset Solar System's Background Stars Render Surface
	draw_clear_alpha(c_black, 0);
	
	//
	draw_set_alpha(1);
	draw_set_color(c_white);
	
	// Enable Background Stars Unlit Shader
	shader_set(shd_background_stars_unlit);
	
	// Set Background Stars Unlit Shader Camera Properties
	shader_set_uniform_f(CelestialSimulator.background_stars_unlit_shader_camera_position_index, CelestialSimulator.camera_position_x, CelestialSimulator.camera_position_y, CelestialSimulator.camera_position_z);
	shader_set_uniform_matrix_array(CelestialSimulator.background_stars_unlit_shader_camera_rotation_index, CelestialSimulator.camera_rotation_matrix);
	shader_set_uniform_f(CelestialSimulator.background_stars_unlit_shader_camera_dimensions_index, GameManager.game_width, GameManager.game_height);
	
	// Draw Background Stars from Solar System's Combined Background Star Icospheres Vertex Buffer
	vertex_submit(solar_systems_background_stars_vertex_buffer[solar_system_index], pr_trianglelist, -1);
	
	// Reset Shader
	shader_reset();
	
	// Reset Surface Target
	surface_reset_target();
	
	//
	surface_set_target(background_bloom_premult_surface);
	
	// Reset Solar System's Background Stars Render Surface
	draw_clear_alpha(c_black, 0);
	
	// Set Bloom Effect Shader
	shader_set(shd_bloom_effect_render);
	
	// Set Bloom Textures
	texture_set_stage(LightingEngine.bloom_effect_render_shader_diffusemap_index, surface_get_texture(background_stars_surface));
	texture_set_stage(LightingEngine.bloom_effect_render_shader_emissivemap_index, surface_get_texture(background_stars_emissive_surface));
	
	// Set Bloom Effect Surface Texel Size & Alpha Multiplier
	shader_set_uniform_f(LightingEngine.bloom_effect_render_shader_surface_texel_size_index, 1 / GameManager.game_width, 1 / GameManager.game_height);
	shader_set_uniform_f(LightingEngine.bloom_effect_render_shader_alpha_multiplier_index, 1 / LightingEngine.bloom_global_size);
	
	// Set Bloom Render Color and Intensity
	draw_set_color(LightingEngine.bloom_global_color);
	draw_set_alpha(LightingEngine.bloom_global_intensity);
	
	// Use Post Process Surface for Bloom Effect
	draw_surface(background_surface, 0, 0);
	
	// Reset Surface & Shader
	surface_reset_target();
	shader_reset();
	
	// Render Bloom Surface over Celestial Simulator's Final Render Surface
	surface_set_target(final_render_surface);
	
	// Reset Celestial Simulator's Final Render Surface
	draw_clear_alpha(c_black, 1);
	
	draw_surface(background_stars_surface, 0, 0);
	
	// Set Premultiply Blendmode - Correctly Layers Premultiplied Transparent Bloom Surface over other Surfaces
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	
	// Reset Color & Alpha
	draw_set_alpha(1);
	draw_set_color(c_white);
	
	// Draw Bloom Effect Surface - pixel offset in each direction
	for (var i = LightingEngine.bloom_global_size; i > 0; i--)
	{
		draw_surface(background_bloom_premult_surface, -i, -i);
		draw_surface(background_bloom_premult_surface, i, -i);
		draw_surface(background_bloom_premult_surface, -i, i);
		draw_surface(background_bloom_premult_surface, i, i);
		draw_surface(background_bloom_premult_surface, -i, 0);
		draw_surface(background_bloom_premult_surface, i, 0);
		draw_surface(background_bloom_premult_surface, 0, -i);
		draw_surface(background_bloom_premult_surface, 0, i);
	}
	
	draw_surface(background_bloom_premult_surface, 0, 0);
	
	// Reset Surface Target
	surface_reset_target();
}
