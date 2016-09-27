import QtQuick 2.4

import "math.js" as M;

// Implementation based on: http://roxlu.com/2015/051/kalman-filter

Rectangle
{
    id: root

    width: 480
    height: 320

    color: "black"

    function createData(w, h) {

        var samples = []

        var start = 100
        var end = width - 100

        var steps = 50
        var w = end - start
        var dt = 0.01

        for (var i=0; i<steps; ++i) {
            var t = i/(steps - 1)

            var sample = {}
            sample.time = i * dt;
            sample.value = start + (Math.sin(t * Math.PI - Math.PI / 2) * 0.5 + 0.5) * w

            sample.velocity = i == 0 ? 0 : (sample.value - samples[i-1].value) / dt

            samples[i] = sample
        }

        return samples
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

    function getFilterSamples(source)
    {
        var interval = 1000.0 / 60000.0
        var samples = []
        var current = source[0]
        var next = source[1]
        var time = source[0].time
        for (var i=1; i<source.length; ++i) {
            next = source[i]
            if (current.time <= time && next.time > time) {
                samples.push( {
                    value: current.value,
                    velocity: current.velocity,
                    time: current.time,
                    source: current,
                    sourceIndex: i - 1
                } );
                time += interval
            }
            current = next
        }
        return samples
    }

    function filterData_simple(samples) {
        samples = getFilterSamples(samples)
        var filter = createSimpleFilter()
        filter.x = samples[0].value
        for (var i=0; i<samples.length; ++i) {
            var s = samples[i]
            s.value = filter.compute(samples[i].value)
        }
        return samples
    }

    function filterData_v(samples, prediction) {
        samples = getFilterSamples(samples)
        var filtered = []

        var dT = 1000.0 / 60000.0

        var A = new M.mat2(1, dT,
                           0, 1)
        var P = new M.mat2(0, 0,
                           0, 0)
        var Q = new M.mat2(0.0, 0.0,
                           0.0, 0.1)
        var R = new M.mat2(0.1, 0.0,
                           0.0, 0.1)
        var H = new M.mat2(1, 0,
                           0, 1)
        var I = new M.mat2(1, 0, 0, 1)
        var s = new M.vec2(samples[0].value,
                           samples[0].velocity)
        var x = new M.vec2(s.x, s.y)

        filtered[0] = {
            time: samples[0].time,
            value: samples[0].value,
            sourceIndex: samples[0].sourceIndex,
            source: samples[0],
            velocity: samples[0].velocity
        }

        for (var i=1; i<samples.length; ++i) {

            // print("iteration: " + i)
            // print(" - source: position=" + samples[i].value + ", velocity=" + samples[i].velocity + " (" + (samples[i].velocity * dT) + ")")

            // Prediction step
            x = A.multiplyVector(x)
            P = A.multiply(P).multiply(A.transpose()).add(Q)

            // print(" - x=" + x)
            // print(" - P=" + P)

            // Correction step
            var S = H.multiply(P).multiply(H.transpose()).add(R)
            // print(" - S=" + S)

            var K = P.multiply(H.transpose()).multiply(S.invert())
            // print(" - K=" + K)
            var m = new M.vec2(samples[i].value, samples[i].velocity)
            // print(" - m=" + m)

            var y = m.subtract(H.multiplyVector(x))
            // print(" - y=" + y)

            x = x.add(K.multiplyVector(y))
            // print(" - x=" + x)

            P = I.subtract(K.multiply(H)).multiply(P)
            // print(" - P=" + P)

            // Write out the value...
            filtered[i] = {
                time: i * dT,
                value: x.x + prediction * x.y,
                velocity: x.y,
                source: samples[i],
                sourceIndex: samples[i].sourceIndex
            }
        }

        return filtered
    }

    Canvas
    {
        id: canvas
        anchors.fill: parent

        function drawDots(ctx, pos, dots, color) {
            // Draw the source point dots
            ctx.fillStyle = color
            for (var i=0; i<dots.length; ++i) {
                var pt = dots[i].value
                ctx.beginPath()
                ctx.arc(pt, pos, 2, 0, 2 * Math.PI, false)
                ctx.fill()
            }
        }

        function drawFiltered(ctx, pos, source, sourceColor, filtered, filterColor) {

            var distance = 25

            // Draw lines between source points and filtered points
            ctx.strokeStyle = "rgb(40, 40, 40)"
            ctx.beginPath()
            for (var i=0; i<source.length; ++i) {
                var d = source[i]
                ctx.moveTo(d.value, pos)
                ctx.lineTo(d.value, pos + distance)
            }
            ctx.stroke()

            // Draw lines between source points and filtered points
            ctx.strokeStyle = "rgb(60, 60, 60)"
            ctx.beginPath()
            for (var i=0; i<filtered.length; ++i) {
                var f = filtered[i]
                var d = source[f.sourceIndex]
                ctx.moveTo(d.value, pos)
                ctx.lineTo(f.value, pos + distance)
            }
            ctx.stroke()


            drawDots(ctx, pos, source, sourceColor)
            drawDots(ctx, pos + distance, filtered, filterColor)
        }

        onPaint: {
            var ctx = getContext("2d")

            ctx.save()
            ctx.clearRect(0, 0, width, height)

            ctx.lineWidth = 0.5

            var sourcePos = 200
            var filterPos = 250
            var filterVPos = 150

            var sampleColor = "rgb(50, 50, 200)"

            ctx.globalCompositeOperation = "lighter"

            var samples = root.createData(width, height)
            var direct = getFilterSamples(samples)
            var simple = filterData_simple(samples)
            var filteredV = filterData_v(samples, 0)
            var filteredVP = filterData_v(samples, 0.016)

            drawFiltered(ctx, 60, samples, sampleColor, direct, "rgb(200, 50, 50)")
            drawFiltered(ctx, 120, samples, sampleColor, simple, "rgb(50, 200, 50)")
            drawFiltered(ctx, 180, samples, sampleColor, filteredV, "rgb(50, 200, 200)")
            drawFiltered(ctx, 240, samples, sampleColor, filteredVP, "rgb(200, 50, 200)")

            ctx.restore()
        }
    }


    Timer {
        id: repeater
        interval: 100
        onTriggered: canvas.requestPaint()
        repeat: true
        running: false
    }

}