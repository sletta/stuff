import QtQuick 2.4

Rectangle
{
	id: root

    width: 480
    height: 320

    objectName: "root"

    gradient: Gradient {
        GradientStop { position: 0.0; color: "steelblue" }
        GradientStop { position: 1.0; color: "black" }
    }

	ListView
	{
		id: listView

		model:	tableModel
		anchors.fill: parent

		delegate: Item {
			id: cellRoot
			width: listView.width
			height: 50

			Rectangle {
				id: cellBackground
				anchors.fill: parent
				anchors.leftMargin: 5
				anchors.rightMargin: 5
				anchors.bottomMargin: 5
				color: "black"
				opacity: 0.2
			}

			Text {
				property string resultString: result == undefined ? "?" : result;
				color: "white"
				text: "Fibbonacci number #" + (index+1) + " is: " + resultString;
				anchors.verticalCenter: cellBackground.verticalCenter
				font.pixelSize: 20
				x: 20
			}
		}
	}
}
