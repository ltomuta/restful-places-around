/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

import QtQuick 1.1
import QtMobility.location 1.2

MapImage {
    id: hereIndicator

    property bool blinking: true

    z: 2
    offset.x: -10
    offset.y: -10
    source: blinking ? "qrc:/here-icon-gray.png" : "qrc:/here-icon.png";
    smooth: true

    onBlinkingChanged: {
        if (!blinking) {
            visible = true;
        }
    }

    // Timer for blinking the location indicator until the current position
    // is found.
    Timer {
        id: mapImageBlinkingTimer
        interval: 500
        running: hereIndicator.blinking
        repeat: true
        onTriggered: hereIndicator.visible = !hereIndicator.visible;
    }
}
