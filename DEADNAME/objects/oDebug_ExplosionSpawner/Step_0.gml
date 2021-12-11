/// @description Insert description here
// You can write your code in this editor

if (mouse_check_button_pressed(mb_left)) {
	var temp_explosion_x = mouse_room_x();
	var temp_explosion_y = mouse_room_y();
	instance_create_depth(temp_explosion_x, temp_explosion_y, 0, oExplosion);
}