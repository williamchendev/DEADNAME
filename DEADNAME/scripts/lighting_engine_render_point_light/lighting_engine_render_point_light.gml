

function lighting_engine_render_point_light(point_light_x, point_light_y, point_light_radius, point_light_color) 
{
    // Set Point Light Radius and Center
    shader_set_uniform_f(LightingEngine.point_light_shader_radius_index, point_light_radius);
    shader_set_uniform_f(LightingEngine.point_light_shader_centerpoint_index, point_light_x, point_light_y);
    
    // Set Point Light Color
    draw_set_color(point_light_color);
    
    // Draw Primitive Square by rendering 2 triangles with a side length the size of the radius
    draw_primitive_begin(pr_trianglestrip);
    draw_vertex_texture(point_light_x - point_light_radius, point_light_y - point_light_radius, 0, 0);
    draw_vertex_texture(point_light_x + point_light_radius, point_light_y - point_light_radius, 1, 0);
    draw_vertex_texture(point_light_x - point_light_radius, point_light_y + point_light_radius, 0, 1);
    draw_vertex_texture(point_light_x + point_light_radius, point_light_y + point_light_radius, 1, 1);
    draw_primitive_end();
}