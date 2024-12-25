

function lighting_engine_render_point_light(point_light_x, point_light_y, point_light_radius, point_light_color) 
{
    shader_set_uniform_f(LightingEngine.point_light_shader_radius_index, point_light_radius);
    shader_set_uniform_f(LightingEngine.point_light_shader_centerpoint_index, point_light_x, point_light_y);
    
    draw_set_color(point_light_color);
    
    draw_primitive_begin(pr_trianglestrip);
    draw_vertex_texture(point_light_x - point_light_radius, point_light_y - point_light_radius, 0, 0);
    draw_vertex_texture(point_light_x + point_light_radius, point_light_y - point_light_radius, 1, 0);
    draw_vertex_texture(point_light_x - point_light_radius, point_light_y + point_light_radius, 0, 1);
    draw_vertex_texture(point_light_x + point_light_radius, point_light_y + point_light_radius, 1, 1);
    draw_primitive_end();
    
    //draw_sprite_ext(sDebugSystem, 0, point_light_x, point_light_y, (point_light_radius / 48), (point_light_radius / 48), 0, c_white, 1);
    //draw_rectangle(point_light_x - point_light_radius, point_light_y - point_light_radius, point_light_x + point_light_radius, point_light_y + point_light_radius, false);
    //draw_circle(point_light_x, point_light_y, point_light_radius, false);
}