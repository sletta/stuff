import QtQuick 2.4

ListView {
    id: listView

    property int cellWidth: 70
    property int cellHeight: 20
    property int cellSpacing: 5

    NumberAnimation on contentY {
        from: 0; to: 1000; duration: 5000; loops: -1
    }

    clip: true
    model: tableModel
    delegate: Item {
        id: rowContainer
        width: cellWidth + cellSpacing
        height: cellHeight + cellSpacing

        Row {
            spacing: cellSpacing
            Repeater {
                model: columnSize;

                Loader {

                    sourceComponent: {
                        var type = eval("columnType" + index);
                        switch (type) {
                            case 0: return comp0;
                            case 1: return comp1;
                            case 2: return comp2;
                            case 3: return comp3;
                            case 4: return comp4;
                            case 5: return comp5;
                            case 6: return comp6;
                        }
                        return null;
                    }

                    Component {
                        id: comp0
                        Item {
                            width: cellWidth
                            height: cellHeight

                            Rectangle {
                                anchors.fill: parent
                                color: Qt.hsla(0 / 7.0, 0.5, 0.3);
                            }

                            Text {
                                text: column0;
                                anchors.centerIn: parent
                                color: "white"
                            }
                        }
                    }

                    Component {
                        id: comp1
                        Item {
                            width: cellWidth
                            height: cellHeight

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
                    }

                    Component {
                        id: comp2
                        Item {
                            width: cellWidth; height: cellHeight;
                            Rectangle { color: Qt.hsla(2 / 7.0, 0.5, 0.3); anchors.fill: parent; }
                            Text { text: column3; anchors.centerIn: parent; color: "white"; font.bold: true }
                        }
                    }

                    Component {
                        id: comp3
                        Item {
                            width: cellWidth; height: cellHeight;
                            Rectangle { color: Qt.hsla(3 / 7.0, 0.5, 0.3); anchors.fill: parent; }
                            Text { text: column3; anchors.centerIn: parent; color: Qt.hsla(0.6, 0.5, 0.9); }
                        }
                    }

                    Component {
                        id: comp4
                        Item {
                            width: cellWidth; height: cellHeight;
                            Rectangle { color: Qt.hsla(4 / 7.0, 0.5, 0.3); anchors.fill: parent; }
                            Text { text: column4; anchors.centerIn: parent; color: "white"; font.underline: true }
                        }
                    }

                    Component {
                        id: comp5
                        Item {
                            width: cellWidth; height: cellHeight;
                            Rectangle { color: Qt.hsla(5 / 7.0, 0.5, 0.3); anchors.fill: parent; border.color: "white"; radius: 4 }
                            Text { text: column5; anchors.centerIn: parent; color: "white"; style: Text.Raised }
                        }
                    }

                    Component {
                        id: comp6
                        Item {
                            width: cellWidth; height: cellHeight;
                            Rectangle { color: Qt.hsla(6 / 7.0, 0.5, 0.8); anchors.fill: parent; }
                            Text { text: column6; anchors.centerIn: parent; color: "black" }
                        }
                    }
                }
            }
        }
    }
}
