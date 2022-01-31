/// @description Material Destroy Surfaces
// Frees Surfaces used by the Material

// Surface Cleanup
surface_free(material_dmg_surface);
surface_free(material_surface);
material_dmg_surface = -1;
material_surface = -1;