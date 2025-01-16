/// @description Box Shadow Init Event
// Initializes Box Shadow Variables

// Dynamic Property
dynamic_shadows = false;

// Center Position
center_xpos = x + lerp(0, rot_point_x(sprite_width, sprite_height, image_angle), 0.5);
center_ypos = y + lerp(0, rot_point_y(sprite_width, sprite_height), 0.5);

// Shadow Vertexes
shadow_vertex_buffer = -1;

// Calculate Shadow Vertex Positions
var shadows_corner_xpos_a = x - center_xpos;
var shadows_corner_ypos_a = y - center_ypos;
    
var shadows_corner_xpos_b = x + rot_point_x(sprite_width, 0) - center_xpos;
var shadows_corner_ypos_b = y + rot_point_y(sprite_width, 0) - center_ypos;
    
var shadows_corner_xpos_c = x + rot_point_x(sprite_width, sprite_height) - center_xpos;
var shadows_corner_ypos_c = y + rot_point_y(sprite_width, sprite_height) - center_ypos;
    
var shadows_corner_xpos_d = x + rot_point_x(0, sprite_height) - center_xpos;
var shadows_corner_ypos_d = y + rot_point_y(0, sprite_height) - center_ypos;

// Shadow Buffer
shadow_vertex_buffer = vertex_create_buffer();
vertex_begin(shadow_vertex_buffer, LightingEngine.lighting_engine_box_shadows_vertex_format);
    
// Soft Shadows
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_a, shadows_corner_ypos_a, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_a, shadows_corner_ypos_a, 1);
vertex_texcoord(shadow_vertex_buffer, 1, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_a, shadows_corner_ypos_a, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);
    
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_b, shadows_corner_ypos_b, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_b, shadows_corner_ypos_b, 1);
vertex_texcoord(shadow_vertex_buffer, 1, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_b, shadows_corner_ypos_b, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);
    
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_c, shadows_corner_ypos_c, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_c, shadows_corner_ypos_c, 1);
vertex_texcoord(shadow_vertex_buffer, 1, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_c, shadows_corner_ypos_c, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);
    
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_d, shadows_corner_ypos_d, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_d, shadows_corner_ypos_d, 1);
vertex_texcoord(shadow_vertex_buffer, 1, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_d, shadows_corner_ypos_d, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);
    
// Gap Shadows
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_a, shadows_corner_ypos_a, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, 0, 0, -1);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_a, shadows_corner_ypos_a, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);
    
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_b, shadows_corner_ypos_b, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, 0, 0, -1);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_b, shadows_corner_ypos_b, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);
    
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_c, shadows_corner_ypos_c, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, 0, 0, -1);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_c, shadows_corner_ypos_c, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);
    
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_d, shadows_corner_ypos_d, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, 0, 0, -1);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_d, shadows_corner_ypos_d, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);
    
// Hard Shadows
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_a, shadows_corner_ypos_a, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, 0, 0, -1);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_c, shadows_corner_ypos_c, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
    
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_b, shadows_corner_ypos_b, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, 0, 0, -1);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_d, shadows_corner_ypos_d, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
    
// Box Shadows
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_a, shadows_corner_ypos_a, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_b, shadows_corner_ypos_b, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_c, shadows_corner_ypos_c, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
    
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_a, shadows_corner_ypos_a, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_d, shadows_corner_ypos_d, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_c, shadows_corner_ypos_c, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
    
vertex_end(shadow_vertex_buffer);
vertex_freeze(shadow_vertex_buffer);

// Disable Sprite & Visibility
sprite_index = -1;
visible = false;
