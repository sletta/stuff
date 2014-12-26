import QtQuick 2.0

Item {
    id: root;
    function complicate() { count += increment; }
    function simplify() { count = Math.max(1, count - increment); }
    property int increment: Math.log(count * count);

    property string description: "Updating " + count + " Text elements per frame"
    property int count: 100;
    property real t;
    NumberAnimation on t { from: 0; to: 1; duration: 2347; loops: Animation.Infinite }

    Repeater {
        id: repeater
        model: root.count
        Text {
            x: Math.random() * root.width
            y: Math.random() * root.height
            text: Math.floor( root.t * 1000 ) / 1000;
        }
    }
}
