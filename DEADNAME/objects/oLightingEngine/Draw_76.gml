/// @description Surfaces Initialization
// Creates the Surfaces for the Lighting Engine

// Pre-Draw Check and Create Lighting Engine Utilized Surfaces Event
if (!surface_exists(temp_surface))
{
    temp_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(background_surface))
{
    background_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(diffuse_back_color_surface))
{
    diffuse_back_color_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(diffuse_mid_color_surface))
{
    diffuse_mid_color_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(diffuse_front_color_surface))
{
    diffuse_front_color_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(lights_back_color_surface))
{
    lights_back_color_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(lights_mid_color_surface))
{
    lights_mid_color_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(lights_front_color_surface))
{
    lights_front_color_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(normalmap_vector_surface))
{
    normalmap_vector_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(depth_specular_bloom_surface))
{
    depth_specular_bloom_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(background_depth_specular_bloom_surface))
{
	background_depth_specular_bloom_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(bloom_effect_surface))
{
    bloom_effect_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(distortion_effect_surface))
{
    distortion_effect_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(post_processing_surface))
{
    post_processing_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(final_render_surface))
{
    final_render_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(ui_surface))
{
    ui_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

// Reset Light Color Surface
surface_set_target(lights_back_color_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

surface_set_target(lights_mid_color_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

surface_set_target(lights_front_color_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

// Reset Diffuse Color Surface
surface_set_target(diffuse_back_color_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

surface_set_target(diffuse_mid_color_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

surface_set_target(diffuse_front_color_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

// Reset Normal Map Vector Surface
surface_set_target(normalmap_vector_surface);
draw_clear_alpha(global.lighting_engine_normalmap_default_color, 1);
surface_reset_target();

// Reset Depth Specular Bloom Surface
surface_set_target(depth_specular_bloom_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

surface_set_target(background_depth_specular_bloom_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

// Reset Distortion Effect Surface
surface_set_target(distortion_effect_surface);
draw_clear_alpha(global.lighting_engine_normalmap_default_color, 1);
surface_reset_target();

// Reset Post Process Surface
surface_set_target(post_processing_surface);
draw_clear(c_black);
surface_reset_target();

// Refresh UI Surface Clear
surface_set_target(ui_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

// Debug-Enabled Surfaces Behaviour
if (global.debug_surface_enabled)
{
	// Check and Create Debug Surface
	if (!surface_exists(debug_surface))
	{
		debug_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
	}
	
	// Refresh Debug Surface Clear
	surface_set_target(debug_surface);
	draw_clear_alpha(c_black, 0);
	surface_reset_target();
}
