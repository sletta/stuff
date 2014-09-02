uniform lowp float _tr;
uniform lowp float _tw;

varying highp vec2 qt_TexCoord0;

void main(void)
{
    lowp vec2 coord = (qt_TexCoord0 - vec2(0.5, 0.5)) * 2.0;
    lowp float dist = smoothstep(_tr, _tw, length(coord));

    gl_FragColor = vec4(0, 0, dist, 0.5);
}
