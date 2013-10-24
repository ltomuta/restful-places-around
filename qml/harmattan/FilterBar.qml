/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

import QtQuick 1.1
import com.nokia.meego 1.0

SearchBox {
    id: filterBar
    width: parent.width
    state: "hidden"

    onSearchTextChanged: placesModel.filter = searchText;

    states: [
        State {
            name: "shown"

            PropertyChanges {
                target: filterBar
                opacity: pageStack.currentPage == placesMapPage ? 0.7 : 1;
            }
        },
        State {
            name: "hidden"

            PropertyChanges {
                target: filterBar
                opacity: 0
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                target: filterBar
                property: "opacity"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    ]
}

