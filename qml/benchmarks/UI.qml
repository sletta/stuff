import QtQuick 2.2

Item {
    id: root

    signal complicate
    signal simplify
    signal next
    signal previous

    state: "hidden"
    states: [
        State {
            name: "visible"
            PropertyChanges { target: uiRoot; enabled: true; opacity: 1 }
        },
        State {
            name: "hidden"
            PropertyChanges { target: uiRoot; enabled: false; opacity: 0 }
        }
    ]

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            if (root.state == "hidden") {
                root.state = "visible"
                uiRoot.triggerFadeTimer();
            }
        }
    }

    Item {
        id: uiRoot
        anchors.fill: parent

        Behavior on opacity { OpacityAnimator { duration: 300 } }

        Timer {
            id: fadeTimer
            interval: 5000
            repeat: false
            onTriggered: {
                root.state = "hidden";
            }
        }

        function triggerFadeTimer() {
            if (fadeTimer.running)
                fadeTimer.running = false;
            fadeTimer.running = true;
        }

        Column {
            width: 3 * cm

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 0.1 * cm;
            spacing: 0.1 * cm

            Button {
                text: "Complicate"
                onClicked: {
                    uiRoot.triggerFadeTimer()
                    root.complicate()
                }
            }
            Button {
                text: "Simplify"
                onClicked: {
                    uiRoot.triggerFadeTimer()
                    root.simplify()
                }
            }

            Button {
                text: "Next"
                onClicked: {
                    uiRoot.triggerFadeTimer()
                    root.next()
                }
            }
            Button {
                text: "Previous"
                onClicked: {
                    uiRoot.triggerFadeTimer()
                    root.previous()
                }
            }
        }
    }


    
}
