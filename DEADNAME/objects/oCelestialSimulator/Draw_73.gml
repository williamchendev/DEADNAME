//

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

//
surface_set_target(LightingEngine.ui_surface);
draw_surface(planets_depth_surface, 0, 0);
surface_reset_target();