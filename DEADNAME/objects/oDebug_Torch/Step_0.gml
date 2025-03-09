/// @description Insert description here
// You can write your code in this editor

x = mouse_x + LightingEngine.render_x - 50;
y = mouse_y + LightingEngine.render_y - 50;

flame_entity.x = x - 1;
flame_entity.y = y - 7;

// DEBUG DISTORTION
if (mouse_check_button_pressed(mb_left))
{
    lighting_engine_create_distortion(sDistortionNormal_Shockwave_Ball, 0, x, y, 0.15, 0.15, 0, 1);
}
