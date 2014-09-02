import QtQuick 2.2
import org.sletta.core 1.0

import "math3d.js" as Math3D

ShaderEffect {
    id: shader

    width: 700
    height: 500

    FileContentTracker {
        id: tracker
        file: "tracing.fsh"
    }

    CubeTexture {
        id: textures
    }

    property real tSlow;
    UniformAnimator on tSlow { from: 0; to: 1; duration: 13791; loops: Animation.Infinite }

    property real tFast;
    UniformAnimator on tFast { from: 0; to: 1; duration: 1973; loops: Animation.Infinite }

    property size resolution: Qt.size(width, height);

    property Image skymap: Image { source: "skymap.jpg"; visible: false }
    property variant normals: textures.normalmapTexture
    property Image materials: Image { source: "reflection.png"; visible: false }

    property variant matrix: Qt.matrix4x4();

    property variant cubeMatrix: Qt.matrix4x4();

    property real cubeRotation: 0;
    NumberAnimation on cubeRotation { from: 0; to: Math.PI * 2; duration: 19007; loops: Animation.Infinite }
    onCubeRotationChanged: {
        var matrix = new Math3D.mat4();
        matrix.rotateAroundY(cubeRotation);
        matrix.rotateAroundX(-Math.PI / 4);
        matrix.rotateAroundZ(Math.PI / 4);
        var m = matrix.data;
        cubeMatrix = Qt.matrix4x4(m[0], m[1], m[2], m[3],
                                  m[4], m[5], m[6], m[7],
                                  m[8], m[9], m[10], m[11],
                                  m[12], m[13], m[14], m[15]);
    }

    function updateMatrix() {
        var m = navigator.matrix.data;
        matrix = Qt.matrix4x4(m[0], m[1], m[2], m[3],
                              m[4], m[5], m[6], m[7],
                              m[8], m[9], m[10], m[11],
                              m[12], m[13], m[14], m[15]);


    }

    fragmentShader: tracker.content

    Navigator {
        id: navigator;
        anchors.fill: parent
        onChanged: updateMatrix();
        Component.onCompleted: {
//            matrix.data = [
//                    0.84,  0.03, -0.55, -0.15,
//                   -0.14,  0.98, -0.17, -0.13,
//                    0.53,  0.22,  0.82, -1.70,
//                    0,     0,     0,     1]

            /*
              [1, 0, 0, 0,
               0, 0.97, 0.25, 3,
               0, -0.25, 0.97, 6,
               0, 0, 0, 1]
              */

            matrix.translate(3, 1, 6);
            matrix.rotateAroundY(0.3);
            matrix.rotateAroundX(-0.25);

            print(matrix.data)

            updateMatrix();


        }
    }
}
