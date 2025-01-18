/// @description Lighting Engine Toggle Settings Behaviour
// Toggles Settings in the Lighting Engine before destroying itself

// Toggle Layer Shadow Enable & Disable Settings
LightingEngine.lighting_engine_back_render_layer_shadows_enabled = shadows_enabled_background_layer;
LightingEngine.lighting_engine_mid_render_layer_shadows_enabled = shadows_enabled_midground_layer;
LightingEngine.lighting_engine_front_render_layer_shadows_enabled = shadows_enabled_foreground_layer;

// Destroy Instance
instance_destroy();