import QtQuick 2.0

Rectangle {
    id: root

    signal clicked

    property alias label: text.text

    width: Math.max(50, text.width + text.font.pixelSize)
    height: Math.max(10, text.width + text.font.pixelSize)

    gradient: Gradient {
        GradientStop { position: 0; color: Qt.rgba(0.5, 0.5, 0.5, 1); }
        GradientStop { position: 1; color: Qt.rgba(0.2, 0.2, 0.2, 1); }
    }
    border.color: mouseArea.pressed ? "lightsteelblue" : "steelblue"
    border.width: mouseArea.pressed ? 5 : 1;

    radius: 5

    Text {
        id: text
        color: "white"
        anchors.centerIn: parent
        font.bold: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked();
    }

}
