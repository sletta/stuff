import QtQuick 2.4

Rectangle
{
    width: 800
    height: 480

    objectName: "root"

    gradient: Gradient {
        GradientStop { position: 0.0; color: "steelblue" }
        GradientStop { position: 1.0; color: "black" }
    }

    Loader {
        id: loader
        anchors.fill: parent
        anchors.margins: 10
    }

    Timer {
        id: timer
        running: true
        interval: 1000
        repeat: false
        onTriggered: {
            var startTime = new Date().getTime();
            var count = 100;
            print("Now starting...");
            for (var i=0; i<count; ++i) {
                loader.source = "";
                loader.source = viewComponent;
            }
            var delta = new Date().getTime() - startTime;
            print("All done, " + delta + "ms total, " + delta / count + "ms per iteration");
        }
    }

}