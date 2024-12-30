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
const float HalfPi = 1.57079632679;

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
	float NormalZ = pow(cos((Distance / 0.5) * HalfPi), 3.0);
	float Mag = 1.0 - pow((Distance / 0.5), 5.0);
	
	vec4 SurfaceNormal = (texture2D(gm_NormalTexture, v_vSurfaceUV) * 2.0) - 1.0;
	//vec4 LightColor = mix(vec4(0.0, 0.0, 0.0, 1.0), v_vColour * mag, dot(v_vNormal.xyz, SurfaceNormal.xyz + vec3(0.0, 0.0, 0.5)));
	gl_FragColor = vec4(max(dot(v_vNormal.xy, SurfaceNormal.xy) * 6.0, dot(NormalZ, SurfaceNormal.z) * 1.0), 0.0, 0.0, Mag);
}