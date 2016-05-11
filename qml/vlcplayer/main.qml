import QtQuick 2.4
import MyVLC 0.1

Item
{
	id: root

	width: 1280
	height: 720

	Grid {
		id: grid
		anchors.fill: parent
		columns: 8
		rows: 6

		Repeater {
			model: grid.rows * grid.columns
			VLCItem {
				source: "movie.mp4"
				width: grid.width / grid.columns
				height: grid.height / grid.rows
			}
		}
	}


}