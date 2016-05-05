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
        width: rowContainer.width
        height: cellHeight + cellSpacing

        Row {
            id: rowContainer
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
                        Delegate0 { width: cellWidth; height: cellHeight }
                    }

                    Component {
                        id: comp1
                        Delegate1 { width: cellWidth; height: cellHeight }
                    }

                    Component {
                        id: comp2
                        Delegate2 { width: cellWidth; height: cellHeight }
                    }

                    Component {
                        id: comp3
                        Delegate3 { width: cellWidth; height: cellHeight }
                    }

                    Component {
                        id: comp4
                        Delegate4 { width: cellWidth; height: cellHeight }
                    }

                    Component {
                        id: comp5
                        Delegate5 { width: cellWidth; height: cellHeight }
                    }

                    Component {
                        id: comp6
                        Delegate6 { width: cellWidth; height: cellHeight }
                    }
                }
            }
        }
    }
}
