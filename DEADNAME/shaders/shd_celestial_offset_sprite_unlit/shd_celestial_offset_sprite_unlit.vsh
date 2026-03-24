//
// Simple passthrough vertex shader
//

// Vertex Buffer Properties
attribute vec2 in_Position;                  // (x, y)

// Camera Properties
uniform vec3 in_CameraPosition;
uniform vec2 in_CameraDimensions;

// Celestial Object Properties
uniform vec3 u_CelestialObjectPosition;
uniform vec3 u_CelestialOffsetVector;
uniform float u_CelestialOffsetDistance;

// Sprite Properties
uniform vec4 u_SpriteUV;
uniform vec4 u_SpriteOffset;

// Interpolated UVs
varying vec2 v_vTexcoord;

// Constants
const float fov = 60.0;
const float Pi = 3.14159265359;

// Vertex Shader
void main() 
{
	// Calculate Camera Right and Up Vectors from Camera's View Matrix
	vec3 camera_right = normalize(vec3(gm_Matrices[MATRIX_VIEW][0][0], gm_Matrices[MATRIX_VIEW][1][0], gm_Matrices[MATRIX_VIEW][2][0]));
	vec3 camera_up = normalize(vec3(gm_Matrices[MATRIX_VIEW][0][1], gm_Matrices[MATRIX_VIEW][1][1], gm_Matrices[MATRIX_VIEW][2][1]));
	
	// Translate Square UV into Square Offset matching Camera's Orientation
	//vec3 camera_quad_vector = camera_right * in_Position.x + camera_up * in_Position.y;
	
	//
	vec3 celestial_world_position = u_CelestialObjectPosition + (u_CelestialOffsetVector * u_CelestialOffsetDistance);
	
	// Translate Square UV into Quad Offset matching Camera's Orientation
	
	
	//
	float fov_radians = fov * (Pi / 180.0);
	float camera_distance = distance(in_CameraPosition, celestial_world_position);
	float world_size = (2.0 * tan(fov_radians / 2.0)) * camera_distance;
	
	//
	vec2 size = vec2(mix(u_SpriteOffset.x, u_SpriteOffset.z, in_Position.x * 0.5 + 0.5), mix(-u_SpriteOffset.y, -u_SpriteOffset.w, in_Position.y * 0.5 + 0.5)) / in_CameraDimensions.y * world_size;
	
	//
	vec3 camera_quad_offset = camera_right * size.x + camera_up * size.y;
	
	// Translate Square UV into Quad Offset matching Camera's Orientation
	//vec2 quad_offset = vec2(mix(u_SpriteOffset.x, u_SpriteOffset.z, in_Position.x) / in_CameraDimensions.x, mix(u_SpriteOffset.y, u_SpriteOffset.w, in_Position.y) / in_CameraDimensions.y);
	//vec2 quad_offset = vec2(mix(u_SpriteOffset.x, u_SpriteOffset.z, in_Position.x), mix(u_SpriteOffset.y, u_SpriteOffset.w, in_Position.y));
	//vec2 quad_offset = vec2(mix(u_SpriteOffset.x, u_SpriteOffset.z, in_Position.x), mix(u_SpriteOffset.y, u_SpriteOffset.w, in_Position.y));
	
	// Interpolated Texture UVs & Color
	v_vTexcoord = vec2(mix(u_SpriteUV.x, u_SpriteUV.z, in_Position.x), mix(u_SpriteUV.y, u_SpriteUV.w, in_Position.y));
	
	// Translate Vertex World Positions to Clip Space Position
	//vec4 view_position = gm_Matrices[MATRIX_VIEW] * (celestial_world_position + vec4(camera_quad_offset, 0.0));
	//vec4 clip_position = gm_Matrices[MATRIX_PROJECTION] * view_position;
	gl_Position = gm_Matrices[MATRIX_PROJECTION] * gm_Matrices[MATRIX_VIEW] * vec4(celestial_world_position + camera_quad_offset, 1.0);
}
