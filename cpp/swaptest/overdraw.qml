import QtQuick
import QtQuick.Window

Window
{
    id: window

    width: Screen.width
    height: Screen.height

    visible: true
    visibility: "FullScreen"

    readonly property int overdraw: 8

    Item {
        id: root
        anchors.fill: parent

        Repeater {
            model: overdraw

            Rectangle {
                width: Math.max(window.width, window.height)
                height: width
                anchors.centerIn: parent
                property real alpha: Math.min(0.5, (3.0 / overdraw))
                color: Qt.hsla((index * .271) % 1.0, 0.5, 0.5, alpha);
                layer.enabled: true
                layer.format: ShaderEffectSource.RGBA
                NumberAnimation on rotation { from: 0; to: 360; loops: -1; duration: 5000 + (1000 * index) }
                Text {
                    font.pixelSize: parent.height * 0.05
                    font.family: "Courier"
                    text: "Layer " + (index + 1)
                    x: Math.random() * (parent.width - width)
                    y: Math.random() * (parent.height - height)
                }
            }
        }

        Rectangle {
            id: fpsMeter

            anchors.centerIn: parent
            width: 100
            height: 100
            color: alternate ? "red" : "blue"

            property bool alternate
            property real t;
            NumberAnimation on t { from: 0; to: 1; duration: 1000; loops: -1 }
            onTChanged: {
                fpsMeter.alternate = !fpsMeter.alternate
            }
        }
    }
}
