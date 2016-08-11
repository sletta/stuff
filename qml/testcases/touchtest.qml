import QtQuick 2.2

Canvas
{
    id: canvas

    width: 480
    height: 320

    property var pts: []

    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)
        ctx.fillStyle = "black"

        ctx.beginPath();
        var S = 1;
        for (var i=0; i<pts.length; ++i) {
            var pt = pts[i];
            var s2 = 2 * S + 1;
            ctx.rect(pt.x - S, pt.y - S, s2, s2);
        }
        ctx.fill();
    }

    MouseArea {
        anchors.fill: parent

        onPositionChanged: {
            pts.push({x: mouse.x, y: mouse.y});
            canvas.requestPaint()
        }

        onDoubleClicked: {
            pts = [];
            canvas.requestPaint();
        }

    }

}