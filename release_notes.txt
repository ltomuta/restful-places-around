RESTful Places Around
=====================

RESTful Places Around demonstrates the use of the Nokia RESTful
Places API within a Qt Quick application. This example retrieves the places
nearby and displays them on Nokia Maps.

This example application demonstrates:
- Making RESTful API requests and handling the network replies with Qt C++
- Comprehensive use of QML bindings of the Qt Mobility Location API
- Planning a route on a map from the current position to a selected place
- Making phone calls (opening the call UI)

This example application is hosted in Nokia Developer Projects:
- http://projects.developer.nokia.com/restfulplacesaround

For more information on implementation, visit the wiki pages:
- http://projects.developer.nokia.com/restfulplacesaround/wiki


1. Usage
-------------------------------------------------------------------------------

The application consists of the following pages (views) and their features:
- Places map page
  - Planning routes
  - Displaying places with markers
    - Tapping a marker opens up a bubble. If the bubble is tapped, more details
      of the selected place are displayed.
    - Long press opens the context menu with a quick routing option.
- Places list page
  - Displays the found places as a list
  - Items can be filtered by enabling the filter mode by tapping the search
    icon in the tool bar.
    - Items that are filtered out are also hidden from the map.
- Place details page
  - Can display name, image, address, phone number, email address, and website
    address of a given place if those details are provided by the RESTful
    Places API.
  - Provides options for calling the place and drawing a route to the location
    in the tool bar.


2. Project structure and implementation
-------------------------------------------------------------------------------

2.1 Folders
-----------

 |                  The root folder contains the project file, the licence
 |                  information, and this file (release notes).
 |
 |- bin             Contains application binaries.
 |
 |- doc             Contains the simplified UML diagram of the application
 |                  architecture.
 |
 |- icons           Contains application icons.
 |
 |- images          Contains application graphics.
 |
 |- placesapiplugin Contains the Places API plug-in, i.e., the Qt C++
 |                  implementation for managing the RESTful Places API.
 |
 |- qml             Root folder for QML and JavaScript files.
 |  |
 |  |- common       Common, cross-platform QML and JavaScript files.
 |  |
 |  |- harmattan    Harmattan-specific QML and JavaScript files.
 |  |
 |  |- symbian      Symbian-specific QML and JavaScript files.
 |
 |- qtc_packaging   Contains the Harmattan (Debian) packaging files.
 |
 |- rsc             Contains the Qt resource system files.
 |
 |- src             Contains the Qt/C++ source code files.


2.2 Used APIs/QML elements/Qt Quick Components
----------------------------------------------

The basic types, common classes, and elements are omitted.

- Classes and APIs in the Places API plug-in:
  - QAbstractListModel
  - QDeclarativeExtensionPlugin
  - QGeoRouteReply
  - QGeoRoutingManager
  - QGeoServiceProvider
  - QLandmark
  - QNetworkReply
  - QNetworkRequest
  
- QML elements:
  - BorderImage
  - PinchArea
  - QML bindings of Qt Mobility Location API
    - Map
    - MapCircle
    - MapImage
    - MapMouseArea
    - PositionSource

- Qt Quick Components:
  - BusyIndicator
  - Menu
  - SearchBox (Symbian extras)


3. Compatibility
-------------------------------------------------------------------------------

 - Symbian devices with Qt 4.7.4 and Qt Mobility 1.2.1.
 - MeeGo 1.2 Harmattan.

Tested to work on Nokia 701 and Nokia N9. Developed with Qt SDK 1.2.1.

3.1 Required capabilities
-------------------------

None; the application can be self signed on Symbian.

3.2 Known issues
----------------

None.


4. Building, installing, and running the application
-------------------------------------------------------------------------------

4.1 Preparations
----------------

Check that you have the latest Qt SDK installed in the development environment
and the latest Qt version on the device.

Qt Quick Components 1.1 or higher is required.

4.2 Using the Qt SDK
--------------------

You can install and run the application on the device by using the Qt SDK.
Open the project in the SDK, set up the correct target (depending on the device
platform), and click the Run button. For more details about this approach,
visit the Qt Getting Started section at Nokia Developer
(http://www.developer.nokia.com/Develop/Qt/Getting_started/).

4.3 Symbian device
------------------

Make sure your device is connected to your computer. Locate the .sis
installation file and open it with Nokia Suite. Accept all requests from Nokia
Suite and the device. Note that you can also install the application by copying
the installation file onto your device and opening it with the Symbian File
Manager application.

After the application is installed, locate the application icon from the
application menu and launch the application by tapping the icon.

4.4 Nokia N9 and Nokia N950
---------------------------

Copy the application Debian package onto the device. Locate the file with the
device and run it; this will install the application. Note that you can also
use the terminal application and install the application by typing the command
'dpkg -i <package name>.deb' on the command line. To install the application
using the terminal application, make sure you have the right privileges 
to do so (e.g. root access).

Once the application is installed, locate the application icon from the
application menu and launch the application by tapping the icon.


5. Licence
-------------------------------------------------------------------------------

See the licence text file delivered with this project. The licence file is also
available online at
http://projects.developer.nokia.com/restfulplacesaround/browser/Licence.txt


6. Related documentation
-------------------------------------------------------------------------------
Nokia RESTful Places API documentation:
- http://api.maps.nokia.com/en/restplaces/overview.html


7. Version history
-------------------------------------------------------------------------------

1.0 Initial release
