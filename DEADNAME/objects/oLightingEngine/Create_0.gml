/// @description LIGHTING ENGINE INIT EVENT
// Self-Creating Lighting Engine Init Behaviour Event

// Global Lighting Engine Properties
#macro LightingEngine global.lighting_engine
#macro LightingEngineUnitLayer "main"

// Enums
enum LightingEngineLitObjectType
{
    Basic,
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
application_surface_enable(false);
application_surface_draw_enable(false);

// Renders
render_x = 0;
render_y = 0;

// Layers
lighting_engine_layer_name_list = ds_list_create();
lighting_engine_layer_object_list = ds_list_create();
lighting_engine_layer_depth_list = ds_list_create();

lighting_engine_layer_main_index = -1;

// Surfaces
diffuse_color_surface = -1;
normalmap_color_surface = -1;
depth_specular_stencil_surface = -1;

// Shader Indexes
mrt_rendering_shader_normal_map_index  = shader_get_sampler_index(shd_mrt_deferredlighting_render_sprite, "normalMapTex");
mrt_rendering_shader_specular_map_index  = shader_get_sampler_index(shd_mrt_deferredlighting_render_sprite, "specularMap");