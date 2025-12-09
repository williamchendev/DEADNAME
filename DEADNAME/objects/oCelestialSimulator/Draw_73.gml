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

//
surface_set_target(LightingEngine.ui_surface);
draw_surface(final_render_surface, 0, 0);
surface_reset_target();