/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#include <QtCore/QObject>
#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeView>
#include <QtGui/QApplication>
#include <QtNetwork/QNetworkProxyFactory>

#include "mainloader.h"
#include "placesapiplugin.h"
#include "settings.h"

#ifdef HARMATTAN_BOOSTER
#include <MDeclarativeCache>
#endif

Q_DECL_EXPORT int main(int argc, char *argv[])
{
#ifdef HARMATTAN_BOOSTER
    QScopedPointer<QApplication> app(MDeclarativeCache::qApplication(argc, argv));
#else
    QScopedPointer<QApplication> app(new QApplication(argc, argv));
#endif

    // Construct and register the Places API plug-in
    PlacesApiPlugin placesApiPlugin;
    placesApiPlugin.registerTypes("PlacesApi");

    QNetworkProxyFactory::setUseSystemConfiguration(true);

    QDeclarativeView view;
    view.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    QObject::connect(view.engine(), SIGNAL(quit()), app.data(), SLOT(quit()));

#ifdef Q_OS_SYMBIAN
    view.setAttribute(Qt::WA_NoSystemBackground);
#endif

    Settings settings;
    view.rootContext()->setContextProperty("settings", &settings);

#ifdef Q_WS_SIMULATOR
    view.rootContext()->setContextProperty("isSimulator", true);
#else
    view.rootContext()->setContextProperty("isSimulator", false);
#endif

    QScopedPointer<MainLoader> mainLoader(
                MainLoader::create(view,
                                   QUrl("qrc:/SplashScreen.qml"),
                                   QUrl("qrc:/main.qml")));
    mainLoader->load();

    return app->exec();
}
