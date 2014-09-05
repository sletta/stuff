import QtQuick 2.0

Rectangle {
    id: root

    width: 3 * cm
    height: 1 * cm

    property alias text: label.text
    signal clicked;

    gradient: Gradient {
        GradientStop { position: 0; color: Qt.hsla(0, 0, 0.3); }
        GradientStop { position: 0.33; color: mouse.pressed ? Qt.hsla(0, 0, 0.2) : Qt.hsla(0, 0, 0.1); }
    }

    radius: height / 3;
    border.width: mouse.pressed ? 0.1 * cm : 0.01 * cm;
    border.color: Qt.hsla(0, 0, 0.5);

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()
    }

    Text {
        id: label
        color: "white"
        font.family: "Open Sans"
        font.pixelSize: 0.35 * cm
        anchors.centerIn: parent
    }

}
