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
		render_layer_type: -1
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

// Create Background
instance_create_depth
(
	x, 
	y,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_AdobeHouseBack, 
	{
		sub_layer_name: temp_back_layer_name,
	}
);

// Create Kiva Rumford Fireplace
instance_create_depth
(
	x - 138, 
	y - 78,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_KivaRumfordFireplace, 
	{
		sub_layer_name: temp_back_layer_name,
	}
);

// Create Bed
instance_create_depth
(
	x - 81, 
	y - 76,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_Bed, 
	{
		sub_layer_name: temp_back_layer_name,
	}
);

// Create Book Shelf
instance_create_depth
(
	x - 11, 
	y - 77,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_BookShelf, 
	{
		sub_layer_name: temp_back_layer_name,
	}
);

// Create Drawers
instance_create_depth
(
	x + 80, 
	y - 42,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_Drawers, 
	{
		sub_layer_name: temp_back_layer_name,
	}
);

// Create Wood Corbels
instance_create_depth
(
	x - 145, 
	y - 171,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_WoodCorbel, 
	{
		sub_layer_name: temp_back_layer_name,
	}
);

instance_create_depth
(
	x - 88, 
	y - 173,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_WoodCorbel, 
	{
		sub_layer_name: temp_back_layer_name,
	}
);

instance_create_depth
(
	x - 34, 
	y - 176,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_WoodCorbel, 
	{
		sub_layer_name: temp_back_layer_name,
	}
);

instance_create_depth
(
	x + 21, 
	y - 178,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_WoodCorbel, 
	{
		sub_layer_name: temp_back_layer_name,
	}
);

instance_create_depth
(
	x + 72, 
	y - 147,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_WoodCorbel, 
	{
		sub_layer_name: temp_back_layer_name,
	}
);

// Create Painting
instance_create_depth
(
	x - 79, 
	y - 128,
	depth, 
	oEnvironment_AdobeHouse_Dynamic_HorsesPainting, 
	{
		sub_layer_name: temp_back_layer_name,
	}
);

// Inherit the parent event
event_inherited();

// Create Front Passthrough
var temp_image_xscale = image_xscale;

house_front = instance_create_depth
(
	x, 
	y, 
	depth, 
	oEnvironment_AdobeHouse_Dynamic_AdobeHouseFrontPassthrough, 
	{
		sub_layer_name: temp_back_layer_name,
		image_xscale: temp_image_xscale
	}
);

// Create Door
house_door = instance_create_depth
(
	x + (sign(image_xscale) * 150), 
	y - 81, depth, 
	oEnvironment_AdobeHouse_Dynamic_AdobeHouseDoor,
	{
		sub_layer_name: temp_back_layer_name,
		image_xscale: temp_image_xscale
	}
);

// Create Ladder
house_ladder = instance_create_depth
(
	x - 217, 
	y + 3, 
	depth, 
	oEnvironment_AdobeHouse_Dynamic_Ladder,
	{
		sub_layer_name: temp_front_layer_name,
		image_xscale: temp_image_xscale
	}
);
