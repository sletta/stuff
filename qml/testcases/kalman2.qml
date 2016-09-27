import QtQuick 2.4

import "math.js" as M;

// Implementation based on: http://roxlu.com/2015/051/kalman-filter

Rectangle
{
    id: root

    width: 1280
    height: 720

    color: "black"

    property var sourcePoints: [];

    property var errorRatio: 20

    property var dT: 0.01

    function createData(w, h) {

        var pts = []

        var start = 100
        var end = width - 100

        var steps = 50
        var w = end - start

        for (var i=0; i<steps; ++i) {
            var t = i/(steps - 1)
            pts[i] = {}

            // pts[i] = { x: start + (Math.sin(t * Math.PI - Math.PI / 2) * 0.5 + 0.5) * w }
            // pts[i].v = i == 0 ? 0 : (pts[i].x - pts[i-1].x) / dT
        }


        return pts
    }

    function createSimpleFilter() {
        var filter = {}
        filter.q = 1
        filter.r = 5
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


    function filterData_simple(source) {
        var result = []
        var filter = createSimpleFilter()
        filter.x = source[0].x
        for (var i=0; i<source.length; ++i)
            result[i] = { x: filter.compute(source[i].x),
                          v: 0
                        }
        return result
    }

    function filterData_v(source) {
        var filtered = []

        var F = new M.mat2(1, dT,
                           0, 1)
        var K = new M.mat2(0.5, 0,
                           0, 0.5)
        filtered[0] = new M.vec2(source[0].x, source[0].v)

        for (var i=1; i<source.length; ++i) {

            var last = filtered[i-1]

            var predNext = F.multiplyWithVector(new M.vec2(last.x, last.y))

            var measured = new M.vec2(source[i].x, source[i].v)
            var diff = measured.subtract(predNext)

            filtered[i] = last.add(K.multiplyWithVector(diff))
            filtered[i].x += 0.007 * filtered[i].y
        }

        return filtered
    }

    Canvas
    {
        id: canvas
        anchors.fill: parent

        function drawDots(ctx, pos, source, sourceColor, filtered, filterColor) {

            var distance = 40

            // Draw lines between source points and filtered points
            ctx.strokeStyle = "rgb(200, 200, 200)"
            ctx.beginPath()
            for (var i=0; i<Math.min(filtered.length, source.length); ++i) {
                var f = filtered[i].x
                var d = source[i].x
                ctx.moveTo(d, pos)
                ctx.lineTo(f, pos + distance)
            }
            ctx.stroke()

            // Draw the source point dots
            ctx.fillStyle = sourceColor
            for (var i=0; i<source.length; ++i) {
                var pt = source[i].x
                ctx.beginPath()
                ctx.arc(pt, pos, 2, 0, 2 * Math.PI, false)
                ctx.fill()
            }

            // Draw the filtered point dots
            ctx.fillStyle = filterColor
            for (var i=0; i<filtered.length; ++i) {
                var pt = filtered[i].x
                ctx.beginPath()
                ctx.arc(pt, pos + distance, 2, 0, 2 * Math.PI, false)
                ctx.fill()
            }
        }

        onPaint: {
            var ctx = getContext("2d")

            ctx.clearRect(0, 0, width, height)

            ctx.lineWidth = 0.5

            var sourcePos = 200
            var filterPos = 250
            var filterVPos = 150

            ctx.globalCompositeOperation = "lighter"

            var data = root.createData(width, height)
            var filtered = filterData_simple(data)
            var filteredV = filterData_v(data)

            drawDots(ctx, 100, data, "rgb(100, 100, 255)", filtered, "rgb(255, 100, 100)")
            drawDots(ctx, 200, data, "rgb(100, 100, 255)", filteredV, "rgb(100, 255, 100)")
        }
    }


    Timer {
        id: repeater
        interval: 100
        onTriggered: canvas.requestPaint()
        repeat: true
        running: true
    }

}