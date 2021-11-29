/// @description Basic Light Object Init
// Creates the variables necessary for the Basic Lighting Object

// Inherit Create Event
event_inherited();

// Basic-Lighting-Object Settings
colors_sprite_index = sWolf_Jump;
normals_sprite_index = sWolf_Jump_NormalMap;

// Normal Settings
normalmap_level = 1.0;

// Shader Variables
vectortransform_shader_angle = shader_get_uniform(shd_vectortransform, "vectorAngle");
vectortransform_shader_scale = shader_get_uniform(shd_vectortransform, "vectorScale");