/// @description Lighting Engine Singleton Init Event
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

highlight_strength_multiplier = 1.8;
broadlight_strength_multiplier = 1.25;
highlight_to_broadlight_ratio_max = 5.0;

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
render_directional_shadows_border = 240;

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

// Vertex Formats
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
lighting_engine_box_shadows_vertex_format = vertex_format_end();

vertex_format_begin();
vertex_format_add_position();
lighting_engine_simple_light_vertex_format = vertex_format_end();

// Vertex Buffers
simple_light_vertex_buffer = vertex_create_buffer();

vertex_begin(simple_light_vertex_buffer, lighting_engine_simple_light_vertex_format);

vertex_position(simple_light_vertex_buffer, -1, -1);
vertex_position(simple_light_vertex_buffer, 1, -1);
vertex_position(simple_light_vertex_buffer, -1, 1);

vertex_position(simple_light_vertex_buffer, 1, 1);
vertex_position(simple_light_vertex_buffer, -1, 1);
vertex_position(simple_light_vertex_buffer, 1, -1);

vertex_end(simple_light_vertex_buffer);
vertex_freeze(simple_light_vertex_buffer);

// Point Light Blend Shader Indexes
point_light_shader_radius_index = shader_get_uniform(shd_point_light_blend, "in_Radius");
point_light_shader_centerpoint_index = shader_get_uniform(shd_point_light_blend, "in_CenterPoint");

point_light_shader_surface_size_index = shader_get_uniform(shd_point_light_blend, "in_SurfaceSize");
point_light_shader_surface_position_index = shader_get_uniform(shd_point_light_blend, "in_SurfacePosition");

point_light_shader_highlight_strength_multiplier_index = shader_get_uniform(shd_point_light_blend, "in_HighLight_Strength_Multiplier");
point_light_shader_broadlight_strength_multiplier_index = shader_get_uniform(shd_point_light_blend, "in_BroadLight_Strength_Multiplier");
point_light_shader_highlight_to_broadlight_ratio_max_index = shader_get_uniform(shd_point_light_blend, "in_HighLight_To_BroadLight_Ratio_Max");

point_light_shader_light_color_index = shader_get_uniform(shd_point_light_blend, "in_LightColor");
point_light_shader_light_intensity_index = shader_get_uniform(shd_point_light_blend, "in_LightIntensity");
point_light_shader_light_falloff_index = shader_get_uniform(shd_point_light_blend, "in_LightFalloff");

point_light_shader_normalmap_texture_index  = shader_get_sampler_index(shd_point_light_blend, "gm_NormalTexture");
point_light_shader_shadows_texture_index  = shader_get_sampler_index(shd_point_light_blend, "gm_ShadowTexture");

// Spot Light Blend Shader Indexes
spot_light_shader_radius_index = shader_get_uniform(shd_spot_light_blend, "in_Radius");
spot_light_shader_centerpoint_index = shader_get_uniform(shd_spot_light_blend, "in_CenterPoint");

spot_light_shader_surface_size_index = shader_get_uniform(shd_spot_light_blend, "in_SurfaceSize");
spot_light_shader_surface_position_index = shader_get_uniform(shd_spot_light_blend, "in_SurfacePosition");

spot_light_shader_highlight_strength_multiplier_index = shader_get_uniform(shd_spot_light_blend, "in_HighLight_Strength_Multiplier");
spot_light_shader_broadlight_strength_multiplier_index = shader_get_uniform(shd_spot_light_blend, "in_BroadLight_Strength_Multiplier");
spot_light_shader_highlight_to_broadlight_ratio_max_index = shader_get_uniform(shd_spot_light_blend, "in_HighLight_To_BroadLight_Ratio_Max");

spot_light_shader_light_color_index = shader_get_uniform(shd_spot_light_blend, "in_LightColor");
spot_light_shader_light_intensity_index = shader_get_uniform(shd_spot_light_blend, "in_LightIntensity");
spot_light_shader_light_falloff_index = shader_get_uniform(shd_spot_light_blend, "in_LightFalloff");

spot_light_shader_light_direction_index = shader_get_uniform(shd_spot_light_blend, "in_LightDirection");
spot_light_shader_light_angle_index = shader_get_uniform(shd_spot_light_blend, "in_LightAngle");

spot_light_shader_normalmap_texture_index  = shader_get_sampler_index(shd_spot_light_blend, "gm_NormalTexture");
spot_light_shader_shadows_texture_index  = shader_get_sampler_index(shd_spot_light_blend, "gm_ShadowTexture");

// Point Light Shadow Shader Indexes
point_light_and_spot_light_shadow_shader_light_source_radius_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_LightSource_Radius");
point_light_and_spot_light_shadow_shader_light_source_position_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_LightSource_Position");
point_light_and_spot_light_shadow_shader_collider_center_position_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_ColliderCenter_Position");

// Directional Light Blend Shader Indexes
directional_light_shader_light_source_vector_index = shader_get_uniform(shd_directional_light_blend, "in_LightSource_Vector");

directional_light_shader_highlight_strength_multiplier_index = shader_get_uniform(shd_directional_light_blend, "in_HighLight_Strength_Multiplier");
directional_light_shader_broadlight_strength_multiplier_index = shader_get_uniform(shd_directional_light_blend, "in_BroadLight_Strength_Multiplier");
directional_light_shader_highlight_to_broadlight_ratio_max_index = shader_get_uniform(shd_directional_light_blend, "in_HighLight_To_BroadLight_Ratio_Max");

directional_light_shader_normalmap_texture_index  = shader_get_sampler_index(shd_directional_light_blend, "gm_NormalTexture");

// Directional Light Shadow Shader Indexes
directional_light_shadow_shader_light_source_radius_index = shader_get_uniform(shd_directional_light_shadows, "in_LightSource_Radius");
directional_light_shadow_shader_light_source_vector_index = shader_get_uniform(shd_directional_light_shadows, "in_LightSource_Vector");
directional_light_shadow_shader_collider_center_position_index = shader_get_uniform(shd_directional_light_shadows, "in_ColliderCenter_Position");

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

// Lighting Directional Shadows Variables
directional_light_collisions_exist = false;
directional_light_collisions_list = ds_list_create();