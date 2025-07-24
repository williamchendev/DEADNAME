/// @description Render UI Layer Event
// Draws the Lighting Engine's UI Layer during the Default Draw Event

// Set Default Blendmode
gpu_set_blendmode(bm_normal);

// (UI Layer) Iterate through all Objects assigned to the Lighting Engine's UI Layer to be draw sequentially (from back to front) in a Painter's Sorted List
lighting_engine_render_ui_layer();
