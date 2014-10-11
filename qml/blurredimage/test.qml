import Qt.labs.blurredimage 1.0
import QtQuick 2.4

Rectangle {
    id: root

    color: "black"

     width: 640
     height: 360

     property real t: 0;
     SequentialAnimation on t {
         PauseAnimation { duration: 2000 }
         ScriptAction {
             script: root.grabToImage(function(result) { result.saveToFile("state1.png"); });
         }
         NumberAnimation { to: 1; duration: 2000; }
         ScriptAction {
             script: root.grabToImage(function(result) { result.saveToFile("state2.png"); });
         }
         PauseAnimation { duration: 2000 }
         NumberAnimation { to: 0; duration: 2000; }
         loops: Animation.Infinite
         running: true
     }

     property real strength: 0.2

     BlurredImage {
         source: "walker.png"
         x: 200
         y: 0
         scale: 0.9
         blurRatio: (1 - root.t) * root.strength
     }
     BlurredImage {
         source: "walker.png"
         x: 325
         y: 0
         blurRatio: (1 - root.t) * root.strength
     }
     BlurredImage {
         source: "droid2.png"
         x: 0
         y: 175
         scale: 0.9
         blurRatio: root.t * root.strength
     }
     BlurredImage {
         source: "droid2.png"
         x: 100
         y: 200
         blurRatio: root.t * root.strength
     }
     BlurredImage {
         source: "droid1.png"
         x: 500
         y: 175
         scale: 0.9
         blurRatio: root.t * root.strength
     }
     BlurredImage {
         source: "droid1.png"
         x: 425
         y: 200
         blurRatio: root.t * root.strength
     }
}
