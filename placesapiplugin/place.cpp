/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#include "place.h"

/*!
  \class Place
  \brief Wrapper for QLandmark with some extra features.
*/

/*!
  Constructor.
*/
Place::Place(QObject *parent)
    : QObject(parent),
      mLandmark(new QLandmark()),
      mVisible(true)
{
}


/*!
  Destructor.
*/
Place::~Place()
{
    emit aboutToBeDestroyed();
    delete mLandmark;
}


// Wrapper setters and getters for QLandmark

QList<QLandmarkCategoryId> Place::categoryIds() const
{
    return mLandmark->categoryIds();
}

QGeoCoordinate Place::coordinate() const
{
    return mLandmark->coordinate();
}

QGeoAddress Place::address() const
{
    return mLandmark->address();
}

QString Place::description() const
{
    return mLandmark->description();
}

QUrl Place::iconUrl() const
{
    return mLandmark->iconUrl();
}

QLandmarkId	Place::landmarkId() const
{
    return mLandmark->landmarkId();
}

QString Place::name() const
{
    return mLandmark->name();
}

QString Place::phoneNumber() const
{
    return mLandmark->phoneNumber();
}

QUrl Place::url() const
{
    return mLandmark->url();
}

void Place::setDescription(const QString &description)
{
    mLandmark->setDescription(description);
}

void Place::setIconUrl(const QUrl &url)
{
    mLandmark->setIconUrl(url);
    emit iconUrlChanged(url);
}

void Place::setLandmarkId(const QLandmarkId &id)
{
    mLandmark->setLandmarkId(id);
}

void Place::setName(const QString &name)
{
    mLandmark->setName(name);
}

void Place::setPhoneNumber(const QString &phoneNumber)
{
    mLandmark->setPhoneNumber(phoneNumber);
}

void Place::setUrl(const QUrl &url)
{
    mLandmark->setUrl(url);
}


// Extra

/*!
  Returns the place latitude.
*/
qreal Place::latitude() const
{
    return mLandmark->coordinate().latitude();
}


/*!
  Returns the place longitude.
*/
qreal Place::longitude() const
{
    return mLandmark->coordinate().longitude();
}


/*!
*/
QString Place::addressString() const
{
    return mLandmark->address().street();
}


/*!
*/
QString Place::email() const
{
    return mEmail;
}


/*!
*/
void Place::setEmail(const QString &email)
{
    mEmail = email;
    emit emailChanged(mEmail);
}


/*!
*/
QString Place::website() const
{
    return mWebsite;
}


/*!
*/
void Place::setWebsite(const QString &website)
{
    mWebsite = website;
    emit websiteChanged(mWebsite);
}


/*!
*/
QString Place::imageSource() const
{
    return mImageSource;
}


/*!
*/
void Place::setImageSource(const QString &imageSource)
{
    mImageSource = imageSource;
    emit imageSourceChanged(mImageSource);
}


/*!
  Returns true if this place should be visible. False otherwise.
*/
bool Place::visible() const
{
    return mVisible;
}


/*!
  Sets the visibility of this place.
*/
void Place::setVisible(bool visible)
{
    if (mVisible != visible) {
        mVisible = visible;
        emit visibleChanged(mVisible);
    }
}


// Wrapper slots for QLandmark

void Place::addCategoryId(const QLandmarkCategoryId &categoryId)
{
    mLandmark->addCategoryId(categoryId);
}

void Place::removeCategoryId(const QLandmarkCategoryId &categoryId)
{
    mLandmark->removeCategoryId(categoryId);
}

void Place::setCategoryIds(const QList<QLandmarkCategoryId> &categoryIds)
{
    mLandmark->setCategoryIds(categoryIds);
}

void Place::setAddress(const QGeoAddress &address)
{
    mLandmark->setAddress(address);
    emit addressStringChanged(addressString());
}

void Place::setCoordinate(const QGeoCoordinate &coordinate)
{
    mLandmark->setCoordinate(coordinate);
    emit latitudeChanged(coordinate.latitude());
    emit longitudeChanged(coordinate.longitude());
}

