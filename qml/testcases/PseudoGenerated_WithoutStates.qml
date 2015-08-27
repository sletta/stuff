import QtQuick 2.0

import "components" as Components

Rectangle {
    id: root

    color: "gray"

    width: 320
    height: 480

    property int _uiState: 0

    property int uiStateListener: _uiState;

    onUiStateListenerChanged: print("_uiState: " + _uiState);

    // Three states;
    // - 0: initial, nothing is showing
    // - 1: search, search field and a result list (search: hstretch, list: hvstretch)
    // - 2: settings, rows of label/input, hcentered, v stretch

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
                GradientStop { position: 0.0; color: Qt.rgba(0.5, 0.5, 0.5, 1); }
                GradientStop { position: 0.2; color: Qt.rgba(0.7, 0.7, 0.7, 1); }
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

    // 1: Initial state
    Binding { target: topToolBar; property: "y"; value: -topToolBar.height; when: _uiState == 0 }
    Binding { target: topToolBar; property: "visible"; value: false ; when: _uiState == 0 }
    Binding { target: textField; property: "x"; value: topToolBar.width ; when: _uiState == 0 }
    Binding { target: goButton; property: "x"; value: topToolBar.width ; when: _uiState == 0 }
    Binding { target: buttonBox; property: "y"; value: root.height ; when: _uiState == 0 }
    Binding { target: buttonBox; property: "visible"; value: false ; when: _uiState == 0 }
    Binding { target: searchButton; property: "x"; value: -searchButton.width ; when: _uiState == 0 }
    Binding { target: settingsButton; property: "x"; value: buttonBox.width ; when: _uiState == 0 }
    Binding { target: boxes; property: "visible"; value: false;when: _uiState == 0 }
    Binding { target: boxes; property: "opacity"; value: 0; when: _uiState == 0 }
    Binding { target: searchResultList; property: "visible"; value: false ; when: _uiState == 0 }
    Binding { target: searchResultList; property: "opacity"; value: 0 ; when: _uiState == 0 }

    // 2: Search state
    Binding { target: topToolBar; property: "visible"; value: true ; when: _uiState == 1 }
    Binding { target: topToolBar; property: "y"; value: 0; when: _uiState == 1 }
    Binding { target: textField; property: "x"; value: 5; when: _uiState == 1 }
    Binding { target: goButton; property: "x"; value: topToolBar.width - 5 - goButton.width  ; when: _uiState == 1 }
    Binding { target: buttonBox; property: "visible"; value: true ; when: _uiState == 1 }
    Binding { target: buttonBox; property: "y"; value: root.height - buttonBox.height ; when: _uiState == 1 }
    Binding { target: searchButton; property: "x"; value: 5; when: _uiState == 1 }
    Binding { target: settingsButton; property: "x"; value: 5 + (buttonBox.width - 2 * 5 - 5) / 2 + 5; when: _uiState == 1 }
    Binding { target: boxes; property: "visible"; value: false; when: _uiState == 1 }
    Binding { target: boxes; property: "opacity"; value: 0; when: _uiState == 1 }
    Binding { target: box1; property: "x"; value: -box1.width; when: _uiState == 1 }
    Binding { target: box1; property: "y"; value: -box1.height; when: _uiState == 1 }
    Binding { target: box2; property: "x"; value: boxes.width; when: _uiState == 1 }
    Binding { target: box2; property: "y"; value: -box2.height; when: _uiState == 1 }
    Binding { target: box3; property: "x"; value: -box3.width; when: _uiState == 1 }
    Binding { target: box3; property: "y"; value: boxes.height; when: _uiState == 1 }
    Binding { target: box4; property: "x"; value: boxes.width; when: _uiState == 1 }
    Binding { target: box4; property: "y"; value: boxes.height; when: _uiState == 1 }
    Binding { target: searchResultList; property: "visible"; value: true; when: _uiState == 1 }
    Binding { target: searchResultList; property: "opacity"; value: 1 ; when: _uiState == 1 }

    // 3: Settings state
    Binding { target: topToolBar; property: "y"; value: -topToolBar.height; when: _uiState == 2 }
    Binding { target: topToolBar; property: "visible"; value: false ; when: _uiState == 2 }
    Binding { target: textField; property: "x"; value: topToolBar.width; when: _uiState == 2 }
    Binding { target: goButton; property: "x"; value: topToolBar.width; when: _uiState == 2 }
    Binding { target: buttonBox; property: "visible"; value: true; when: _uiState == 2 }
    Binding { target: buttonBox; property: "y"; value: root.height - buttonBox.height; when: _uiState == 2 }
    Binding { target: searchButton; property: "x"; value: 5; when: _uiState == 2 }
    Binding { target: settingsButton; property: "x"; value: 5 + (buttonBox.width - 2 * 5 - 5) / 2 + 5; when: _uiState == 2 }
    Binding { target: boxes; property: "visible"; value: true; when: _uiState == 2 }
    Binding { target: boxes; property: "opacity"; value: 1; when: _uiState == 2 }
    Binding { target: box1; property: "x"; value: 5 ; when: _uiState == 2 }
    Binding { target: box1; property: "y"; value: 5 ; when: _uiState == 2 }
    Binding { target: box2; property: "x"; value: 10 + (boxes.width - 15) / 2 ; when: _uiState == 2 }
    Binding { target: box2; property: "y"; value: 5 ; when: _uiState == 2 }
    Binding { target: box3; property: "x"; value: 5 ; when: _uiState == 2 }
    Binding { target: box3; property: "y"; value: 10 + (boxes.height - 15) / 2; when: _uiState == 2 }
    Binding { target: box4; property: "x"; value: 10 + (boxes.width - 15) / 2; when: _uiState == 2 }
    Binding { target: box4; property: "y"; value: 10 + (boxes.height - 15) / 2; when: _uiState == 2 }
    Binding { target: searchResultList; property: "visible"; value: false ; when: _uiState == 2 }
    Binding { target: searchResultList; property: "opacity"; value: 0 ; when: _uiState == 2 }

    property int latency: 200

    SequentialAnimation {
        id: initialToSearchAnimation
        ScriptAction {
            script: {
                print("starting initial -> search transition")
                root._uiState = -1
                topToolBar.visible = true;
                buttonBox.visible = true;
                searchResultList.visible = true;
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
                root._uiState = 1
            }
        }
    }

    SequentialAnimation {
        id: searchToSettingsAnimation
        ScriptAction {
            script: {
                print("starting search -> settings transition")
                root._uiState = -1
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
                    NumberAnimation { target: box4; property: "x"; to: 10 + (boxes.width - 15) / 2; duration: 2 * latency; easing.type: Easing.InOutCubic }
                    NumberAnimation { target: box4; property: "y"; to: 10 + (boxes.height - 15) / 2; duration: 2 * latency; easing.type: Easing.InOutQuart }
                }
            }
        }

        ScriptAction {
            script: {
                print("   done: search -> settings")
                root._uiState = 2
            }
        }

    }


    SequentialAnimation {
        id: settingsToSearchAnimation
        ScriptAction {
            script: {
                print("starting settings -> search transition")
                root._uiState = -1
                topToolBar.visible = true;
                buttonBox.visible = true;
                searchResultList.visible = true;
                searchResultList.opacity = 1;
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
                root._uiState = 1
            }
        }
    }

    Timer {
        running: true
        interval: 500
        repeat: false
        onTriggered: {
            initialToSearchAnimation.running = true;
        }
    }

    Connections {
        target: searchButton
        onClicked: settingsToSearchAnimation.running = true;
    }

    Connections {
        target: settingsButton
        onClicked: searchToSettingsAnimation.running = true;
    }

}
