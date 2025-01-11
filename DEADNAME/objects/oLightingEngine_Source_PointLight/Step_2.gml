/// @description Insert description here
// You can write your code in this editor

//
point_light_render_enabled = rectangle_in_rectangle
(
    x - point_light_radius, 
    y - point_light_radius, 
    x + point_light_radius, 
    y + point_light_radius, 
    LightingEngine.render_x - LightingEngine.render_border, 
    LightingEngine.render_y - LightingEngine.render_border, 
    LightingEngine.render_x + GameManager.game_width + LightingEngine.render_border, 
    LightingEngine.render_y + GameManager.game_height + LightingEngine.render_border
);

//
if (point_light_render_enabled)
{
    //
    var temp_point_light_changed = (point_light_radius != old_point_light_radius) or (x != old_point_light_position_x) or (y != old_point_light_position_y);
    
    if (temp_point_light_changed)
    {
		//
		ds_list_clear(point_light_collisions_list);
		
		//
        collision_circle_list(x, y, point_light_radius, oSolid, false, false, point_light_collisions_list, false);
    }
    
    //
    old_point_light_radius = point_light_radius;
    old_point_light_position_x = x;
    old_point_light_position_y = y;
}