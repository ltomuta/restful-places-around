/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

var mMap;
var mClickListener;
var mPlaceObject;
var mComponent;
var mMarker;

function createMarkerObjects(map, clickListener, placeObject) {
    //console.debug("createMarkerObjects(): " + map, placeObject);
    mMap = map;
    mClickListener = clickListener;
    mPlaceObject = placeObject;
    mComponent = Qt.createComponent("qrc:/PlaceItem.qml");

    if (mComponent.status == Component.Ready) {
        finishCreation();
    }
    else {
        mComponent.statusChanged.connect(finishCreation);
    }
}

function finishCreation() {
    if (mComponent.status == Component.Ready) {
        mMarker = mComponent.createObject(mMap, { placeObject: mPlaceObject });

        if (mMarker == null) {
            console.log("MarkerCreator.js: finishCreation(): "
                        + "Failed to create a marker!");
        }
        else {
            mMap.addMapObject(mMarker);
            mMarker.clicked.connect(mClickListener.onPlaceClicked);
        }
    }
    else if (mComponent.status == Component.Error) {
        console.log("MarkerCreator.js: finishCreation(): Error loading component: "
                    + mComponent.errorString());
    }
}
