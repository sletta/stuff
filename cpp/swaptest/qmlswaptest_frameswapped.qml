import QtQuick 2.0
import QtQuick.Window 2.0

Window {

    id: root

    property var startTime;
    property int frameCount: 0;

    color: frameCount % 2 == 0 ? "red" : "blue"

    onFrameSwapped: {
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
