import QtQuick 2.0

Item {
    id: root;

    property real cellSize: Math.floor(Math.sqrt(width * height / count))
    property int count: 250

    Grid {
        width: root.width
        height: root.height
        columns: Math.ceil(root.width / root.cellSize);
        rows: Math.ceil(root.height / root.cellSize);
        Repeater {
            model: root.count

            ShaderEffect {
                property color c: Qt.rgba(Math.random(), Math.random(), Math.random());
                blending: false
                width: root.cellSize
                height: root.cellSize
                fragmentShader: "uniform lowp vec4 c; void main() { gl_FragColor = c; }"
            }
        }
    }
}
