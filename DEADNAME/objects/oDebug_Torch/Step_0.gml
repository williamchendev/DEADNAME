/// @description Insert description here
// You can write your code in this editor

x = mouse_x + LightingEngine.render_x - 50;
y = mouse_y + LightingEngine.render_y - 50;

flame_entity.x = x - 1;
flame_entity.y = y - 7;

// DEBUG DISTORTION
if (mouse_check_button_pressed(mb_left))
{
    instance_create_depth(x, y, depth, oShockwave_DefaultExplosion);
}
