/// @description Lighting Engine Singleton Init Event
// Self-Creating Lighting Engine Init Behaviour Event

// Global Lighting Engine Properties
#macro LightingEngine global.lighting_engine
#macro LightingEngineDefaultLayer "main"

#macro LightingEngineUseGameMakerLayerName "#USE_GAMEMAKER_LAYER_NAME#"

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

universal_distortion_strength = 0.25;

// Engine Settings
application_surface_enable(false);
application_surface_draw_enable(false);

gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);

gpu_set_sprite_cull(false);

surface_depth_disable(true);

// Render Settings
render_x = 0;
render_y = 0;

render_border = 120;
render_directional_shadows_border = 240;

lighting_engine_camera_bounds_exist = false;
lighting_engine_camera_bounds_min_x = 0;
lighting_engine_camera_bounds_min_y = 0;
lighting_engine_camera_bounds_max_x = 0;
lighting_engine_camera_bounds_max_y = 0;

// Render Functions
render_position = function(render_position_x, render_position_y)
{
	// Restrict Render to Camera Bounds
	LightingEngine.render_x = LightingEngine.lighting_engine_camera_bounds_exist ? clamp(render_position_x, LightingEngine.lighting_engine_camera_bounds_min_x, LightingEngine.lighting_engine_camera_bounds_max_x - GameManager.game_width) : render_position_x;
	LightingEngine.render_y = LightingEngine.lighting_engine_camera_bounds_exist ? clamp(render_position_y, LightingEngine.lighting_engine_camera_bounds_min_y, LightingEngine.lighting_engine_camera_bounds_max_y - GameManager.game_height) : render_position_y;
}

// Bloom Settings
bloom_global_size = 3;
bloom_global_color = c_white;
bloom_global_intensity = 1.0;

// Surfaces
temp_surface = -1;

background_surface = -1;

diffuse_back_color_surface = -1;
diffuse_mid_color_surface = -1;
diffuse_front_color_surface = -1;

pbr_lighting_back_color_surface = -1;
pbr_lighting_mid_color_surface = -1;
pbr_lighting_front_color_surface = -1;

normalmap_vector_surface = -1;

layered_prb_metalrough_emissive_depth_surface = -1;
background_prb_metalrough_emissive_depth_surface = -1;

bloom_effect_surface = -1;
distortion_effect_surface = -1;

post_processing_surface = -1;
final_render_surface = -1;

ui_surface = -1;
debug_surface = -1;

#endregion

#region Vertex Formats

// Vertex Formats
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
lighting_engine_box_shadows_vertex_format = vertex_format_end();

vertex_format_begin();
vertex_format_add_position();
lighting_engine_simple_light_vertex_format = vertex_format_end();

vertex_format_begin();
vertex_format_add_position();
lighting_engine_screen_space_render_vertex_format = vertex_format_end();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_color();
vertex_format_add_texcoord();
vertex_format_add_custom(vertex_type_float4, vertex_usage_texcoord);
vertex_format_add_custom(vertex_type_float4, vertex_usage_texcoord);
vertex_format_add_custom(vertex_type_float4, vertex_usage_texcoord);
vertex_format_add_custom(vertex_type_float4, vertex_usage_texcoord);
lighting_engine_static_sprite_bulk_mrt_rendering_vertex_format = vertex_format_end();

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

screen_space_vertex_buffer = vertex_create_buffer();

vertex_begin(screen_space_vertex_buffer, lighting_engine_screen_space_render_vertex_format);

vertex_position(screen_space_vertex_buffer, 0, 0);
vertex_position(screen_space_vertex_buffer, 0, 1);
vertex_position(screen_space_vertex_buffer, 1, 0);

vertex_position(screen_space_vertex_buffer, 1, 1);
vertex_position(screen_space_vertex_buffer, 1, 0);
vertex_position(screen_space_vertex_buffer, 0, 1);

vertex_end(screen_space_vertex_buffer);
vertex_freeze(screen_space_vertex_buffer);

// MRT Deferred Lighting Dynamic Sprite Shader Indexes
mrt_deferred_lighting_dynamic_sprite_shader_camera_offset_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Camera_Offset");

mrt_deferred_lighting_dynamic_sprite_shader_normalmap_uv_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Normal_UVs");
mrt_deferred_lighting_dynamic_sprite_shader_metallicroughnessmap_uv_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_MetallicRoughness_UVs");
mrt_deferred_lighting_dynamic_sprite_shader_emissivemap_uv_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Emissive_UVs");

