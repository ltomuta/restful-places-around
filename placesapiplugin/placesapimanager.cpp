/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#include "placesapimanager.h"

#include <QtCore/QByteArray>
#include <QtCore/QDebug>
#include <QtCore/QStringList>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>

#include "apikeys.h" // Contains the App ID and the App Code
#include "place.h"
#include "placesmodel.h"

// Constants
#ifdef PLACES_DEBUG
const char *PlacesApiUrl = "http://demo.places.nlp.nokia.com/places/v1/";
#else
const char *PlacesApiUrl = "http://places.nlp.nokia.com/places/v1/";
#endif
const char *DiscoverExplorePath = "discover/explore";
const char *DiscoverHerePath = "discover/here";
const char *AppIdKey = "app_id";
const char *AppCodeKey = "app_code";
const int DefaultMaxNumberOfPlaces(40);
const char *LocationParameterKey = "at";
const char *QueryParameterFormat = "%1=%2";
const char *QueryParameterSeparator = "&";


/*!
  \class PlacesApiManager
  \brief Provides the methods to manage the RESTful Places API.
*/

/*!
  Constructor.
*/
PlacesApiManager::PlacesApiManager(QObject *parent)
    : QObject(parent),
      mPlacesModel(0),
      mMaxNumOfPlaces(DefaultMaxNumberOfPlaces)
{
    qDebug() << "Using" << PlacesApiUrl;
    connect(&mNetworkAccessManager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(onReplyReceived(QNetworkReply*)));
}


/*!
  Destructor.
*/
PlacesApiManager::~PlacesApiManager()
{
    // TODO: Cancel any requests here
}


/*!
  Returns the maximum number of places i.e. the limit.
*/
int PlacesApiManager::maxNumOfPlaces() const
{
    return mMaxNumOfPlaces;
}


/*!
  Sets the maximum number of places to \a maxNumOfPlaces.
*/
void PlacesApiManager::setMaxNumOfPlaces(int maxNumOfPlaces)
{
    mMaxNumOfPlaces = maxNumOfPlaces;
}


/*!
  Returns the places model.
*/
QObject *PlacesApiManager::placesModel() const
{
    return (QObject*)mPlacesModel;
}


/*!
  Sets the places model to \a placesModel.
*/
void PlacesApiManager::setPlacesModel(QObject *placesModel /* = 0 */)
{
    if (mPlacesModel) {
        disconnect(mPlacesModel, SIGNAL(destroyed()));
    }

    mPlacesModel = qobject_cast<PlacesModel*>(placesModel);

    if (mPlacesModel) {
        connect(mPlacesModel, SIGNAL(destroyed()),
                this, SLOT(setPlacesModel()));
    }
}


/*!
  Populates the places model with places found in \a data.
*/
void PlacesApiManager::createPlaces(const QVariant &data)
{
    qDebug() << __PRETTY_FUNCTION__;

    if (!mPlacesModel) {
        qDebug() << __PRETTY_FUNCTION__ << "Error: No model set!";
        return;
    }

    QVariantList places(data.toList());

    foreach (QVariant temp, places) {
        // Get needed data from the dictionary tree.
        QVariantMap tempMap(temp.toMap());

        QGeoCoordinate geoCoordinate;
        QVariantList position(tempMap["position"].value<QVariantList>());

        if (position.count() >= 2) {
            geoCoordinate.setLatitude(position.at(0).value<qreal>());
            geoCoordinate.setLongitude(position.at(1).value<qreal>());
        }
        else {
            continue;
        }

        Place *place = new Place();
        place->setName(tempMap["title"].toString());
        place->setCoordinate(geoCoordinate);
        place->setIconUrl(tempMap["icon"].toString());
        place->setUrl(tempMap["href"].toString());

        QString address(tempMap["vicinity"].toString());
        QStringList addressItems = address.split("\n");

        QGeoAddress geoAddress;
        geoAddress.setStreet(addressItems.first());
        place->setAddress(geoAddress);

        if (!mPlacesModel->addPlace(place)) {
            delete place;
        }
    }
}


/*!
  Parses contact details from \a data and places the extracted data into
  \a place.
*/
void PlacesApiManager::parseContacts(const QVariant &data, Place *place)
{
    qDebug() << __PRETTY_FUNCTION__;

    if (!place) {
        qDebug() << __PRETTY_FUNCTION__ << "Error: No place given!";
        return;
    }

    QVariantMap contactMap(data.toMap());

    foreach (QString key, contactMap.keys()) {
        QVariantList tempList = contactMap[key].toList();

        foreach (QVariant temp, tempList) {
            QVariantMap tempMap(temp.toMap());
            //qDebug() << tempMap["value"];

            if (key == "email") {
                place->setEmail(tempMap["value"].toString());
            }
            else if (key == "phone") {
                place->setPhoneNumber(tempMap["value"].toString());
            }
            else if (key == "website") {
                place->setWebsite(tempMap["value"].toString());
            }
        }
    }
}


