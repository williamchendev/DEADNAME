/// @description Insert description here
// You can write your code in this editor

if (keyboard_check_pressed(ord("I")))
{
	instance_create_depth(mouse_x + LightingEngine.render_x, mouse_y + LightingEngine.render_y, 0, oExplosion_Entity);
}
