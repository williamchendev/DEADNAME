//
// Shadows Vertex Shader
//
attribute vec3 in_Position;                  // (x,y,z)

uniform vec2 lightPosition;

void main()
{
	vec2 pos = in_Position.xy;
	
	if (in_Position.z > 0.0) {
		vec2 displace_vector = pos - lightPosition;
		pos += (displace_vector / sqrt((displace_vector.x * displace_vector.x) + (displace_vector.y * displace_vector.y))) * 10000.0;
	}
	
    vec4 object_space_pos = vec4( pos.x, pos.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
