//
// Forward Rendered Lit Planet Atmosphere vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec2 in_Position; // (x, y)

// Atmosphere Properties
uniform float u_vsh_AtmosphereRadius;

// Planet Properties
uniform vec3 u_vsh_PlanetPosition;

// Interpolated Surface Mask UV and World Position
varying vec2 v_vSurfaceUV;
varying vec3 v_vWorldPosition;

// Vertex Shader
void main() 
{
	// Calculate Camera Right and Up Vectors from Camera's View Matrix
	vec3 camera_right = normalize(vec3(gm_Matrices[MATRIX_VIEW][0][0], gm_Matrices[MATRIX_VIEW][1][0], gm_Matrices[MATRIX_VIEW][2][0]));
	vec3 camera_up = normalize(vec3(gm_Matrices[MATRIX_VIEW][0][1], gm_Matrices[MATRIX_VIEW][1][1], gm_Matrices[MATRIX_VIEW][2][1]));
	
	// Translate Square UV into Square Offset matching Camera's Orientation
	vec3 camera_quad_offset = camera_right * in_Position.x + camera_up * in_Position.y;
	
	// Calculate Imposter Sphere's Quad Vertex World Positions
	vec3 vertex_local_position = camera_quad_offset * u_vsh_AtmosphereRadius * 2.0;
	vec4 vertex_world_position = vec4(vertex_local_position + u_vsh_PlanetPosition, 1.0);
	
	// Interpolated World Position
	v_vWorldPosition = vertex_world_position.xyz;
	
	// Translate Imposter Sphere's Quad Vertex World Positions to Clip Space Position
	gl_Position = gm_Matrices[MATRIX_PROJECTION] * gm_Matrices[MATRIX_VIEW] * vertex_world_position;
	
	// Update Surface Mask UV from Clip Space Position
	v_vSurfaceUV = (vec2(gl_Position.x, -gl_Position.y) / gl_Position.w) * 0.5 + 0.5;
}
