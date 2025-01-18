/// @description Lighting Engine Singleton Init Event
// Self-Creating Lighting Engine Init Behaviour Event

// Global Lighting Engine Properties
#macro LightingEngine global.lighting_engine
#macro LightingEngineDefaultLayer "main"

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

// Surfaces
lights_back_color_surface = -1;
lights_mid_color_surface = -1;
lights_front_color_surface = -1;

lights_shadow_surface = -1;

diffuse_back_color_surface = -1;
diffuse_mid_color_surface = -1;
diffuse_front_color_surface = -1;

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

vertex_format_begin();
vertex_format_add_position();
lighting_engine_screen_space_render_vertex_format = vertex_format_end();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_custom(vertex_type_float3, vertex_usage_normal);
vertex_format_add_color();
vertex_format_add_texcoord();
vertex_format_add_texcoord();
vertex_format_add_texcoord();
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
mrt_deferred_lighting_dynamic_sprite_shader_normalmap_uv_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Normal_UVs");
mrt_deferred_lighting_dynamic_sprite_shader_specularmap_uv_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Specular_UVs");

mrt_deferred_lighting_dynamic_sprite_shader_vector_scale_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_VectorScale");
mrt_deferred_lighting_dynamic_sprite_shader_vector_angle_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_VectorAngle");

mrt_deferred_lighting_dynamic_sprite_shader_layer_depth_index  = shader_get_uniform(shd_mrt_deferred_lighting_dynamic_sprite, "in_Layer_Depth");

mrt_deferred_lighting_dynamic_sprite_shader_normalmap_texture_index  = shader_get_sampler_index(shd_mrt_deferred_lighting_dynamic_sprite, "gm_NormalTexture");
mrt_deferred_lighting_dynamic_sprite_shader_specularmap_texture_index  = shader_get_sampler_index(shd_mrt_deferred_lighting_dynamic_sprite, "gm_SpecularTexture");

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

point_light_shader_light_layers_index = shader_get_uniform(shd_point_light_blend, "in_Light_Layers");

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

spot_light_shader_light_layers_index = shader_get_uniform(shd_spot_light_blend, "in_Light_Layers");

spot_light_shader_normalmap_texture_index  = shader_get_sampler_index(shd_spot_light_blend, "gm_NormalTexture");
spot_light_shader_shadows_texture_index  = shader_get_sampler_index(shd_spot_light_blend, "gm_ShadowTexture");

// Point Light Shadow Shader Indexes
point_light_and_spot_light_shadow_shader_light_source_radius_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_LightSource_Radius");
point_light_and_spot_light_shadow_shader_light_source_position_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_LightSource_Position");

point_light_and_spot_light_shadow_shader_collider_center_position_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_ColliderCenter_Position");
point_light_and_spot_light_shadow_shader_collider_scale_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_Collider_Scale");
point_light_and_spot_light_shadow_shader_collider_rotation_index = shader_get_uniform(shd_point_light_and_spot_light_shadows, "in_Collider_Rotation");

// Directional Light Blend Shader Indexes
directional_light_shader_light_source_vector_index = shader_get_uniform(shd_directional_light_blend, "in_LightSource_Vector");

directional_light_shader_light_layers_index = shader_get_uniform(shd_directional_light_blend, "in_Light_Layers");

directional_light_shader_highlight_strength_multiplier_index = shader_get_uniform(shd_directional_light_blend, "in_HighLight_Strength_Multiplier");
directional_light_shader_broadlight_strength_multiplier_index = shader_get_uniform(shd_directional_light_blend, "in_BroadLight_Strength_Multiplier");
directional_light_shader_highlight_to_broadlight_ratio_max_index = shader_get_uniform(shd_directional_light_blend, "in_HighLight_To_BroadLight_Ratio_Max");

directional_light_shader_normalmap_texture_index  = shader_get_sampler_index(shd_directional_light_blend, "gm_NormalTexture");

// Directional Light Shadow Shader Indexes
directional_light_shadow_shader_light_source_radius_index = shader_get_uniform(shd_directional_light_shadows, "in_LightSource_Radius");
directional_light_shadow_shader_light_source_vector_index = shader_get_uniform(shd_directional_light_shadows, "in_LightSource_Vector");

directional_light_shadow_shader_collider_center_position_index = shader_get_uniform(shd_directional_light_shadows, "in_ColliderCenter_Position");
directional_light_shadow_shader_collider_scale_index = shader_get_uniform(shd_directional_light_shadows, "in_Collider_Scale");
directional_light_shadow_shader_collider_rotation_index = shader_get_uniform(shd_directional_light_shadows, "in_Collider_Rotation");

