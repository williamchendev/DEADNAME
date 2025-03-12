/// @description Kiva Rumford Fireplace Init Event
// Creates the Fireplace's Fire

// Inherited Event
event_inherited();

// Establish Variables
var temp_sub_layer_name = sub_layer_name;

// Create Fire
fireplace_flame = instance_create_depth
(
	x + 2, 
	y - 14, 
	depth,
	oFlameEntity_Small,
	{
		sub_layer_name: temp_sub_layer_name,
		sub_layer_use_default_layer: false
	}
);

fireplace_flame.point_light_source.point_light_render_background_layer = false;
fireplace_flame.point_light_source.point_light_render_foreground_layer = false;
