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

lighting_engine_camera_bounds_exist = false;
lighting_engine_camera_bounds_min_x = 0;
lighting_engine_camera_bounds_min_y = 0;
lighting_engine_camera_bounds_max_x = 0;
lighting_engine_camera_bounds_max_y = 0;

render_bloom_color = c_white;
render_bloom_intensity = 1.0;

// Render Functions
render_position = function(render_position_x, render_position_y)
{
	// Restrict Render to Camera Bounds
	render_x = lighting_engine_camera_bounds_exist ? clamp(render_position_x, lighting_engine_camera_bounds_min_x, lighting_engine_camera_bounds_max_x - GameManager.game_width) : render_position_x;
	render_y = lighting_engine_camera_bounds_exist ? clamp(render_position_y, lighting_engine_camera_bounds_min_y, lighting_engine_camera_bounds_max_y - GameManager.game_height) : render_position_y;
}

// Surfaces
lights_back_color_surface = -1;
lights_mid_color_surface = -1;
lights_front_color_surface = -1;

lights_shadow_surface = -1;

background_surface = -1;

diffuse_back_color_surface = -1;
diffuse_mid_color_surface = -1;
diffuse_front_color_surface = -1;

normalmap_vector_surface = -1;
depth_specular_bloom_surface = -1;

bloom_effect_surface = -1;
distortion_effect_surface = -1;

post_processing_surface = -1;
final_render_surface = -1;

ui_surface = -1;
debug_surface = -1;

// Surface Variables
bloom_surface_texel_width = 0;
bloom_surface_texel_height = 0;

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
vertex_format_add_custom(vertex_type_float3, vertex_usage_texcoord);
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
mrt_deferred_lighting_dynamic_sprite_shader_camera_offset_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Camera_Offset");

mrt_deferred_lighting_dynamic_sprite_shader_normalmap_uv_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Normal_UVs");
mrt_deferred_lighting_dynamic_sprite_shader_specularmap_uv_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Specular_UVs");
mrt_deferred_lighting_dynamic_sprite_shader_bloommap_uv_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Bloom_UVs");

mrt_deferred_lighting_dynamic_sprite_shader_vector_scale_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_VectorScale");
mrt_deferred_lighting_dynamic_sprite_shader_vector_angle_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_VectorAngle");

mrt_deferred_lighting_dynamic_sprite_shader_layer_depth_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Layer_Depth");

mrt_deferred_lighting_dynamic_sprite_shader_normal_enabled_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Normal_Enabled");
mrt_deferred_lighting_dynamic_sprite_shader_specular_enabled_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Specular_Enabled");
mrt_deferred_lighting_dynamic_sprite_shader_bloom_enabled_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Bloom_Enabled");

mrt_deferred_lighting_dynamic_sprite_shader_normalmap_texture_index  = shader_get_sampler_index(shd_mrt_deferred_lighting_dynamic_sprite, "gm_NormalTexture");
mrt_deferred_lighting_dynamic_sprite_shader_specularmap_texture_index  = shader_get_sampler_index(shd_mrt_deferred_lighting_dynamic_sprite, "gm_SpecularTexture");
mrt_deferred_lighting_dynamic_sprite_shader_bloommap_texture_index  = shader_get_sampler_index(shd_mrt_deferred_lighting_dynamic_sprite, "gm_BloomTexture");

// MRT Deferred Lighting Bulk Static Sprite Shader Indexes
mrt_deferred_lighting_bulk_static_sprite_shader_camera_offset_index  = shader_get_uniform(shd_mrt_deferred_lighting_bulk_static_sprite, "in_Camera_Offset");

mrt_deferred_lighting_bulk_static_sprite_shader_layer_depth_index  = shader_get_uniform(shd_mrt_deferred_lighting_bulk_static_sprite, "in_Layer_Depth");

// Point Light Blend Shader Indexes
point_light_shader_camera_offset_index = shader_get_uniform(shd_point_light_blend, "in_Camera_Offset");

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

point_light_shader_light_layers_index = shader_get_uniform(shd_point_light_blend, "in_Light_Layers");
point_light_shader_shadow_layers_index = shader_get_uniform(shd_point_light_blend, "in_Shadow_Layers");

point_light_shader_normalmap_texture_index  = shader_get_sampler_index(shd_point_light_blend, "gm_NormalTexture");
point_light_shader_shadows_texture_index  = shader_get_sampler_index(shd_point_light_blend, "gm_ShadowTexture");

