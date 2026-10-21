/// @description Adobe House Init
// Creates the variables and settings of the Adobe House

// Create Dynamic Layers for Adobe House
var temp_back_layer_name = "AdobeHouse_Background_Layer";
var temp_front_layer_name = "AdobeHouse_Foreground_Layer";

instance_create_depth
(
	x, 
	y, 
	depth, 
	oLighting_Layers_Dynamic, 
	{
		sub_layer_name: temp_back_layer_name,
		sub_layer_depth: -0.1,
		render_layer_type: 0
	}
);

instance_create_depth
(
	x, 
	y, 
	depth, 
	oLighting_Layers_Dynamic, 
	{
		sub_layer_name: temp_front_layer_name,
		sub_layer_depth: 0.1,
		render_layer_type: 1
	}
);

// Set Sub-Layer Name
sub_layer_name = temp_front_layer_name;

// Set Image
sprite_index = sAdobeHouse_Front_DiffuseMap;

// Settings
alpha_lerp_spd = 0.1;

// Variables
alpha_value = 1;

// Create Adobe House Instantiation Structs
var temp_dynamic_object_environment_backlayer_struct =
{
	sub_layer_name: temp_back_layer_name,
	image_xscale: image_xscale
};

// Create Background
instance_create_depth
(
	x, 
	y,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_AdobeHouseBack, 
	temp_dynamic_object_environment_backlayer_struct
);

// Create Kiva Rumford Fireplace
instance_create_depth
(
	x - (sign(image_xscale) * 138), 
	y - 78,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_KivaRumfordFireplace, 
	temp_dynamic_object_environment_backlayer_struct
);

// Create Bed
instance_create_depth
(
	x - (sign(image_xscale) * 81), 
	y - 76,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_Bed, 
	temp_dynamic_object_environment_backlayer_struct
);

// Create Book Shelf
instance_create_depth
(
	x - (sign(image_xscale) * 11), 
	y - 77,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_BookShelf, 
	temp_dynamic_object_environment_backlayer_struct
);

// Create Drawers
instance_create_depth
(
	x + (sign(image_xscale) * 80), 
	y - 42,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_Drawers, 
	temp_dynamic_object_environment_backlayer_struct
);

// Create Wood Corbels
instance_create_depth
(
	x - (sign(image_xscale) * 145), 
	y - 171,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_WoodCorbel, 
	temp_dynamic_object_environment_backlayer_struct
);

instance_create_depth
(
	x - (sign(image_xscale) * 88), 
	y - 173,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_WoodCorbel, 
	temp_dynamic_object_environment_backlayer_struct
);

instance_create_depth
(
	x - (sign(image_xscale) * 34), 
	y - 176,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_WoodCorbel, 
	temp_dynamic_object_environment_backlayer_struct
);

instance_create_depth
(
	x + (sign(image_xscale) * 21), 
	y - 178,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_WoodCorbel, 
	temp_dynamic_object_environment_backlayer_struct
);

instance_create_depth
(
	x + (sign(image_xscale) * 72), 
	y - 147,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_WoodCorbel, 
	temp_dynamic_object_environment_backlayer_struct
);

// Create Painting
instance_create_depth
(
	x - (sign(image_xscale) * 79), 
	y - 128,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_HorsesPainting, 
	temp_dynamic_object_environment_backlayer_struct
);

// Inherit the parent event
event_inherited();

// Create Front Passthrough
house_front = instance_create_depth
(
	x, 
	y, 
	depth, 
	oEnvironment_AdobeHouse_Dynamic_AdobeHouseFrontPassthrough, 
	temp_dynamic_object_environment_backlayer_struct
);

// Create Door
house_door = instance_create_depth
(
	x + (sign(image_xscale) * 150), 
	y - 81, 
	depth, 
	oEnvironment_AdobeHouse_Dynamic_AdobeHouseDoor,
	temp_dynamic_object_environment_backlayer_struct
);

// Create Ladder
house_ladder = instance_create_depth
(
	x - (sign(image_xscale) * 217), 
	y + 3, 
	depth, 
	oEnvironment_AdobeHouse_Dynamic_Ladder,
	temp_dynamic_object_environment_backlayer_struct
);
