//
// Unlit Solar System Background Stars vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)

// Camera Properties
uniform vec3 in_CameraPosition;
uniform mat4 in_CameraRotation;
uniform vec2 in_CameraDimensions;

// Interpolated Color
varying vec4 v_vColour;

// Constants
const float camera_position_scale = 0.01;
const vec3 inverse_vertical_vector = vec3(1.0, -1.0, 1.0);

// Vertex Shader
void main() 
{
	// Calculate Camera Forward Vector from Camera's Rotation Matrix
	vec3 camera_forward = normalize(in_CameraRotation[2].xyz);
	
	// Calculate Render Vertex Position with Camera Rotation Matrix
	vec4 render_position = vec4(in_Position - in_CameraPosition * camera_position_scale * inverse_vertical_vector, 1.0) * in_CameraRotation;
	
	// Calculate if Render Vertex Position is in front of the Camera
	float render_forward_dot_product = dot(camera_forward, normalize(in_Position)) > 0.0 ? 1.0 : 0.0;
	
	// Interpolated Color
	v_vColour = in_Colour * render_forward_dot_product;
	
	// Set Vertex Position
	vec4 object_space_pos = vec4(render_position.xyz + vec3(in_CameraDimensions * 0.5, 0.0), 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
