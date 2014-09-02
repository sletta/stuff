import QtQuick 2.2
import QtGraphicalEffects 1.0

Item
{
    id: root

    width: 512
    height: 512

    property alias reflectionTexture: reflection;
    property alias normalmapTexture: normalMap

    Canvas {
        id: baseCanvas
        x: 10
        y: 10
        width: parent.width
        height: parent.height

        visible: false

        onPaint: {
            var ctx = getContext('2d');

            var lineWidth = 0.03
            var boxDim = 0.25;

            var w = baseCanvas.width
            var h = baseCanvas.height
            var cx = w / 2;
            var cy = h / 2;

            var lw = w * lineWidth;
            var bd = w * boxDim;

            ctx.save();

            ctx.fillStyle = "white"
            ctx.fillRect(0, 0, w, h);

            ctx.beginPath();
            ctx.moveTo(cx - lw, 0);
            ctx.lineTo(cx - lw, cy - bd);
            ctx.lineTo(cx - bd, cy - lw);
            ctx.lineTo(0, cy - lw);
            ctx.lineTo(0, cy + lw);
            ctx.lineTo(cx - bd, cy + lw);
            ctx.lineTo(cx - lw, cy + bd);
            ctx.lineTo(cx - lw, h);
            ctx.lineTo(cx + lw, h);
            ctx.lineTo(cx + lw, cy + bd);
            ctx.lineTo(cx + bd, cy + lw);
            ctx.lineTo(w, cy + lw);
            ctx.lineTo(w, cy - lw);
            ctx.lineTo(cx + bd, cy - lw);
            ctx.lineTo(cx + lw, cy - bd);
            ctx.lineTo(cx + lw, 0);
            ctx.fillStyle = "black"
            ctx.fill();

            ctx.restore();
        }
    }

    GaussianBlur {
        id: blur
        x: 300
        y: 10
        width: parent.width
        height: parent.height
        radius: 32
        samples: 32
        source: baseCanvas
        layer.enabled: true
        visible: false
    }

    ShaderEffect {
        id: reflection;
        x: 600
        y: 10
        width: parent.width
        height: parent.height

        layer.enabled: true;

        property variant blurred: blur;

        fragmentShader:
            "
            uniform lowp sampler2D blurred;

            varying highp vec2 qt_TexCoord0;

            void main() {
                float blurPixel = 1.0 - texture2D(blurred, qt_TexCoord0).r;
                float reflection = 1.0 - sin(blurPixel * 3.141592) - blurPixel / 2.0;
                gl_FragColor = vec4(pow(blurPixel, 1.7), 0, reflection, 1);
            }
            "
        visible: false
    }



    Item {
        id: normalMapBase
        width: parent.width
        height: parent.height
        layer.enabled: true;
        visible: false
        ShaderEffectSource {
            sourceItem: baseCanvas
            width: parent.width
            height: parent.height
        }
        Repeater {
            model: root.width / 7
            Rectangle {
                anchors.centerIn: parent
                width: index * 2
                height: index * 2
                opacity: 0.02
                radius: width / 2
                rotation: 45
            }
        }
        ShaderEffect {
            id: normalMapNoise
            anchors.fill: parent
            fragmentShader:
                "
                varying highp vec2 qt_TexCoord0;
                void main() {
                    float v = fract(sin(dot(qt_TexCoord0 ,vec2(12.9898,78.233))) * 43758.5453);
                    gl_FragColor = vec4(v, v, v, 0.5) * 0.3;
                }
                "
        }
        Rectangle {
            color: "transparent"
            border.color: "black"
            border.width: 2
            anchors.fill: parent
        }
    }

    GaussianBlur {
        id: normalMapBlur
        x: 10
        y: 300
        width: parent.width
        height: parent.height
        radius: 13
        samples: 32
        source: normalMapBase
        layer.enabled: true
        visible: false
    }





    ShaderEffect {
        id: normalMap;

        x: 300
        y: 300

        width: parent.width
        height: parent.height

        property Item tex: normalMapBlur
        property real sampleStep: 2.0
        property size pixelSize: Qt.size(sampleStep / tex.width, sampleStep / tex.height);

        visible: false

        blending: false

        transform: [
            Scale { yScale: -1 },
            Translate { y: normalMap.height }
        ]

        fragmentShader: "
            #ifdef GL_ES
            precision lowp float;
            #endif

            uniform lowp sampler2D tex;
            uniform highp vec2 pixelSize;
            varying highp vec2 qt_TexCoord0;
            void main() {

                lowp vec2 xps = vec2(pixelSize.x, 0.0);
                vec3 vx = vec3(1, 0, texture2D(tex, qt_TexCoord0 + xps).x - texture2D(tex, qt_TexCoord0 - xps).x);

                lowp vec2 yps = vec2(0.0, pixelSize.y);
                vec3 vy = vec3(0, 1, texture2D(tex, qt_TexCoord0 + yps).x - texture2D(tex, qt_TexCoord0 - yps).x);

                vec3 n = normalize(cross(vx, vy)) * 0.5 + 0.5;

                gl_FragColor = vec4(n, 1);
            }
        "
        layer.enabled: true
    }

//    ShaderEffect {
//        x: 600
//        y: 300
//        width: 256
//        height: 256

//        property Item normals: normalMap;
//        property Item materials: reflection;

//        property real t;
//        UniformAnimator on t { from: 0; to: Math.PI * 2.0; duration: 10000; loops: Animation.Infinite }

//        fragmentShader:
//            "
//uniform sampler2D normals;
//uniform sampler2D materials;

//uniform float t;

//varying highp vec2 qt_TexCoord0;

//const float topLight = 0.2;
//const vec3 glowColor = vec3(0.2, 0.3, 0.8);

//float calculateLight(float a, vec3 n, float r) {
//    vec3 pixelPos = vec3(qt_TexCoord0, 0);
//    vec3 lightPos = vec3(vec2(cos(a), sin(a)) * r + 0.5, 2);

//    vec3 vl = normalize(lightPos - pixelPos);

//    return pow(dot(vl, n), 32.0);
//}

//vec3 calculateGlow(float intensity) {
//    float amp = max(0.0, pow(sin(t + 2.97), 32.0));
//    return glowColor * amp * 10.0 * intensity;
//}



//void main()
//{
//    vec3 n = normalize(texture2D(normals, qt_TexCoord0).xyz * 2.0 - 1.0);
//    vec4 m = texture2D(materials, qt_TexCoord0);

//    vec3 red = vec3(0.8, 0.3, 0.3) * calculateLight(t, n, .7);
//    vec3 blue = vec3(0.1, 0.3, 0.8) * calculateLight(t * 2.0, n, 0.4);
//    vec3 green = vec3(0.4, 0.6, 0.3) * calculateLight(0.5, n, 0.2);

//    vec3 lightColors = (red + blue + green) - m.x * 0.8;

//    vec3 glowColors = calculateGlow(m.x);

//    gl_FragColor = vec4(lightColors + glowColors, 1);
//}
//            "
//    }


//    Timer {
//        id: timer
//        running: true
//        repeat: false
//        interval: 1000
//        onTriggered: {
//            print("requesting grabbed item...");
//            grabber.requestGrabItem(normalMap);
//            grabber.requestGrabItem(reflection);
//        }
//    }

//    ItemGrabber {
//        id: grabber
//        onItemGrabbed: {
//            if (item == normalMap) {
//                var ok = saveImageToFile(image, "normalmap.png");
//                print("normalmap.png saved: " + ok);
//            } else if (item == reflection) {
//                var ok = saveImageToFile(image, "reflection.png");
//                print("reflection.png saved: " + ok);
//            }
//        }
//    }

}
