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

Page {
    property PlaceItem place

    /*!
      Updates the page content.
    */
    function updateDetails()
    {
        if (!place || !place.placeObject) {
            console.debug("PlaceDetailsPage.qml: updateDetails(): Error, no place set!");
            return;
        }

        var placeObject = place.placeObject;
        placeIcon.source = placeObject.imageSource;
        placeName.text = placeObject.name
        placeAddress.text = placeObject.address;
        placePhone.text = placeObject.phoneNumber;
        placeEmail.text = "<a href=\"mailto:" + placeObject.email + "\">" + placeObject.email + "</a>";
        placeWebsite.text = "<a href=\"" + placeObject.website + "\">" + placeObject.website + "</a>";
    }

    onPlaceChanged: updateDetails();

    Connections {
        target: placesApiManager
        onRequestCompleted: updateDetails();
    }
    Connections {
        target: routeManager
        onRequestCompleted: pageStack.pop(placesMapPage);
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: container.height + 30

        Item {
            id: container
            height: childrenRect.height

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 10
                leftMargin: 20
                rightMargin: 20
            }

            Column {
                height: childrenRect.height

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                spacing: 6

                Label {
                    id: placeName
                    width: parent.width
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    font.pixelSize: 26
                    textFormat: Text.RichText
                }
                Image {
                    id: placeIcon
                    width: parent.width
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
                Label {
                    id: placeAddress
                    width: parent.width
                    visible: text.length
                    wrapMode: Text.WordWrap
                    textFormat: Text.RichText
                }
                Label {
                    id: placePhone
                    width: parent.width
                    visible: text.length
                    textFormat: Text.RichText
                }
                Label {
                    id: placeEmail
                    width: parent.width
                    visible: text.length
                    wrapMode: Text.WrapAnywhere
                    textFormat: Text.RichText
                    onLinkActivated: Qt.openUrlExternally(link);
                }
                Label {
                    id: placeWebsite
                    width: parent.width
                    visible: text.length
                    wrapMode: Text.WrapAnywhere
                    textFormat: Text.RichText
                    onLinkActivated: Qt.openUrlExternally(link);
                }
            }
        }
    }
    ScrollDecorator {
        flickableItem: flickable
    }

    BusyIndicator {
         id: busyIndicator
         anchors.centerIn: parent
         opacity: 0
         platformStyle: BusyIndicatorStyle { size: "large" }
         running: opacity > 0 ? true : false;
         Behavior on opacity { NumberAnimation { duration: 300 } }

    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: pageStack.pop();
        }
        ToolButton {
            enabled: placePhone.text.length > 0
            flat: false
            text: qsTr("Call");

            onClicked: {
                // Call the number, but before that remove invalid characters
                // from the phone number
                var phoneNumber = placePhone.text;
                var url = phoneNumber.replace(new RegExp("[^0-9\+]", "g"), "");
                Qt.openUrlExternally("tel:" + url);
            }
        }
        ToolButton {
            flat: false
            text: qsTr("Route");

            onClicked: {
                // Create a route request
                var placeObject = place.placeObject;

                if (placeObject) {
                    busyIndicator.opacity = 1;
                    placesMapPage.map.drawRoute(placeObject.latitude,
                                                placeObject.longitude);
                }
            }
        }
        //ToolIcon {} // Place holder
    }
}

