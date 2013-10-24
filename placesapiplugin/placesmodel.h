/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#ifndef PLACESMODEL_H
#define PLACESMODEL_H

#include <QtCore/QAbstractListModel>
#include <QtCore/QTimer>

class Place;


class PlacesModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY rowCountChanged)
    Q_PROPERTY(QString filter READ filter WRITE setFilter NOTIFY filterChanged)

public: // Roles

    enum PlacesModelRoles {
        NameRole = 0,
        StreetAddressRole,
        LatitudeRole,
        LongitudeRole,
        IconUrlRole,
        PlaceObjectRole
    };

public:
    explicit PlacesModel(QObject *parent = 0);
    explicit PlacesModel(const PlacesModel &model, QObject *parent = 0);
    virtual ~PlacesModel();

public: // From QAbstractListModel
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

public:
    QString filter() const;
    void setFilter(const QString &filter);

public slots:
    void clear();
    bool addPlace(Place *place);

private:
    void modifyPlaceVisibility(Place *place, bool visible);

signals:
    void rowCountChanged(int count);
    void filterChanged(QString filter);
    void placeAdded(Place *place);

private: // Data
    QList<Place*> mPlaces;
    QString mFilter;
};

Q_DECLARE_METATYPE(PlacesModel)

#endif // PLACESMODEL_H
