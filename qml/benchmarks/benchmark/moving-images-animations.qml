import QtQuick 2.2

Item {
    id: root;

    function complicate() { size = Math.max(1, size - increment); }
    function simplify() { size = size == 1 ? 2 : size + increment; }
    property int increment: size > 16 ? 2 : 1;
    property int size: 24;
    property int columns: width / size;
    property int rows: height / size;

    property string description: (columns * rows) + " " + size + "x" + size + " textures\nAnimated with animations";

    Grid {
        columns: root.columns
        rows: root.rows
        Repeater {
            model: root.rows * root.columns;
            Image {
                source: "butterfly-wide.png"
                sourceSize: Qt.size(root.size, root.size);
                SequentialAnimation on rotation {
                    PauseAnimation { duration: 200 + Math.random() * 200 }
                    NumberAnimation { from: -10; to: 10; duration: 500; easing.type: Easing.InOutCubic }
                    NumberAnimation { from: 10; to: -10; duration: 500; easing.type: Easing.InOutCubic }
                    loops: Animation.Infinite
                }
            }
        }
    }
}
