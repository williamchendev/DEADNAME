/// @description Draw Sphere Render

// Basic Normal/Lit Sprite Split
if (lit_draw_event) {
	image_index = 1;
}
else if (normal_draw_event) {
	image_index = 0;
}
else {
	image_index = 0;
	if (instance_exists(oLighting)) {
		return;
	}
}

draw_self();