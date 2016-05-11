import QtQuick 2.4
import MyVLC 0.1

Item
{
	id: root

	width: 800
	height: 480

	VLCItem {
		source: "movie.mp4"
		anchors.fill: parent
	}


}