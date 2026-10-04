/// @description Hitmarker Hit Combat Action Initialization
// Initializes the Hitmarker Hit Combat Action for Celestial Simulator Behaviour and Rendering

// Prop Combat Action Initialization Behaviour
event_inherited();

// Set Hitmarker's Image Index
image_index = irandom(sprite_get_number(sprite_index) - 1);

// Set Hitmarker's Rotation
image_angle = random(360);

// Set Hitmarker's Horizontal and Vertical Facing Directions
image_xscale = random(1.0) > 0.5 ? 1 : -1;
image_yscale = random(1.0) > 0.5 ? 1 : -1;

