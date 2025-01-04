//
// Point Light & Spot Light Shadow Shader
//
attribute vec3 in_Position;                  // (x,y,z)

//
uniform vec2 in_LightSource_Position;

//
varying float PenumbraDistanceT;
varying float PenumbraDistanceL;

//
const float PseudoInfinity = 10000.0;


void main()
{
    vec2 vertex_position = in_Position.xy;
    vec2 vertex_to_light_offset = vertex_position - in_LightSource_Position;
    float vertex_to_light_distance = length(vertex_to_light_offset);
    
    if (in_Position.z >= 1.0)
    {
        vertex_position += (vertex_to_light_offset / vertex_to_light_distance) * PseudoInfinity;
        PenumbraDistanceT = in_Position.z - 2.0;
        PenumbraDistanceL = 1.0;
    }
    else
    {
        PenumbraDistanceL = vertex_to_light_distance / PseudoInfinity;
        PenumbraDistanceT = mix(0.5, in_Position.z, PenumbraDistanceL);
    }
    
    vec4 object_space_pos = vec4(vertex_position.x, vertex_position.y, 0.0, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
