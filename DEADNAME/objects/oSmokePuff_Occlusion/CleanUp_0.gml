/// @description Insert description here
// You can write your code in this editor

// Destroy Unit Collision DS List
ds_list_destroy(unit_collision_list);
unit_collision_list = -1;

// Destroy Unused Surfaces
if (surface_exists(smoke_surface)) {
	surface_free(smoke_surface);
	smoke_surface = -1;
}
if (surface_exists(occlusion_surface)) {
	surface_free(occlusion_surface);
	occlusion_surface = -1;
}
if (surface_exists(occlusion_remove_surface)) {
	surface_free(occlusion_remove_surface);
	occlusion_remove_surface = -1;
}
if (surface_exists(smoke_final_surface)) {
	surface_free(smoke_final_surface);
	smoke_final_surface = -1;
}