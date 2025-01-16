/// @description Box Shadow Init Event
// Initializes Box Shadow Variables

// Shadow Vertexes
shadow_vertex_buffer = -1;

var temp_shadow_vertex_xpos_a = -sprite_width / 2;
var temp_shadow_vertex_ypos_a = -sprite_height / 2;

var temp_shadow_vertex_xpos_b = sprite_width / 2;
var temp_shadow_vertex_ypos_b = -sprite_height / 2;

var temp_shadow_vertex_xpos_c = sprite_width / 2;
var temp_shadow_vertex_ypos_c = sprite_height / 2;

var temp_shadow_vertex_xpos_d = -sprite_width / 2;
var temp_shadow_vertex_ypos_d = sprite_height / 2;

// Shadow Buffer
shadow_vertex_buffer = vertex_create_buffer();
vertex_begin(shadow_vertex_buffer, LightingEngine.lighting_engine_box_shadows_vertex_format);

// Soft Shadows
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_a, temp_shadow_vertex_ypos_a, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_a, temp_shadow_vertex_ypos_a, 1);
vertex_texcoord(shadow_vertex_buffer, 1, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_a, temp_shadow_vertex_ypos_a, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);

vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_b, temp_shadow_vertex_ypos_b, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_b, temp_shadow_vertex_ypos_b, 1);
vertex_texcoord(shadow_vertex_buffer, 1, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_b, temp_shadow_vertex_ypos_b, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);

vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_c, temp_shadow_vertex_ypos_c, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_c, temp_shadow_vertex_ypos_c, 1);
vertex_texcoord(shadow_vertex_buffer, 1, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_c, temp_shadow_vertex_ypos_c, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);

vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_d, temp_shadow_vertex_ypos_d, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_d, temp_shadow_vertex_ypos_d, 1);
vertex_texcoord(shadow_vertex_buffer, 1, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_d, temp_shadow_vertex_ypos_d, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);

// Gap Shadows
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_a, temp_shadow_vertex_ypos_a, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, 0, 0, -1);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_a, temp_shadow_vertex_ypos_a, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);

vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_b, temp_shadow_vertex_ypos_b, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, 0, 0, -1);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_b, temp_shadow_vertex_ypos_b, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);

vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_c, temp_shadow_vertex_ypos_c, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, 0, 0, -1);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_c, temp_shadow_vertex_ypos_c, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);

vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_d, temp_shadow_vertex_ypos_d, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, 0, 0, -1);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_d, temp_shadow_vertex_ypos_d, 1);
vertex_texcoord(shadow_vertex_buffer, 0, 1);

// Hard Shadows
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_a, temp_shadow_vertex_ypos_a, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, 0, 0, -1);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_c, temp_shadow_vertex_ypos_c, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);

vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_b, temp_shadow_vertex_ypos_b, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, 0, 0, -1);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_d, temp_shadow_vertex_ypos_d, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);

// Box Shadows
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_a, temp_shadow_vertex_ypos_a, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_b, temp_shadow_vertex_ypos_b, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_c, temp_shadow_vertex_ypos_c, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);

vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_a, temp_shadow_vertex_ypos_a, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_d, temp_shadow_vertex_ypos_d, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);
vertex_position_3d(shadow_vertex_buffer, temp_shadow_vertex_xpos_c, temp_shadow_vertex_ypos_c, 0);
vertex_texcoord(shadow_vertex_buffer, 0, 0);

vertex_end(shadow_vertex_buffer);
