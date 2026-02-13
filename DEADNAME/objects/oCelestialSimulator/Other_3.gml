/// @description Game End Cleanup Event
// Cleanup Event for Celestial Simulator

// Clean Up Celestial Simulation Surfaces
surface_free(background_surface);
background_surface = -1;

surface_free(celestial_body_render_surface);
celestial_body_render_surface = -1;

surface_free(celestial_body_diffuse_surface);
celestial_body_diffuse_surface = -1;

surface_free(celestial_body_emissive_surface);
celestial_body_emissive_surface = -1;

surface_free(celestial_body_atmosphere_depth_mask_surface);
celestial_body_atmosphere_depth_mask_surface = -1;

surface_free(clouds_render_surface);
clouds_render_surface = -1;

surface_free(post_processing_surface);
post_processing_surface = -1;

surface_free(diffuse_surface);
diffuse_surface = -1;

surface_free(emissive_surface);
emissive_surface = -1;

surface_free(bloom_premult_surface);
bloom_premult_surface = -1;

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