/// @description Game End Cleanup Event
// Cleanup Event for Celestial Simulator

// Destroy Solar System Render Order DS List
ds_list_destroy(solar_system_render_depth_values_list);
solar_system_render_depth_values_list = -1;

ds_list_destroy(solar_system_render_depth_instances_list);
solar_system_render_depth_instances_list = -1;

// Clean Up Celestial Simulation Surfaces
surface_free(background_surface);
background_surface = -1;

surface_free(background_bloom_premult_surface);
background_bloom_premult_surface = -1;

surface_free(background_stars_surface);
background_stars_surface = -1;

surface_free(background_stars_emissive_surface);
background_stars_emissive_surface = -1;

surface_free(celestial_body_render_surface);
celestial_body_render_surface = -1;

surface_free(celestial_body_atmosphere_depth_mask_surface);
celestial_body_atmosphere_depth_mask_surface = -1;

surface_free(clouds_render_surface);
clouds_render_surface = -1;

surface_free(final_render_surface);
final_render_surface = -1;

// Delete Vertex Formats
vertex_format_delete(icosphere_render_vertex_format);
icosphere_render_vertex_format = -1;

vertex_format_delete(background_stars_render_vertex_format);
background_stars_render_vertex_format = -1;

vertex_format_delete(square_uv_vertex_format);
square_uv_vertex_format = -1;

// Delete Vertex Buffers
var temp_solar_systems_background_stars_vertex_buffer_index = array_length(solar_systems_background_stars_vertex_buffer) - 1;

repeat (array_length(solar_systems_background_stars_vertex_buffer))
{
	// Delete Background Stars Vertex Buffer from Background Stars Vertex Buffer Array
	vertex_delete_buffer(solar_systems_background_stars_vertex_buffer[temp_solar_systems_background_stars_vertex_buffer_index]);
	solar_systems_background_stars_vertex_buffer[temp_solar_systems_background_stars_vertex_buffer_index] = -1;
	
	// Decrement Background Stars Vertex Buffer Array Index
	temp_solar_systems_background_stars_vertex_buffer_index--;
}

vertex_delete_buffer(square_uv_vertex_buffer);
square_uv_vertex_buffer = -1;