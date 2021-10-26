/// @description Blood Clean Up Event
// Removes any unused assets and data from memory that the blood effect was using

// Free Surfaces
if (surface_exists(blood_surface)) {
	surface_free(blood_surface);
	blood_surface = -1;
}
if (surface_exists(occlusion_surface)) {
	surface_free(occlusion_surface);
	occlusion_surface = -1;
}
if (surface_exists(occlusion_remove_surface)) {
	surface_free(occlusion_remove_surface);
	occlusion_remove_surface = -1;
}