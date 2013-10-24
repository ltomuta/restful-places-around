/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

import QtQuick 1.1
import QtMobility.location 1.2
import PlacesApi 1.0
import "Constants.js" as Constants

/*!
  \qmlclass PlaceItem
  \brief A landmark which can be placed on a map.
*/
MapImage {
    id: place

    property Place placeObject

    property string url
    property string name
    property string address
    property string phoneNumber
    property string email
    property string website

    signal clicked(variant place, real latitude, real longitude)

    /*!
      Updates the properties of this item based on the ones of placeObject.
    */
    function updateProperties() {
        /*console.debug("Place.qml: updateProperties():",
                      placeObject.latitude,
                      placeObject.longitude,
                      placeObject.iconUrl,
                      placeObject.visible);*/

        coordinate.latitude = placeObject.latitude;
        coordinate.longitude = placeObject.longitude;
        source = placeObject.iconUrl;
        visible = placeObject.visible;

        url = placeObject.url;
        name = placeObject.name;
        address = placeObject.address;
        phoneNumber = placeObject.phoneNumber;
        email = placeObject.email;
        website = placeObject.website;
    }

    /*!
      Removes this item from the map and deletes the item.
    */
    function dispose() {
        console.debug("Place.qml: dispose()");

        if (parent) {
            // It is expected that the parent is a Map item-
            parent.removeMapObject(this);
        }

        delete this;
    }

    // Note: Coordinate must be defined (created) when creating this object!
    // Otherwise, when trying to set latitude or longitude, the application
    // will crash since coordinate property is null.
    coordinate: Coordinate {}

    onPlaceObjectChanged: {
        //console.debug("Place.qml: onPlaceObjectChanged: " + placeObject);
        if (placeObject) {
            updateProperties();
            placeObject.visibleChanged.connect(updateProperties);
            placeObject.aboutToBeDestroyed.connect(dispose);
        }
    }

    onSourceChanged: {
        offset.x = -Constants.MarkerIconWidth / 2;
        offset.y = -Constants.MarkerIconHeight + 2;
    }

    MapMouseArea {
        anchors.fill: parent

        onClicked: {
            console.debug("Place.qml: \"" + place.placeObject.name + "\" clicked.")
            place.clicked(place, place.coordinate.latitude, place.coordinate.longitude);
        }
    }
}
