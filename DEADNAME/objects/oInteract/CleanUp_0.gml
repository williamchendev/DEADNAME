/// @description Insert description here
// You can write your code in this editor

// Clean Up Surfaces
if (surface_exists(temp_surface)) {
	surface_free(temp_surface);
	temp_surface = -1;
}
if (surface_exists(interact_surface)) {
	surface_free(interact_surface);
	interact_surface = -1;
}