mrt_deferred_lighting_dynamic_sprite_shader_vector_scale_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_VectorScale");
mrt_deferred_lighting_dynamic_sprite_shader_vector_angle_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_VectorAngle");

mrt_deferred_lighting_dynamic_sprite_shader_layer_depth_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Layer_Depth");

mrt_deferred_lighting_dynamic_sprite_shader_normal_strength_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_NormalStrength");
mrt_deferred_lighting_dynamic_sprite_shader_metallic_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Metallic");
mrt_deferred_lighting_dynamic_sprite_shader_roughness_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Roughness");
mrt_deferred_lighting_dynamic_sprite_shader_emissive_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Emissive");
mrt_deferred_lighting_dynamic_sprite_shader_emissive_multiplier_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_EmissiveMultiplier");

mrt_deferred_lighting_dynamic_sprite_shader_normalmap_enabled_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_NormalMap_Enabled");
mrt_deferred_lighting_dynamic_sprite_shader_metallicroughnessmap_enabled_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_MetallicRoughnessMap_Enabled");
mrt_deferred_lighting_dynamic_sprite_shader_emissivemap_enabled_index = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_EmissiveMap_Enabled");

mrt_deferred_lighting_dynamic_sprite_shader_normalmap_texture_index = shader_get_sampler_index(shd_mrt_deferred_lighting_dynamic_sprite, "gm_NormalTexture");
mrt_deferred_lighting_dynamic_sprite_shader_metallicroughnessmap_texture_index = shader_get_sampler_index(shd_mrt_deferred_lighting_dynamic_sprite, "gm_MetallicRoughnessTexture");
mrt_deferred_lighting_dynamic_sprite_shader_emissivemap_texture_index = shader_get_sampler_index(shd_mrt_deferred_lighting_dynamic_sprite, "gm_EmissiveTexture");

// MRT Deferred Lighting Bulk Static Sprite Shader Indexes
mrt_deferred_lighting_bulk_static_sprite_shader_camera_offset_index  = shader_get_uniform(shd_mrt_deferred_lighting_bulk_static_sprite, "in_Camera_Offset");

mrt_deferred_lighting_bulk_static_sprite_shader_layer_depth_index  = shader_get_uniform(shd_mrt_deferred_lighting_bulk_static_sprite, "in_Layer_Depth");

// Point Light Blend Shader Indexes
point_light_shader_camera_offset_index = shader_get_uniform(shd_point_light_blend, "in_Camera_Offset");

point_light_shader_radius_index = shader_get_uniform(shd_point_light_blend, "in_Radius");
point_light_shader_centerpoint_index = shader_get_uniform(shd_point_light_blend, "in_CenterPoint");

point_light_shader_surface_size_index = shader_get_uniform(shd_point_light_blend, "in_SurfaceSize");

point_light_shader_highlight_strength_multiplier_index = shader_get_uniform(shd_point_light_blend, "in_HighLight_Strength_Multiplier");
point_light_shader_broadlight_strength_multiplier_index = shader_get_uniform(shd_point_light_blend, "in_BroadLight_Strength_Multiplier");
point_light_shader_highlight_to_broadlight_ratio_max_index = shader_get_uniform(shd_point_light_blend, "in_HighLight_To_BroadLight_Ratio_Max");

point_light_shader_light_color_index = shader_get_uniform(shd_point_light_blend, "in_LightColor");
point_light_shader_light_intensity_index = shader_get_uniform(shd_point_light_blend, "in_LightIntensity");
point_light_shader_light_falloff_index = shader_get_uniform(shd_point_light_blend, "in_LightFalloff");

point_light_shader_light_layers_index = shader_get_uniform(shd_point_light_blend, "in_Light_Layers");
point_light_shader_shadow_layers_index = shader_get_uniform(shd_point_light_blend, "in_Shadow_Layers");

point_light_shader_diffusemap_texture_back_layer_index = shader_get_sampler_index(shd_point_light_blend, "gm_DiffuseMap_BackLayer_Texture");
point_light_shader_diffusemap_texture_mid_layer_index = shader_get_sampler_index(shd_point_light_blend, "gm_DiffuseMap_MidLayer_Texture");
point_light_shader_diffusemap_texture_front_layer_index = shader_get_sampler_index(shd_point_light_blend, "gm_DiffuseMap_FrontLayer_Texture");

point_light_shader_normalmap_texture_index  = shader_get_sampler_index(shd_point_light_blend, "gm_NormalTexture");
point_light_shader_shadowmap_texture_index  = shader_get_sampler_index(shd_point_light_blend, "gm_ShadowTexture");

