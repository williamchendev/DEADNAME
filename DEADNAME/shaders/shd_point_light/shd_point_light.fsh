///

//
uniform sampler2D gm_NormalTexture;

//
varying vec4 v_vColour;
varying vec4 v_vNormal;
varying vec2 v_vPosition;
varying vec2 v_vSurfaceUV;

//1.57079632679
//3.14159265359

//
const vec2 Center = vec2(0.5, 0.5);

//
void main() 
{
	//
	float Distance = distance(v_vPosition, Center);
	if (Distance > 0.5)
	{
		return;
	}
	
	//
	vec4 SurfaceNormal = (texture2D(gm_NormalTexture, v_vSurfaceUV) * 2.0) - 1.0;
	vec4 LightColor = mix(vec4(0.0, 0.0, 0.0, 1.0), v_vColour, dot(v_vNormal.xy, SurfaceNormal.xy));
	gl_FragColor = LightColor;
}