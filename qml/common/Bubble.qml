/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

import QtQuick 1.1
import "Constants.js" as Constants

Item {
    id: bubble

    // Default width and height
    width: 280
    height: 95

    property alias text: bubbleText.text
    property int fontPixelSize: 26 // Default size

    signal clicked()
    signal longPress()
    signal moveComplete()

    /*!
      Moves the bubble to the given position with an animation. When the
      animation is finished the size of the bubble is set according to the
      given size.
    */
    function move(targetX, targetY, targetWidth, targetHeight, targetText)
    {
        console.debug("Bubble.qml: move(): " + targetX, targetY, targetText);
        moveAnimation.targetX = targetX;
        moveAnimation.targetY = targetY;
        moveAnimation.targetWidth = targetWidth;
        moveAnimation.targetHeight = targetHeight;
        moveAnimation.targetText = targetText;
        moveAnimation.restart();
    }

    BorderImage {
        id: bubbleImage
        border.left: 16
        border.top: 16
        border.right: 16
        border.bottom: 27
        horizontalTileMode: BorderImage.Repeat
        verticalTileMode: BorderImage.Repeat
        anchors.fill: parent
        source: "qrc:/bubble.png"
        smooth: true

        Text {
            id: bubbleText

            anchors {
                fill: parent
                topMargin: 10
                leftMargin: 10
                rightMargin: 10
                bottomMargin: 20
            }

            color: "black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: bubble.fontPixelSize
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            elide: Text.ElideRight
        }

        MouseArea {
            anchors.fill: parent
            onClicked: bubble.clicked();
            onPressAndHold: bubble.longPress();
        }
    }

    SequentialAnimation {
        id: moveAnimation

        property int targetX: 0
        property int targetY: 0
        property string targetText: ""

        // Default target width and height
        property int targetWidth: 350
        property int targetHeight: 75
        property int stepDuration: 450

        ParallelAnimation {
            NumberAnimation {
                target: bubble
                properties: "width, height"
                to: 0
                duration: bubble.opacity > 0 ? moveAnimation.stepDuration : 10;
                easing.type: Easing.InOutBack
                easing.overshoot: 5.0
            }
            NumberAnimation {
                target: bubbleText
                properties: "opacity"
                to: 0
                duration: bubble.opacity > 0 ? moveAnimation.stepDuration : 10;
            }
        }
        // Change the properties
        ScriptAction {
            script: {
                bubble.x = moveAnimation.targetX;
                bubble.y = moveAnimation.targetY;
                bubble.opacity = 1;

                if (moveAnimation.targetText.length) {
                    bubbleText.text = moveAnimation.targetText;
                }
            }
        }
        ParallelAnimation {
            NumberAnimation {
                target: bubble
                properties: "width"
                to: moveAnimation.targetWidth
                duration: moveAnimation.stepDuration
                easing.type: Easing.InOutBack
                easing.overshoot: 5.0
            }
            NumberAnimation {
                target: bubble
                properties: "height"
                to: moveAnimation.targetHeight
                duration: moveAnimation.stepDuration
                easing.type: Easing.InOutBack
                easing.overshoot: 5.0
            }
            NumberAnimation {
                target: bubbleText
                properties: "opacity"
                to: 1
                duration: moveAnimation.stepDuration
            }
        }
        ScriptAction { script: bubble.moveComplete(); }
    }
}
