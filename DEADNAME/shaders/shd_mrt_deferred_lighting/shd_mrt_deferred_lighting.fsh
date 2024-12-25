//
// Multi Render Target fragment shader for a Deferred Lighting System
//
varying vec2 v_vTexcoord;
varying vec2 v_vTexcoordNormalMap;
varying vec2 v_vTexcoordSpecularMap;
varying vec4 v_vColour;

//
uniform vec3 vectorScale;
uniform float vectorAngle;

// Textures
uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_SpecularTexture;

// Rotate Vector Function
vec2 rotate(vec2 vec, float angle) 
{
	float vec_x = sin(angle);
	float vec_y = cos(angle);
	mat2 m = mat2(vec_y, vec_x, -vec_x, vec_y);
	return m * vec;            
}

// Fragment Shader
void main()
{
	// Normal Map
	vec4 Normal = (texture2D(gm_NormalTexture, v_vTexcoordNormalMap) - 0.5) * 2.0;
	Normal *= vec4(vectorScale.x, vectorScale.y, vectorScale.z, 1.0);
	
	// Normal Vector Rotation & Scale Calculation
	float NormalAngle = atan(Normal.y, Normal.x);
	Normal.xy = rotate(Normal.xy, vectorAngle);
	Normal = ((Normal / 2.0) + 0.5);
	
	// Specular Map
	vec4 Specular = texture2D(gm_SpecularTexture, v_vTexcoordSpecularMap);
	
	// Set MRT Render Data
    gl_FragData[0] = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragData[1] = Normal;
    gl_FragData[2] = vec4(Specular.r * Specular.a, 0.0, 0.0, 1.0);
}