point_light_shader_prb_metalrough_emissive_depth_texture_index  = shader_get_sampler_index(shd_point_light_blend, "gm_PBR_MetallicRoughness_Emissive_Depth_Map_Texture");

// Spot Light Blend Shader Indexes
spot_light_shader_camera_offset_index = shader_get_uniform(shd_spot_light_blend, "in_Camera_Offset");

spot_light_shader_radius_index = shader_get_uniform(shd_spot_light_blend, "in_Radius");
spot_light_shader_centerpoint_index = shader_get_uniform(shd_spot_light_blend, "in_CenterPoint");

spot_light_shader_surface_size_index = shader_get_uniform(shd_spot_light_blend, "in_SurfaceSize");

spot_light_shader_highlight_strength_multiplier_index = shader_get_uniform(shd_spot_light_blend, "in_HighLight_Strength_Multiplier");
spot_light_shader_broadlight_strength_multiplier_index = shader_get_uniform(shd_spot_light_blend, "in_BroadLight_Strength_Multiplier");
spot_light_shader_highlight_to_broadlight_ratio_max_index = shader_get_uniform(shd_spot_light_blend, "in_HighLight_To_BroadLight_Ratio_Max");

spot_light_shader_light_color_index = shader_get_uniform(shd_spot_light_blend, "in_LightColor");
spot_light_shader_light_intensity_index = shader_get_uniform(shd_spot_light_blend, "in_LightIntensity");
spot_light_shader_light_falloff_index = shader_get_uniform(shd_spot_light_blend, "in_LightFalloff");

spot_light_shader_light_direction_index = shader_get_uniform(shd_spot_light_blend, "in_LightDirection");
spot_light_shader_light_angle_index = shader_get_uniform(shd_spot_light_blend, "in_LightAngle");

spot_light_shader_light_layers_index = shader_get_uniform(shd_spot_light_blend, "in_Light_Layers");
spot_light_shader_shadow_layers_index = shader_get_uniform(shd_spot_light_blend, "in_Shadow_Layers");

spot_light_shader_normalmap_texture_index  = shader_get_sampler_index(shd_spot_light_blend, "gm_NormalTexture");
spot_light_shader_shadows_texture_index  = shader_get_sampler_index(shd_spot_light_blend, "gm_ShadowTexture");

// Point Light & Spot Light Shadow Shader Indexes
point_light_and_spot_light_shadow_shader_camera_offset_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_Camera_Offset");

point_light_and_spot_light_shadow_shader_light_source_radius_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_LightSource_Radius");
point_light_and_spot_light_shadow_shader_light_source_position_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_LightSource_Position");

point_light_and_spot_light_shadow_shader_collider_center_position_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_ColliderCenter_Position");
point_light_and_spot_light_shadow_shader_collider_scale_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_Collider_Scale");
point_light_and_spot_light_shadow_shader_collider_rotation_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_Collider_Rotation");

// Directional Light Blend Shader Indexes
directional_light_shader_light_source_vector_index = shader_get_uniform(shd_directional_light_blend, "in_LightSource_Vector");

directional_light_shader_light_layers_index = shader_get_uniform(shd_directional_light_blend, "in_Light_Layers");
directional_light_shader_shadow_layers_index = shader_get_uniform(shd_directional_light_blend, "in_Shadow_Layers");

directional_light_shader_highlight_strength_multiplier_index = shader_get_uniform(shd_directional_light_blend, "in_HighLight_Strength_Multiplier");
directional_light_shader_broadlight_strength_multiplier_index = shader_get_uniform(shd_directional_light_blend, "in_BroadLight_Strength_Multiplier");
directional_light_shader_highlight_to_broadlight_ratio_max_index = shader_get_uniform(shd_directional_light_blend, "in_HighLight_To_BroadLight_Ratio_Max");

directional_light_shader_normalmap_texture_index  = shader_get_sampler_index(shd_directional_light_blend, "gm_NormalTexture");

// Directional Light Shadow Shader Indexes
directional_light_shadow_shader_camera_offset_index = shader_get_uniform(shd_directional_light_shadows, "in_Camera_Offset");

directional_light_shadow_shader_light_source_radius_index = shader_get_uniform(shd_directional_light_shadows, "in_LightSource_Radius");
directional_light_shadow_shader_light_source_vector_index = shader_get_uniform(shd_directional_light_shadows, "in_LightSource_Vector");

directional_light_shadow_shader_collider_center_position_index = shader_get_uniform(shd_directional_light_shadows, "in_ColliderCenter_Position");
directional_light_shadow_shader_collider_scale_index = shader_get_uniform(shd_directional_light_shadows, "in_Collider_Scale");
directional_light_shadow_shader_collider_rotation_index = shader_get_uniform(shd_directional_light_shadows, "in_Collider_Rotation");

