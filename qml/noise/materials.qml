import QtQuick 2.4
import org.sletta.core 1.0

Rectangle {
    id: root

    width: 480
    height: 640

    color: "black"

    gradient: Gradient {
        GradientStop { position: 0; color: "steelblue" }
        GradientStop { position: 1; color: "black " }
    }

    FileContentTracker {
        id: noiseTable
        file: "noisetable.fsh"
    }

    FileContentTracker {
        id: noiseFunctions
        file: "noisefunctions.fsh"
    }

    Column {
        y: 10
        spacing: 10
        width: parent.width - spacing

        anchors.horizontalCenter: parent.horizontalCenter

        ShaderEffect {
            id: woodEffect

            width: parent.width
            height: 200

            property color wood1: "#966F33"
            property color wood2: "#F9C396"
            property real aspectRatio: width / height;

            fragmentShader: 
            "#version 120\n"
            + noiseTable.content
            + noiseFunctions.content
            + 
            "
                uniform lowp vec4 wood1;
                uniform lowp vec4 wood2;
                uniform highp float aspectRatio;

                varying highp vec2 qt_TexCoord0;
                void main() {
                    float v = noise(qt_TexCoord0 * vec2(aspectRatio, 1.0) * 2.0) * 10.0;
                    gl_FragColor = mix(wood1, wood2, fract(v));
                }
            "
        }

        ShaderEffect {
            id: marbleEffect

            y: 10
            width: parent.width
            height: 200

            property color color1: Qt.hsla(0.2, 0.1, 0.9);
            property color color2: Qt.hsla(0, 0, 0.1);
            property real aspectRatio: width / height;

            fragmentShader: 
            "#version 120\n"
            + noiseTable.content
            + noiseFunctions.content
            + 
            "
                uniform lowp vec4 color1;
                uniform lowp vec4 color2;
                uniform highp float aspectRatio;

                varying highp vec2 qt_TexCoord0;
                void main() {
                    highp vec2 tc = qt_TexCoord0 * vec2(aspectRatio, 1.0); 
                    float v = abs(noise(tc))
                            + abs(0.5 * noise(tc * 2.0))
                            + abs(0.25 * noise(tc * 4.0))
                            + abs(0.125 * noise(tc * 8.0))
                            + abs(0.0625 * noise(tc * 16.0));
                    v = smoothstep(0.0, 2.0, v);
                    v += qt_TexCoord0.x;
                    v *= 10.0;
                            ;
                    gl_FragColor = mix(color1,
                                       color2, 
                                       abs(sin(v))
                                      );
                }
            "
        }
    }
}

