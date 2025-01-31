/// @description Create Layer
// Creates a Layer and destroys its Instance

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

// Create Sub Layer
var temp_sub_layer_name = sub_layer_name == LightingEngineUseGameMakerLayerName ? layer_get_name(layer) : sub_layer_name;
lighting_engine_create_sub_layer(temp_sub_layer_name, sub_layer_depth, LightingEngineSubLayerType.BulkStatic, temp_render_layer_type);

// Index Bulk Static Layer in Lighting Engine Worker if Creation Event is Toggled
if (create_bulk_static_from_layer)
{
	ds_list_add(LightingEngine.lighting_engine_worker.bulk_static_layers_list, temp_sub_layer_name);
}

// Destroy Instance
instance_destroy();
