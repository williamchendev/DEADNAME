/// @description Lighting Init Event
// Creates the variables and settings necessary for the Lighting Engine

// Settings
screen_width = 640;
screen_height = 360;
tint = c_white;

// Surfaces
surface_color = noone;
surface_normals = noone;

surface_temp = noone;
surface_vectors = noone;
surface_blend = noone;

surface_shadows = noone;

surface_light = noone;

// Shadows
vertex_format_begin();
vertex_format_add_position_3d();
shadows_vertex_format = vertex_format_end();
shadows_vertex_buffer = vertex_create_buffer();

shadow_light_position = shader_get_uniform(shd_shadows, "lightPosition");

// Shader Textures
sprite_normals = shader_get_sampler_index(shd_forwardlighting, "spriteNormalTex");
light_vectors = shader_get_sampler_index(shd_forwardlighting, "lightVectorTex");
light_blend = shader_get_sampler_index(shd_forwardlighting, "lightBlendTex");
light_shadows = shader_get_sampler_index(shd_forwardlighting, "lightShadowsTex");
light_render = shader_get_sampler_index(shd_forwardlighting, "lightRenderTex");

light_texture = shader_get_sampler_index(shd_drawlitsurface, "lightTex");