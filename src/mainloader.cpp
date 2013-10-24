/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#include "mainloader.h"

#include <QtCore/QTimer>
#include <QtDeclarative/QDeclarativeComponent>
#include <QtDeclarative/QDeclarativeItem>
#include <QtDeclarative/QDeclarativeView>
#include <QtGui/QApplication>

// Lock orientation in Symbian
#ifdef Q_OS_SYMBIAN
    #include <eikenv.h>
    #include <eikappui.h>
    #include <aknenv.h>
    #include <aknappui.h>
#endif


/*!
  \class MainLoader
  \brief A utility class for loading the splash screen and application main QML
         file after it.
*/



/*!
  Factory method for creating a MainLoader instance.
*/
MainLoader *MainLoader::create(QDeclarativeView &view,
                               const QUrl &splashScreenUrl,
                               const QUrl &mainQmlUrl,
                               QObject *parent)
{
    return new MainLoader(view, splashScreenUrl, mainQmlUrl, parent);
}


/*!
  Constructor.
*/
MainLoader::MainLoader(QDeclarativeView &view,
                       const QUrl &splashScreenUrl,
                       const QUrl &mainQmlUrl,
                       QObject *parent)
    : QObject(parent),
      mView(view),
      mSplashScreenItem(0),
      mMainItem(0),
      mSplashScreenUrl(splashScreenUrl),
      mMainQmlUrl(mainQmlUrl)
{
}


/*!
  Loads splash screen, also connects the splash screens hidden signal to this
  objects destroySplashScreen slot, so when the splash screen has animated
  away it will be destroyed.
*/
void MainLoader::load()
{
#ifdef Q_OS_SYMBIAN
    // Lock orientation in Symbian for the splash screen
    CAknAppUi* appUi = dynamic_cast<CAknAppUi*>( CEikonEnv::Static()->AppUi() );

    TRAP_IGNORE(
        if ( appUi )
            {
            appUi->SetOrientationL( CAknAppUi::EAppUiOrientationPortrait );
            }
    );
#endif

    QDeclarativeComponent splashScreenComponent(mView.engine(), mSplashScreenUrl);
    mSplashScreenItem = qobject_cast<QDeclarativeItem *>(splashScreenComponent.create());

    qDebug() << mView.width() << mView.height();

    mSplashScreenItem->setWidth(mView.width());
    mSplashScreenItem->setHeight(mView.height());

    connect(mSplashScreenItem, SIGNAL(hidden()),
            this, SLOT(destroySplashScreen()),
            Qt::QueuedConnection);

    mView.scene()->addItem(mSplashScreenItem);
    mView.showFullScreen();
    QTimer::singleShot(100, this, SLOT(loadMainQml()));
}


/*!
  Loads the main QML file while the splash screen is being shown.
*/
void MainLoader::loadMainQml()
{
    QDeclarativeComponent component(mView.engine(), mMainQmlUrl);

    if (component.status() == QDeclarativeComponent::Error) {
        qDebug() << "MainLoader::loadMainQml(): Error(s): " << component.errors();
        return;
    }

    mMainItem = qobject_cast<QDeclarativeItem *>(component.create());

    if (!mMainItem) {
        qDebug() << "MainLoader::loadMainQml(): mMainItem == NULL";
        return;
    }

    mView.scene()->addItem(mMainItem);

#if defined(Q_OS_SYMBIAN) || defined(MEEGO_EDITION_HARMATTAN) || defined(Q_WS_SIMULATOR)
    // Begin the hide animation of the splash screen
    QMetaObject::invokeMethod(mSplashScreenItem, "hide");
#endif
}


/*!
  Destroys the splash screen.
*/
void MainLoader::destroySplashScreen()
{
    mView.scene()->removeItem(mSplashScreenItem);
    delete mSplashScreenItem;

#ifdef Q_OS_SYMBIAN
    // Release the portrait lock on Symbian
    CAknAppUi* appUi = dynamic_cast<CAknAppUi*>( CEikonEnv::Static()->AppUi() );

    TRAP_IGNORE(
        if (appUi)
            {
            appUi->SetOrientationL( CAknAppUi::EAppUiOrientationUnspecified );
            }
    );
#endif
}