// Spot Light Blend Shader Indexes
spot_light_shader_camera_offset_index = shader_get_uniform(shd_spot_light_blend, "in_Camera_Offset");

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
post_process_lighting_render_shader_background_texture_index  = shader_get_sampler_index(shd_post_process_render, "gm_Background_Texture");

post_process_lighting_render_shader_diffusemap_back_layer_texture_index  = shader_get_sampler_index(shd_post_process_render, "gm_DiffuseMap_BackLayer_Texture");
post_process_lighting_render_shader_diffusemap_front_layer_texture_index  = shader_get_sampler_index(shd_post_process_render, "gm_DiffuseMap_FrontLayer_Texture");

post_process_lighting_render_shader_lightblend_back_layer_texture_index  = shader_get_sampler_index(shd_post_process_render, "gm_LightBlend_BackLayer_Texture");
post_process_lighting_render_shader_lightblend_mid_layer_texture_index  = shader_get_sampler_index(shd_post_process_render, "gm_LightBlend_MidLayer_Texture");
post_process_lighting_render_shader_lightblend_front_layer_texture_index  = shader_get_sampler_index(shd_post_process_render, "gm_LightBlend_FrontLayer_Texture");

// Bloom Effect Surface Rendering Shader Indexes
bloom_effect_render_shader_surface_texel_size_index  = shader_get_uniform(shd_bloom_effect_render, "in_Surface_Texel_Size");

bloom_effect_render_shader_bloom_texture_index  = shader_get_sampler_index(shd_bloom_effect_render, "in_Bloom_Texture");

// Distortion Effect Surface Rendering Shader Indexes
distortion_effect_render_shader_distortion_strength_index = shader_get_uniform(shd_distortion_effect_render, "in_Distortion_Strength");
distortion_effect_render_shader_distortion_aspect_index = shader_get_uniform(shd_distortion_effect_render, "in_Distortion_Aspect");
distortion_effect_render_shader_distortion_texture_index  = shader_get_sampler_index(shd_distortion_effect_render, "gm_Distortion_Texture");

// Final Render Pass Lighting Shader Indexes
final_render_lighting_shader_distortion_strength_index = shader_get_uniform(shd_final_render_lighting, "in_Distortion_Strength");
final_render_lighting_shader_distortion_aspect_index = shader_get_uniform(shd_final_render_lighting, "in_Distortion_Aspect");
final_render_lighting_shader_distortion_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_Distortion_Texture");

final_render_lighting_shader_background_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_Background_Texture");

final_render_lighting_shader_diffusemap_back_layer_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_DiffuseMap_BackLayer_Texture");
final_render_lighting_shader_diffusemap_front_layer_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_DiffuseMap_FrontLayer_Texture");

final_render_lighting_shader_lightblend_back_layer_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_LightBlend_BackLayer_Texture");
final_render_lighting_shader_lightblend_mid_layer_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_LightBlend_MidLayer_Texture");
final_render_lighting_shader_lightblend_front_layer_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_LightBlend_FrontLayer_Texture");

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

// Lighting Engine Rendering Methods
render_sprite = function(diffusemap_index, diffusemap_subimage, normalmap_texture, specularmap_texture, bloommap_texture, normalmap_uvs, specularmap_uvs, bloommap_uvs, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha) 
{
	//
	var temp_mrt_shader_normal_enabled = normalmap_texture != noone;
	var temp_mrt_shader_specular_enabled = specularmap_texture != noone;
	var temp_mrt_shader_bloom_enabled = bloommap_texture != noone;
	
	var temp_normalmap_uvs = temp_mrt_shader_normal_enabled ? normalmap_uvs : [ 0, 0, 0, 0 ];
	var temp_specularmap_uvs = temp_mrt_shader_specular_enabled ? specularmap_uvs : [ 0, 0, 0, 0 ];
	var temp_bloommap_uvs = temp_mrt_shader_bloom_enabled ? bloommap_uvs : [ 0, 0, 0, 0 ];
	
	//
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normal_enabled_index, temp_mrt_shader_normal_enabled ? 1 : 0);
	
	if (temp_mrt_shader_normal_enabled)
	{
		texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normalmap_texture_index, normalmap_texture);
		 shader_set_uniform_f_array(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_normalmap_uv_index, temp_normalmap_uvs);
	}
	
    //
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_specular_enabled_index, temp_mrt_shader_specular_enabled ? 1 : 0);
    
    if (temp_mrt_shader_specular_enabled)
    {
    	texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_specularmap_texture_index, specularmap_texture);
    	shader_set_uniform_f_array(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_specularmap_uv_index, temp_specularmap_uvs);
    }
    
    //
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_bloom_enabled_index, temp_mrt_shader_bloom_enabled ? 1 : 0);
	
	if (temp_mrt_shader_bloom_enabled)
	{
		texture_set_stage(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_bloommap_texture_index, bloommap_texture);
    	shader_set_uniform_f_array(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_bloommap_uv_index, temp_bloommap_uvs);
	}
    
    //
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_vector_scale_index, x_scale, y_scale, 1);
    shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_vector_angle_index, rotation);
    
    //
    draw_sprite_ext(diffusemap_index, diffusemap_subimage, x_pos, y_pos, x_scale, y_scale, rotation, color, alpha);
}

