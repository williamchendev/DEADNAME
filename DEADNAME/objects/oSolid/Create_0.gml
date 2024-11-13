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
rotations = 0;

var temp_smallest_value = min(corner_angle_a, corner_angle_b, corner_angle_c, corner_angle_d);

switch (temp_smallest_value)
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
    case corner_angle_d:
    default:
        rotations = 2;
        break;
}
