/// @description Insert description here
// Draws the unit to the screen

// Lighting Draw Behaviour
var temp_skip_gui = false;
var temp_skip_sprite = false;

// Draw Unit Sprite
draw_sprite_ext(sprite_index, image_index, x, y - ((sin(degtorad(slope_angle)) * (bbox_left - bbox_right)) / 2), draw_xscale * image_xscale, draw_yscale, slope_angle, draw_color, image_alpha);






