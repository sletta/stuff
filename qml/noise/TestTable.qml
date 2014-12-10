import QtQuick 2.2
import org.sletta.core 1.0

ShaderEffect 
{
    id: effect

	width: 640
	height: 640

	FileContentTracker {
		id: noiseTable
		file: "noisetable.fsh"
	}

	FileContentTracker {
		id: noiseFunctions
		file: "noisefunctions.fsh"
	}

    property real textureScale: 10.0;
    property real aspectRatio: width / height;

    property real t;
    SequentialAnimation on t {
        UniformAnimator { from: 0; to: 1; duration: 5000; easing.type: Easing.InOutQuad }
        UniformAnimator { from: 1; to: 0; duration: 5000; easing.type: Easing.InOutQuad }
        loops: Animation.Infinite
    }

    // To keep performance decent on the 13" retina mbp. It doesn't
    // have a GPU to cope with its screen size...
    layer.enabled: true
    layer.textureSize: Qt.size(effect.width / 4, effect.height / 4);
    layer.smooth: false

	fragmentShader: 
	"#version 120\n"
	 + noiseTable.content + "\n"
	 + noiseFunctions.content + "\n"
	+ "
        uniform float textureScale;    
        uniform float aspectRatio;
        uniform float t;

		varying highp vec2 qt_TexCoord0;
		void main() {
            vec2 tc = qt_TexCoord0 * textureScale * vec2(aspectRatio, 1) + vec2(t * 10.0, 0.0);
	 		float v = noise(tc);
	      	gl_FragColor = vec4(v, 0, -v, 1);
		}
	"
}