// Ambient Occlusion Light Blend Shader Indexes
ambient_light_shader_surface_size_index = shader_get_uniform(shd_ambient_occlusion_light_blend, "in_SurfaceSize");

ambient_light_shader_light_color_index = shader_get_uniform(shd_ambient_occlusion_light_blend, "in_LightColor");
ambient_light_shader_light_intensity_index = shader_get_uniform(shd_ambient_occlusion_light_blend, "in_LightIntensity");

// Final Render Pass Lighting Shader Indexes
final_render_lighting_shader_diffusemap_back_layer_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_DiffuseMap_BackLayer_Texture");
final_render_lighting_shader_diffusemap_front_layer_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_DiffuseMap_FrontLayer_Texture");

final_render_lighting_shader_lightblend_back_layer_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_LightBlend_BackLayer_Texture");
final_render_lighting_shader_lightblend_mid_layer_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_LightBlend_MidLayer_Texture");
final_render_lighting_shader_lightblend_front_layer_texture_index  = shader_get_sampler_index(shd_final_render_lighting, "gm_LightBlend_FrontLayer_Texture");

// Lighting Directional Shadows Variables
directional_light_collisions_exist = false;
directional_light_collisions_list = ds_list_create();

// Layers
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

// Lighting Engine Layer Types
enum LightingEngineRenderLayerType
{
	Back,
	Mid,
	Front
}

// Lighting Engine Sub Layer Types
enum LightingEngineSubLayerType
{
	Dynamic,
	BulkStatic
}

// Lighting Engine Object Types
enum LightingEngineObjectType
{
	Default,
    Basic,
    Dynamic,
    Unit
}

// Lighting Engine Layer Methods: Add Sub Layer Behaviours
add_sub_layer = function(sub_layer_name, sub_layer_depth, sub_layer_type, render_layer_type)
{
	// Clamp Layer Depth
    var temp_sub_layer_depth = clamp(sub_layer_depth, -1, 1);
    
	// Add Sub Layer based on Render Layer Type
	switch (render_layer_type)
	{
		case LightingEngineRenderLayerType.Back:
			// Check if Sub Layer already exists
			if (ds_list_find_index(lighting_engine_back_layer_sub_layer_name_list, sub_layer_name) != -1)
			{
				// Unsuccessfully added Sub Layer because a sub layer with the given name already exists - Return False
				return false;
			}
			
			// Find Index based on Layer Depth
			for (var i = 0; i < ds_list_size(lighting_engine_back_layer_sub_layer_depth_list); i++)
			{
				var temp_check_sub_layer_depth = ds_list_find_value(lighting_engine_back_layer_sub_layer_depth_list, i);
				
				if (temp_sub_layer_depth < temp_check_sub_layer_depth)
		        {
		        	// Add Sub Layer's Name, Depth, and Type
		        	ds_list_insert(lighting_engine_back_layer_sub_layer_name_list, i, sub_layer_name);
    				ds_list_insert(lighting_engine_back_layer_sub_layer_depth_list, i, temp_sub_layer_depth);
    				ds_list_insert(lighting_engine_back_layer_sub_layer_type_list, i, sub_layer_type);
    				
    				// Add Sub Layer Object and Object Type Lists
    				ds_list_insert(lighting_engine_back_layer_sub_layer_object_list, i, ds_list_create());
    				ds_list_mark_as_list(lighting_engine_back_layer_sub_layer_object_list, i);
    				
    				ds_list_insert(lighting_engine_back_layer_sub_layer_object_type_list, i, ds_list_create());
    				ds_list_mark_as_list(lighting_engine_back_layer_sub_layer_object_type_list, i);
		            break;
		        }
			}
			break;
		case LightingEngineRenderLayerType.Front:
			// Check if Sub Layer already exists
			if (ds_list_find_index(lighting_engine_front_layer_sub_layer_name_list, sub_layer_name) != -1)
			{
				// Unsuccessfully added Sub Layer because a sub layer with the given name already exists - Return False
				return false;
			}
			
			// Find Index based on Layer Depth
			for (var i = 0; i < ds_list_size(lighting_engine_front_layer_sub_layer_depth_list); i++)
			{
				var temp_check_sub_layer_depth = ds_list_find_value(lighting_engine_front_layer_sub_layer_depth_list, i);
				
				if (temp_sub_layer_depth < temp_check_sub_layer_depth)
		        {
		        	// Add Sub Layer's Name, Depth, and Type
		        	ds_list_insert(lighting_engine_front_layer_sub_layer_name_list, i, sub_layer_name);
    				ds_list_insert(lighting_engine_front_layer_sub_layer_depth_list, i, temp_sub_layer_depth);
    				ds_list_insert(lighting_engine_front_layer_sub_layer_type_list, i, sub_layer_type);
    				
    				// Add Sub Layer Object and Object Type Lists
    				ds_list_insert(lighting_engine_front_layer_sub_layer_object_list, i, ds_list_create());
    				ds_list_mark_as_list(lighting_engine_front_layer_sub_layer_object_list, i);
    				
    				ds_list_insert(lighting_engine_front_layer_sub_layer_object_type_list, i, ds_list_create());
    				ds_list_mark_as_list(lighting_engine_front_layer_sub_layer_object_type_list, i);
		            break;
		        }
			}
			break;
		case LightingEngineRenderLayerType.Mid:
		default:
			// Check if Sub Layer already exists
			if (ds_list_find_index(lighting_engine_mid_layer_sub_layer_name_list, sub_layer_name) != -1)
			{
				// Unsuccessfully added Sub Layer because a sub layer with the given name already exists - Return False
				return false;
			}
			
			// Find Index based on Layer Depth
			for (var i = 0; i < ds_list_size(lighting_engine_mid_layer_sub_layer_depth_list); i++)
			{
				var temp_check_sub_layer_depth = ds_list_find_value(lighting_engine_mid_layer_sub_layer_depth_list, i);
				
				if (temp_sub_layer_depth < temp_check_sub_layer_depth)
		        {
		        	// Add Sub Layer's Name, Depth, and Type
		        	ds_list_insert(lighting_engine_mid_layer_sub_layer_name_list, i, sub_layer_name);
    				ds_list_insert(lighting_engine_mid_layer_sub_layer_depth_list, i, temp_sub_layer_depth);
    				ds_list_insert(lighting_engine_mid_layer_sub_layer_type_list, i, sub_layer_type);
    				
    				// Add Sub Layer Object and Object Type Lists
    				ds_list_insert(lighting_engine_mid_layer_sub_layer_object_list, i, ds_list_create());
    				ds_list_mark_as_list(lighting_engine_mid_layer_sub_layer_object_list, i);
    				
    				ds_list_insert(lighting_engine_mid_layer_sub_layer_object_type_list, i, ds_list_create());
    				ds_list_mark_as_list(lighting_engine_mid_layer_sub_layer_object_type_list, i);
		            break;
		        }
			}
			break;
	}
	
	// Successfully added Sub Layer - Return True
	return true;
}

