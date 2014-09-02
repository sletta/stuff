import QtQuick 2.0

NumberAnimation {
    id: triggerAnimation
    property real internalState;
    signal changed;
    onInternalStateChanged: changed();
    onRunningChanged: changed();
    target: triggerAnimation
    property: "internalState"
    from: 0;
    to: 1;
    duration: 1000;
    loops: Animation.Infinite;
}

