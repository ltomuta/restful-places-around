/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

/*!
  Updates nearby places by current position.
*/
function updateNearbyPlaces() {
    placesApiManager.discoverExplore(lastUpdatePos.latitude,
                                     lastUpdatePos.longitude,
                                     {});
}


/*!
  Updates the nearby places if needed.

  @param forceUpdate If true, will force update.
  @return True if update is triggered, false otherwise.
*/
function updateNearbyPlacesIfNeeded(forceUpdate) {
    // Update if position has changed more than 100 m, or update is forced
    if (positionSource.position.coordinate.distanceTo(lastUpdatePos) > 100 || forceUpdate) {
        lastUpdatePos.latitude = positionSource.position.coordinate.latitude;
        lastUpdatePos.longitude = positionSource.position.coordinate.longitude;
        updateNearbyPlaces();
        return true;
    }

    return false;
}


/*!
  Hides the filter bar if visible and opens the the details page according to
  the given place.

  @param place The place (object of type declared in Place.qml) whose details
               to show.
*/
function openDetailsPage(place)
{
    if (!place || place.url.length == 0) {
        console.debug("openDetailsPage(): Error: No place given!");
        return;
    }
    if (place.url.length == 0) {
        console.debug("openDetailsPage(): Error: No URL defined!");
        return;
    }

    placesApiManager.request(place.url, 2); // 2 == PlacesApiManager.PlaceDetails
    filterBar.state = "hidden";
    pageStack.push("qrc:/PlaceDetailsPage.qml", { place: place });
}
