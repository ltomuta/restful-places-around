/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.meego 1.1

Window {
    id: splashScreen

    signal hidden()

    /*!
      Hides this splash screen using a transition. hidden() signal is emitted
      when the transition is complete.
    */
    function hide()
    {
        console.debug("SplashScreen.qml: hide()");
        hideAnimation.start();
    }

    z: 10

    // Lock to portrait
    Page {
        orientationLock: PageOrientation.LockPortrait
    }

    Rectangle {
        id: gradientRectangle
        width: parent.width > parent.height ? parent.width : parent.height;
        height: width

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#478fd7" }
            GradientStop { position: 1.0; color: "#2a569c" }
        }
    }
    Image {
        id: markerImage
        x: 20
        y: 426 - sourceSize.height / 2
        width: 100
        fillMode: Image.PreserveAspectFit
        smooth: true

        transform: Rotation {
            id: rotation
            origin.x: markerImage.width / 2
            origin.y: markerImage.height / 2
            axis { x: 0; y: 1; z: 0 }
        }

        source: "qrc:/n-marker.png"
    }

    SequentialAnimation {
        id: splashScreenAnimation

        NumberAnimation {
            target: rotation
            properties: "angle"
            from: 0
            to: 360
            duration: 3600
        }
        ScriptAction { script: splashScreenAnimation.restart(); }
    }

    // Application title label
    Text {
        anchors {
            top: markerImage.top
            left: markerImage.right
            right: parent.right
            leftMargin: 20
        }

        color: "#eeeeee"
        font.pixelSize: 50
        wrapMode: Text.WordWrap
        text: "RESTful\nPlaces\nAround"
    }

    // Animation for hiding this splash screen
    SequentialAnimation {
        id: hideAnimation

        PauseAnimation { duration: 200 }
        NumberAnimation {
            target: splashScreen
            property: "opacity"
            to: 0.0
            duration: 500
        }
        ScriptAction { script: splashScreen.hidden(); }
    }

    Component.onCompleted: splashScreenAnimation.start();
}
