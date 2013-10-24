/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#ifndef PLACE_H
#define PLACE_H

#include <QtCore/QList>
#include <QtCore/QObject>
//#include <QtLocation/QLandmark> // Doesn't build in Symbian
#include <QLandmark>

QTM_USE_NAMESPACE


class Place : public QObject
{
    Q_OBJECT

    // For QLandmark
    Q_PROPERTY(QString description READ description WRITE setDescription)
    Q_PROPERTY(QUrl iconUrl READ iconUrl WRITE setIconUrl NOTIFY iconUrlChanged)
    Q_PROPERTY(QString name READ name WRITE setName)
    Q_PROPERTY(QString phoneNumber READ phoneNumber WRITE setPhoneNumber)
    Q_PROPERTY(QUrl url READ url WRITE setUrl)

    // Extra
    Q_PROPERTY(qreal latitude READ latitude NOTIFY latitudeChanged)
    Q_PROPERTY(qreal longitude READ longitude NOTIFY longitudeChanged)
    Q_PROPERTY(QString address READ addressString NOTIFY addressStringChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)
    Q_PROPERTY(QString website READ website WRITE setWebsite NOTIFY websiteChanged)
    Q_PROPERTY(QString imageSource READ imageSource WRITE setImageSource NOTIFY imageSourceChanged)
    Q_PROPERTY(bool visible READ visible WRITE setVisible NOTIFY visibleChanged)

public:
    explicit Place(QObject *parent = 0);
    ~Place();

public: // Wrappers for QLandmark
    Q_INVOKABLE QList<QLandmarkCategoryId> categoryIds() const;
    Q_INVOKABLE QGeoAddress address() const;
    Q_INVOKABLE QGeoCoordinate coordinate() const;

    QString description() const;
    QUrl iconUrl() const;
    QLandmarkId	landmarkId() const;
    QString name() const;
    QString phoneNumber() const;
    QUrl url() const;
    void setDescription(const QString &description);
    void setIconUrl(const QUrl &url);
    void setLandmarkId(const QLandmarkId &id);
    void setName(const QString &name);
    void setPhoneNumber(const QString &phoneNumber);
    void setUrl(const QUrl &url);

public: // Extra
    qreal latitude() const;
    qreal longitude() const;
    QString addressString() const;
    QString email() const;
    void setEmail(const QString &email);
    QString website() const;
    void setWebsite(const QString &website);
    QString imageSource() const;
    void setImageSource(const QString &imageSource);
    bool visible() const;
    void setVisible(bool visible);

public slots:
    void addCategoryId(const QLandmarkCategoryId &categoryId);
    void removeCategoryId(const QLandmarkCategoryId &categoryId);
    void setCategoryIds(const QList<QLandmarkCategoryId> &categoryIds);
    void setAddress(const QGeoAddress &address);
    void setCoordinate(const QGeoCoordinate &coordinate);

signals:
    void iconUrlChanged(QUrl iconUrl);
    void latitudeChanged(qreal latitude);
    void longitudeChanged(qreal longitude);
    void addressStringChanged(QString address);
    void emailChanged(QString email);
    void websiteChanged(QString website);
    void imageSourceChanged(QString imageSource);
    void visibleChanged(bool visible);
    void aboutToBeDestroyed();

private: // Data
    QLandmark *mLandmark;
    QString mEmail;
    QString mWebsite;
    QString mImageSource;
    bool mVisible;
};

#endif // PLACE_H
