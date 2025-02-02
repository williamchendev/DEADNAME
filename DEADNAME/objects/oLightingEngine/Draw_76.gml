/// @description Surfaces Initialization
// Creates the Surfaces for the Lighting Engine

// Pre-Draw Check and Create Lighting Engine Utilized Surfaces Event
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

if (!surface_exists(lights_shadow_surface))
{
    lights_shadow_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
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

if (!surface_exists(normalmap_vector_surface))
{
    normalmap_vector_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(depth_specular_stencil_surface))
{
    depth_specular_stencil_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
}

if (!surface_exists(distortion_surface))
{
    distortion_surface = surface_create(GameManager.game_width + (render_border * 2), GameManager.game_height + (render_border * 2), surface_rgba8unorm);
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

// Reset Depth Specular Stencil Surface
surface_set_target(depth_specular_stencil_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

// Reset Distortion Surface
surface_set_target(distortion_surface);
draw_clear_alpha(global.lighting_engine_normalmap_default_color, 1);
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

// Background Update Behaviour
for (var temp_background_index = 0; temp_background_index < ds_list_size(lighting_engine_backgrounds); temp_background_index++)
{
	// Find Background Struct
	var temp_background_struct = ds_list_find_value(lighting_engine_backgrounds, temp_background_index);
	
	// Background Offset, Movement, and Parallax
	temp_background_struct.movement_x = (temp_background_struct.movement_x + temp_background_struct.movement_speed_x * frame_delta) mod temp_background_struct.background_width;
	temp_background_struct.movement_y = (temp_background_struct.movement_y + temp_background_struct.movement_speed_y * frame_delta) mod temp_background_struct.background_height;
	
	var temp_background_parallax_x = temp_background_struct.offset_x - (render_x * temp_background_struct.parallax_horizontal_movement);
	var temp_background_parallax_y = temp_background_struct.offset_y - (render_y * temp_background_struct.parallax_vertical_movement);
	
	layer_x
	(
		temp_background_struct.layer_id, 
		temp_background_struct.parallax_horizontal_lock ? clamp(temp_background_struct.movement_x + temp_background_parallax_x, GameManager.game_width + render_border - temp_background_struct.background_width, render_border) : temp_background_struct.movement_x + temp_background_parallax_x
	);
	
	layer_y
	(
		temp_background_struct.layer_id, 
		temp_background_struct.parallax_vertical_lock ? clamp(temp_background_struct.movement_y + temp_background_parallax_y, GameManager.game_height + render_border - temp_background_struct.background_height, render_border) : temp_background_struct.movement_y + temp_background_parallax_y
	);
}