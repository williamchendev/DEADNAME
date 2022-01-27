/// @description Lighting Init Event
// Creates the variables and settings necessary for the Lighting Engine

// Settings
screen_width = 641;
screen_height = 361;
tint = c_white;

// Variables
visible = true;
basic_object_depth_list = ds_list_create();
for (var i = 0; i < instance_number(oBasic); i++) {
	var temp_basic_inst = instance_find(oBasic, i);
	if (ds_list_find_index(basic_object_depth_list, temp_basic_inst.id) == -1) {
		ds_list_add_instance_by_depth(basic_object_depth_list, temp_basic_inst.id);
	}
}

// Surfaces
surface_color = noone;
surface_normals = noone;
surface_background_color = noone;
surface_background_normals = noone;
surface_foreground_color = noone;
surface_foreground_normals = noone;

surface_temp = noone;
surface_vectors = noone;
surface_blend = noone;

surface_shadows = noone;

surface_light = noone;

// Shadows Vertex Data
vertex_format_begin();
vertex_format_add_position_3d();
shadows_vertex_format = vertex_format_end();
shadows_vertex_buffer = vertex_create_buffer();

// Shader Variables
pointconelightvector_shader_fov = shader_get_uniform(shd_pointconelightvector, "lightConeFOV");
pointconelightvector_shader_direction = shader_get_uniform(shd_pointconelightvector, "lightConeDirection");
pointconelightfade_shader_fov = shader_get_uniform(shd_pointconelightfade, "lightConeFOV");
pointconelightfade_shader_direction = shader_get_uniform(shd_pointconelightfade, "lightConeDirection");

shadow_pointlight_shader_position = shader_get_uniform(shd_pointlightshadows, "lightPosition");
shadow_directionallight_shader_angle = shader_get_uniform(shd_directionallightshadows, "lightDirection");

// Shader Textures
sprite_normals = shader_get_sampler_index(shd_forwardlighting, "spriteNormalTex");
light_vectors = shader_get_sampler_index(shd_forwardlighting, "lightVectorTex");
light_blend = shader_get_sampler_index(shd_forwardlighting, "lightBlendTex");
light_shadows = shader_get_sampler_index(shd_forwardlighting, "lightShadowsTex");
light_render = shader_get_sampler_index(shd_forwardlighting, "lightRenderTex");

light_texture = shader_get_sampler_index(shd_drawlitsurface, "lightTex");