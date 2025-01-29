//
// Directional Light Shadow vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec3 in_Position;                  // (x, y, z)
attribute vec2 in_TextureCoord;              // (u, v)

// Uniform Camera Properties
uniform vec2 in_Camera_Offset;

// Uniform Light Source Properties
uniform float in_LightSource_Radius;
uniform vec2 in_LightSource_Vector;

// Uniform Collider Properties
uniform vec2 in_ColliderCenter_Position;
uniform vec2 in_Collider_Scale;
uniform float in_Collider_Rotation;

// Interpolated Shadow Gradient UV Coordinates
varying vec2 v_vShadowCoord;

// Constants
const float PseudoInfinity = 1000.0;

// Vertex Shader
void main()
{
    // Calculate Vertex Position
    float rotate_angle = radians(in_Collider_Rotation);
	vec2 rotate_vector = vec2(cos(rotate_angle), sin(rotate_angle));
	mat2 rotate_matrix = mat2(rotate_vector.x, -rotate_vector.y, rotate_vector.y, rotate_vector.x);
    
    // Normalize Light Direction Vectors
    vec2 vertex_position = in_ColliderCenter_Position + (in_Position.xy * in_Collider_Scale * rotate_matrix);
    vec2 in_LightSource_Position = in_ColliderCenter_Position + (vec2(in_LightSource_Vector.x, -in_LightSource_Vector.y) * PseudoInfinity);
    vec2 vertex_to_light_offset = normalize(vertex_position - in_LightSource_Position);

    // Vertex Z Axis determines Vertex Displacement
    if (in_Position.z == -1.0)
    {
        // Simple Vertex Displacement Behaviour
        vertex_position += normalize(vertex_position - in_LightSource_Position) * PseudoInfinity;
    }
    else if (in_Position.z == 1.0)
    {
        // Use Dot Product to find orientation of Vertex's Position relative to Light Source's Position
        vec2 vertex_to_center_offset = normalize(vertex_position - in_ColliderCenter_Position);
        float dotproduct = dot(vertex_to_light_offset, vec2(-vertex_to_center_offset.y, vertex_to_center_offset.x)) * abs(dot(vertex_to_light_offset, vec2(-vertex_to_center_offset.y, vertex_to_center_offset.x)));
        
        // Displace Vertex from the Light Source's Radius & Position to create triangle compatible for a soft shadow gradient
        vec2 orientation = (in_TextureCoord * 2.0) - 1.0;
        vec2 offset = vec2(vertex_to_light_offset.y * orientation.x, vertex_to_light_offset.x * orientation.y) * in_LightSource_Radius * dotproduct;
        vertex_position += normalize((vertex_position + offset) - in_LightSource_Position) * PseudoInfinity;
    }
    
    // Set UVs for Shadow Fin Triangle Gradient
    v_vShadowCoord = in_TextureCoord;
    
    // Set Vertex Position
    vec4 object_space_pos = vec4(vertex_position.x - in_Camera_Offset.x, vertex_position.y - in_Camera_Offset.y, 0.0, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
