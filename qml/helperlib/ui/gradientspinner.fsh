uniform lowp float _t;                  // 0 -> 2 x PI
uniform lowp float _edgeSize;           //
uniform lowp float _circleWidth;
uniform lowp sampler2D _colors;

const highp float PI = 3.141592653589793;
const highp float PIx2 = PI * 2.0;

varying highp vec2 qt_TexCoord0;

void main() {
    lowp vec2 coord = (qt_TexCoord0 - vec2(0.5, 0.5)) * 2.0;
    lowp float dist = length(coord);

    lowp float mask = min(smoothstep(1.0, 1.0 - _edgeSize, dist),
                          smoothstep(1.0 - _circleWidth, 1.0 - _circleWidth + _edgeSize, dist));

    lowp float angle = 1.0 - fract((atan(coord.y, coord.x) + PI - _t) / PIx2);

    gl_FragColor = texture2D(_colors, vec2(0.0, angle)) * mask;
}
