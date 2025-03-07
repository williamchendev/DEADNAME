/// @description Init Variables
// Create Lighting Engine Region Variables

// Disable Visibility
visible = false;

// Create DS Maps for Bulk Static Layers
bulk_static_region_texture_map = ds_map_create();
bulk_static_region_vertex_buffer_map = ds_map_create();

// Create Region Variables
region_render_enabled = false;

// Index Bulk Static Region in Lighting Engine Worker
if (single_sub_layer)
{
	ds_list_insert(LightingEngine.lighting_engine_worker.bulk_static_regions_list, 0, id);
}
else
{
	ds_list_add(LightingEngine.lighting_engine_worker.bulk_static_regions_list, id);
}

// Index Region Culling ID in Lighting Engine's Region Culling DS Map
if (region_culling_id != LightingEngineEmptyRegionCullingID)
{
	ds_map_add(LightingEngine.lighting_engine_culling_regions_map, region_culling_id, id);
}
