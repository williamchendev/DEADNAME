/// @description Hitmarker Miss Combat Action Initialization
// Initializes the Hitmarker Miss Combat Action for Celestial Simulator Behaviour and Rendering

// Hitmarker Combat Action Initialization Behaviour
event_inherited();

// Set Hitmarker's Image Index
image_index = irandom(sprite_get_number(sprite_index) - 1);

// Set Hitmarker's Rotation
image_angle = 0;

// Set Hitmarker's Horizontal and Vertical Facing Directions
image_xscale = random(1.0) > 0.5 ? 1 : -1;
image_yscale = 1;

