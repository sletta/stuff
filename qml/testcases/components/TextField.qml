import QtQuick 2.0


Rectangle {
    id: textAreaBackground

    color: "white"

    border.color: "steelblue"
    border.width: textArea.activeFocus ? 2 : 1

    TextInput {
        id: textArea
        anchors.fill: parent
        anchors.margins: 5
        horizontalAlignment: Text.Right
        verticalAlignment: Text.Center
    }
}
