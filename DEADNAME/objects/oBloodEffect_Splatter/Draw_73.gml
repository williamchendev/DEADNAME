/// @description Blood Draw Event
// Draws the Blood to the surface

// Skip if Knockout
if (instance_exists(oKnockout)) {
	return;
}

// Draw Splatter
draw_self();