/// @description Final Render Event
// Renders the Final Celestial Simulation Surface to the Screen

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

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