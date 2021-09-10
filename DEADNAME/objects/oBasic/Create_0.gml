/// @description Basic Light Object Init
// Creates the variables necessary for the Basic Lighting Object

// Basic-Lighting-Object Settings
lit_sprite_index = sWolf_Jump;
normal_sprite_index = sWolf_Jump_NormalMap;

// Shader Variables
vectorcolorscale_shader_r = shader_get_uniform(shd_vectorcolorscale, "rScale");
vectorcolorscale_shader_g = shader_get_uniform(shd_vectorcolorscale, "gScale");
vectorcolorscale_shader_b = shader_get_uniform(shd_vectorcolorscale, "bScale");