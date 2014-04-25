/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1

SearchBox {
    id: filterBar
    width: parent ? parent.width : 360
    placeHolderText: "Filter Text"
    state: "hidden"

    onSearchTextChanged: placesModel.filter = searchText;

    states: [
        State {
            name: "shown"

            PropertyChanges {
                target: filterBar
                y: 0
                opacity: 1
            }
        },
        State {
            name: "hidden"

            PropertyChanges {
                target: filterBar
                y: -filterBar.height
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
            NumberAnimation {
                target: filterBar
                property: "y"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    ]
}

