/// @description Adobe House Init
// Creates the variables and settings of the Adobe House

// Settings
alpha_lerp_spd = 0.1;

// Variables
alpha_value = 1;

// Inherit the parent event
event_inherited();

// Create Front Passthrough
var temp_front = instance_create_layer(x, y, layer, oAdobeHouse_FrontPassthrough);
temp_front.image_xscale = image_xscale;
temp_front.depth = 0;

// Create Door
var temp_front = instance_create_layer(x + (sign(image_xscale) * 150), y - 81, layer, oAdobeHouse_Door);
temp_front.image_xscale = image_xscale;
temp_front.depth = -1;