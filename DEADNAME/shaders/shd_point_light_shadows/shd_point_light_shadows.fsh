//
varying float PenumbraDistanceT;
varying float PenumbraDistanceL;

void main()
{
    float light_strength = 1.0 - (abs(PenumbraDistanceT - 0.5) * (5.0 / PenumbraDistanceL));
    gl_FragColor = vec4(0.0, 0.0, light_strength, 1.0);
}
