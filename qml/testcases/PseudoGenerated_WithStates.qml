import QtQuick 2.0

import "components" as Components

Rectangle {
    id: root

    color: "gray"

    width: 320
    height: 480

    ListView {
        id: searchResultList
        model: 50

        clip: true

        x: 0
        width: parent.width
        y: topToolBar.height
        height: parent.height - topToolBar.height - buttonBox.height

        delegate: Rectangle {
            height: 30
            width: searchResultList.width
            gradient: Gradient {
                GradientStop { position: 0; color: "gray" }
                GradientStop { position: 1; color: "black" }
            }
            Text {
                anchors.centerIn: parent
                text: "bla-di-blah-blah " + index
                color: "white"
            }
        }
    }

    Rectangle {
        id: boxes

        color: "black"
        x: 0
        y: 0
        width: parent.width
        height: parent.height - buttonBox.height

        Components.Button {
            id: box1
            label: "Top Left"
            width: (boxes.width - 15) / 2
            height: (boxes.height - 15) / 2

        }
        Components.Button {
            id: box2
            label: "Top Right"
            width: (boxes.width - 15) / 2
            height: (boxes.height - 15) / 2
        }
        Components.Button {
            id: box3
            label: "Bottom Left"
            width: (boxes.width - 15) / 2
            height: (boxes.height - 15) / 2
        }
        Components.Button {
            id: box4
            label: "Bottom Right"
            width: (boxes.width - 15) / 2
            height: (boxes.height - 15) / 2
        }
    }

    Rectangle {
        id: topToolBar

        height: 40
        width: root.width

        gradient: Gradient {
            GradientStop { position: 0; color: Qt.rgba(0.4, 0.4, 0.4, 1) }
            GradientStop { position: 1; color: "black" }
        }

        Components.TextField {
            id: textField

            height: parent.height - 10
            y: 5
            width: topToolBar.width - 15 - goButton.width
        }

        Components.Button {
            id: goButton
            label: "Go!"

            height: parent.height - 10
            y: 5

            width: 80
        }
    }

    Rectangle {
        id: buttonBox

        height: 80
        width: root.width

        gradient: Gradient {
            GradientStop { position: 0; color: Qt.rgba(0.4, 0.4, 0.4, 1) }
            GradientStop { position: 1; color: "black" }
        }

        Components.Button {
            id: searchButton
            label: "Search"

            y: 5
            height: buttonBox.height - 2 * 5
            width: (buttonBox.width - 2 * 5 - 5) / 2;
        }
        Components.Button {
            id: settingsButton
            label: "Settings"

            y: 5
            height: buttonBox.height - 2 * 5
            width: (buttonBox.width - 2 * 5 - 5) / 2;
        }
    }

    states: [
        State {
            name: "initial"
            PropertyChanges { target: topToolBar; y: -topToolBar.height}
            PropertyChanges { target: topToolBar; visible: false }
            PropertyChanges { target: textField; x: topToolBar.width }
            PropertyChanges { target: goButton; x: topToolBar.width }

            PropertyChanges { target: buttonBox; y: root.height }
            PropertyChanges { target: buttonBox; visible: false }
            PropertyChanges { target: searchButton; x: -searchButton.width }
            PropertyChanges { target: settingsButton; x: buttonBox.width }

            PropertyChanges { target: boxes; visible: false; }
            PropertyChanges { target: boxes; opacity: 0; }

            PropertyChanges { target: searchResultList; visible: false }
            PropertyChanges { target: searchResultList; opacity: 0 }
        },

        State {
            name: "search"
            PropertyChanges { target: topToolBar; visible: true }
            PropertyChanges { target: topToolBar; y: 0}
            PropertyChanges { target: textField; x: 5; }
            PropertyChanges { target: goButton; x: topToolBar.width - 5 - goButton.width  }

            PropertyChanges { target: buttonBox; visible: true }
            PropertyChanges { target: buttonBox; y: root.height - buttonBox.height }
            PropertyChanges { target: searchButton; x: 5; }
            PropertyChanges { target: settingsButton; x: 5 + (buttonBox.width - 2 * 5 - 5) / 2 + 5; }

            PropertyChanges { target: boxes; visible: false; }
            PropertyChanges { target: boxes; opacity: 0; }
            PropertyChanges { target: box1; x: -box1.width }
            PropertyChanges { target: box1; y: -box1.height }
            PropertyChanges { target: box2; x: boxes.width}
            PropertyChanges { target: box2; y: -box2.height }
            PropertyChanges { target: box3; x: -box3.width }
            PropertyChanges { target: box3; y: boxes.height }
            PropertyChanges { target: box4; x: boxes.width }
            PropertyChanges { target: box4; y: boxes.height }

            PropertyChanges { target: searchResultList; visible: true}
            PropertyChanges { target: searchResultList; opacity: 1 }
        },

        State {
            name: "settings"
            PropertyChanges { target: topToolBar; y: -topToolBar.height}
            PropertyChanges { target: topToolBar; visible: false }
            PropertyChanges { target: textField; x: topToolBar.width }
            PropertyChanges { target: goButton; x: topToolBar.width }

            PropertyChanges { target: buttonBox; visible: true }
            PropertyChanges { target: buttonBox; y: root.height - buttonBox.height }
            PropertyChanges { target: searchButton; x: 5; }
            PropertyChanges { target: settingsButton; x: 5 + (buttonBox.width - 2 * 5 - 5) / 2 + 5; }

            PropertyChanges { target: boxes; visible: true; }
            PropertyChanges { target: boxes; opacity: 1; }
            PropertyChanges { target: box1; x: 5 }
            PropertyChanges { target: box1; y: 5 }
            PropertyChanges { target: box2; x: 10 + (boxes.width - 15) / 2 }
            PropertyChanges { target: box2; y: 5 }
            PropertyChanges { target: box3; x: 5 }
            PropertyChanges { target: box3; y: 10 + (boxes.height - 15) / 2 }
            PropertyChanges { target: box4; x: 10 + (boxes.width - 15) / 2 }
            PropertyChanges { target: box4; y: 10 + (boxes.height - 15) / 2 }

            PropertyChanges { target: searchResultList; visible: false }
            PropertyChanges { target: searchResultList; opacity: 0 }
        }
    ]

    // Bindings for search state

    // Bindings for the settings state...

    property int latency: 200

    transitions: [
        Transition {
            from: "initial"
            to: "search"
            SequentialAnimation {
                ScriptAction {
                    script: {
                        print("starting initial -> search transition")
                    }
                }
                ParallelAnimation {
                    NumberAnimation { target: topToolBar;  property: "y"; from: -topToolBar.height; to: 0; duration: latency; easing.type: Easing.InOutCubic }
                    SequentialAnimation {
                        PauseAnimation { duration: latency }
                        NumberAnimation { target: textField;  property: "x"; from: topToolBar.width; to: 5; duration: latency; easing.type: Easing.OutBack }
                    }
                    SequentialAnimation {
                        PauseAnimation { duration: latency }
                        NumberAnimation { target: textField;  property: "width"; to: topToolBar.width - 15 - goButton.width; duration: latency; easing.type: Easing.OutBack }
                    }
                    SequentialAnimation {
                        PauseAnimation { duration: 2 * latency }
                        NumberAnimation { target: goButton;  property: "x"; from: topToolBar.width; to: topToolBar.width - 5 - goButton.width; duration: latency; easing.type: Easing.InOutCubic }
                    }
                    SequentialAnimation {
                        PauseAnimation { duration: 3 * latency }
                        NumberAnimation { target: buttonBox;  property: "y"; from: root.height; to: root.height - buttonBox.height; duration: latency; easing.type: Easing.InOutCubic }
                    }
                    SequentialAnimation {
                        PauseAnimation { duration: 4 * latency }
                        NumberAnimation { target: searchButton;  property: "x"; from: -searchButton.width; to: 5; duration: latency; easing.type: Easing.OutBack}
                    }
                    SequentialAnimation {
                        PauseAnimation { duration: 5 * latency }
                        NumberAnimation { target: settingsButton;  property: "x"; from: buttonBox.width; to: 5 + (buttonBox.width - 2 * 5 - 5) / 2 + 5;  duration: latency; easing.type: Easing.InOutCubic }
                    }
                    SequentialAnimation {
                        PropertyAction { target: searchResultList; property: "opacity"; value: 0 }
                        PauseAnimation { duration: 6 * latency }
                        NumberAnimation { target: searchResultList; property: "opacity"; from: 0; to: 1; duration: latency; }
                    }

                }
                ScriptAction {
                    script: {
                        print("   done: initial -> search")
                        root.state = "UNDEFINED"
                        root.state = "search"
                    }
                }
            }
        },
        Transition {
            from: "search"
            to: "settings"
            SequentialAnimation {
                ScriptAction {
                    script: {
                        print("starting search -> settings transition")
                    }
                }
                ParallelAnimation {
                    SequentialAnimation {
                        PauseAnimation { duration: 0 * latency }
                        NumberAnimation { target: topToolBar;  property: "y"; to: -topToolBar.height; duration: latency; easing.type: Easing.InOutCubic }
                        PropertyAction { target: topToolBar; property: "visible"; value: false }
                    }
                    SequentialAnimation {
                        PauseAnimation { duration: 2 * latency }
                        PropertyAction { target: searchResultList; property: "opacity"; value: 0 }
                        PropertyAction { target: searchResultList; property: "visible"; value: false }
                    }

                    SequentialAnimation {
                        PauseAnimation { duration: 0 * latency }
                        PropertyAction { target: boxes; property: "visible"; value: true }
                        NumberAnimation { target: boxes; property: "opacity"; to: 1; duration: latency }
                    }

                    // Timeline output wouldn't look like this, but I was too bored to write it out as above..
                    SequentialAnimation {
                        PauseAnimation { duration: 1 * latency }
                        ParallelAnimation {
                            NumberAnimation { target: box1; property: "x"; to: 5; duration: 2 * latency; easing.type: Easing.InOutCubic }
                            NumberAnimation { target: box1; property: "y"; to: 5; duration: 2 * latency; easing.type: Easing.OutBack }
                            NumberAnimation { target: box2; property: "x"; to: 10 + (boxes.width - 15) / 2; duration: 2 * latency; easing.type: Easing.InOutCubic }
                            NumberAnimation { target: box2; property: "y"; to: 5; duration: 2 * latency; easing.type: Easing.InOutSine}
                            NumberAnimation { target: box3; property: "x"; to: 5; duration: 2 * latency; easing.type: Easing.InOutQuad }
                            NumberAnimation { target: box3; property: "y"; to: 10 + (boxes.height - 15) / 2; duration: 2 * latency; easing.type: Easing.OutBack }
                            NumberAnimation { target: box4; property: "x"; to: 10 + (boxes.width - 15) / 2; duration: 2 * latency; easing.type: Easing.IntOutCubic }
                            NumberAnimation { target: box4; property: "y"; to: 10 + (boxes.height - 15) / 2; duration: 2 * latency; easing.type: Easing.InOutQuart }
                        }
                    }
                }

                ScriptAction {
                    script: {
                        print("   done: search -> settings")

                        // This is a bit of a hack.. For some reason, the PropertyChanges seem to get
                        // overridden by the aniamtions in the transition, perhaps, not a big surprise
                        // but it also breaks the usecase of using transitions for states...
                        root.state = "UNDEFINED"
                        root.state = "settings"
                    }
                }

            }
        },
        Transition {
            from: "settings"
            to: "search"
            SequentialAnimation {
                ScriptAction {
                    script: {
                        print("starting settings -> search transition")
                    }
                }
                ParallelAnimation {
                    // Timeline output wouldn't look like this, but I was too bored to write it out as above..
                    SequentialAnimation {
                        PauseAnimation { duration: 0 * latency }
                        ParallelAnimation {
                            NumberAnimation { target: box1; property: "y"; to: -box1.height; duration: 2.2 * latency; easing.type: Easing.InOutQuad }
                            NumberAnimation { target: box2; property: "y"; to: -box2.height; duration: 2.1 * latency; easing.type: Easing.InOutSine }
                            NumberAnimation { target: box3; property: "y"; to: boxes.height; duration: 2.3 * latency; easing.type: Easing.InBack }
                            NumberAnimation { target: box4; property: "y"; to: boxes.height; duration: 2.4 * latency; easing.type: Easing.InOutQuart }
                        }
                    }

                    SequentialAnimation {
                        PauseAnimation { duration: 2 * latency }
                        NumberAnimation { target: boxes; property: "opacity"; to: 0; duration: latency }
                        PropertyAction { target: boxes; property: "visible"; value: false }
                    }

                    SequentialAnimation {
                        PauseAnimation { duration: 3 * latency }
                        NumberAnimation { target: topToolBar;  property: "y"; from: -topToolBar.height; to: 0; duration: latency; easing.type: Easing.InOutCubic }
                    }
                    SequentialAnimation {
                        PauseAnimation { duration: 4 * latency }
                        NumberAnimation { target: textField;  property: "x"; from: topToolBar.width; to: 5; duration: latency; easing.type: Easing.OutBack }
                    }
                    SequentialAnimation {
                        PauseAnimation { duration: 5 * latency }
                        NumberAnimation { target: goButton;  property: "x"; from: topToolBar.width; to: topToolBar.width - 5 - goButton.width; duration: latency; easing.type: Easing.InOutCubic }
                    }
                }
                ScriptAction {
                    script: {
                        print("   done: settings -> search")
                        root.state = "UNDEFINED"
                        root.state = "search"
                    }
                }
            }
        }


    ]

    state: "initial"

    Timer {
        running: true
        interval: 500
        repeat: false
        onTriggered: {
            root.state = "search"
        }
    }

    Connections {
        target: searchButton
        onClicked: state = "search"
    }

    Connections {
        target: settingsButton
        onClicked: state = "settings"
    }

}
