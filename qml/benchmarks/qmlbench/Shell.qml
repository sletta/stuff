import QtQuick 2.0

Item {
    width: 320
    height: 480

    objectName: "benchmarkShell"

    property Component benchmarkDelegate;

    FpsMeter {
        id: fpsMeter

        clip: true

        onFpsChanged: {
            print("FPS is now: " + fps);
        }

        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }
}
