/// @description Squad CleanUp Event
// Clears unused data upon object uninstantiation

// Clear DS Lists
ds_list_destroy(squad_units_list);
squad_units_list = -1;

// Free Surfaces
if (surface_exists(temp_surface)) {
	surface_free(temp_surface);
	temp_surface = -1;
}
if (surface_exists(squad_surface)) {
	surface_free(squad_surface);
	squad_surface = -1;
}