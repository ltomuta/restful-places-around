/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#ifndef PLACESAPIMANAGER_H
#define PLACESAPIMANAGER_H

#include <QtCore/QList>
#include <QtCore/QObject>
#include <QtCore/QString>
#include <QtCore/QVariantMap>
#include <QtNetwork/QNetworkAccessManager>

// Forward declarations
class Place;
class PlacesModel;
class QNetworkReply;


class PlacesApiManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int maxNumOfPlaces READ maxNumOfPlaces WRITE setMaxNumOfPlaces)
    Q_PROPERTY(QObject* placesModel READ placesModel WRITE setPlacesModel)
    Q_ENUMS(RequestIds)

public: // Data types
    enum RequestIds {
        None = 0,
        Places = 1,
        PlaceDetails = 2
    };

public:
    explicit PlacesApiManager(QObject *parent = 0);
    ~PlacesApiManager();

public: // Properties
    int maxNumOfPlaces() const;
    void setMaxNumOfPlaces(int maxNumOfPlaces);
    QObject *placesModel() const;

public slots:
    void setPlacesModel(QObject *placesModel = 0);
    void createPlaces(const QVariant &data);
    void parseContacts(const QVariant &data, Place *place);
    void parseMediaImages(const QVariant &data, Place *place);

    void request(const QString url, int requestId = None);

    void resourceRequest(const QString resourceUri,
                         qreal latitude,
                         qreal longitude,
                         const QVariantMap &categories,
                         int requestId = None);

    // Query methods wrapping the API features. For more information,
    // see http://api.maps.nokia.com/en/restplaces/api.html

    void discoverExplore(qreal latitude,
                         qreal longitude,
                         const QVariantMap &categories);
    void discoverHere(qreal latitude,
                      qreal longitude,
                      const QVariantMap &categories);

private:
    QString constructQuery(const QVariantMap &parameters) const;

private slots:
    void onReplyReceived(QNetworkReply *reply);

signals:
    void requestCompleted(int requestId, const QString &result);

private: // Data
    PlacesModel *mPlacesModel; // Not owned
    QNetworkAccessManager mNetworkAccessManager;
    int mMaxNumOfPlaces;
};

#endif // PLACESAPIMANAGER_H
