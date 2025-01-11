/// @description Solid Init Event

// Corner Position A
corner_xpos_a = x;
corner_ypos_a = y;

// Corner Position B
corner_xpos_b = x + rot_point_x(sprite_width, 0, image_angle);
corner_ypos_b = y + rot_point_y(sprite_width, 0);

// Corner Position C
corner_xpos_c = x + rot_point_x(sprite_width, sprite_height);
corner_ypos_c = y + rot_point_y(sprite_width, sprite_height);

// Corner Position D
corner_xpos_d = x + rot_point_x(0, sprite_height);
corner_ypos_d = y + rot_point_y(0, sprite_height);

// Center Position
center_xpos = lerp(corner_xpos_a, corner_xpos_c, 0.5);
center_ypos = lerp(corner_ypos_a, corner_ypos_c, 0.5);

// Corner Angles
corner_angle_a = point_direction(center_xpos, center_ypos, corner_xpos_a, corner_ypos_a);
corner_angle_b = point_direction(center_xpos, center_ypos, corner_xpos_b, corner_ypos_b);
corner_angle_c = point_direction(center_xpos, center_ypos, corner_xpos_c, corner_ypos_c);
corner_angle_d = point_direction(center_xpos, center_ypos, corner_xpos_d, corner_ypos_d);

// Side Angles
side_angle_ab = point_direction(center_xpos, center_ypos, lerp(corner_xpos_a, corner_xpos_b, 0.5), lerp(corner_ypos_a, corner_ypos_b, 0.5));
side_angle_bc = point_direction(center_xpos, center_ypos, lerp(corner_xpos_b, corner_xpos_c, 0.5), lerp(corner_ypos_b, corner_ypos_c, 0.5));
side_angle_cd = point_direction(center_xpos, center_ypos, lerp(corner_xpos_c, corner_xpos_d, 0.5), lerp(corner_ypos_c, corner_ypos_d, 0.5));
side_angle_da = point_direction(center_xpos, center_ypos, lerp(corner_xpos_d, corner_xpos_a, 0.5), lerp(corner_ypos_d, corner_ypos_a, 0.5));

// Rotations
rotations = -1;

switch (min(corner_angle_a, corner_angle_b, corner_angle_c, corner_angle_d))
{
    case corner_angle_a:
        rotations = 3;
        break;
    case corner_angle_b:
        rotations = 0;
        break;
    case corner_angle_c:
        rotations = 1;
        break;
    default:
        rotations = 2;
        break;
}

// Shadow Vertexes
shadow_vertex_buffer = -1;

if (shadows_enabled)
{
    // Calculate Shadow Vertex Positions via Light Penetration
    var shadows_light_penetration_lerp_corner_ac = shadows_light_penetration_depth / point_distance(corner_xpos_a, corner_ypos_a, center_xpos, center_ypos);
    var shadows_light_penetration_lerp_corner_bd = shadows_light_penetration_depth / point_distance(corner_xpos_b, corner_ypos_b, center_xpos, center_ypos);
    
    var shadows_corner_xpos_a = lerp(corner_xpos_a, center_xpos, shadows_light_penetration_lerp_corner_ac);
    var shadows_corner_ypos_a = lerp(corner_ypos_a, center_ypos, shadows_light_penetration_lerp_corner_ac);
    
    var shadows_corner_xpos_b = lerp(corner_xpos_b, center_xpos, shadows_light_penetration_lerp_corner_bd);
    var shadows_corner_ypos_b = lerp(corner_ypos_b, center_ypos, shadows_light_penetration_lerp_corner_bd);
    
    var shadows_corner_xpos_c = lerp(corner_xpos_c, center_xpos, shadows_light_penetration_lerp_corner_ac);
    var shadows_corner_ypos_c = lerp(corner_ypos_c, center_ypos, shadows_light_penetration_lerp_corner_ac);
    
    var shadows_corner_xpos_d = lerp(corner_xpos_d, center_xpos, shadows_light_penetration_lerp_corner_bd);
    var shadows_corner_ypos_d = lerp(corner_ypos_d, center_ypos, shadows_light_penetration_lerp_corner_bd);

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
    vertex_position_3d(shadow_vertex_buffer, center_xpos, center_ypos, -1);
    vertex_texcoord(shadow_vertex_buffer, 0, 0);
    vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_a, shadows_corner_ypos_a, 1);
    vertex_texcoord(shadow_vertex_buffer, 0, 1);
    
    vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_b, shadows_corner_ypos_b, 0);
    vertex_texcoord(shadow_vertex_buffer, 0, 0);
    vertex_position_3d(shadow_vertex_buffer, center_xpos, center_ypos, -1);
    vertex_texcoord(shadow_vertex_buffer, 0, 0);
    vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_b, shadows_corner_ypos_b, 1);
    vertex_texcoord(shadow_vertex_buffer, 0, 1);
    
    vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_c, shadows_corner_ypos_c, 0);
    vertex_texcoord(shadow_vertex_buffer, 0, 0);
    vertex_position_3d(shadow_vertex_buffer, center_xpos, center_ypos, -1);
    vertex_texcoord(shadow_vertex_buffer, 0, 0);
    vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_c, shadows_corner_ypos_c, 1);
    vertex_texcoord(shadow_vertex_buffer, 0, 1);
    
    vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_d, shadows_corner_ypos_d, 0);
    vertex_texcoord(shadow_vertex_buffer, 0, 0);
    vertex_position_3d(shadow_vertex_buffer, center_xpos, center_ypos, -1);
    vertex_texcoord(shadow_vertex_buffer, 0, 0);
    vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_d, shadows_corner_ypos_d, 1);
    vertex_texcoord(shadow_vertex_buffer, 0, 1);
    
    
    // Hard Shadows
    vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_a, shadows_corner_ypos_a, 0);
    vertex_texcoord(shadow_vertex_buffer, 0, 0);
    vertex_position_3d(shadow_vertex_buffer, center_xpos, center_ypos, -1);
    vertex_texcoord(shadow_vertex_buffer, 0, 0);
    vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_c, shadows_corner_ypos_c, 0);
    vertex_texcoord(shadow_vertex_buffer, 0, 0);
    
    vertex_position_3d(shadow_vertex_buffer, shadows_corner_xpos_b, shadows_corner_ypos_b, 0);
    vertex_texcoord(shadow_vertex_buffer, 0, 0);
    vertex_position_3d(shadow_vertex_buffer, center_xpos, center_ypos, -1);
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
}