// Lighting Engine Layer Methods: Remove Sub Layer Behaviours
remove_object_from_sub_layer = function(sub_layer_object_list, sub_layer_object_type_list, sub_layer_object_index)
{
	// Find Object and Object Type from given Sub Layer Object and Object Type DS Lists at the Sub Layer Object Index
	var temp_sub_layer_object = ds_list_find_value(sub_layer_object_list, sub_layer_object_index);
	var temp_sub_layer_object_type = ds_list_find_value(sub_layer_object_type_list, sub_layer_object_index);
	
	// Properly Delete the given Object based on the Object's Type
	switch (temp_sub_layer_object_type)
	{
		case LightingEngineObjectType.Default:
		default:
			// Default Object Type Condition: Destroy Game Object
			instance_destroy(temp_sub_layer_object);
			break;
	}
	
	// Remove Object and Object Type at Index within Sub Layer DS Lists
	ds_list_delete(sub_layer_object_list, sub_layer_object_index);
	ds_list_delete(sub_layer_object_type_list, sub_layer_object_index);
}

remove_all_objects_from_sub_layer = function(sub_layer_object_list, sub_layer_object_type_list)
{
	// Iterate through entire Sub Layer Object and Object Type DS Lists and delete every index
	for (var i = ds_list_size(sub_layer_object_list) - 1; i >= 0; i--)
	{
		remove_object_from_sub_layer(sub_layer_object_list, sub_layer_object_type_list, i);
	}
}

