import QtQuick 2.3
import org.sletta.core 1.0

import "math3d.js" as Math3D

Item {
    id: root

    width: 640
    height: 480

    // public API
    property bool includeNoise: false
    property alias shaderFile: shaderSourceTracker.file 
    property alias animatedTime: timeAnimator.running;

    property string fragmentShader: (includeNoise 
                                     ? "#version 120\n" + noiseTable.content + "\n" + noiseFunctions.content + "\n" 
                                     : "")
                                    + shaderSourceTracker.content;
    property string shaderSource: shaderSourceTracker.content;


    FileContentTracker {
        id: noiseTable
        file: "../noise/noisetable.fsh"
    }

    FileContentTracker {
        id: noiseFunctions
        file: "../noise/noisefunctions.fsh"
    }

    FileContentTracker {
        id: shaderSourceTracker
    }

    function updateMatrix() {
        var m = navigator.matrix.data;
        effect.matrix = Qt.matrix4x4(m[0], m[1], m[2], m[3],
                                     m[4], m[5], m[6], m[7],
                                     m[8], m[9], m[10], m[11],
                                     m[12], m[13], m[14], m[15]);
    }

    property real textureScale: 1

    function resetMatrix() {
        navigator.matrix = new Math3D.mat4();
        navigator.matrix.translate(0, 1.0, 4);
        navigator.matrix.rotateAroundX(-0.5);
        updateMatrix();
    }

    Navigator {
        id: navigator;
        anchors.fill: parent
        onChanged: updateMatrix();
        Component.onCompleted: {
            resetMatrix();
        }
    }


    ShaderEffect {
        id: effect

        anchors.fill: parent
        fragmentShader: root.fragmentShader

        property var resolution: Qt.vector2d(width, height)
        property var matrix;
        property var time;

        layer.enabled: root.textureScale > 1;
        layer.textureSize: Qt.size(root.width / textureScale, root.height / textureScale);
        layer.smooth: false;

        UniformAnimator on time { 
            id: timeAnimator
            from: 0
            to: 1000000
            duration: 1000000
            loops: Animation.Infinite
            running: false
        }
    }
}