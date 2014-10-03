import QtQuick 2.0

import "overdraw.js" as Data;

Item {
    width: 1030

    height: 480

    Canvas {

        id: graphCanvas

        property real padLeft: 50
        property real padRight: 200
        property real padTop: 50
        property real padBottom: 100

        property real margin: 20
        property real barLabelHeight: 50
        property real barWidth: 15
        property real barSpacing: 5

        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");


            var d = Data.createData();

            d.sectionColor = [];
            for (var i=0; i<d.sections.length; ++i)
                d.sectionColor[i] = Qt.hsla(i / d.sections.length, 0.6, 0.7);

            ctx.reset();
            ctx.clearRect(0, 0, width, height);
            ctx.font = "13px Arial"

            // draw the grid..
            ctx.translate(padLeft, graphCanvas.height - padBottom);
            ctx.beginPath();

            var chartHeight = graphCanvas.height - padBottom - padTop
            var chartWidth = graphCanvas.width - padLeft - padRight

            // Draw the lines..
            ctx.save()
            var grad = ctx.createLinearGradient(0, -chartHeight, 0, 0);
            grad.addColorStop(0, Qt.hsla(0, 0, 0.9));
            grad.addColorStop(1, Qt.hsla(0, 0, 0.7));
            ctx.fillStyle = grad;
            ctx.fillRect(0, 0, chartWidth, -chartHeight);
            ctx.translate(0.5, 0.5);
            ctx.moveTo(0, -chartHeight);
            ctx.lineTo(0, 0);
            ctx.lineTo(chartWidth - 1, 0);
            ctx.strokeStyle = "black"
            ctx.stroke();
            ctx.restore();

            // Draw the yAxis label..
            ctx.save();
            ctx.strokeStyle = "black";
            ctx.rotate(-Math.PI / 2);
            ctx.translate(0, -10);
            ctx.textBaseline = "bottom";
            ctx.fillText(d.yAxis, 0, 0);
            ctx.restore()

            // Draw the section descriptions on the top-right side
            ctx.save()
            ctx.textBaseline = "hanging"
            ctx.translate(chartWidth + margin, -chartHeight);
            for (var i=0; i<d.sections.length; ++i) {
                ctx.fillStyle = d.sectionColor[i];
                ctx.fillRect(0, 0, 20, 14);
                ctx.fillStyle = "black"
                ctx.fillText(d.sections[i], 25, 0);
                ctx.translate(0, 20);
            }
            ctx.restore();

            var distanceBetweenSets = 0;

            var maxValue = d.maxValue;
            var heightScale = (chartHeight - barLabelHeight) / maxValue;

            var spacing = Math.max(1, 5 - d.sections.length) * (barSpacing + barWidth);


            ctx.save();
            // Draw the bars
            ctx.translate(barWidth + barSpacing, 0);
            ctx.translate(0.5, 0.5);
            ctx.beginPath();
            ctx.rect(0, 0, chartWidth, -heightScale * maxValue);
            ctx.save();
            ctx.clip();
            for (var i=0; i<d.sets.length; ++i) {
                var s = d.sets[i].sections;
                for (var j=0; j<s.length; ++j) {
                    ctx.beginPath();
                    ctx.fillStyle = d.sectionColor[j];
                    ctx.rect(0, 0, barWidth, -s[j] * heightScale);
                    ctx.fill();
                    ctx.stroke();
                    ctx.fillStyle = "black"
                    ctx.translate(barWidth + barSpacing, 0);
                }
                ctx.translate(spacing, 0);
            }
            ctx.restore();

            // Draw the bar labels..
            ctx.save();
            for (var i=0; i<d.sets.length; ++i) {
                var s = d.sets[i].sections;
                var l = d.sets[i].label.split(" ");
                for (var li=0; li<l.length; ++li)
                    ctx.fillText(l[li], -0, 15 + li * 15);
                for (var j=0; j<s.length; ++j) {
                    var top = -Math.min(maxValue, s[j]) * heightScale;
                    ctx.save()
                    ctx.translate(12, top - 5);
                    ctx.rotate(-Math.PI / 2);
                    ctx.fillText(s[j], 0, 0);
                    ctx.restore()
                    ctx.translate(barWidth + barSpacing, 0);
                }

                ctx.translate(spacing, 0);
            }
            ctx.restore();

        }
    }

}
