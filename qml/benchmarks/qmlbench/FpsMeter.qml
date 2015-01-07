import QtQuick 2.0

Item {

    id: root

    property int tickCounter;
    property var lastFrameTime: new Date();
    property real fps: 0;

    width: 10
    height: 10

    Rectangle {
        id: swapTest
        anchors.fill: parent
        property real t;
        NumberAnimation on t { from: 0; to: 1; duration: 1000; loops: Animation.Infinite }
        onTChanged: {
            ++root.tickCounter;
            color = (root.tickCounter % 2) == 0 ? "red" : "blue"
        }
    }

    Timer {
        id: updateFpsTimer
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            var now = new Date();
            var dt = now.getTime() - lastFrameTime.getTime();
            root.lastFrameTime = now;
            var fps = (root.tickCounter * 1000) / dt;
            root.fps = Math.round(fps * 10) / 10;
            root.tickCounter = 0;
        }
    }

}
