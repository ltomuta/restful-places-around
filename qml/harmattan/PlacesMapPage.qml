/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

import QtQuick 1.1
import com.nokia.meego 1.1
import QtMobility.location 1.2
import PlacesApi 1.0
import "CommonFunctions.js" as Functions

Page {
    id: placesMapPage

    property alias map: placesMap

    PlacesMap {
        id: placesMap
        anchors.fill: parent
        onBubbleClicked: Functions.openDetailsPage(selectedPlaceOnMap);
        onBubbleLongPress: placeContextMenu.open();
    }

    // Buttons for zooming in/out for Simulator
    Row {
        anchors {
            top: parent.top
            left: parent.left
            margins: 10
        }

        opacity: 0.5
        visible: isSimulator == true
        spacing: 6

        Button {
            text: "-"
            onClicked: placesMap.map.zoomLevel -= 1;
        }
        Button {
            text: "+"
            onClicked: placesMap.map.zoomLevel += 1;
        }

        Component.onCompleted: console.debug("isSimulator == " + isSimulator);
    }

    Menu {
        id: placeContextMenu

        content: MenuLayout {
            MenuItem {
                text: qsTr("Place details");
                onClicked: Functions.openDetailsPage(selectedPlaceOnMap);
            }
            MenuItem {
                text: qsTr("Draw route");
                onClicked: placesMap.drawRouteToSelectedPlaceOnMap();
            }
        }
    }


    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            enabled: false
            opacity: 0.3
            onClicked: Qt.quit();
        }
        ToolIcon {
            id: listViewButton
            iconId: "toolbar-list"

            onClicked: {
                placesMap.selectedPlaceOnMap = null;
                pageStack.push("qrc:/PlacesListPage.qml");
            }
        }
        ToolIcon {
            id: deleteRouteButton
            enabled: placesMap.hasRoute
            opacity: enabled ? 1.0 : 0.3;
            iconId: "toolbar-delete"
            onClicked: placesMap.clearRoute();
        }
        ToolIcon {
            id: infoButton
            iconSource: "qrc:/info.png"
            onClicked: pageStack.push("qrc:/InfoPage.qml");
        }
    }
}