// Ambient Occlusion Light Blend Shader Indexes
ambient_light_shader_surface_size_index = shader_get_uniform(shd_ambient_occlusion_light_blend, "in_SurfaceSize");

ambient_light_shader_light_color_index = shader_get_uniform(shd_ambient_occlusion_light_blend, "in_LightColor");

// Deferred Lighting & Background Post Process Rendering Shader Indexes
post_process_lighting_render_shader_lightblend_texture_index  = shader_get_sampler_index(shd_post_process_render, "gm_LightBlend_Texture");
post_process_lighting_render_shader_lightblend_normal_dot_product_texture_index  = shader_get_sampler_index(shd_post_process_render, "gm_LightBlend_DotProduct_Texture");

post_process_lighting_render_shader_depth_specular_bloom_map_index  = shader_get_sampler_index(shd_post_process_render, "gm_DepthSpecularBloomMap");

post_process_lighting_render_shader_view_normal_map_index  = shader_get_sampler_index(shd_post_process_render, "gm_ViewNormal_Texture");

// Bloom Effect Surface Rendering Shader Indexes
bloom_effect_render_shader_surface_texel_size_index  = shader_get_uniform(shd_bloom_effect_render, "in_TexelSize");
bloom_effect_render_shader_alpha_multiplier_index  = shader_get_uniform(shd_bloom_effect_render, "in_AlphaMult");

bloom_effect_render_shader_bloom_texture_index  = shader_get_sampler_index(shd_bloom_effect_render, "in_Bloom_Texture");

// Distortion Effect Surface Rendering Shader Indexes
distortion_effect_render_shader_distortion_strength_index = shader_get_uniform(shd_distortion_effect_render, "in_Distortion_Strength");
distortion_effect_render_shader_distortion_aspect_index = shader_get_uniform(shd_distortion_effect_render, "in_Distortion_Aspect");
distortion_effect_render_shader_distortion_texture_index  = shader_get_sampler_index(shd_distortion_effect_render, "gm_Distortion_Texture");

// Lighting Engine Sub Layer Rendering Variables
lighting_engine_sub_layer_depth = 0;

lighting_engine_default_layer_index = 0;

lighting_engine_back_render_layer_shadows_enabled = true;
lighting_engine_mid_render_layer_shadows_enabled = true;
lighting_engine_front_render_layer_shadows_enabled = true;

// Lighting Engine Sub Layer DS Lists
lighting_engine_sub_layer_name_list = ds_list_create();
lighting_engine_sub_layer_render_layer_type_list = ds_list_create();

lighting_engine_back_layer_sub_layer_name_list = ds_list_create();
lighting_engine_back_layer_sub_layer_depth_list = ds_list_create();
lighting_engine_back_layer_sub_layer_type_list = ds_list_create();
lighting_engine_back_layer_sub_layer_object_list = ds_list_create();
lighting_engine_back_layer_sub_layer_object_type_list = ds_list_create();

lighting_engine_mid_layer_sub_layer_name_list = ds_list_create();
lighting_engine_mid_layer_sub_layer_depth_list = ds_list_create();
lighting_engine_mid_layer_sub_layer_type_list = ds_list_create();
lighting_engine_mid_layer_sub_layer_object_list = ds_list_create();
lighting_engine_mid_layer_sub_layer_object_type_list = ds_list_create();

lighting_engine_front_layer_sub_layer_name_list = ds_list_create();
lighting_engine_front_layer_sub_layer_depth_list = ds_list_create();
lighting_engine_front_layer_sub_layer_type_list = ds_list_create();
lighting_engine_front_layer_sub_layer_object_list = ds_list_create();
lighting_engine_front_layer_sub_layer_object_type_list = ds_list_create();

// Lighting Engine Layer Method: Create Default Sub Layers
create_default_sub_layers = function()
{
	// Create Default "Main" Sub Layer
	lighting_engine_create_sub_layer(LightingEngineDefaultLayer, 0.0, LightingEngineSubLayerType.Dynamic, LightingEngineRenderLayerType.Mid);
}

create_default_sub_layers();

// Background Variables
lighting_engine_background_depth = 250;
lighting_engine_backgrounds = ds_list_create();
lighting_engine_background_layer_ids = ds_list_create();

// Lighting Directional Shadows Variables
directional_light_collisions_exist = false;
directional_light_collisions_list = ds_list_create();

// Lighting Engine Worker
lighting_engine_worker = -1;