/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1

Item {
    id: mainLoaderItem

    /*!
      Handles the signals emitted when the status text in the splash screen is
      changed.
    */
    function handleStatusTextChanged()
    {
        if (splashScreenLoader.item
                && !mainAppLoader.Loading
                && !mainAppLoader.item)
        {
            console.debug("Starting to load the main application.");
            mainAppLoader.source = Qt.resolvedUrl("qrc:/main.qml");
        }
    }

    /*!
      Hides the splash screen.
    */
    function hideSplashScreen()
    {
        if (splashScreenLoader.item) {
            console.debug("Hiding the splash screen.");
            splashScreenLoader.item.text = "";
            splashScreenLoader.item.hide();
        }
    }

    /*!
      Deletes the splash screen item by setting the source property of its
      loader to an empty string.
    */
    function deleteSplashScreen()
    {
        if (splashScreenLoader.item) {
            console.debug("Deleting the splash screen.");
            splashScreenLoader.source = "";
        }
    }

    // Loaders for the main application and the splash screen.
    Loader {
        id: mainAppLoader
        width: mainLoaderItem.width
        height: mainLoaderItem.height

        onLoaded: {
            console.debug("Main application loaded.");
            item.readyToBeShown.connect(mainLoaderItem.hideSplashScreen);
            splashScreenLoader.item.text = "Authenticating...";
        }
    }
    Loader {
        id: splashScreenLoader
        source: Qt.resolvedUrl("qrc:/SplashScreen.qml");
        width: mainLoaderItem.width
        height: mainLoaderItem.height

        onLoaded: {
            item.text = "Loading...";
            item.textChangeComplete.connect(mainLoaderItem.handleStatusTextChanged);
            item.hidden.connect(mainLoaderItem.deleteSplashScreen);
        }
    }
}
