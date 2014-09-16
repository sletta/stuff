import QtQuick 2.0

Item {
    id: root;
    function complicate() { count = count + increment; }
    function simplify() { count = Math.max(1, count - increment); }
    property int increment: (count >= 100
                             ? 10
                             : (count >= 50
                                ? 5
                                : count >= 10 ? 2 : 1
                                )
                             )
    property int count: 8;
    property string description: "Rendering "
                                 + count + " blended rectangle"
                                 + (count > 1 ? "s" : "");
    Repeater {
        model: root.count;

        Grid {
            width: root.width
            height: root.height
            ShaderEffect {
                property color c: Qt.rgba(Math.random(), Math.random(), Math.random(()));
            }
        }

    }
}
