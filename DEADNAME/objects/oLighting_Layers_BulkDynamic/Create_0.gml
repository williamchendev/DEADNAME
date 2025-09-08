/// @description Create Bulk Dynamic Layer
// Creates a Bulk Dynamic Layer

// Disable Visibility
visible = false;

// Disable Default Layer Behaviour
sub_layer_use_default_layer = false;

// Create Bulk Dynamic Layer Vertex Buffer
bulk_dynamic_layer_vertex_buffer = vertex_create_buffer();
bulk_dynamic_layer_vertex_buffer_exists = false;

// Establish Bulk Dynamic Layer Vertex Entries Count & Maximum Size
bulk_dynamic_layer_vertex_entries = 0;
bulk_dynamic_layer_vertex_entries_max = 3000;

// Create Bulk Dynamic Layer Render DS Lists
bulk_dynamic_layer_vertex_coordinate_ax_list = ds_list_create();
bulk_dynamic_layer_vertex_coordinate_ay_list = ds_list_create();

bulk_dynamic_layer_vertex_coordinate_bx_list = ds_list_create();
bulk_dynamic_layer_vertex_coordinate_by_list = ds_list_create();

bulk_dynamic_layer_vertex_coordinate_cx_list = ds_list_create();
bulk_dynamic_layer_vertex_coordinate_cy_list = ds_list_create();

bulk_dynamic_layer_vertex_coordinate_dx_list = ds_list_create();
bulk_dynamic_layer_vertex_coordinate_dy_list = ds_list_create();

bulk_dynamic_layer_image_angle_list = ds_list_create();

bulk_dynamic_layer_image_xscale_list = ds_list_create();
bulk_dynamic_layer_image_yscale_list = ds_list_create();

bulk_dynamic_layer_normal_strength_list = ds_list_create();

bulk_dynamic_layer_image_blend_list = ds_list_create();

bulk_dynamic_layer_image_alpha_list = ds_list_create();

bulk_dynamic_layer_diffusemap_uvs_list = ds_list_create();
bulk_dynamic_layer_normalmap_uvs_list = ds_list_create();
bulk_dynamic_layer_metallicroughnessmap_uvs_list = ds_list_create();
bulk_dynamic_layer_emissivemap_uvs_list = ds_list_create();

bulk_dynamic_layer_metallic_list = ds_list_create();
bulk_dynamic_layer_roughness_list = ds_list_create();
bulk_dynamic_layer_emissive_list = ds_list_create();
bulk_dynamic_layer_emissive_multiplier_list = ds_list_create();

// Establish Bulk Dynamic Texture
bulk_dynamic_layer_texture = sprite_get_texture(sDebug_Lighting_Layers_BulkDynamic, 0);

// Establish Bulk Dynamic Layer Vertex Buffer Recompile Toggle
bulk_dynamic_layer_vertex_buffer_recompile = false;

// Establish Render Layer
var temp_render_layer_type = LightingEngineRenderLayerType.Mid;

switch (render_layer_type)
{
	case -1:
		temp_render_layer_type = LightingEngineRenderLayerType.Back;
		break;
	case 1:
		temp_render_layer_type = LightingEngineRenderLayerType.Front;
		break;
	case 0:
	default:
		break;
}

// Create Sub-Layer
var temp_sub_layer_name = sub_layer_name == LightingEngineUseGameMakerLayerName ? layer_get_name(layer) : sub_layer_name;
lighting_engine_create_sub_layer(temp_sub_layer_name, sub_layer_depth, LightingEngineSubLayerType.BulkStatic, temp_render_layer_type);

// Update BulkDynamic Layer's Sub-Layer Name
sub_layer_name = temp_sub_layer_name;

// Adds Bulk Dynamic Layer Object to Lighting Engine
if (LightingEngine.lighting_engine_worker != -1 and instance_exists(LightingEngine.lighting_engine_worker))
{
    // Add Bulk Dynamic Layer Object to Lighting Engine Worker to add to Layer after they have been initialized
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_object_list, id);
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_type_list, LightingEngineObjectType.BulkDynamic_Layer);
}
else
{
    // Add Bulk Dynamic Layer Object to Sub Layer by Sub-Layer Name
    var temp_successfully_added_object = lighting_engine_add_object(id, LightingEngineObjectType.BulkDynamic_Layer, sub_layer_name);
    
    // Debug Flag - Unsuccessfully added Bulk Dynamic Layer Object to Lighting Engine Sub-Layer
    if (!temp_successfully_added_object)
    {
        show_debug_message($"Debug Warning! - Unsuccessfully added Bulk Dynamic Layer Object \"{object_get_name(object_index)}\" to Lighting Engine Sub Layer with name \"{sub_layer_name}\"");
        instance_destroy();
        return;
    }
}
