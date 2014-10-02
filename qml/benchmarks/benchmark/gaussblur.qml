import QtQuick 2.2
import QtGraphicalEffects 1.0

Item {
    id: root;
    function complicate() { sampleCount = Math.min(32, sampleCount+1); }
    function simplify() { sampleCount = Math.max(2, sampleCount-1); }
    property int sampleCount: 8
    property string description: "Gaussian Blur with " + sampleCount + " samples";

    width: 600
    height: 600

    Image {
        id: contentRoot
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "grapes.jpg"
        Rectangle {
            color: "palegreen"
            border.color: "black"
            width: parent.width / 3
            height: parent.width / 3
            RotationAnimator on rotation { from: 0; to: 360; duration: 10000; loops: Animation.Infinite }
            anchors.centerIn: parent
            antialiasing: true
        }

        layer.enabled: true
        layer.effect: GaussianBlur {
            samples: root.sampleCount
            radius: root.sampleCount
            deviation: Math.sqrt(root.sampleCount)
        }
    }
}
