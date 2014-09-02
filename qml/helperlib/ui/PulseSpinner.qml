import QtQuick 2.2

import org.sletta.core 1.0

ShaderEffect
{
    id: root

    width: 300
    height: 300

    property bool running: true

    property real _tr;
    property real _tw;

    SequentialAnimation {
        ParallelAnimation {
            UniformAnimator { target: root; uniform: "_tr"; from: 0.5; to: 1; duration: 500; easing.type: Easing.OutCubic }
            UniformAnimator { target: root; uniform: "_tw"; from: 0.2; to: 0.9; duration: 500; easing.type: Easing.OutCubic }
        }
        ParallelAnimation {
            UniformAnimator { target: root; uniform: "_tr"; from: 1.0; to: 0.5; duration: 1500; easing.type: Easing.InCubic }
            UniformAnimator { target: root; uniform: "_tw"; from: 0.9; to: 0.2; duration: 1500; easing.type: Easing.OutExpo }
        }
        running: true
        loops: Animation.Infinite
    }

    FileContentTracker {
        id: fragTracker;
        file: Qt.resolvedUrl("pulsespinner.fsh")
    }

    fragmentShader: fragTracker.content
}
