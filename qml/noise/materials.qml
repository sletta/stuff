import QtQuick 2.4
import org.sletta.core 1.0

Rectangle {
    id: root

    width: 500
    height: 800

    property real itemHeight: 150;

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
            height: root.itemHeight

            property color wood1: Qt.hsla(0.1, 0.5, 0.3);
            property color wood2: Qt.hsla(0.1, 0.9, 0.7);
            property real aspectRatio: width / height;

            property real textureScale: 2.0;
            property real splits: 4;
            property var sampleOffset: Qt.vector2d(3, 2.5);

            property real t; 
            UniformAnimator on t { 
                from: 0
                to: 256; 
                duration: 10001535; 
                loops: Animation.Infinite 
            }

            fragmentShader: 
            "#version 120\n"
            + noiseTable.content
            + noiseFunctions.content
            + 
            "
                uniform lowp vec4 wood1;
                uniform lowp vec4 wood2;
                uniform highp float t;
                uniform highp float aspectRatio;
                uniform highp float textureScale;
                uniform highp float splits;
                uniform highp vec2 sampleOffset;

                varying highp vec2 qt_TexCoord0;
                void main() {
                    highp vec2 texCoord = qt_TexCoord0 + vec2(t,0);
                    highp vec2 tc = texCoord * vec2(aspectRatio, 1.0) * 1.0; 
                    tc += sampleOffset;
                    tc *= textureScale;
                    float v = (noise(tc) 
                              ) * splits;
                    gl_FragColor = mix(wood1, wood2, fract(v));
                }
            "

            OverlayUI {
                controls: [
                    { name: "Scale", 
                      type: "float", 
                      lowerBound: 0, 
                      upperBound: 64
                    }
                ]
            }

        }

        ShaderEffect {
            id: marbleEffect

            y: 10
            width: parent.width
            height: root.itemHeight

            property color color1: Qt.hsla(0.2, 0.3, 0.9);
            property color color2: Qt.hsla(0.1, 0.2, 0.1);
            property real aspectRatio: width / height;

            property real t; 
            UniformAnimator on t { 
                from: 0
                to: 256; 
                duration: 10005819; 
                loops: Animation.Infinite 
            }



            fragmentShader: 
            "#version 120\n"
            + noiseTable.content
            + noiseFunctions.content
            + 
            "
                uniform highp float t;
                uniform lowp vec4 color1;
                uniform lowp vec4 color2;
                uniform highp float aspectRatio;

                varying highp vec2 qt_TexCoord0;
                void main() {
                    highp vec2 texCoord = qt_TexCoord0 + vec2(t,0);
                    highp vec2 tc = texCoord * vec2(aspectRatio, 1.0) * 1.0; 
                    float v = abs(noise(tc))
                            + abs(0.5 * noise(tc * 2.0))
                            + abs(0.25 * noise(tc * 4.0))
                            + abs(0.125 * noise(tc * 8.0))
                            + abs(0.0625 * noise(tc * 16.0))
                            ;
                    // v = smoothstep(0.0, 2.0, v);
                    v += texCoord.x * 3.0;
                    v *= 8.0;
                    gl_FragColor = mix(color2,
                                       color1, 
                                       0.5 * sin(v) + 0.5
                                      );
                }
            "
        }

        ShaderEffect {
            id: fireEffect

            y: 10
            width: parent.width
            height: root.itemHeight

            property color color1: Qt.hsla(0.0, 0.8, 0.0);
            property color color2: Qt.hsla(0.02, 1.0, 0.6);
            property real aspectRatio: width / height;

            property real t; 
            UniformAnimator on t { 
                from: 0
                to: 256; 
                duration: 1000000; 
                loops: Animation.Infinite 
            }

            Rectangle {
                id: fireGradient
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "black" }
                    GradientStop { position: 0.3; color: Qt.hsla(0, 0, 0.1) }
                    GradientStop { position: 0.5; color: "red" }
                    GradientStop { position: 0.8; color: Qt.hsla(0.1, 1.0, 0.5) }
                    GradientStop { position: 0.9; color: Qt.hsla(0.15, 1.0, 0.8) }
                    // GradientStop { position: 1; color: Qt.hsla(0.6, 0.6, 0.5, 0.1) }
                }
                width: 1
                height: 128
                layer.enabled: true
                layer.smooth: true
            }

            property Item gradient: fireGradient

            fragmentShader: 
            "#version 120\n"
            + noiseTable.content
            + noiseFunctions.content
            + 
            "
                uniform lowp sampler2D gradient;
                uniform highp float t; 
                uniform highp float aspectRatio;

                varying highp vec2 qt_TexCoord0;
                void main() {
                    highp vec2 tc = (qt_TexCoord0 + vec2(4.15, 6.19 + t)) * vec2(aspectRatio, 1.0) * 1.0; 
                    highp vec3 tc3 = vec3(tc, t * 0.1);
                    float v = abs(noise(tc3))
                            + abs(0.5 * noise(tc3 * 2.0))
                            + abs(0.25 * noise(tc3 * 4.0))
                            + abs(0.125 * noise(tc3 * 8.0))
                            ;
                            v = v * 2.0;
                    highp vec2 tex = vec2(qt_TexCoord0.x, v * qt_TexCoord0.y);
                    gl_FragColor = texture2D(gradient, tex);
                }
            "
        }

                ShaderEffect {
            id: waterEffect

            y: 10
            width: parent.width
            height: root.itemHeight

            property color color1: Qt.hsla(0.0, 0.8, 0.0);
            property color color2: Qt.hsla(0.02, 1.0, 0.6);
            property real aspectRatio: width / height;

            property real t; 
            UniformAnimator on t { 
                from: 0
                to: 256; 
                duration: 2000000; 
                loops: Animation.Infinite 
            }

            Rectangle {
                id: waterGradient
                gradient: Gradient {
                    GradientStop { position: 0; color: Qt.hsla(0.6, 0.5, 0.1) }
                    GradientStop { position: 0.95; color: Qt.hsla(0.7, 0.5, 0.6) }
                    GradientStop { position: 1; color: Qt.hsla(0.7, 0.5, 0.8) }
                }
                width: 1
                height: 128
                layer.enabled: true
                layer.smooth: true
            }

            property Item gradient: waterGradient

            fragmentShader: 
            "#version 120\n"
            + noiseTable.content
            + noiseFunctions.content
            + 
            "
                uniform lowp sampler2D gradient;
                uniform highp float t; 
                uniform highp float aspectRatio;

                varying highp vec2 qt_TexCoord0;
                void main() {
                    highp vec2 tc = (qt_TexCoord0) * vec2(aspectRatio, 1.0) * 1.0;                     highp vec3 tc3 = vec3(tc, 0);
                    float v = abs(noise(tc))
                            + abs(0.5 * noise(tc * 2.0))
                            + abs(0.25 * noise(tc * 4.0))
                            ;
                            // v = v * 3;
                    float cycle = tc.x + tc.y + t + v * 0.5;
                            v = pow(abs(sin( cycle * 10.0 )), 2.0);
                    highp vec2 tex = vec2(qt_TexCoord0.x, v);
                    gl_FragColor = texture2D(gradient, tex);
                }
            "
        }

    }
}

