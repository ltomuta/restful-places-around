/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

import QtQuick 1.1
import com.nokia.meego 1.1
import PlacesApi 1.0

Window {
    id: main

    // Elements provided by the PlacesApi plug-in
    PlacesModel {
        id: placesModel
    }
    PlacesApiManager {
        id: placesApiManager
        placesModel: placesModel

        onRequestCompleted: {
            // Parse the results
            var jsonObject = JSON.parse(result);

            switch (requestId) {
            case PlacesApiManager.Places: {
                // Create the places
                createPlaces(jsonObject.results.items);
                break;
            }
            case PlacesApiManager.PlaceDetails: {
                var placeObject = selectedPlace.placeObject;

                if (placeObject) {
                    placesApiManager.parseContacts(jsonObject.contacts, placeObject);
                    placesApiManager.parseMediaImages(jsonObject.media.images.items, placeObject);
                }

                break;
            }
            }
        }
    }
    RouteManager {
        id: routeManager
    }

    PlaceItem {
        id: selectedPlace
    }

    // The main page of the application
    PlacesMapPage {
        id: placesMapPage
    }

    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    PageStack {
        id: pageStack

        anchors {
            top: statusBar.bottom
            left: parent.left
            right: parent.right
        }

        toolBar: toolBar

        Component.onCompleted: pageStack.push(placesMapPage);

        onCurrentPageChanged: {
            if (currentPage != placesMapPage) {
                bottomAnchorTimer.start();
            }
            else {
                if (bottomAnchorTimer.running)
                    bottomAnchorTimer.stop();

                anchors.bottom = parent.bottom;
            }
        }

        // Timer to avoid the map jumping up during a page change transition
        Timer {
            id: bottomAnchorTimer
            repeat: false
            running: false
            interval: 750
            onTriggered: pageStack.anchors.bottom = toolBar.top;
        }
    }

    StatusBar {
        id: statusBar
        z: 1
        anchors.top: parent.top
    }

    // Bar containing a text filter for entering text for filtering the found
    // places.
    FilterBar {
        id: filterBar
        anchors.top: statusBar.bottom
        z: 1
    }

    ToolBarStyle {
        id: transparentToolBarStyle
        background: "qrc:/harmattan-toolbar.png"
    }
    ToolBar {
        id: toolBar

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        platformStyle: transparentToolBarStyle
    }

    Component.onCompleted: theme.inverted = false;
}
