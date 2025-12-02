/// @description Game End Cleanup Event
// Cleanup Event for Celestial Simulator

// Destroy Solar System Render Order DS List
ds_list_destroy(solar_system_render_depth_values_list);
solar_system_render_depth_values_list = -1;

ds_list_destroy(solar_system_render_depth_instances_list);
solar_system_render_depth_instances_list = -1;

// Clean Up Celestial Simulation Surfaces
surface_free(planets_depth_surface);
planets_depth_surface = -1;

// Delete Vertex Buffers
vertex_format_delete(icosphere_render_vertex_format);
icosphere_render_vertex_format = -1;
