//
varying vec2 v_vShadowCoord;

//
void main()
{
    float Penumbra = v_vShadowCoord.x / max(0.00001, v_vShadowCoord.y);
    float LightGradient = mix(1.0, 1.0, 1.0 - Penumbra);
    
    gl_FragColor = vec4(LightGradient);
}
