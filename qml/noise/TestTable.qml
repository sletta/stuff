import QtQuick 2.2
import org.sletta.core 1.0

ShaderEffect 
{
    id: effect

	width: 640
	height: 480

	FileContentTracker {
		id: noiseTable
		file: "noisetable.fsh"
	}

	FileContentTracker {
		id: noiseFunctions
		file: "noisefunctions.fsh"
	}

    property real textureScale: 10.0;

    property real smoothed: 1.0;

    MouseArea {
        anchors.fill: parent
        onPositionChanged: {
            effect.textureScale = mouseY / 10.0;
        }
        onClicked: {
            if (effect.smoothed > 0) {
                effect.smoothed = 0;
            } else {
                effect.smoothed = 1.0;
            }

        }
    }

    property real t;
    UniformAnimator on t { from: 0; to: 1; duration: 50000; loops: Animation.Infinite }

	fragmentShader: 
	"#version 120\n"
	+ noiseTable.content + "\n"
	+ noiseFunctions.content + "\n"
	+ "
        uniform float smoothed;
        uniform float textureScale;
        uniform float t;

		varying highp vec2 qt_TexCoord0;
		void main() {
            vec2 tc = qt_TexCoord0 / textureScale + vec2(t, 0.0);
			float v = smoothed > 0 ? smoothNoise(tc) : noise(tc);
			gl_FragColor = vec4(v, v, v, 1);
		}
	"
}