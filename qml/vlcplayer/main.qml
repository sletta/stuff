import QtQuick 2.4
import MyVLC 0.1

Item
{
	id: root

	property bool small: true
	property bool many: false

	width: small ? 800 : 1920
	height: small ? 480 : 1080

	// width: 160
	// height: 90

	Grid {
		id: grid
		anchors.fill: parent
		columns: many ? 8 : 1
		rows: many ? 6 : 1

		Repeater {
			model: grid.rows * grid.columns
			VLCItem {
				source: "rtsp://localhost:8554/stream"
				width: grid.width / grid.columns
				height: grid.height / grid.rows
			}
		}
	}


}