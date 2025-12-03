//
// Forward Rendered Lit Planet Atmosphere fragment shader meant for Inno's Solar System Overworld
//

// Interpolated Position
varying vec2 v_vPosition;

// Constants
const vec2 Center = vec2(0.5, 0.5);

const float Pi = 3.14159265359;

// Fragment Shader
void main()
{
	// Point Light Distance
	float Distance = distance(v_vPosition, Center);
	
	if (Distance > 0.5)
	{
		// Circle Cut-Out Early Return
		return;
	}
	
	// Render Atmosphere
    gl_FragColor = vec4(vec3(1.0), cos(Distance * Pi));
}
