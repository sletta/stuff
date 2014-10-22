import QtQuick 2.2

Benchmark {
    id: root;

    property string description: count + " " + cellSize + "x" + cellSize + " sprites\nUsing SpriteSequence";
    property real cellSize: Math.floor(Math.sqrt(width * height / count))

    count: 200

    Grid {
        width: root.width
        height: root.height
        columns: Math.ceil(root.width / root.cellSize);
        rows: Math.ceil(root.height / root.cellSize);
        Repeater {
            model: root.count
            SpriteSequence {
                id: sprite
                width: root.cellSize
                height: root.cellSize
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
