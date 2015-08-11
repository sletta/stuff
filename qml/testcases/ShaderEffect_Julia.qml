import QtQuick 2.0

Item {
    width: 800
    height: 600

    ShaderEffect {
        anchors.fill: parent

        layer.enabled: true
        layer.textureSize: Qt.size(512, 256);
        layer.smooth: true

        property real tt;
        NumberAnimation on tt { from: 0; to: 1; duration: 1000; loops: -1 }
        onTtChanged: updateC();

        property var c;
        function updateC() {
            var t = new Date().getTime() / 2000.0;
            var cx = Math.sin(t) * 0.2;
            var cy = Math.cos(t) * 0.8;
            c = Qt.vector2d(cx, cy);
        }

        vertexShader: "
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            uniform highp mat4 qt_Matrix;
            uniform highp float scale;
            varying highp vec2 vTC;
            void main() {
                gl_Position = qt_Matrix * qt_Vertex;
                vTC = 3.0 * (qt_MultiTexCoord0 - 0.5);
            }";

        fragmentShader: "
            uniform highp vec2 c;
            varying highp vec2 vTC;
            #define ITERATIONS 50
            void main() {
                highp vec2 z = vTC;
                int i;
                for (i=0; i<ITERATIONS; ++i) {
                    highp float x = (z.x * z.x - z.y * z.y) + c.x;
                    highp float y = (z.y * z.x + z.x * z.y) + c.y;
                    if (x*x + y*y > 4.0) break;
                    z = vec2(x,y);
                }

                float v = i == ITERATIONS ? 0.0 : pow(float(i) / float(ITERATIONS), 0.5);

                gl_FragColor = vec4(v * vec3(0.5, 0.3, 1), 1);
            }"

    }
}