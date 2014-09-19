import QtQuick 2.0
import QtQuick.Window 2.0

// This test only works on Qt 5.4 due to a bug in Window.color
// when window is without any member items.

Window {
    id: root

    property var startTime;
    property int frameCount: 0;

    color: frameCount % 2 == 0 ? "red" : "blue"

    property real t;
    NumberAnimation on t { from: 0; to: 1000; duration: 1000; loops: Animation.Infinite }
    onTChanged: {
        ++frameCount;
        var runningTime = new Date().getTime() - startTime;
        if (runningTime > 10000) {
            print(frameCount + " frames in " + runningTime + " ms; "
                  + frameCount * 1000.0 / runningTime + " fps, "
                  + runningTime / frameCount + " ms/frame");
            Qt.quit();
        }
    }

    Component.onCompleted: {
        root.showFullScreen();
        startTime = new Date().getTime();
    }
}
