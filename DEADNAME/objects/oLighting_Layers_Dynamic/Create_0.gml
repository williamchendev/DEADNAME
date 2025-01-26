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
LightingEngine.create_sub_layer(sub_layer_name == LightingEngineUseGameMakerLayerName ? layer_get_name(layer) : sub_layer_name, sub_layer_depth, LightingEngineSubLayerType.Dynamic, temp_render_layer_type);

// Destroy Instance
instance_destroy();