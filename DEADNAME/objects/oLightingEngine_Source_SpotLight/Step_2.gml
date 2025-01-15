/// @description Insert description here
// You can write your code in this editor

//
spot_light_fov = clamp(spot_light_fov, 0, 360);

//
spot_light_render_enabled = rectangle_in_circle
(
    LightingEngine.render_x - LightingEngine.render_border, 
    LightingEngine.render_y - LightingEngine.render_border, 
    LightingEngine.render_x + GameManager.game_width + LightingEngine.render_border, 
    LightingEngine.render_y + GameManager.game_height + LightingEngine.render_border,
    x,
    y,
    spot_light_radius
);

//
if (spot_light_render_enabled)
{
    //
    var temp_point_light_changed = (spot_light_radius != old_spot_light_radius) or (x != old_spot_light_position_x) or (y != old_spot_light_position_y) or (image_angle != old_spot_light_angle) or (spot_light_fov != old_spot_light_fov);
    
    if (temp_point_light_changed)
    {
		//
		ds_list_clear(spot_light_collisions_list);
		
		//
		collision_circle_list(x, y, spot_light_radius, oSolid, false, false, spot_light_collisions_list, false);
    }
    
    //
    old_spot_light_radius = spot_light_radius;
    old_spot_light_position_x = x;
    old_spot_light_position_y = y;
    old_spot_light_angle = image_angle;
	old_spot_light_fov = spot_light_fov;
}