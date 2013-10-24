/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#include "routemanager.h"
#include <QDebug>


/*!
  \class RouteManager
  \brief This class is a route manager that can be used for requesting
         routes from place A to place B.
*/


/*!
  Constructor.
*/
RouteManager::RouteManager(QObject *parent)
    : QObject(parent)
{
    m_geoProvider = new QGeoServiceProvider("nokia");
    m_routingMgr = m_geoProvider->routingManager();
    connect(m_routingMgr, SIGNAL(error(QGeoRouteReply*,QGeoRouteReply::Error,QString)),
            this, SLOT(error(QGeoRouteReply*,QGeoRouteReply::Error,QString)));
    connect(m_routingMgr, SIGNAL(finished(QGeoRouteReply*)),
            this, SLOT(finished(QGeoRouteReply*)));
}


/*!
  Copy constructor.
  Not used.
*/
RouteManager::RouteManager(const RouteManager &manager)
    : QObject(0)
{
    Q_UNUSED(manager);
}


/*!
  Destructor.
*/
RouteManager::~RouteManager()
{
    delete m_geoProvider;
}


/*!
  Calculates a route from coordinate A to coordinate B.
*/
void RouteManager::requestRoute(const double fromLat,
                                const double fromLng,
                                const double toLat,
                                const double toLng)
{
    qDebug() << "Route request - from:" << fromLat << fromLng << " to:" << toLat << toLng;
    QGeoRouteRequest request(QGeoCoordinate(fromLat, fromLng),
                             QGeoCoordinate(toLat, toLng));
    m_routingMgr->calculateRoute(request);
}


/*!
  Handle error, if route request fails.
*/
void RouteManager::error(QGeoRouteReply *reply,
                         QGeoRouteReply::Error error,
                         QString errorString)
{
    Q_UNUSED(error);
    emit requestFailed(errorString);
    reply->deleteLater();
}


/*!
  Handle a successful route request.
*/
void RouteManager::finished(QGeoRouteReply *reply)
{
    if (reply->routes().count() == 0) {
        emit requestFailed(reply->errorString());
        qDebug() << "Route error:" << reply->errorString();
        return;
    }

    emit requestCompleted();

    QGeoRoute route = reply->routes().at(0);

    foreach (QGeoCoordinate coord, route.path()) {
        emit coordinateFound(coord.latitude(), coord.longitude());
    }

    reply->deleteLater();
}

