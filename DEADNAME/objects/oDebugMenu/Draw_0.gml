/// @description Insert description here
// You can write your code in this editor

// Check if Debug Mode is Enabled
if (!global.debug or !global.debug_surface_enabled)
{
    // Debug Mode is not Enabled, Hide Menu
    return;
}

// Check if Debug Surface Exists
if (!surface_exists(LightingEngine.debug_surface))
{
	return;
}

// Set Debug Surface as Surface Target
surface_set_target(LightingEngine.debug_surface);

// Debug Menu - Debug Rendering Printout
if (rendering_background_light_map_enabled)
{
    // Background Light Map
    draw_surface_ext(LightingEngine.pbr_lighting_back_color_surface, -LightingEngine.render_border, -LightingEngine.render_border, 1,1, 0, c_white, 1);
}
else if (rendering_midground_light_map_enabled)
{
    // Midground Light Map
    draw_surface_ext(LightingEngine.pbr_lighting_mid_color_surface, -LightingEngine.render_border, -LightingEngine.render_border, 1,1, 0, c_white, 1);
}
else if (rendering_foreground_light_map_enabled)
{
    // Foreground Light Map
    draw_surface_ext(LightingEngine.pbr_lighting_front_color_surface, -LightingEngine.render_border, -LightingEngine.render_border, 1,1, 0, c_white, 1);
}
else if (rendering_normal_map_enabled)
{
    // Normal Map
    draw_surface_ext(LightingEngine.normalmap_vector_surface, -LightingEngine.render_border, -LightingEngine.render_border, 1,1, 0, c_white, 1);
}
else if (rendering_depth_map_enabled)
{
    // Depth Map
    shader_set(shd_print_depth_map);
    
    draw_surface_ext(LightingEngine.background_prb_metalrough_emissive_depth_surface, -LightingEngine.render_border, -LightingEngine.render_border, 1,1, 0, c_white, 1);
    draw_surface_ext(LightingEngine.layered_prb_metalrough_emissive_depth_surface, -LightingEngine.render_border, -LightingEngine.render_border, 1, 1, 0, c_white, 1);
    
    shader_reset();
}

// Reset Surface Target
surface_reset_target();