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
        Rectangle {
            x: index
            y: index
            width: root.width
            height: root.height
            color: Qt.hsla((index * .271) % 1.0, 0.5, 0.5, 0.5);
        }
    }
}
