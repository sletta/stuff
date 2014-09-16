import QtQuick 2.0

Item {
    id: root;
    function complicate() { cellSize = Math.max(2, cellSize - increment); }
    function simplify() { cellSize = cellSize + increment; }
    property int increment: 2;
    property string description: "Rendering "
                                 + cellCount + " rectangles using separate GL calls."

    property int cellSize: 40
    property int cellCount: Math.floor(width / cellSize) * Math.ceil(height / cellSize)

    Grid {
        width: root.width
        height: root.height
        columns: root.width / root.cellSize
        rows: root.height / root.cellSize
        Repeater {
            model: root.cellCount

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
