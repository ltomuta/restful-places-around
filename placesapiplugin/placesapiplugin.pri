# Copyright (c) 2012 Nokia Corporation.

QT += declarative network
CONFIG += qt plugin mobility
MOBILITY += location

CONFIG(debug, debug|release) {
    message(Debug build)
    DEFINES += PLACES_DEBUG
}

INCLUDEPATH += $$PWD

HEADERS += \
    $$PWD/apikeys.h \
    $$PWD/place.h \
    $$PWD/placesapimanager.h \
    $$PWD/placesapiplugin.h \
    $$PWD/placesmodel.h \
    $$PWD/routemanager.h

SOURCES += \
    $$PWD/place.cpp \
    $$PWD/placesapimanager.cpp \
    $$PWD/placesapiplugin.cpp \
    $$PWD/placesmodel.cpp \
    $$PWD/routemanager.cpp

qmldir.files += $$PWD/qmldir
qmldir.path +=  $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

INSTALLS += qmldir
