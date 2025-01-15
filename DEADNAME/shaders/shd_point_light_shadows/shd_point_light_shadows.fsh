//
// Point Light and Spot Light Shadow fragment shader for Inno's Deferred Lighting System
//

// Interpolated Shadow Gradient UV Coordinates
varying vec2 v_vShadowCoord;

// Constants
const float PseudoZero = 0.00001;

// Fragment Shader
void main()
{
    // Render Shadow Fin's Gradient
    float PenumbraValue = 1.0 - (v_vShadowCoord.x / max(PseudoZero, v_vShadowCoord.y));
    float LightGradient = smoothstep(0.0, 1.0, PenumbraValue);
    gl_FragColor = vec4(LightGradient);
}
