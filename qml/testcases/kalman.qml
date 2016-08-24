import QtQuick 2.4

// Implementation based on: http://roxlu.com/2015/051/kalman-filter

Item
{
    id: root

    width: 480
    height: 320

    property var sourcePoints: [];

    property var errorRatio: 20

    function createData(w, h) {
        var pts = []
        var cx = width / 2
        var cy = height / 2
        var radius = 0.8
        var error = 20

        for (var i=0; i<100; ++i) {
                var t = i / 150
                pts[i] = {
                    x: cx + radius * cx * Math.cos(t * Math.PI * 2) + Math.random() * error,
                    y: cy + radius * cy * Math.sin(t * Math.PI * 2) + Math.random() * error
                }
        }
        return pts
    }

    function createFilter() {
        var filter = {}
        filter.q = 1
        filter.r = 10
        filter.p = 1
        filter.x = 0.5
        filter.k = 0.0
        filter.compute = function(z) {
            this.p = this.p + this.q;
            this.k = this.p / (this.p + this.r);
            this.x = this.x + this.k * (z - this.x);
            this.p = (1.0 - this.k) * this.p;
            return this.x
        }
        filter.toString = function() {
            return "Filter(q=" + this.q
                   + ", r=" + this.r
                   + ", p=" + this.p
                   + ", x=" + this.x
                   + ", k=" + this.k + ")"
        }
        return filter
    }

    Canvas
    {
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")

            ctx.fillStyle = "rgb(127, 0, 0)"
            ctx.strokeStyle = "black"
            ctx.lineWidth = 0.5

            var data = root.createData(width, height)

            ctx.beginPath();
            for (var i=0; i<data.length; ++i) {
                var pt = data[i]
                ctx.lineTo(pt.x, pt.y)
            }
            ctx.stroke()

            for (var i=0; i<data.length; ++i) {
                var pt = data[i]
                ctx.beginPath()
                ctx.arc(pt.x, pt.y, 2, 0, 2 * Math.PI * 2, false)
                ctx.fill()
            }



            var xFilter = root.createFilter()
            var yFilter = root.createFilter()

            ctx.beginPath()
            for (var i=0; i<data.length; ++i) {
                var pt = data[i]
                if (i == 0) {
                    xFilter.x = pt.x
                    yFilter.x = pt.y
                }
                var x = xFilter.compute(pt.x);
                var y = yFilter.compute(pt.y);
                // print(i + ": " + x + "," + y)
                ctx.lineTo(x, y);
            }
            ctx.strokeStyle = "blue"
            ctx.lineWidth = 2
            ctx.stroke();

        }
    }


}