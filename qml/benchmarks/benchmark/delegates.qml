import QtQuick 2.0

Item {
    id: root;
    function complicate() { count += increment; }
    function simplify() { count = Math.max(1, count - increment); }
    property int increment: Math.log(count * count);

    property string description: "Creating and deleting "
                                 + count + " delegates per frame."

    property int count: 100;

    property real t;
    NumberAnimation on t { from: 0; to: 1; duration: 1000; loops: Animation.Infinite }
    onTChanged: {
        repeater.model = 0;
        repeater.model = root.count
    }

    Repeater {
        id: repeater
        model: root.count
        Rectangle {
            x: Math.random() * root.width
            y: Math.random() * root.height
            width: 30
            height: 15
            gradient: Gradient {
                GradientStop { position: 0; color: "steelblue" }
                GradientStop { position: 1; color: "black" }
            }

            Text {
                anchors.centerIn: parent
                text: "hello"
                color: "white"
                font.pixelSize: 12
            }
        }
    }
}
