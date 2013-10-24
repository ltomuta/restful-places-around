/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#ifndef ROUTEMANAGER_H
#define ROUTEMANAGER_H

#include <QGeoRouteReply>
#include <QGeoRoutingManager>
#include <QGeoServiceProvider>

QTM_USE_NAMESPACE

class RouteManager : public QObject
{
    Q_OBJECT

public:
    explicit RouteManager(QObject *parent = 0);
    explicit RouteManager(const RouteManager &manager);
    virtual ~RouteManager();
    
public slots:
    void requestRoute(const double fromLat,
                      const double fromLng,
                      const double toLat,
                      const double toLng);

private slots:
    void error(QGeoRouteReply *reply,
               QGeoRouteReply::Error error,
               QString errorString = QString());
    void finished(QGeoRouteReply *reply);
    
signals:
    void coordinateFound(const double latitude, const double longitude);
    void requestCompleted();
    void requestFailed(QString error);

private:
    QGeoServiceProvider *m_geoProvider; // Owned
    QGeoRoutingManager *m_routingMgr; // Not owned
};

Q_DECLARE_METATYPE(RouteManager)

#endif // ROUTEMANAGER_H