render_layer = function(render_layer_type)
{
	// Establish Empty Render Layer Variables
	var temp_render_layer_sub_layer_name_list = undefined;
	var temp_render_layer_sub_layer_depth_list = undefined;
	var temp_render_layer_sub_layer_type_list = undefined;
	var temp_render_layer_sub_layer_object_list = undefined;
	var temp_render_layer_sub_layer_object_type_list = undefined;
	
	// Assign Render Layer Variables from given Render Layer Type
	switch (render_layer_type)
	{
		case LightingEngineRenderLayerType.Back:
			temp_render_layer_sub_layer_name_list = lighting_engine_back_layer_sub_layer_name_list;
			temp_render_layer_sub_layer_depth_list = lighting_engine_back_layer_sub_layer_depth_list;
			temp_render_layer_sub_layer_type_list = lighting_engine_back_layer_sub_layer_type_list;
			temp_render_layer_sub_layer_object_list = lighting_engine_back_layer_sub_layer_object_list;
			temp_render_layer_sub_layer_object_type_list = lighting_engine_back_layer_sub_layer_object_type_list;
			break;
		case LightingEngineRenderLayerType.Front:
			temp_render_layer_sub_layer_name_list = lighting_engine_front_layer_sub_layer_name_list;
			temp_render_layer_sub_layer_depth_list = lighting_engine_front_layer_sub_layer_depth_list;
			temp_render_layer_sub_layer_type_list = lighting_engine_front_layer_sub_layer_type_list;
			temp_render_layer_sub_layer_object_list = lighting_engine_front_layer_sub_layer_object_list;
			temp_render_layer_sub_layer_object_type_list = lighting_engine_front_layer_sub_layer_object_type_list;
			break;
		case LightingEngineRenderLayerType.Mid:
		default:
			temp_render_layer_sub_layer_name_list = lighting_engine_mid_layer_sub_layer_name_list;
			temp_render_layer_sub_layer_depth_list = lighting_engine_mid_layer_sub_layer_depth_list;
			temp_render_layer_sub_layer_type_list = lighting_engine_mid_layer_sub_layer_type_list;
			temp_render_layer_sub_layer_object_list = lighting_engine_mid_layer_sub_layer_object_list;
			temp_render_layer_sub_layer_object_type_list = lighting_engine_mid_layer_sub_layer_object_type_list;
			break;
	}
	
	// Iterate through Render Layer's Sub Layers
	var temp_sub_layer_index = 0;
	
	repeat (ds_list_size(temp_render_layer_sub_layer_name_list))
	{
		// Get Render Layer Name, Depth, and Type
		var temp_sub_layer_name = ds_list_find_value(temp_render_layer_sub_layer_name_list, temp_sub_layer_index);
		var temp_sub_layer_depth = ds_list_find_value(temp_render_layer_sub_layer_depth_list, temp_sub_layer_index);
		var temp_sub_layer_type = ds_list_find_value(temp_render_layer_sub_layer_type_list, temp_sub_layer_index);
		
		// Get Render Layer Object and Object Type DS Lists
		var temp_sub_layer_object_list = ds_list_find_value(temp_render_layer_sub_layer_object_list, temp_sub_layer_index);
		var temp_sub_layer_object_type_list = ds_list_find_value(temp_render_layer_sub_layer_object_type_list, temp_sub_layer_index);
		
		// Set Lighting Engine Layer Depth
		lighting_engine_sub_layer_depth = temp_sub_layer_depth;
		
		// Set Shader Properties based on Sub Layer Type
		switch (temp_sub_layer_type)
		{
			case LightingEngineSubLayerType.BulkStatic:
				// MRT Bulk Static Sprite Layer
				shader_set(shd_mrt_deferred_lighting_bulk_static_sprite);
				
				// Set Sub Layer Depth
				shader_set_uniform_f(mrt_deferred_lighting_bulk_static_sprite_shader_layer_depth_index, temp_sub_layer_depth);
				
				// Set Camera Offset
				shader_set_uniform_f(mrt_deferred_lighting_bulk_static_sprite_shader_camera_offset_index, render_x - render_border, render_y - render_border);
				break;
			case LightingEngineSubLayerType.Dynamic:
			default:
				// MRT Dynamic Sprite Layer
				shader_set(shd_mrt_deferred_lighting_dynamic_sprite);
				
				// Set Sub Layer Depth
    			shader_set_uniform_f(mrt_deferred_lighting_dynamic_sprite_shader_layer_depth_index, temp_sub_layer_depth);
    			
    			// Set Camera Offset
				shader_set_uniform_f(mrt_deferred_lighting_dynamic_sprite_shader_camera_offset_index, render_x - render_border, render_y - render_border);
				break;
		}
		
		// Iterate through Sub Layer's Objects List
		var temp_sub_layer_object_index = 0;
	
		repeat (ds_list_size(temp_sub_layer_object_type_list))
		{
			// Get Sub Layer Object and Object Type
			var temp_sub_layer_object = ds_list_find_value(temp_sub_layer_object_list, temp_sub_layer_object_index);
			var temp_sub_layer_object_type = ds_list_find_value(temp_sub_layer_object_type_list, temp_sub_layer_object_index);
			
			// Draw Object based on Object Type
			switch (temp_sub_layer_object_type)
			{
				case LightingEngineObjectType.BulkStatic_Region:
					// Draw Bulk Static Region Vertex Buffer on Bulk Static Layer
					with (temp_sub_layer_object)
					{
						if (bulk_static_region_render_enabled)
						{
							vertex_submit(ds_map_find_value(bulk_static_region_vertex_buffer_map, temp_sub_layer_name), pr_trianglelist, ds_map_find_value(bulk_static_region_texture_map, temp_sub_layer_name));
						}
					}
					break;
				case LightingEngineObjectType.BulkStatic_Layer:
					// Draw Bulk Static Layer Vertex Buffer with Texture from Sub-Layer Vertex Buffer and Texture Struct
					vertex_submit(temp_sub_layer_object.bulk_static_vertex_buffer, pr_trianglelist, temp_sub_layer_object.bulk_static_texture);
					break;
				case LightingEngineObjectType.Dynamic_Unit:
					// Draw Unit on Dynamic Layer
					with (temp_sub_layer_object)
					{
						// Draw Secondary Arm rendered behind Unit Body
						limb_secondary_arm.render_behaviour();
					
						// Draw Unit Body
						LightingEngine.render_sprite
						(
							sprite_index,
							image_index,
							normalmap_spritepack != noone ? normalmap_spritepack[image_index].texture : noone,
							specularmap_spritepack != noone ? specularmap_spritepack[image_index].texture : noone,
							bloommap_spritepack != noone ? bloommap_spritepack[image_index].texture : noone,
							normalmap_spritepack != noone ? normalmap_spritepack[image_index].uvs : noone,
							specularmap_spritepack != noone ? specularmap_spritepack[image_index].uvs : noone,
							bloommap_spritepack != noone ? bloommap_spritepack[image_index].uvs : noone,
							x,
							y + ground_contact_vertical_offset,
							draw_xscale,
							draw_yscale,
							image_angle + draw_angle_value,
							image_blend,
							image_alpha
						);
						
						// Draw Unit's Weapon (if equipped)
						if (weapon_active)
						{
							weapon_equipped.render_behaviour();
						}
						
						// Draw Primary Arm rendered in front Unit Body
						limb_primary_arm.render_behaviour();
					}
					break;
				default:
					break;
			}
			
			// Increment Object
			temp_sub_layer_object_index++;
		}
		
		// Reset Shader Properties
		shader_reset();
		
		// Increment Sub Layer Index
		temp_sub_layer_index++;
	}
}

// Background Variables
lighting_engine_background_depth = 250;
lighting_engine_backgrounds = ds_list_create();
lighting_engine_background_layer_ids = ds_list_create();

// Lighting Directional Shadows Variables
directional_light_collisions_exist = false;
directional_light_collisions_list = ds_list_create();

// Lighting Engine Worker
lighting_engine_worker = -1;