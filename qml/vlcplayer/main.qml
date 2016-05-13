import QtQuick 2.4
import MyVLC 0.1

Item
{
	id: root

	width: 640
	height: 360

	Grid {
		id: grid
		anchors.fill: parent
		columns: 1
		rows: 1

		Repeater {
			model: grid.rows * grid.columns
			VLCItem {
				// source: "movie.mp4"
				source: "rtsp://localhost:8554/stream"
				width: grid.width / grid.columns
				height: grid.height / grid.rows
			}
		}
	}


}