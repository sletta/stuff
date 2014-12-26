import QtQuick 2.0

Benchmark {
    id: root;
    property string description: "Updating one text out of "
                                 + count + " items in a scene"

    count: 100

    property real t;
    NumberAnimation on t { from: 0; to: 1000; duration: 1000; loops: Animation.Infinite }

    Grid {
        anchors.fill: parent

        columns: root.width / 100
        spacing: 1

        Repeater {
            id: repeater
            model: root.count
            Rectangle {
                width: 100
                height: 20
                color: "steelblue"
                radius: 4

//                Row {
//                    height: parent.height
//                    anchors.centerIn: parent
                    Text { x: 0; text: "1"; color: "red" }
                    Text { x: 10; text: "2"; color: "blue" }
//                    Rectangle { radius: 4; x: 20; width: index == count - 10 ? t * 0.09 : 10; height: 10; anchors.centerIn: parent; color: "palegreen"  }
                    Text { x: 20; text: "3"; color: "lightsteelblue" }
                    Text { x: 30; text: "-"; color: "white" }
                    Text { x: 40; text: index == count - 1 ? Math.round( t ) : "[]"; }
//                }
            }
        }
    }
}
