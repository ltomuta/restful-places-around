/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

import QtQuick 1.1
import QtMobility.location 1.2

Item {
    id: pannableMap

    property bool paused: false
    property alias map: map

    signal positionChanged(real latitude, real longitude)
    signal panningComplete()
    signal touched()

    /*!
      Moves the location indicator and pans to \a coordinate.
    */
    function updateCoordinates(coordinate, accuracyInMeters)
    {
        panToCoordinate(coordinate);
        moveHereToCoordinate(coordinate, accuracyInMeters);
    }

    /*!
      Moves the red circle to given coordinate, sets the radius of the circle
      by the given accuracy.
    */
    function moveHereToCoordinate(coordinate, accuracyInMeters)
    {
        if (!paused) {
            hereCenterAnimation.latitude = coordinate.latitude;
            hereCenterAnimation.longitude = coordinate.longitude;
            hereCenterAnimation.accuracyInMeters = accuracyInMeters;
            hereCenterAnimation.restart();
        }
    }

    /*!
      Pans the map to the given coordinate.
    */
    function panToCoordinate(coordinate)
    {
        if (!paused) {
            panningAnimation.latitude = coordinate.latitude;
            panningAnimation.longitude = coordinate.longitude;
            panningAnimation.restart();
        }
    }

    /*!
      Changes here icon bitmap to inform user that position source has
      been initialized.
     */
    function positionSourceInitialized() {
        hereIndicator.blinking = false;
    }

    Map {
        id: map
        anchors.fill: parent
        z: 1

        center: Coordinate {
            latitude: settings.setting("last_latitude");
            longitude: settings.setting("last_longitude");
        }

        plugin : Plugin { name : "nokia" }
        zoomLevel: 14
        connectivityMode: Map.OnlineMode
        mapType: Map.StreetMap

        // Circle for indicating both the position and the accuracy of the
        // positioning.
        MapCircle {
            id: positionAccuracyIndicator
            color: "#40FF0000"
            border.color: Qt.darker(color);
            border.width: 3
            opacity: 1.0

            center: Coordinate {
                latitude: settings.setting("last_latitude");
                longitude: settings.setting("last_longitude");
            }
        }

        HereIndicator {
            id: hereIndicator
            coordinate: positionAccuracyIndicator.center
        }
    }

    PinchArea {
        property double oldZoomLevel

        function calcZoomDelta(zoom, percent) {
            var zoomLevel = zoom + Math.log(percent) / Math.log(2);
            zoomLevel = Math.round(zoomLevel);

            if (zoomLevel > map.maximumZoomLevel) {
                zoomLevel = map.maximumZoomLevel;
            }
            else if (zoomLevel < map.minimumZoomLevel) {
                zoomLevel = map.minimumZoomLevel;
            }

            return zoomLevel;
        }

        anchors.fill: parent

        onPinchStarted: oldZoomLevel = map.zoomLevel;

        onPinchUpdated: {
            if (oldZoomLevel >= map.maximumZoomLevel
                    && pinch.scale > 1.0)
            {
                // Don't allow the user to zoom more than the map supports
                return;
            }
            else if (oldZoomLevel <= map.minimumZoomLevel
                     && pinch.scale < 1.0) {
                // Don't allow the user to zoom less than the map supports
                return;
            }

            map.scale = pinch.scale;
        }

        onPinchFinished: {
            map.zoomLevel = calcZoomDelta(oldZoomLevel, pinch.scale);
            map.scale = 1;
        }
    }

    MouseArea {
        id: panMouseArea

        property bool mouseDown: false
        property int lastX: -1
        property int lastY: -1

        anchors.fill: parent

        onPressed: {
            pannableMap.touched();
            panningAnimation.stop();
            mouseDown = true;
            lastX = mouse.x;
            lastY = mouse.y;
        }
        onReleased: {
            mouseDown = false;
            lastX = -1;
            lastY = -1;
        }
        onPositionChanged: {
            if (mouseDown) {
                var dx = mouse.x - lastX;
                var dy = mouse.y - lastY;
                map.pan(-dx, -dy);
                lastX = mouse.x;
                lastY = mouse.y;
            }
        }
        onCanceled: {
            mouseDown = false;
        }
    }

    ParallelAnimation {
        id: hereCenterAnimation

        property real latitude
        property real longitude
        property real accuracyInMeters

        property int duration: 1000
        property int easingType: Easing.InOutCubic

        PropertyAnimation {
            target: positionAccuracyIndicator
            property: "center.latitude"
            to: hereCenterAnimation.latitude
            duration: hereCenterAnimation.duration
            easing.type: hereCenterAnimation.easingType
        }
        PropertyAnimation {
            target: positionAccuracyIndicator
            property: "center.longitude"
            to: hereCenterAnimation.longitude
            duration: hereCenterAnimation.duration
            easing.type: hereCenterAnimation.easingType
        }
        PropertyAnimation {
            target: positionAccuracyIndicator
            property: "radius"
            to: hereCenterAnimation.accuracyInMeters
            duration: hereCenterAnimation.duration
            easing.type: hereCenterAnimation.easingType
        }
    }

    // An animation for centering the map to a given coordinate.
    ParallelAnimation {
        id: panningAnimation

        property real latitude
        property real longitude

        // Constants
        property int panningDuration: 800
        property int easingType: Easing.InOutCubic

        PropertyAnimation {
            target: map
            property: "center.latitude"
            to: panningAnimation.latitude
            easing.type: panningAnimation.easingType
            duration: panningAnimation.panningDuration
        }
        PropertyAnimation {
            target: map
            property: "center.longitude"
            to: panningAnimation.longitude
            easing.type: panningAnimation.easingType
            duration: panningAnimation.panningDuration
        }
        // Notify listeners after the panning animation is complete
        SequentialAnimation {
            PauseAnimation { duration: panningAnimation.panningDuration }
            ScriptAction { script: pannableMap.panningComplete(); }
        }
    }
}
