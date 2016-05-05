import QtQuick 2.4

Item {
    Rectangle {
        anchors.fill: parent
        color: Qt.hsla(1 / 7.0, 0.5, 0.3);
    }

    Text {
        text: column1;
        anchors.centerIn: parent
        color: "white"
        font.italic: true
    }
}
