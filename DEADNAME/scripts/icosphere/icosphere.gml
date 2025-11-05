/// @function geodesic_icosphere_create(resolution)
/// @description Creates vertices for a geodesic icosphere using angular interpolation
/// @param {real} resolution Number of segments per edge (higher = more detail)
/// @return {array} Array of vertex positions [x, y, z, x, y, z, ...]

function geodesic_icosphere_create(resolution) 
{
    var resolution_v = 2 * resolution;
    var vertex_count = 5 * resolution_v * resolution + 2;
    var vertices = array_create(vertex_count * 3, 0);
    
    var edge_rotation_angle = get_edge_rotation_angle();
    
    // Top and bottom poles
    vertices[0] = 0;  // down
    vertices[1] = -1;
    vertices[2] = 0;
    
    // Process 5 strips
    for (var strip_id = 0; strip_id < 5; strip_id++) 
    {
        var strip = create_strip(strip_id);
        
        // Process each column in the strip
        for (var u = 0; u < resolution; u++) 
        {
            var vi = (resolution_v * (resolution * strip_id + u) + 1) * 3;
            
            // First vertex in column - rotate from bottom pole
            var axis = strip.bottom_right_axis;
            var angle = edge_rotation_angle * (u + 1) / resolution;
            var pos = quaternion_rotate_point(axis, angle, 0, -1, 0);
            
            vertices[vi] = pos[0];
            vertices[vi + 1] = pos[1];
            vertices[vi + 2] = pos[2];
            vi += 3;
            
            // Process each row in the column
            for (var v = 1; v < resolution_v; v++) 
            {
                var h = u + 1 + v;
                var left_axis, right_axis, left_start, right_start;
                var edge_angle_scale, face_angle_scale;
                
                if (v <= resolution - u - 1) 
                {
                    // Bottom face
                    left_axis = strip.bottom_left_axis;
                    right_axis = strip.bottom_right_axis;
                    left_start = [0, -1, 0];
                    right_start = [0, -1, 0];
                    edge_angle_scale = h / resolution;
                    face_angle_scale = v / h;
                }
                else if (v < resolution) 
                {
                    // Lower middle face
                    left_axis = strip.mid_center_axis;
                    right_axis = strip.mid_right_axis;
                    left_start = strip.low_left_corner;
                    right_start = strip.low_right_corner;
                    edge_angle_scale = h / resolution - 1;
                    face_angle_scale = (resolution - u - 1) / (resolution_v - h);
                }
                else if (v <= resolution_v - u - 1) 
                {
                    // Upper middle face
                    left_axis = strip.mid_left_axis;
                    right_axis = strip.mid_center_axis;
                    left_start = strip.low_left_corner;
                    right_start = strip.low_left_corner;
                    edge_angle_scale = h / resolution - 1;
                    face_angle_scale = (v - resolution) / (h - resolution);
                }
                else 
                {
                    // Top face
                    left_axis = strip.top_left_axis;
                    right_axis = strip.top_right_axis;
                    left_start = strip.high_left_corner;
                    right_start = strip.high_right_corner;
                    edge_angle_scale = h / resolution - 2;
                    face_angle_scale = (resolution - u - 1) / (3 * resolution - h);
                }
                
                // Calculate left and right edge points
                var p_left = quaternion_rotate_point
                (
                    left_axis, 
                    edge_rotation_angle * edge_angle_scale,
                    left_start[0], left_start[1], left_start[2]
                );
                
                var p_right = quaternion_rotate_point
                (
                    right_axis,
                    edge_rotation_angle * edge_angle_scale,
                    right_start[0], right_start[1], right_start[2]
                );
                
                // Calculate interpolation axis and angle
                var interp_axis = vec3_cross(p_right, p_left);
                interp_axis = vec3_normalize(interp_axis);
                var interp_angle = arccos(vec3_dot(p_right, p_left)) * face_angle_scale;
                
                // Final vertex position
                pos = quaternion_rotate_point(interp_axis, interp_angle, p_right[0], p_right[1], p_right[2]);
                
                vertices[vi] = pos[0];
                vertices[vi + 1] = pos[1];
                vertices[vi + 2] = pos[2];
                vi += 3;
            }
        }
    }
    
    //
    vertices[array_length(vertices) - 3] = 0;  // up
    vertices[array_length(vertices) - 2] = 1;
    vertices[array_length(vertices) - 1] = 0;
    
    return vertices;
}

function create_strip(id) 
{
    var strip = 
    {
        id: id,
        low_left_corner: get_corner(2 * id, -1),
        low_right_corner: get_corner(id == 4 ? 0 : 2 * id + 2, -1),
        high_left_corner: get_corner(id == 0 ? 9 : 2 * id - 1, 1),
        high_right_corner: get_corner(2 * id + 1, 1)
    };
    
    var down = [0, -1, 0];
    var up = [0, 1, 0];
    
    strip.bottom_left_axis = vec3_normalize(vec3_cross(down, strip.low_left_corner));
    strip.bottom_right_axis = vec3_normalize(vec3_cross(down, strip.low_right_corner));
    strip.mid_left_axis = vec3_normalize(vec3_cross(strip.low_left_corner, strip.high_left_corner));
    strip.mid_center_axis = vec3_normalize(vec3_cross(strip.low_left_corner, strip.high_right_corner));
    strip.mid_right_axis = vec3_normalize(vec3_cross(strip.low_right_corner, strip.high_right_corner));
    strip.top_left_axis = vec3_normalize(vec3_cross(strip.high_left_corner, up));
    strip.top_right_axis = vec3_normalize(vec3_cross(strip.high_right_corner, up));
    
    return strip;
}

function get_corner(id, y_sign) 
{
    var angle = 0.2 * pi * id;
    
    return 
    [
        0.4 * sqrt(5) * sin(angle),
        y_sign * 0.2 * sqrt(5),
        -0.4 * sqrt(5) * cos(angle)
    ];
}

function get_edge_rotation_angle() 
{
    var up = [0, 1, 0];
    var corner = get_corner(0, 1);
    
    return arccos(vec3_dot(up, corner));
}

// Vector3 utility functions
function vec3_dot(a, b) 
{
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

function vec3_cross(a, b) 
{
    return 
    [
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0]
    ];
}

function vec3_normalize(v) 
{
    var len = sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
    
    if (len > 0) 
    {
        return [v[0] / len, v[1] / len, v[2] / len];
    }
    
    return [0, 0, 0];
}

// Quaternion rotation function
function quaternion_rotate_point(axis, angle, px, py, pz) 
{
    // Create quaternion from axis-angle
    var half_angle = angle * 0.5;
    var s = sin(half_angle);
    var qx = axis[0] * s;
    var qy = axis[1] * s;
    var qz = axis[2] * s;
    var qw = cos(half_angle);
    
    // Rotate point by quaternion: q * p * q^-1
    // First: q * p
    var ix = qw * px + qy * pz - qz * py;
    var iy = qw * py + qz * px - qx * pz;
    var iz = qw * pz + qx * py - qy * px;
    var iw = -qx * px - qy * py - qz * pz;
    
    // Second: result * q^-1 (conjugate)
    return 
    [
        ix * qw + iw * -qx + iy * -qz - iz * -qy,
        iy * qw + iw * -qy + iz * -qx - ix * -qz,
        iz * qw + iw * -qz + ix * -qy - iy * -qx
    ];
}