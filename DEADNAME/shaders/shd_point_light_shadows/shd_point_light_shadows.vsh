//
// Point Light & Spot Light Shadow Shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec2 in_TextureCoord;              // (u, v)

//
uniform float in_LightSource_Radius;
uniform vec2 in_LightSource_Position;
uniform vec2 in_ColliderCenter_Position;

//
varying vec2 v_vShadowCoord;

//
const float PseudoInfinity = 1000.0;

//
void main()
{
    //
    vec2 vertex_position = in_Position.xy;
    vec2 vertex_to_light_offset = normalize(vertex_position - in_LightSource_Position);
    
    //
    if (in_Position.z == 2.0)
    {
        vec2 offset_a = vec2(-vertex_to_light_offset.y, vertex_to_light_offset.x) * in_LightSource_Radius;
        vertex_position += normalize((vertex_position + offset_a) - in_LightSource_Position) * PseudoInfinity;
    }
    else if (in_Position.z == 3.0)
    {
        vec2 offset_b = vec2(vertex_to_light_offset.y, -vertex_to_light_offset.x) * in_LightSource_Radius;
        vertex_position += normalize((vertex_position + offset_b) - in_LightSource_Position) * PseudoInfinity;
    }
    
    //
    v_vShadowCoord = in_TextureCoord;
    
    //
    vec4 object_space_pos = vec4(vertex_position.x, vertex_position.y, 0.0, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
