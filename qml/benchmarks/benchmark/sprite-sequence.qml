import QtQuick 2.2

Item {
    id: root;

    function complicate() { size = Math.max(1, size - increment); }
    function simplify() { size = size == 1 ? 2 : size + increment; }
    property int increment: size > 16 ? 2 : 1;
    property int size: 24;
    property int columns: width / size;
    property int rows: height / size;

    property string description: (columns * rows) + " " + size + "x" + size + " sprites\nUsing SpriteSequence";

    Grid {
        columns: root.columns
        rows: root.rows
        Repeater {
            model: root.rows * root.columns;

            SpriteSequence {
                id: sprite
                width: root.size
                height: root.size
                Sprite {
                    name: "one"
                    source: "butterfly-wide.png"
                    frameCount: 1
                    frameDuration: 300 + Math.random() * 300
                    to: { "two" : 1 }
                }
                Sprite {
                    name: "two"
                    source: "butterfly-half.png"
                    frameCount: 1
                    frameDuration: 300
                    to: { "three" : 1 }
                }
                Sprite {
                    name: "three"
                    source: "butterfly-collapsed.png"
                    frameCount: 1
                    frameDuration: 300
                    to: { "one" : 1 }
                }

            }
        }
    }
}
