/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import "Constants.js" as Constants

Page {
    id: infoPage

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: infoText.height

        Text {
            id: infoText

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 10
            }

            font {
                family: platformStyle.fontFamilyRegular
                pixelSize: platformStyle.fontSizeMedium
            }

            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            color: platformStyle.colorNormalLight
            text: Constants.InfoText
            onLinkActivated: Qt.openUrlExternally(link);
        }
    }
    ScrollDecorator {
        flickableItem: flickable
    }

    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: pageStack.pop();
        }
    }
}
