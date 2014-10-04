import QtQuick 2.2

ShaderEffect
{
    id: root

    width: 300
    height: 300

    property bool reversed: false
    property bool running: true
    onRunningChanged: _t = 0;
    property real duration: 1500;
    property real circleWidth: Math.min(width, height) * 0.1;

    property color color0: "steelblue";
    property color color1: Qt.rgba(0, 0, 0, 0.5);

    property Gradient gradient: Gradient {
        GradientStop { position: 0; color: "transparent" }
        GradientStop { position: 0.01; color: root.color0 }
        GradientStop { position: 0.5; color: root.color1 }
        GradientStop { position: 0.6; color: "transparent" }
    }

    Rectangle {
        id: gradientRect
        width: 1;
        height: 128
        gradient: root.gradient
        layer.enabled: true
        layer.smooth: true
        visible: false
    }

    property real _t;
    property real _edgeSize: 4 / Math.min(width, height);
    property real _circleWidth: 2 * circleWidth / Math.min(width, height);
    property variant _colors: gradientRect;


    UniformAnimator on _t {
        from: root.reversed ? Math.PI * 2 : 0;
        to: root.reversed ? 0 : Math.PI * 2;
        duration: root.duration;
        running: root.running;
        loops: Animation.Infinite
    }

    fragmentShader: "
        uniform lowp float _t;                  // 0 -> 2 x PI
        uniform lowp float _edgeSize;           //
        uniform lowp float _circleWidth;
        uniform lowp sampler2D _colors;
        uniform lowp float qt_Opacity;

        const highp float PI = 3.141592653589793;
        const highp float PIx2 = PI * 2.0;

        varying highp vec2 qt_TexCoord0;

        void main() {
            lowp vec2 coord = (qt_TexCoord0 - vec2(0.5, 0.5)) * 2.0;
            lowp float dist = length(coord);

            lowp float mask = min(smoothstep(1.0, 1.0 - _edgeSize, dist),
                                  smoothstep(1.0 - _circleWidth, 1.0 - _circleWidth + _edgeSize, dist));

            lowp float angle = 1.0 - fract((atan(coord.y, coord.x) + PI - _t) / PIx2);

            gl_FragColor = texture2D(_colors, vec2(0.0, angle)) * mask * qt_Opacity;
        }
        "
}
