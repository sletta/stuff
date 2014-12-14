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
    property real aspectRatio: width / height;

    property real t;
    SequentialAnimation on t {
        UniformAnimator { from: 0; to: 1; duration: 20000; easing.type: Easing.InOutQuad }
        UniformAnimator { from: 1; to: 0; duration: 20000; easing.type: Easing.InOutQuad }
        loops: Animation.Infinite
        // running: false
    }

    // To keep performance decent on the 13" retina mbp. It doesn't
    // have a GPU to cope with its screen size...
    property real textureReduction: 10;
    layer.enabled: false
    layer.textureSize: Qt.size(effect.width / textureReduction, 
                               effect.height / textureReduction);
    layer.smooth: false

    vertexShader:
    "
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;

        uniform highp mat4 qt_Matrix;
        uniform highp float textureScale;
        uniform highp float aspectRatio;

        varying highp vec2 qt_TexCoord0;

        void main() {
            gl_Position = qt_Matrix * qt_Vertex;
            qt_TexCoord0 = qt_MultiTexCoord0 * textureScale * vec2(aspectRatio, 1);
        }
    "

	fragmentShader: 
	"#version 120\n"
	 + noiseTable.content + "\n"
	 + noiseFunctions.content + "\n"
	+ "
        uniform highp float t;

		varying highp vec2 qt_TexCoord0;

		void main() {
            vec3 tc = vec3(qt_TexCoord0, t * 10.0);
	 		float v = noise(tc)
                      // + 0.5 * noise(tc * 2.0)
                      // + 0.25 * noise(tc * 4.0)
                      // + 0.125 * noise(tc * 8.0)
                     ;
            // v = smoothstep(0.0, 0.1, v);
            v *= 2.0;
	      	gl_FragColor = vec4(v, 0, -v, 1);
		}
	"
}
