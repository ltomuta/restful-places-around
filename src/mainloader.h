/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#ifndef MAINLOADER_H
#define MAINLOADER_H

#include <QObject>
#include <QUrl>

class QDeclarativeItem;
class QDeclarativeView;


class MainLoader : public QObject
{
    Q_OBJECT

public:
    static MainLoader *create(QDeclarativeView &view,
                              const QUrl &splashScreenUrl,
                              const QUrl &mainQmlUrl,
                              QObject *parent = 0);

public slots:
    void load();

private:
    explicit MainLoader(QDeclarativeView &view,
                        const QUrl &splashScreenUrl,
                        const QUrl &mainQmlUrl,
                        QObject *parent = 0);

private slots:
    void loadMainQml();
    void destroySplashScreen();

protected:
    QDeclarativeView &mView; // Not owned
    QDeclarativeItem *mSplashScreenItem; // Not owned
    QDeclarativeItem *mMainItem; // Not owned
    QUrl mSplashScreenUrl;
    QUrl mMainQmlUrl;
};

#endif // MAINLOADER_H
