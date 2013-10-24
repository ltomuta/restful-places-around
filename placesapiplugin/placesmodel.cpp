/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#include "placesmodel.h"

#include <QtCore/QDebug>
#include <QtCore/QDir>

#include "place.h"

// Constants
const int UpdateInterval(1000);
const QString CategoryName("Places Around");


/*!
  \class PlacesModel
  \brief This class represents a model containing Facebook places data.
*/


/*!
  Constructor.
*/
PlacesModel::PlacesModel(QObject *parent)
    : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[StreetAddressRole] = "streetAddress";
    roles[LatitudeRole] = "latitude";
    roles[LongitudeRole] = "longitude";
    roles[IconUrlRole] = "iconUrl";
    roles[PlaceObjectRole] = "object";
    setRoleNames(roles);
}


/*!
  Copy constructor.
  Not used.
*/
PlacesModel::PlacesModel(const PlacesModel &model, QObject *parent)
    : QAbstractListModel(parent)
{
    Q_UNUSED(model);
}


/*!
  Destructor.
*/
PlacesModel::~PlacesModel()
{
    clear();
}


/*!
  From QAbstractListModel.
  Returns data from model by \a index by \a role.
*/
QVariant PlacesModel::data(const QModelIndex &index,
                           int role /* Qt::DisplayRole */) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    const int itemIndex(index.row());
    const int placesCount(mPlaces.count());
    int virtualIndex(0);
    Place *place = 0;

    // Skip all invisible places
    for (int i = 0; i < placesCount; ++i) {
        if (mPlaces[i]->visible()) {
            if (itemIndex == virtualIndex) {
                place = mPlaces[i];
                break;
            }
            else {
                virtualIndex++;
            }
        }
    }

    if (!place) {
        return QVariant();
    }

    QVariant value = QVariant();

    switch (role) {
    case NameRole:
        value = QVariant::fromValue(place->name());
        break;
    case StreetAddressRole:
        value = QVariant::fromValue(place->address().street());
        break;
    case LatitudeRole:
        value = QVariant::fromValue(place->coordinate().latitude());
        break;
    case LongitudeRole:
        value = QVariant::fromValue(place->coordinate().longitude());
        break;
    case IconUrlRole:
        value = QVariant::fromValue(place->iconUrl());
        break;
    case PlaceObjectRole:
        value = QVariant::fromValue((QObject*)place);
        break;
    default:
        break;
    }

    return value;
}


/*!
  From QAbstractListModel.
  Returns the row count of the model.
*/
int PlacesModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    const int placesCount(mPlaces.count());
    int count(0);

    for (int i = 0; i < placesCount; ++i) {
        if (mPlaces[i] && mPlaces[i]->visible()) {
            count++;
        }
    }

    return count;
}


/*!
  Returns the filter text.
*/
QString PlacesModel::filter() const
{
    return mFilter;
}


/*!
  Sets filter text to the model.
*/
void PlacesModel::setFilter(const QString &filter)
{
    if (mFilter != filter) {
        //qDebug() << __PRETTY_FUNCTION__ << filter;
        QModelIndex lastIndex = createIndex(rowCount(), 0, 0);
        mFilter = filter;

        // Apply the filter
        foreach (Place *place, mPlaces) {
            if (mFilter.isEmpty()) {
                if (place && !place->visible()) {
                    modifyPlaceVisibility(place, true);
                }
            }
            else if (place) {
                if (place->name().contains(mFilter, Qt::CaseInsensitive)) {
                    if (!place->visible()) {
                        modifyPlaceVisibility(place, true);
                    }
                }
                else if (place->visible()) {
                    modifyPlaceVisibility(place, false);
                }
            }
        }

        emit filterChanged(mFilter);
    }
}


/*!
  Clears the model (deletes all the places from the list).
*/
void PlacesModel::clear()
{
    foreach (Place *place, mPlaces) {
        delete place;
    }

    mPlaces.clear();
    emit rowCountChanged(0);
}


/*!
*/
bool PlacesModel::addPlace(Place *place)
{
    if (!place) {
        return false;
    }

    const QString placeName(place->name());

    foreach (Place *temp, mPlaces) {
        if (temp && temp->name() == placeName) {
            // Place already exists!
            return false;
        }
    }

    qDebug() << "Adding:" << place->name();
    const int count(mPlaces.count());
    beginInsertRows(QModelIndex(), count, count);
    mPlaces.append(place);
    endInsertRows();
    emit rowCountChanged(rowCount());
    emit placeAdded(place);
    return true;
}


/*!
*/
void PlacesModel::modifyPlaceVisibility(Place *place, bool visible)
{
    if (!place) {
        return;
    }

    const int count(mPlaces.count());
    int virtualIndex(0);

    for (int realIndex = 0; realIndex < count; ++realIndex) {
        if (mPlaces[realIndex] == place) {
            if (mPlaces[realIndex]->visible() == visible) {
                // No need to modify
                return;
            }
            else {
                break;
            }
        }
        else if (mPlaces[realIndex]->visible()) {
            virtualIndex++;
        }
    }

    if (visible) {
        // Show
        beginInsertRows(QModelIndex(), virtualIndex, virtualIndex);
        place->setVisible(visible);
        endInsertRows();
    }
    else {
        // Hide
        beginRemoveRows(QModelIndex(), virtualIndex, virtualIndex);
        place->setVisible(visible);
        endRemoveRows();
    }

    emit rowCountChanged(rowCount());
}


