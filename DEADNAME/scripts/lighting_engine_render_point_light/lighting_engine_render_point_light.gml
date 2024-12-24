

function lighting_engine_render_point_light(point_light_x, point_light_y, point_light_radius, point_light_color) 
{
    shader_set_uniform_f(LightingEngine.point_light_shader_radius_index, point_light_radius);
    shader_set_uniform_f(LightingEngine.point_light_shader_centerpoint_index, point_light_x, point_light_y);
    
    draw_set_color(point_light_color);
    
    draw_circle(point_light_x, point_light_y, point_light_radius, false);
}