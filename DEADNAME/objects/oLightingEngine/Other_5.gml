/// @description Room End Cleanup Event
// Cleanup Lighting Engine Layer and Object Lists & Set up for Next Room

// Clean Up all Sub Layers and Lighting Objects from Lighting Object "Painter's Sorted List" DS Lists
clear_all_sub_layers();

// Clear Directional Shadows Variables and List
directional_light_collisions_exist = false;
ds_list_clear(directional_light_collisions_list);

// Reset Lighting Engine Render Settings
lighting_engine_back_render_layer_shadows_enabled = true;
lighting_engine_mid_render_layer_shadows_enabled = true;
lighting_engine_front_render_layer_shadows_enabled = true;

// Add Default Layers to Lighting Engine
create_default_sub_layers();