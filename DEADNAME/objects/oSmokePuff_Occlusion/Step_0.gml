/// @description Insert description here
// You can write your code in this editor

// Smoke Puff Size
var temp_smokepuff_width = sprite_get_width(colors_sprite_index);
var temp_smokepuff_height = sprite_get_height(colors_sprite_index);

// Index Colliding Unit Objects
unit_collision_num = 0;
if (!ds_list_empty(unit_collision_list)) {
	ds_list_clear(unit_collision_list);
}

if (collision_rectangle(x - temp_smokepuff_width, y - temp_smokepuff_height, x + temp_smokepuff_width, y + temp_smokepuff_height, oUnit, false, false) != noone) {
	unit_collision_num = collision_rectangle_list(x - temp_smokepuff_width, y - temp_smokepuff_height, x + temp_smokepuff_width, y + temp_smokepuff_height, oUnit, false, false, unit_collision_list, false);
}

// Movement Behaviour
event_inherited();