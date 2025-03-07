/// @description Room End Cleanup Event
// Cleanup Lighting Engine Layer and Object Lists & Set up for Next Room

// Clean Up all Sub Layers and Lighting Objects from Lighting Object "Painter's Sorted List" DS Lists
lighting_engine_delete_all_sub_layers();

// Clear Directional Shadows Variables and List
directional_light_collisions_exist = false;
ds_list_clear(directional_light_collisions_list);

// Clear Backgrounds Lists
ds_list_clear(lighting_engine_backgrounds);
ds_list_clear(lighting_engine_background_layer_ids);

// Clear Culling Regions Map
ds_map_clear(lighting_engine_culling_regions_map);

// Flush Texture Data
draw_texture_flush();

// Reset Lighting Engine Render Settings
lighting_engine_back_render_layer_shadows_enabled = true;
lighting_engine_mid_render_layer_shadows_enabled = true;
lighting_engine_front_render_layer_shadows_enabled = true;

lighting_engine_camera_bounds_exist = false;

// Reset Lighting Engine Bloom Settings
bloom_global_color = c_white;
bloom_global_intensity = 1.0;

// Add Default Layers to Lighting Engine
create_default_sub_layers();

// Initialize Lighting Engine Worker
lighting_engine_worker = instance_create_depth(x, y, depth, oLightingEngine_Worker);