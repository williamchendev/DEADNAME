//
// Point Light & Spot Light Shadow Shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec2 in_TextureCoord;              // (u, v)

//
uniform float in_LightSource_Radius;
uniform float in_LightSource_Distance;
uniform vec2 in_LightSource_Vector;
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
    vec2 in_LightSource_Position = in_ColliderCenter_Position + (vec2(in_LightSource_Vector.y, in_LightSource_Vector.x) * in_LightSource_Distance);
    vec2 vertex_to_light_offset = normalize(vertex_position - in_LightSource_Position);

    //
    if (in_Position.z == -1.0)
    {
        vertex_position += normalize(vertex_position - in_LightSource_Position) * PseudoInfinity;
    }
    else if (in_Position.z == 1.0)
    {
        vec2 vertex_to_center_offset = normalize(vertex_position - in_ColliderCenter_Position);
        float dotproduct = dot(vertex_to_light_offset, vec2(-vertex_to_center_offset.y, vertex_to_center_offset.x)) * abs(dot(vertex_to_light_offset, vec2(-vertex_to_center_offset.y, vertex_to_center_offset.x)));
        
        vec2 orientation = (in_TextureCoord * 2.0) - 1.0;
        vec2 offset = vec2(vertex_to_light_offset.y * orientation.x, vertex_to_light_offset.x * orientation.y) * in_LightSource_Radius * dotproduct;
        vertex_position += normalize((vertex_position + offset) - in_LightSource_Position) * PseudoInfinity;
    }
    
    //
    v_vShadowCoord = in_TextureCoord;
    
    //
    vec4 object_space_pos = vec4(vertex_position.x, vertex_position.y, 0.0, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
