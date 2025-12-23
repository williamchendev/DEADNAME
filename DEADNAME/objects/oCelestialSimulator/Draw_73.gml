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
draw_surface(final_render_surface, 0, 0);
//draw_surface(celestial_body_atmosphere_depth_mask_surface, 0, 0);
surface_reset_target();