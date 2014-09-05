import QtQuick 2.0

Rectangle {

    id: root

    property int tickCounter;
    property var lastFrameTime: new Date();
    property real fps: 0;

    width: 3 * cm
    height: cm

    color: Qt.hsla(0, 0, 1, 0.9);

    Rectangle {
        id: cross
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        width: 1 * cm * 0.9
        height: 0.1 * cm
        color: "black"
        border.color: "white"
        antialiasing: true
        NumberAnimation on rotation { from: 0; to: 360; duration: 5000; loops: Animation.Infinite }
        onRotationChanged: {
            root.tickCounter++;
        }

        Rectangle {
            anchors.centerIn: parent
            color: "black"
            border.color: "white"
            height: 1 * cm * 0.9
            width: 0.1 * cm
            antialiasing: true
        }
    }

    Text {
        font.family: "Open Sans"
        font.pixelSize: cm
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: cross.left
        anchors.margins: 0.5 * cm
        style: Text.Outline
        styleColor: "white"
        color: "black"
        text: Math.round(root.fps);

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
            root.fps = (root.tickCounter * 1000) / dt;
            root.tickCounter = 0;
        }
    }

}
