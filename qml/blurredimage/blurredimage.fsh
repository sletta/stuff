uniform lowp sampler2D tex;
uniform lowp float ratio;

uniform lowp float qt_Opacity;

varying highp vec2 tc;

void main()
{
    lowp vec4 p = texture2D(tex, tc, ratio);
    gl_FragColor = p * qt_Opacity;
}
