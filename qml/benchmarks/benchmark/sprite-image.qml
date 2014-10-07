import QtQuick 2.2

Item {
    id: root;

    function complicate() { size = Math.max(1, size - increment); }
    function simplify() { size = size == 1 ? 2 : size + increment; }
    property int increment: size > 16 ? 2 : 1;
    property int size: 24;
    property int columns: width / size;
    property int rows: height / size;

    property string description: (columns * rows) + " " + size + "x" + size + " sprites\nImages with animation";

    Grid {
        columns: root.columns
        rows: root.rows
        Repeater {
            model: root.rows * root.columns;
            Item {
                id: sprite
                width: root.size
                height: root.size;

                Image { id: imgWide; visible: false; source: "butterfly-wide.png"; sourceSize: Qt.size(root.size, root.size); }
                Image { id: imgHalf; visible: false; source: "butterfly-half.png"; sourceSize: Qt.size(root.size, root.size); }
                Image { id: imgSmall; visible: false; source: "butterfly-collapsed.png"; sourceSize: Qt.size(root.size, root.size); }

                SequentialAnimation {
                    running: true
                    PropertyAction { target: imgWide; property: "visible"; value: true; }
                    PauseAnimation { duration: Math.random() * 500; }
                    PauseAnimation { duration: 300 }
                    PropertyAction { target: imgWide; property: "visible"; value: false; }
                    PropertyAction { target: imgHalf; property: "visible"; value: true; }
                    PauseAnimation { duration: 300 }
                    PropertyAction { target: imgHalf; property: "visible"; value: false; }
                    PropertyAction { target: imgSmall; property: "visible"; value: true; }
                    PauseAnimation { duration: 300 }
                    PropertyAction { target: imgSmall; property: "visible"; value: false; }

                    loops: Animation.Infinite
                }
            }
        }
    }
}
