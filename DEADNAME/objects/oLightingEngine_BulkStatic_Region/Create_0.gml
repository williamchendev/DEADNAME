/// @description Init Variables
// Create Bulk Static Region Variables

// Create DS Maps for Bulk Static Layers
bulk_static_region_texture_map = ds_map_create();
bulk_static_region_vertex_buffer_map = ds_map_create();

// Create Bulk Static Region Variables
bulk_static_region_render_enabled = false;

// Index Bulk Static Region in Lighting Engine Worker
ds_list_add(LightingEngine.lighting_engine_worker.bulk_static_regions_list, id);