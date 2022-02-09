/// @description Clean Up Surfaces
// Frees surface memory in use

// Clean Up Surfaces
if (surface_exists(temp_surface)) {
	surface_free(temp_surface);
	temp_surface = -1;
}
if (surface_exists(interact_surface)) {
	surface_free(interact_surface);
	interact_surface = -1;
}