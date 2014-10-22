import QtQuick 2.0

Benchmark {
    id: root;
    function complicate() { cellSize = Math.max(2, cellSize - increment); }
    function simplify() { cellSize = cellSize + increment; }
    property int increment: 2;
    property string description: "Rendering "
                                 + count + " rectangles using separate GL calls."

    property real cellSize: Math.floor(Math.sqrt(width * height / count))

    count: 250

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
