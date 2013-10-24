/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

import QtQuick 1.1
import com.nokia.meego 1.1
import "Constants.js" as Constants

Page {
    id: infoPage

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: infoText.height

        Label {
            id: infoText

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 10
            }

            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            text: Constants.InfoText
            onLinkActivated: Qt.openUrlExternally(link);
        }
    }
    ScrollDecorator {
        flickableItem: flickable
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: pageStack.pop();
        }
    }
}
