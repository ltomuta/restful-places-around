/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#include "placesapiplugin.h"

#include <QtDeclarative>

#include "place.h"
#include "placesapimanager.h"
#include "placesmodel.h"
#include "routemanager.h"


/*!
  \class PlacesApiPlugin
  \brief The main class of the plugin. Registers the public types.
*/

/*!
  Constructor.
*/
PlacesApiPlugin::PlacesApiPlugin(QObject *parent) :
    QDeclarativeExtensionPlugin(parent)
{
}

/*!
  From QDeclarativeExtensionPlugin.
*/
void PlacesApiPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<Place>(uri, 1, 0, "Place");
    qmlRegisterType<PlacesApiManager>(uri, 1, 0, "PlacesApiManager");
    qmlRegisterType<PlacesModel>(uri, 1, 0, "PlacesModel");
    qmlRegisterType<RouteManager>(uri, 1, 0, "RouteManager");
}

Q_EXPORT_PLUGIN2(PlacesApi, PlacesApiPlugin)