remove_sub_layer = function(sub_layer_name)
{
	// Establish Check Boolean if Sub Layer was successfully removed
	var temp_sub_layer_was_removed = false;
	
	// Attempt to remove Sub Layer from Back Render Layer Organizational DS Lists
	var temp_back_render_layer_sub_layer_index = ds_list_find_index(lighting_engine_back_layer_sub_layer_name_list, sub_layer_name);
	
	if (temp_back_render_layer_sub_layer_index != -1)
	{
		// Find Sub Layer Object and Object Type DS Lists to Delete
		var temp_back_render_layer_sub_layer_object_list_to_delete = ds_list_find_value(lighting_engine_back_layer_sub_layer_object_list, temp_back_render_layer_sub_layer_index);
		var temp_back_render_layer_sub_layer_object_type_list_to_delete = ds_list_find_value(lighting_engine_back_layer_sub_layer_object_type_list, temp_back_render_layer_sub_layer_index);
		
		// Delete all Objects on Sub Layer
		remove_all_objects_from_sub_layer(temp_back_render_layer_sub_layer_object_list_to_delete, temp_back_render_layer_sub_layer_object_type_list_to_delete);
		
		// Delete Sub Layer Object and Object Type DS Lists
		ds_list_destroy(temp_back_render_layer_sub_layer_object_list_to_delete);
		ds_list_delete(lighting_engine_back_layer_sub_layer_object_list, temp_back_render_layer_sub_layer_index);
		
		ds_list_destroy(temp_back_render_layer_sub_layer_object_type_list_to_delete);
		ds_list_delete(lighting_engine_back_layer_sub_layer_object_type_list, temp_back_render_layer_sub_layer_index);
		
		// Delete Indexed Sub Layer Properties (Name, Depth, and Type)
		ds_list_delete(lighting_engine_back_layer_sub_layer_name_list, temp_back_render_layer_sub_layer_index);
		ds_list_delete(lighting_engine_back_layer_sub_layer_depth_list, temp_back_render_layer_sub_layer_index);
		ds_list_delete(lighting_engine_back_layer_sub_layer_type_list, temp_back_render_layer_sub_layer_index);
		
		// Toggle boolean to indicate that a Sub Layer was successfully removed
		temp_sub_layer_was_removed = true;
	}
	
	// Attempt to remove Sub Layer from Mid Render Layer Organizational DS Lists
	var temp_mid_render_layer_sub_layer_index = ds_list_find_index(lighting_engine_mid_layer_sub_layer_name_list, sub_layer_name);
	
	if (temp_mid_render_layer_sub_layer_index != -1)
	{
		// Find Sub Layer Object and Object Type DS Lists to Delete
		var temp_mid_render_layer_sub_layer_object_list_to_delete = ds_list_find_value(lighting_engine_mid_layer_sub_layer_object_list, temp_mid_render_layer_sub_layer_index);
		var temp_mid_render_layer_sub_layer_object_type_list_to_delete = ds_list_find_value(lighting_engine_mid_layer_sub_layer_object_type_list, temp_mid_render_layer_sub_layer_index);
		
		// Delete all Objects on Sub Layer
		remove_all_objects_from_sub_layer(temp_mid_render_layer_sub_layer_object_list_to_delete, temp_mid_render_layer_sub_layer_object_type_list_to_delete);
		
		// Delete Sub Layer Object and Object Type DS Lists
		ds_list_destroy(temp_mid_render_layer_sub_layer_object_list_to_delete);
		ds_list_delete(lighting_engine_mid_layer_sub_layer_object_list, temp_mid_render_layer_sub_layer_index);
		
		ds_list_destroy(temp_mid_render_layer_sub_layer_object_type_list_to_delete);
		ds_list_delete(lighting_engine_mid_layer_sub_layer_object_type_list, temp_mid_render_layer_sub_layer_index);
		
		// Delete Indexed Sub Layer Properties (Name, Depth, and Type)
		ds_list_delete(lighting_engine_mid_layer_sub_layer_name_list, temp_mid_render_layer_sub_layer_index);
		ds_list_delete(lighting_engine_mid_layer_sub_layer_depth_list, temp_mid_render_layer_sub_layer_index);
		ds_list_delete(lighting_engine_mid_layer_sub_layer_type_list, temp_mid_render_layer_sub_layer_index);
		
		// Toggle boolean to indicate that a Sub Layer was successfully removed
		temp_sub_layer_was_removed = true;
	}
	
	// Attempt to remove Sub Layer from Front Render Layer Organizational DS Lists
	var temp_front_render_layer_sub_layer_index = ds_list_find_index(lighting_engine_front_layer_sub_layer_name_list, sub_layer_name);
	
	if (temp_front_render_layer_sub_layer_index != -1)
	{
		// Find Sub Layer Object and Object Type DS Lists to Delete
		var temp_front_render_layer_sub_layer_object_list_to_delete = ds_list_find_value(lighting_engine_front_layer_sub_layer_object_list, temp_front_render_layer_sub_layer_index);
		var temp_front_render_layer_sub_layer_object_type_list_to_delete = ds_list_find_value(lighting_engine_front_layer_sub_layer_object_type_list, temp_front_render_layer_sub_layer_index);
		
		// Delete all Objects on Sub Layer
		remove_all_objects_from_sub_layer(temp_front_render_layer_sub_layer_object_list_to_delete, temp_front_render_layer_sub_layer_object_type_list_to_delete);
		
		// Delete Sub Layer Object and Object Type DS Lists
		ds_list_destroy(temp_front_render_layer_sub_layer_object_list_to_delete);
		ds_list_delete(lighting_engine_front_layer_sub_layer_object_list, temp_front_render_layer_sub_layer_index);
		
		ds_list_destroy(temp_front_render_layer_sub_layer_object_type_list_to_delete);
		ds_list_delete(lighting_engine_front_layer_sub_layer_object_type_list, temp_front_render_layer_sub_layer_index);
		
		// Delete Indexed Sub Layer Properties (Name, Depth, and Type)
		ds_list_delete(lighting_engine_front_layer_sub_layer_name_list, temp_front_render_layer_sub_layer_index);
		ds_list_delete(lighting_engine_front_layer_sub_layer_depth_list, temp_front_render_layer_sub_layer_index);
		ds_list_delete(lighting_engine_front_layer_sub_layer_type_list, temp_front_render_layer_sub_layer_index);
		
		// Toggle boolean to indicate that a Sub Layer was successfully removed
		temp_sub_layer_was_removed = true;
	}
	
	// Return Boolean if successfully removed a Sub Layer that matched the given Sub Layer Name
	return temp_sub_layer_was_removed;
}

