/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import QtMobility.location 1.2
import PlacesApi 1.0
import "CommonFunctions.js" as Functions

Page {
    id: placesListPage

    Component {
        id: listHeading

        ListHeading {
            width: parent.width

            ListItemText {
                anchors.fill: parent.paddingItem
                role: "Heading"

                text: {
                    var headingText;

                    if (placesModel.filter.length == 0) {
                        headingText = "No places found";

                        if (listView.count == 1) {
                            headingText = "Found 1 place";
                        }
                        else if (listView.count > 1) {
                            headingText = "Found " + listView.count + " places";
                        }
                    }
                    else {
                        headingText = listView.count + " place";

                        if (listView.count > 1 || listView.count == 0) {
                            headingText += "s";
                        }

                        headingText += " contain \""
                                + placesModel.filter + "\"";
                    }

                    return headingText;
                }
            }
        }
    }

    Component {
        id: listDelegate

        ListItem {
            id: listItem
            subItemIndicator: true

            Column {
                anchors.fill: listItem.paddingItem

                ListItemText {
                    id: titleText
                    width: parent.width
                    mode: listItem.mode
                    role: "Title"
                    text: name
                }
                ListItemText {
                    id: subtitleText
                    width: parent.width
                    mode: listItem.mode
                    role: "SubTitle"
                    text: streetAddress
                }
            }

            onClicked: {
                selectedPlace.placeObject = object;
                Functions.openDetailsPage(selectedPlace);
            }
        }
    }

    ListView {
        id: listView

        y: filterBar.state == "shown" ? filterBar.height : 0;
        width: parent.width
        height: filterBar.state == "shown" ?
                    parent.height - filterBar.height
                  : parent.height;

        anchors {
            left: parent.left
            right: parent.right
        }

        model: placesModel
        delegate: listDelegate
        header: listHeading
        focus: true
        clip: true

        Behavior on y {
            SmoothedAnimation {}
        }
    }
    ScrollDecorator {
        flickableItem: listView
    }

    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "toolbar-back"

            onClicked: {
                filterBar.state = "hidden";
                pageStack.pop();
            }
        }
        ToolButton {
            id: searchButton
            opacity: enabled ? 1 : 0.5;
            enabled: (placesModel.count > 1 || placesModel.filter.length > 0)
            flat: true
            iconSource: "toolbar-search"
            onCheckedChanged: checked ? filterBar.state = "shown"
                                      : filterBar.state = "hidden";
            checkable: true
        }
    }
}
