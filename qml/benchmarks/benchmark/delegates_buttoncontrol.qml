import QtQuick 2.0
import QtQuick.Controls 1.0

Item {
    id: root;
    function complicate() { count += increment; }
    function simplify() { count = Math.max(1, count - increment); }
    property int increment: Math.log(count * count);

    property string description: "Delegates per frame: "
                                 + count + " Button controls."

    property int count: 20;

    property real t;
    NumberAnimation on t { from: 0; to: 1; duration: 1000; loops: Animation.Infinite }
    onTChanged: {
        repeater.model = 0;
        repeater.model = root.count
    }

    Component.onCompleted: repeater.model = root.count

    Repeater {
        id: repeater
        Button {
            x: Math.random() * root.width - width
            y: Math.random() * root.height - height
            text: "Item #" + new Date().getTime();
        }
    }
}