// Lighting Engine Layer Method: Clear and Reset All Sub Layers
clear_all_sub_layers = function()
{
	// Iterate through and delete all Sub Layers
	for (var temp_back_layer_names_index = ds_list_size(lighting_engine_back_layer_sub_layer_name_list) - 1; temp_back_layer_names_index >= 0; temp_back_layer_names_index--)
	{
		// Find Layer Name from Index
		var temp_back_layer_name = ds_list_find_value(lighting_engine_back_layer_sub_layer_name_list, temp_back_layer_names_index);
		
		// Remove and Delete Sub Layer
		remove_sub_layer(temp_back_layer_name);
	}
	
	for (var temp_mid_layer_names_index = ds_list_size(lighting_engine_mid_layer_sub_layer_name_list) - 1; temp_mid_layer_names_index >= 0; temp_mid_layer_names_index--)
	{
		// Find Layer Name from Index
		var temp_mid_layer_name = ds_list_find_value(lighting_engine_mid_layer_sub_layer_name_list, temp_mid_layer_names_index);
		
		// Remove and Delete Sub Layer
		remove_sub_layer(temp_mid_layer_name);
	}
	
	for (var temp_front_layer_names_index = ds_list_size(lighting_engine_front_layer_sub_layer_name_list) - 1; temp_front_layer_names_index >= 0; temp_front_layer_names_index--)
	{
		// Find Layer Name from Index
		var temp_front_layer_name = ds_list_find_value(lighting_engine_front_layer_sub_layer_name_list, temp_front_layer_names_index);
		
		// Remove and Delete Sub Layer
		remove_sub_layer(temp_front_layer_name);
	}
	
	// Clear and Reset Sub Layer Organization DS Lists
	ds_list_clear(lighting_engine_back_layer_sub_layer_name_list);
	ds_list_clear(lighting_engine_back_layer_sub_layer_depth_list);
	ds_list_clear(lighting_engine_back_layer_sub_layer_type_list);
	ds_list_clear(lighting_engine_back_layer_sub_layer_object_list);
	ds_list_clear(lighting_engine_back_layer_sub_layer_object_type_list);
	
	ds_list_clear(lighting_engine_mid_layer_sub_layer_name_list);
	ds_list_clear(lighting_engine_mid_layer_sub_layer_depth_list);
	ds_list_clear(lighting_engine_mid_layer_sub_layer_type_list);
	ds_list_clear(lighting_engine_mid_layer_sub_layer_object_list);
	ds_list_clear(lighting_engine_mid_layer_sub_layer_object_type_list);
	
	ds_list_clear(lighting_engine_front_layer_sub_layer_name_list);
	ds_list_clear(lighting_engine_front_layer_sub_layer_depth_list);
	ds_list_clear(lighting_engine_front_layer_sub_layer_type_list);
	ds_list_clear(lighting_engine_front_layer_sub_layer_object_list);
	ds_list_clear(lighting_engine_front_layer_sub_layer_object_type_list);
}

// Lighting Engine Layer Method: Create Default Sub Layers
create_default_sub_layers = function()
{
	lighting_engine_add_layer(LightingEngineDefaultLayer, 0);
}

create_default_sub_layers();

// Lighting Engine Layer Method: Render Sub Layer

