import QtQuick 2.2

import "math3d.js" as Math3D

Item {
    id: nav

    focus: true;

    property var matrix: new Math3D.mat4();

    property bool debug: false;

    signal changed;

    property KeyTracker rx: KeyTracker { keyPos: Qt.Key_W; keyNeg: Qt.Key_S }   // rotation around x
    property KeyTracker ry: KeyTracker { keyPos: Qt.Key_A; keyNeg: Qt.Key_D }   // rotation around y
    property KeyTracker rz: KeyTracker { keyPos: Qt.Key_Q; keyNeg: Qt.Key_E }   // rotation around z
    property KeyTracker tx: KeyTracker { keyPos: Qt.Key_Left; keyNeg: Qt.Key_Right }    // translate along x
    property KeyTracker ty: KeyTracker { keyPos: Qt.Key_O; keyNeg: Qt.Key_L }           // translate along y
    property KeyTracker tz: KeyTracker { keyPos: Qt.Key_Up; keyNeg: Qt.Key_Down }       // translate along z

    property var trackedKeys: [ rx, ry, rz, tx, ty, tz ]

    property real vRotation : 0.02;
    property real vTranslation : 0.05;

    TriggerAnimation {
        running:
            rx.state != 0
            || ry.state != 0
            || rz.state != 0
            || tx.state != 0
            || ty.state != 0
            || tz.state != 0;
        onChanged: {
            var m = new Math3D.mat4();
            if (rx.state != 0) m.rotateAroundX(-rx.state * nav.vRotation);
            if (ry.state != 0) m.rotateAroundY(ry.state * nav.vRotation);
            if (rz.state != 0) m.rotateAroundZ(rz.state * nav.vRotation);
            if (tx.state != 0) m.translate(tx.state * nav.vTranslation, 0, 0);
            if (ty.state != 0) m.translate(0, ty.state * nav.vTranslation, 0);
            if (tz.state != 0) m.translate(0, 0, -tz.state * nav.vTranslation);

            nav.matrix.multiply(m);

            if (nav.debug)
                print(nav.matrix)
            nav.changed();
        }
    }

    Keys.onPressed: {
        for (var i=0; i<trackedKeys.length; ++i)
            trackedKeys[i].updateState(event.key, true);
    }

    Keys.onReleased: {
        for (var i=0; i<trackedKeys.length; ++i)
            trackedKeys[i].updateState(event.key, false);
    }

}
