import QtQuick 2.2

import org.sletta.core 1.0
import org.sletta.ui 1.0

CheckersBackground
{
    id: root
    width: 480
    height: 320

    Grid {
        anchors.fill: parent
        anchors.margins: 10

        columns: 5
        columnSpacing: 10

        Text {
            height: 40
            text: "Gradient Spinner"
            verticalAlignment: Text.AlignVCenter
        }

        GradientSpinner {
            width: 40
            height: 40
        }

        GradientSpinner {
            width: 40
            height: 40
            circleWidth: 15
            duration: 3000
            color0: "red"
            color1: "black"
        }

        GradientSpinner {
            width: 40
            height: 40
            duration: 6000
            circleWidth: 10
            gradient: Gradient {
                GradientStop { position: 0.3; color: "black" }
                GradientStop { position: 0.4; color: "palegreen" }
                GradientStop { position: 0.6; color: "palegreen" }
                GradientStop { position: 0.7; color: "black" }
            }
            GradientSpinner {
                anchors.centerIn: parent
                width: 38
                height: 38
                duration: 5000
                circleWidth: 8
                reversed: true
                gradient: Gradient {
                    GradientStop { position: 0.3; color: Qt.rgba(0, 0, 0, 0.5) }
                    GradientStop { position: 0.4; color: "palegreen" }
                    GradientStop { position: 0.6; color: "palegreen" }
                    GradientStop { position: 0.7; color: Qt.rgba(0, 0, 0, 0.5); }
                }
            }
        }

        GradientSpinner {
            width: 40
            height: 40
            duration: 500
            circleWidth: 5
            gradient: Gradient {
                GradientStop { position: 0.2; color: "transparent" }
                GradientStop { position: 0.5; color: "black" }
                GradientStop { position: 0.8; color: "transparent" }
            }
        }



        // Pulse spinner...

        Text {
            height: 40
            text: "Pulse Spinner"
            verticalAlignment: Text.AlignVCenter
        }

        PulseSpinner {
            width: 40
            height: 40
        }
    }




}
