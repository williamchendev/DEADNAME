/// @description Surface Manager Destroy
// Surface Manager Destroy Event Behaviour

// Data Structures Garbage Collection
ds_map_destroy(units_outline);
ds_map_destroy(interacts_outline);

units_outline = -1;
interacts_outline = -1;

// Clear Surfaces
if (surface_exists(unit_outline_surface)) {
	surface_free(unit_outline_surface);
	unit_outline_surface = -1;
}
if (surface_exists(unit_outline_overlay_surface)) {
	surface_free(unit_outline_overlay_surface);
	unit_outline_overlay_surface = -1;
}
if (surface_exists(interact_outline_surface)) {
	surface_free(interact_outline_surface);
	interact_outline_surface = -1;
}