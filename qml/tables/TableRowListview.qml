import QtQuick 2.4
import Tables 0.1

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
    delegate: TableRow {
        height: cellHeight + cellSpacing;
        cellWidth: listView.cellWidth;
        cellSpacing: listView.cellSpacing;
        model: tableModel;
        row: index
    }

}
