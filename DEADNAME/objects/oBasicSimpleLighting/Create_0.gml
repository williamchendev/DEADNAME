/// @description Basic Simple Lit Entity Init
// Creates the variables and settings necessary for the Basic Simple Lit Entity's Behaviour

// Shader Settings
shader_forcecolor = shader_get_uniform(shd_color_ceilalpha, "forcedColor");

// Basic Object Variables
basic_old_depth = depth;
basic_reindex_depth = true;