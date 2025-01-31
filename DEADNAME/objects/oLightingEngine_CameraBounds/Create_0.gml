/// @description Lighting Engine Toggle Settings Behaviour
// Toggles Settings in the Lighting Engine before destroying itself

// Toggle and Set Lighting Engine's Camera Bound Settings
LightingEngine.lighting_engine_camera_bounds_exist = true;
LightingEngine.lighting_engine_camera_bounds_min_x = bbox_left;
LightingEngine.lighting_engine_camera_bounds_min_y = bbox_top;
LightingEngine.lighting_engine_camera_bounds_max_x = bbox_right;
LightingEngine.lighting_engine_camera_bounds_max_y = bbox_bottom;

// Destroy Instance
instance_destroy();
