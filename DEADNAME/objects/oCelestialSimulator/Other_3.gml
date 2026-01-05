/// @description Game End Cleanup Event
// Cleanup Event for Celestial Simulator

// Destroy Solar System Render Order DS List
ds_list_destroy(solar_system_render_depth_values_list);
solar_system_render_depth_values_list = -1;

ds_list_destroy(solar_system_render_depth_instances_list);
solar_system_render_depth_instances_list = -1;

// Clean Up Celestial Simulation Surfaces
surface_free(celestial_body_render_surface);
celestial_body_render_surface = -1;

surface_free(celestial_body_atmosphere_depth_mask_surface);
celestial_body_atmosphere_depth_mask_surface = -1;

surface_free(clouds_render_surface);
clouds_render_surface = -1;

surface_free(clouds_alpha_mask_surface);
clouds_alpha_mask_surface = -1;

surface_free(clouds_atmosphere_depth_mask_surface);
clouds_atmosphere_depth_mask_surface = -1;

surface_free(final_render_surface);
final_render_surface = -1;

// Delete Vertex Formats
vertex_format_delete(icosphere_render_vertex_format);
icosphere_render_vertex_format = -1;

vertex_format_delete(atmosphere_vertex_format);
atmosphere_vertex_format = -1;

// Delete Vertex Buffers
vertex_delete_buffer(atmosphere_vertex_buffer);
atmosphere_vertex_buffer = -1;