/*!
  Parses (sources of) images from \a data and places it into \a place.
*/
void PlacesApiManager::parseMediaImages(const QVariant &data, Place *place)
{
    qDebug() << __PRETTY_FUNCTION__;

    if (!place) {
        qDebug() << __PRETTY_FUNCTION__ << "Error: No place given!";
        return;
    }

    QVariantList images(data.toList());

    foreach (QVariant image, images) {
        QVariantMap tempMap(image.toMap());
        qDebug() << tempMap["src"].toString();
        place->setImageSource(tempMap["src"].toString());
        break; // Take only the first image
    }
}


/*!
  Creates a resource request to Places API.
*/
void PlacesApiManager::request(const QString url, int requestId /* = None */)
{
    qDebug() << __PRETTY_FUNCTION__  << url;
    QUrl qUrl(url);
    QNetworkRequest request(qUrl);
    request.setAttribute(QNetworkRequest::User, QVariant::fromValue(requestId));

    // The following must be defined.
    // See http://www.developer.nokia.com/Community/Discussion/showthread.php?235724-status-209-Error-downloading
    request.setRawHeader("Accept", "application/json");

    mNetworkAccessManager.get(request);
}


/*!
  Creates a resource request to Places API.
*/
void PlacesApiManager::resourceRequest(const QString resourceUri,
                                       qreal latitude,
                                       qreal longitude,
                                       const QVariantMap &categories,
                                       int requestId /* = None */)
{
    QStringList query;
    query << PlacesApiUrl << resourceUri << "?";

    QVariantMap parameters(categories);
    parameters.insert(AppIdKey, AppId);
    parameters.insert(AppCodeKey, AppCode);
    QString locationString = QString::number(latitude) + "," + QString::number(longitude);
    parameters.insert(LocationParameterKey, locationString);
    parameters.insert("size", QString::number(mMaxNumOfPlaces));
    parameters.insert("tf", "plain");
    parameters.insert("pretty", "false");

    query << constructQuery(parameters);

    request(query.join(""), requestId);
}


// Query methods wrapping the API features. For more information,
// see http://api.maps.nokia.com/en/restplaces/api.html

/*!
*/
void PlacesApiManager::discoverExplore(qreal latitude,
                                       qreal longitude,
                                       const QVariantMap &categories)
{
    resourceRequest(DiscoverExplorePath, latitude, longitude, categories, Places);
}


/*!
*/
void PlacesApiManager::discoverHere(qreal latitude,
                                    qreal longitude,
                                    const QVariantMap &categories)
{
    resourceRequest(DiscoverHerePath, latitude, longitude, categories, Places);
}


/*!
  Returns a new query contructed from \a parameters.
*/
QString PlacesApiManager::constructQuery(const QVariantMap &parameters) const
{
    QStringList queryList;
    QMapIterator<QString, QVariant> iterator(parameters);

    while (iterator.hasNext()) {
        iterator.next();
        qDebug() << iterator.key() << ":" << iterator.value();
        QString queryItem;

        if (iterator.value().canConvert<QVariantList>()) {
            QVariantList variantList = iterator.value().toList();
            QStringList stringList;

            foreach (QVariant variantItem, variantList) {
                stringList << variantItem.toString();
            }

            queryItem = QString(QueryParameterFormat).arg(iterator.key(), stringList.join(","));
        }
        else {
            queryItem = QString(QueryParameterFormat).arg(iterator.key(), iterator.value().toString());
        }

        queryList.append(queryItem);
    }

    return queryList.join(QueryParameterSeparator);
}


/*!
  If \a reply has no errors, the content of the reply is read, formatted and
  passed on with requestCompleted() signal.
*/
void PlacesApiManager::onReplyReceived(QNetworkReply *reply)
{
    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << __PRETTY_FUNCTION__ << reply->errorString() << reply->error();
        // TODO: Handle error
    }
    else {
        bool gotRequestId(false);
        int requestId = reply->request().attribute(QNetworkRequest::User).toInt(&gotRequestId);

        if (!gotRequestId) {
            requestId = None;
        }

        QByteArray result(reply->readAll());

        // Make sure the result string has proper encoding and character format
        // See http://www.w3schools.com/tags/ref_urlencode.asp
        QString resultString = QString::fromUtf8(result);
        resultString.replace("%3A", ":");
        resultString.replace("%2F", "/");

        emit requestCompleted(requestId, resultString);
    }

    reply->deleteLater();
}
