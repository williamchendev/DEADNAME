/// @description Simple Lit Ragdoll Entity Init
// Creates the variables and settings necessary for the Simple Lit Ragdoll Entity's Behaviour

// Shader Settings
shader_forcecolor = shader_get_uniform(shd_color_ceilalpha, "forcedColor");

// Basic Object Variables
basic_old_depth = depth;
basic_reindex_depth = true;

// Deltatime Physics Variables
old_delta_time = global.deltatime;

phy_speed_old_x = 0;
phy_speed_old_y = 0;

phy_speed_x_bank = 0;
phy_speed_y_bank = 0;