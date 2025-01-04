/// @description LIGHTING ENGINE INIT EVENT
// Self-Creating Lighting Engine Init Behaviour Event

// Global Lighting Engine Properties
#macro LightingEngine global.lighting_engine
#macro LightingEngineDefaultLayer "main"

// Enums
enum LightingEngineLitObjectType
{
	Disabled,
    Basic,
    Dynamic,
    Unit
}

// Configure Lighting Engine - Global Init Event
gml_pragma("global", @"room_instance_add(room_first, 0, 0, oLightingEngine);");

// Delete to prevent multiple Lighting Engine Instances
if (instance_number(object_index) > 1) 
{
	instance_destroy(id, false);
	exit;
}

// Lighting Engine Singleton
global.lighting_engine = id;

// Lighting Engine Settings
global.debug_surface_enabled = true;
global.lighting_engine_normalmap_default_color = make_color_rgb(255 / 2, 255 / 2, 255);

vertex_format_begin();
vertex_format_add_position_3d();
lighting_engine_box_shadows_vertex_format = vertex_format_end();

// Rendering Settings
application_surface_enable(false);
application_surface_draw_enable(false);

gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);

gpu_set_sprite_cull(false);

surface_depth_disable(true);

// Renders
render_x = 0;
render_y = 0;
render_border = 120;

// Layers
lighting_engine_layer_name_list = ds_list_create();
lighting_engine_layer_object_list = ds_list_create();
lighting_engine_layer_depth_list = ds_list_create();

// Surfaces
lights_color_surface = -1;
lights_shadow_surface = -1;

diffuse_color_surface = -1;
normalmap_vector_surface = -1;
depth_specular_stencil_surface = -1;

ui_surface = -1;
debug_surface = -1;

// Point Light Shader Indexes
point_light_shader_radius_index = shader_get_uniform(shd_point_light, "in_Radius");
point_light_shader_centerpoint_index = shader_get_uniform(shd_point_light, "in_CenterPoint");

point_light_shader_surface_size_index = shader_get_uniform(shd_point_light, "in_SurfaceSize");
point_light_shader_surface_position_index = shader_get_uniform(shd_point_light, "in_SurfacePosition");

point_light_shader_normalmap_texture_index  = shader_get_sampler_index(shd_point_light, "gm_NormalTexture");
point_light_shader_shadows_texture_index  = shader_get_sampler_index(shd_point_light, "gm_ShadowTexture");

// Point Light Shadow Shader Indexes
point_light_shadow_shader_light_source_position_index = shader_get_uniform(shd_point_light_shadows, "in_LightSource_Position");

// Deferred Lighting Shader Indexes
mrt_deferred_lighting_shader_normalmap_uv_index  = shader_get_uniform(shd_mrt_deferred_lighting, "in_Normal_UVs");
mrt_deferred_lighting_shader_specularmap_uv_index  = shader_get_uniform(shd_mrt_deferred_lighting, "in_Specular_UVs");

mrt_deferred_lighting_shader_vector_scale_index  = shader_get_uniform(shd_mrt_deferred_lighting, "vectorScale");
mrt_deferred_lighting_shader_vector_angle_index  = shader_get_uniform(shd_mrt_deferred_lighting, "vectorAngle");

mrt_deferred_lighting_shader_normalmap_texture_index  = shader_get_sampler_index(shd_mrt_deferred_lighting, "gm_NormalTexture");
mrt_deferred_lighting_shader_specularmap_texture_index  = shader_get_sampler_index(shd_mrt_deferred_lighting, "gm_SpecularTexture");

// Final Render Pass Lighting Shader Indexes
final_render_lighting_shader_lightblend_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_LightBlendTexture");

// Add Default Layers
lighting_engine_create_default_layers();