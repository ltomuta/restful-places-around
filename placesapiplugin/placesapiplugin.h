/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#ifndef PLACESAPIPLUGIN_H
#define PLACESAPIPLUGIN_H

#include <QtDeclarative/QDeclarativeExtensionPlugin>

class PlacesApiPlugin : public QDeclarativeExtensionPlugin
{
    Q_OBJECT

public:
    explicit PlacesApiPlugin(QObject *parent = 0);
    void registerTypes(const char *uri);
};


#endif // PLACESAPIPLUGIN_H

