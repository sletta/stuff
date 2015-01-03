import QtQuick 2.3
import Qt.labs.folderlistmodel 2.1

TracingBase {
    id: root

    includeNoise: shaderSource.indexOf("USE_NOISE") >= 0;
    animatedTime: shaderSource.indexOf("ANIMATE_TIME") >= 0;

    FolderListModel {
        id: folderModel
        nameFilters: ["*.fsh"]
        folder: "shaders"
        sortField: FolderListModel.Time;
    }

    function activate(index) {
        print("activating: " + index + ", model size: " + folderModel.count);
        if (folderModel.count > index) {
            listView.currentIndex = index;
            var name = folderModel.get(index, "fileName");
            print("now activating shader: " + name);
            root.shaderFile = folderModel.folder + "/" + name;
        }
    }

    Timer {
        id: onStartTimer
        interval: 500
        running: true
        repeat: false
        onTriggered: activate(0);
    }

    ListView {
        id: listView
        width: 150
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        model: folderModel
        delegate: Rectangle {
            color: index == listView.currentIndex 
                            ? Qt.hsla(0, 0, 0.3)
                            : Qt.hsla(0, 0, ((index % 2) == 0) ? 0.1 : 0.2, 0.5);
            height: 20
            width: listView.width
            Text { 
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                text: fileBaseName
                color: font.bold ? "white" : "lightgray"
                font.bold: listView.currentIndex == index;
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listView.currentIndex = index;
                    root.shaderFile = folderModel.folder + "/" + fileName
                }
            }
        }
    }
}