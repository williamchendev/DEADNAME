/// @description Lighting Clean Up Event
// Destroys unused variables and cleans up memory

// Destroy oBasic Depth List
ds_list_destroy(basic_object_depth_list);
basic_object_depth_list = -1;

// Free Surfaces
if (surface_exists(surface_color)) {
	surface_free(surface_color);
	surface_color = -1;
}
if (surface_exists(surface_normals)) {
	surface_free(surface_normals);
	surface_normals = -1;
}
if (surface_exists(surface_temp)) {
	surface_free(surface_temp);
	surface_temp = -1;
}
if (surface_exists(surface_vectors)) {
	surface_free(surface_vectors);
	surface_vectors = -1;
}
if (surface_exists(surface_blend)) {
	surface_free(surface_blend);
	surface_blend = -1;
}
if (surface_exists(surface_shadows)) {
	surface_free(surface_shadows);
	surface_shadows = -1;
}
if (surface_exists(surface_light)) {
	surface_free(surface_light);
	surface_light = -1;
}