//
// Point Light & Spot Light Shadow Shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec2 in_TextureCoord;              // (u, v)

//
uniform vec2 in_LightSource_Position;

//
varying vec2 v_vShadowCoord;

//
const float PseudoInfinity = 1000.0;

//
void main()
{
    //
    vec2 vertex_position = in_Position.xy;
    vec2 vertex_to_light_offset = vertex_position - in_LightSource_Position;
    float vertex_to_light_distance = length(vertex_to_light_offset);
    
    //
    if (in_Position.z != 0.0)
    {
        vertex_position += vertex_to_light_offset * PseudoInfinity;
    }
    
    //
    v_vShadowCoord = in_TextureCoord;
    
    //
    vec4 object_space_pos = vec4(vertex_position.x, vertex_position.y, 0.0, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
