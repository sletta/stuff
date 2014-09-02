import QtQuick 2.2

import org.sletta.core 1.0

ShaderEffect
{
    id: root

    width: 300
    height: 300

    property bool reversed: false
    property bool running: true
    property real duration: 1500;
    property real circleWidth: Math.min(width, height) * 0.2;

    property color color0: "steelblue";
    property color color1: Qt.rgba(0, 0, 0, 0.1);

    property Gradient gradient: Gradient {
        GradientStop { position: 0; color: root.color1 }
        GradientStop { position: 0.05; color: root.color0 }
        GradientStop { position: 1; color: root.color1 }
    }

    Rectangle {
        id: gradientRect
        width: 1;
        height: 32
        gradient: root.gradient
        layer.enabled: true
        visible: false
    }


    property real _t;
    property real _edgeSize: 4 / Math.min(width, height);
    property real _circleWidth: 2 * circleWidth / Math.min(width, height);
    property variant _colors: gradientRect;


    UniformAnimator on _t {
        from: root.reversed ? Math.PI * 2 : 0;
        to: root.reversed ? 0 : Math.PI * 2;
        duration: root.duration;
        running: root.running;
        loops: Animation.Infinite
    }

    FileContentTracker {
        id: fragTracker;
        file: Qt.resolvedUrl("gradientspinner.fsh")
    }

    fragmentShader: fragTracker.content
}
