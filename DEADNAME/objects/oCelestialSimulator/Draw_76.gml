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

if (!surface_exists(celestial_body_diffuse_surface))
{
    celestial_body_diffuse_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(celestial_body_emissive_surface))
{
    celestial_body_emissive_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_r8unorm);
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

if (!surface_exists(post_processing_surface))
{
    post_processing_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(diffuse_surface))
{
    diffuse_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(emissive_surface))
{
    emissive_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_r8unorm);
}

if (!surface_exists(bloom_premult_surface))
{
    bloom_premult_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(final_render_surface))
{
    final_render_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

// Reset Celestial Simulator's Post Processing Rendering Surface
surface_set_target(post_processing_surface);
draw_clear_alpha(c_black, 1);
surface_reset_target();

// Reset Background Surface
surface_set_target(background_surface);
draw_clear_alpha(c_black, 1);
surface_reset_target();

// Reset Diffuse Surface
surface_set_target(diffuse_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

// Reset Emissive Surface
surface_set_target(emissive_surface);
draw_clear(c_black);
surface_reset_target();

// Reset Draw Color & Transparency
draw_set_alpha(1);
draw_set_color(c_white);

// Check if Solar System exists and is being viewed
if (solar_system_index != -1 and solar_systems_background_stars_vertex_buffer[solar_system_index] != -1)
{
	// MRT Render Solar System's Background Stars to Post Processing, Diffuse, and Emissive Surfaces
	surface_set_target_ext(0, post_processing_surface);
	surface_set_target_ext(1, diffuse_surface);
	surface_set_target_ext(2, emissive_surface);
	
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
}
