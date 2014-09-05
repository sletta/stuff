import QtQuick 2.2

Item {
    id: root;

    function complicate() { size = Math.max(1, size - 4); }
    function simplify() { size = size == 1 ? 4 : size + 4; }

    property int size: 24;
    property int columns: width / size;
    property int rows: height / size;

    property string description: (columns * rows) + " " + size + "x" + size + " textures\nAnimation includes JavaScript";

    Grid {
        columns: root.columns
        rows: root.rows
        Repeater {
            model: root.rows * root.columns;
            Image {
                source: "butterfly-wide.png"
                sourceSize: Qt.size(root.size, root.size);

                property real t;
                rotation: 10 * Math.sin(t * Math.PI * 2 + Math.PI);

                SequentialAnimation on t {
                    PauseAnimation { duration: 200 + Math.random() * 200 }
                    NumberAnimation { from: 0; to: 1; duration: 1000; }
                    loops: Animation.Infinite
                }
            }
        }
    }
}
