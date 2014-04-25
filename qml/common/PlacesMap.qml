/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

import QtQuick 1.1
import QtMobility.location 1.2
import PlacesApi 1.0
import "CommonFunctions.js" as Functions
import "Constants.js" as Constants
import "MarkerCreator.js" as MarkerCreator
import "RouteDrawer.js" as RouteDrawer

PannableMap {
    id: placesMap

    property Coordinate lastUpdatePos: Coordinate {}
    property Item selectedPlaceOnMap
    property bool hasRoute: false

    signal bubbleClicked()
    signal bubbleLongPress()

    /*!
      Draws a route to the currently selected place.
    */
    function drawRouteToSelectedPlaceOnMap() {
        if (selectedPlaceOnMap) {
            console.debug("PlacesMap.qml: drawRouteToselectedPlaceOnMap(): "
                          + selectedPlaceOnMap.name);
            RouteDrawer.drawRoute(map,
                                  selectedPlaceOnMap.coordinate.latitude,
                                  selectedPlaceOnMap.coordinate.longitude);
            placesMap.hasRoute = true;
        }
        else {
            console.debug("PlacesMap.qml: drawRouteToselectedPlaceOnMap(): "
                          + "No place selected!");
        }
    }

    /*!
      Draws a route from the current position to the given coordinates.
    */
    function drawRoute(latitude, longitude) {
        RouteDrawer.drawRoute(map, latitude, longitude);
        placesMap.hasRoute = true;
    }

    /*!
      Clears the route.
    */
    function clearRoute() {
        console.debug("PlacesMap.qml: clearRoute()");
        RouteDrawer.clearRoute();
        placesMap.hasRoute = false;
    }

    /*!
    */
    function onPlaceClicked(place, latitude, longitude) {
        if (!place || placesMap.selectedPlaceOnMap == place) {
            console.debug("PlacesMap.qml: Map::placeClicked(): "
                          + "No place given or already selected!");
            return;
        }

        console.debug("PlacesMap.qml: Map::placeClicked(): " + place.name);

        // Hide the bubble if visible
        if (bubble.opacity > 0) {
            bubble.opacity = 0;
        }

        bubble.aboutToBeShown = true;
        placesMap.selectedPlaceOnMap = place;
        var screenPos = map.toScreenPosition(selectedPlaceOnMap.coordinate);

        // Move slightly to the left to leave room for the bubble
        screenPos.x += Constants.BubbleOffset;
        panToCoordinate(map.toCoordinate(screenPos));
    }

    paused: pageStack.currentPage != placesMapPage

    onPausedChanged: console.debug("PlacesMap.qml: paused set to " + paused);

    onTouched: {
        if (bubble.opacity > 0) {
            bubble.opacity = 0;
        }

        if (bubble.aboutToBeShown) {
            bubble.aboutToBeShown = false;
            placesMap.selectedPlaceOnMap = null;
        }
    }
    onPanningComplete: {
        if (bubble.aboutToBeShown && selectedPlaceOnMap) {
            var screenPos = map.toScreenPosition(selectedPlaceOnMap.coordinate);
            bubble.move(screenPos.x - 4,
                        screenPos.y
                            - Constants.DefaultBubbleHeight
                            - Constants.MarkerIconHeight / 2,
                        Constants.DefaultBubbleWidth,
                        Constants.DefaultBubbleHeight,
                        selectedPlaceOnMap.name);
        }
    }
    onHeightChanged: {
        // On orientation change move bubble to correct position.
        if (bubble.opacity > 0 && selectedPlaceOnMap) {
            var screenPos = map.toScreenPosition(selectedPlaceOnMap.coordinate);
            bubble.x = screenPos.x - 4;
            bubble.y = screenPos.y - bubble.height - Constants.MarkerIconHeight / 2;
        }
    }

    Connections {
        target: placesApiManager

        onRequestCompleted: {
            if (!placesMap.selectedPlaceOnMap) {
                console.debug("PlacesMap.qml: Ignoring PlacesApiManager::requestCompleted()");
                return;
            }

            switch (requestId) {
            case PlacesApiManager.PlaceDetails: {
                var jsonObject = JSON.parse(result);
                var placeObject = placesMap.selectedPlaceOnMap.placeObject;
                placesApiManager.parseContacts(jsonObject.contacts, placeObject);
                placesApiManager.parseMediaImages(jsonObject.media.images.items, placeObject);
                break;
            }
            }
        }
    }
    Connections {
        target: placesModel
        onPlaceAdded: MarkerCreator.createMarkerObjects(map, placesMap, place);
    }

    PositionSource {
        id: positionSource
        updateInterval: 5000
        active: false
        property bool initialized: false

        onPositionChanged: {
            var accuracyInMeters = Math.max(position.horizontalAccuracy,
                                            position.verticalAccuracy);

            if (!initialized) {
                Functions.updateNearbyPlacesIfNeeded(true);
                updateCoordinates(position.coordinate, accuracyInMeters);
                positionSourceInitialized();
                initialized = true;
            }
            else {
                moveHereToCoordinate(position.coordinate, accuracyInMeters);
            }

            if (Functions.updateNearbyPlacesIfNeeded(false)) {
                panToCoordinate(position.coordinate);
            }

            settings.setSetting("last_latitude", position.coordinate.latitude);
            settings.setSetting("last_longitude", position.coordinate.longitude);
        }
    }

    Bubble {
        id: bubble

        property bool aboutToBeShown: false

        width: Constants.DefaultBubbleWidth
        height: Constants.DefaultBubbleHeight
        z: 2
        opacity: 0

        Behavior on opacity { NumberAnimation { duration: 200 } }

        onClicked: placesMap.bubbleClicked();
        onLongPress: placesMap.bubbleLongPress();
        onMoveComplete: aboutToBeShown = false;
    }

    Component.onCompleted: positionSource.active = true;
}
