# Copyright (c) 2012-2014 Microsoft Mobile.

QT += core declarative network
CONFIG += mobility qt-components
MOBILITY += location

TARGET = Places
TEMPLATE = app
VERSION = 1.0

include (placesapiplugin/placesapiplugin.pri)

INCLUDEPATH += src

HEADERS += \
    src/mainloader.h \
    src/settings.h

SOURCES += \
    src/main.cpp \
    src/mainloader.cpp \
    src/settings.cpp

OTHER_FILES += \
    qml/common/*

RESOURCES += rsc/common.qrc

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable

symbian {
    TARGET.UID3 = 0xE156DC89

    # Smart Installer package's UID
    # This UID is from the protected range and therefore the package will
    # fail to install if self-signed. By default qmake uses the unprotected
    # range value if unprotected UID is defined for the application and
    # 0x2002CCCF value if protected UID is given to the application
    #symbian:DEPLOYMENT.installer_header = 0x2002CCCF

    TARGET.CAPABILITY += NetworkServices Location
    TARGET.EPOCHEAPSIZE = 0x020000 0x6000000

    # To lock the application to portrait orientation
    LIBS += -lcone -leikcore -lavkon

    RESOURCES += rsc/symbian.qrc
    OTHER_FILES += qml/symbian/*
    ICON = icons/restfulplacesaround.svg
}

contains(MEEGO_EDITION,harmattan) {
    TARGET = restfulplacesaround
    DEFINES += MEEGO_EDITION_HARMATTAN

    contains(CONFIG,qdeclarative-boostable) {
        DEFINES += HARMATTAN_BOOSTER
    }

    RESOURCES += rsc/harmattan.qrc
    OTHER_FILES += qml/harmattan/*

    target.path = /opt/$${TARGET}/bin
    desktopfile.files = $${TARGET}.desktop
    desktopfile.path = /usr/share/applications
    icon64.files += icons/restfulplacesaround80.png
    icon64.path = /usr/share/icons/hicolor/64x64/apps

    INSTALLS += \
        target \
        desktopfile \
        icon64
}

simulator {
    message(Simulator build)
    RESOURCES += rsc/symbian.qrc
    OTHER_FILES += qml/symbian/*
}
