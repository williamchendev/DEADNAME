/// @description Insert description here
// You can write your code in this editor

//
spot_light_fov = clamp(spot_light_fov, 0, 360);

//
spot_light_render_enabled = rectangle_in_rectangle
(
    x - spot_light_radius, 
    y - spot_light_radius, 
    x + spot_light_radius, 
    y + spot_light_radius, 
    LightingEngine.render_x - LightingEngine.render_border, 
    LightingEngine.render_y - LightingEngine.render_border, 
    LightingEngine.render_x + GameManager.game_width + LightingEngine.render_border, 
    LightingEngine.render_y + GameManager.game_height + LightingEngine.render_border
);

//
if (spot_light_render_enabled)
{
    //
    var temp_point_light_changed = (spot_light_radius != old_spot_light_radius) or (x != old_spot_light_position_x) or (y != old_spot_light_position_y);
    
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
}