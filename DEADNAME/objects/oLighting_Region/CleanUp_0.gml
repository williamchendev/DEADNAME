/// @description Clean Up Event
// Delete all Vertex Buffers

// Delete Vertex Buffers
for (var temp_map_key = ds_map_find_first(bulk_static_region_vertex_buffer_map); !is_undefined(temp_map_key); temp_map_key = ds_map_find_next(bulk_static_region_vertex_buffer_map, temp_map_key)) 
{
	// Find Vertex Buffer from DS Map
	var temp_vertex_buffer_value = ds_map_find_value(bulk_static_region_vertex_buffer_map, temp_map_key);
	
	if (!is_undefined(temp_vertex_buffer_value))
	{
		// Delete Vertex Buffer
		vertex_delete_buffer(temp_vertex_buffer_value);
		temp_vertex_buffer_value = -1;
	}
}

// Delete Bulk Static DS Maps
ds_map_destroy(bulk_static_region_texture_map);
bulk_static_region_texture_map = -1;

ds_map_destroy(bulk_static_region_vertex_buffer_map);
bulk_static_region_vertex_buffer_map = -1;
