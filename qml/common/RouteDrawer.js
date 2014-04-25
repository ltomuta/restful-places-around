/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

// "Constants"
var RouteColor = "blue";

// Members
var mMap;
var mRoute;


/*!
  Clears the previous route if one exists and creates a request to draw
  a new one based on the given coordinates.

  @param map The map on which to draw the route.
  @param latitide The latitude coordinate of the end destination.
  @param longitude The longitude coordinate of the end destination.
*/
function drawRoute(map, latitude, longitude) {
    if (!map) {
        console.debug("RouteDrawer.js: drawRoute(): No map given!");
        return;
    }

    var fromLatitude = positionSource.position.coordinate.latitude;
    var fromLongitude = positionSource.position.coordinate.longitude;

    console.debug("RouteDrawer.js: drawRoute(): From "
                  + fromLatitude + ", " + fromLongitude
                  + " to " + latitude + ", " + longitude);
    mMap = map;

    /*if (mRoute) {
        // Clear previous route
        mMap.removeMapObject(mRoute);
        mRoute.destroy();
    }*/
    clearRoute();

    // Create dynamically new route line object and add it to the map
    mRoute =
            Qt.createQmlObject(
                "import QtQuick 1.1; import QtMobility.location 1.2; "
                + "MapPolyline { z: 1; border.width: 4; border.color: "
                + "\"" + RouteColor + "\"; opacity: 1; }",
                mMap);
    mMap.addMapObject(mRoute);
    routeManager.coordinateFound.disconnect(addCoordinate);
    routeManager.coordinateFound.connect(addCoordinate);
    routeManager.requestRoute(fromLatitude, fromLongitude, latitude, longitude);
    
}


/*!
  Removes the existing route from the map and deletes it.
*/
function clearRoute()
{
    if (mMap && mRoute) {
        mMap.removeMapObject(mRoute);
        mRoute.destroy();
        mRoute = null;
    }
}


/*!
  Adds a new coordinate to the route polyline.
*/
function addCoordinate(latitude, longitude) {
    if (!mRoute) {
        console.debug("RouteDrawer.js: addCoordinate(): Error, no route set!");
        return;
    }

    console.debug("RouteDrawer.js: addCoordinate(): "
                  + latitude + ", " + longitude);

    var newCoordinate =
            Qt.createQmlObject(
                "import QtQuick 1.1; import QtMobility.location 1.2; "
                + "Coordinate {latitude: " + latitude
                + "; longitude: " + longitude + "; }",
                mRoute, "coord");
    mRoute.addCoordinate(newCoordinate);
}
