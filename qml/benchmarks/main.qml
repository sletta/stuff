import QtQuick 2.0

/*
  - overdraw
    - solid rectangles
    - blended rectangles
    - solid images
    - blended images

  - throughput
    - moving images
    - moving rectangles

  - complete tests
    - list scrolling
    - home screen scrolling
    - text table
 */

Item {
    id: root

    width: 640
    height: 480

    onWidthChanged: updateDescription()
    onHeightChanged: updateDescription()

    property int pendingBenchmark: -1;
    property int currentBenchmark;
    property var benchmarks: [
        "solidrect.qml",
        "blendedrect.qml",
        "opaquetexture.qml",
        "blendedtexture.qml",
        "drawcalls.qml",
        "sprite-image.qml",
        "sprite-sequence.qml",
        "moving-images-animators.qml",
        "moving-images-animations.qml",
        "moving-images-script.qml",
        "delegates_rect.qml",
        "delegates_tworects.qml",
        "delegates_script.qml",
        "delegates_image.qml",
        "delegates_text.qml",
        "delegates_longtext.qml",
        "delegates_complex.qml",
        "gaussblur.qml"
    ]

    Loader {
        id: loader
        anchors.fill: parent
        source: "benchmark/" + benchmarks[root.currentBenchmark]
        onLoaded: {
            root.updateDescription()
            spinner.running = false
            spinner.opacity = 0
        }
    }

    onPendingBenchmarkChanged: {
        if (pendingBenchmark >= 0) {
            updateDescription();
            switchBenchmark.start();
        }
    }

    GradientSpinner {
        id: spinner;
        width: 3 * cm;
        height: width;
        anchors.centerIn: parent;
        running: true;
        duration: 500
        circleWidth: 0.1 * cm;
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    SequentialAnimation {
        id: switchBenchmark
        PropertyAction { target: spinner; property: "running"; value: true }
        PropertyAction { target: spinner; property: "opacity"; value: 1 }
        PauseAnimation { duration: 250 }
        ScriptAction { script: {
                var pending = root.pendingBenchmark;
                root.pendingBenchmark = -1;
                root.currentBenchmark = pending;
            }
        }
    }

    property real cm: 50;
    Component.onCompleted: {
        var window = Qt.createQmlObject("import QtQuick.Window 2.0; Window { property real cm: Screen.pixelDensity * 10; }", root, "cmhack.qml");
        root.cm = window.cm;
        window.destroy();
    }

    UI {
        id: ui;
        anchors.fill: parent

        onComplicate: {
            try {
                loader.item.complicate()
                root.updateDescription()
            } catch (e) { print("complicate failed, " + e); }
        }
        onSimplify: {
            try {
                loader.item.simplify()
                root.updateDescription()
            } catch (e) { print("complicate failed, " + e); }
        }
        onNext: {
            if (pendingBenchmark >= 0)
                return;
            var n = currentBenchmark + 1;
            if (n >= root.benchmarks.length)
                n = 0;
            pendingBenchmark = n;
        }
        onPrevious: {
            if (pendingBenchmark >= 0)
                return;
            var n = currentBenchmark - 1;
            if (n < 0)
                n = root.benchmarks.length - 1;
            pendingBenchmark = n;
        }
    }

    FpsMeter {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }

    function updateDescription()
    {
        try {
            if (root.pendingBenchmark >= 0) {
                description.text = "Loading: " + root.benchmarks[pendingBenchmark];
            } else {
                description.text = loader.item.description
            }
        } catch (e) {
            description.text = "Benchmark is missing description..."
        }
    }

    Rectangle {
        anchors.fill: description
        anchors.margins: -0.2 * cm
        opacity: 0.9
    }

    Text {
        id: description
        font.pixelSize: 0.35 * cm;
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 0.2 * cm
    }
}
