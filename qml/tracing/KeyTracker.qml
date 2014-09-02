import QtQuick 2.0

QtObject {
    property int state: (_pos && !_neg ? 1 : (_neg && !_pos ? -1 : 0));
    property int keyPos;
    property int keyNeg;
    property bool _pos : false
    property bool _neg: false

    function updateState(key, pressed) {
        if (key == keyPos)
            _pos = pressed;
        else if (key == keyNeg)
            _neg = pressed;
    }
}
