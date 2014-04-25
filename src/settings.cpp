/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#include "settings.h"
#include <QtCore/QSettings>

// Constants
const char *Organisation = "Nokia";
const char *Application = "PlacesAround";


/*!
  \class Settings
  \brief This class loads and stores settings used by client application.
*/


/*!
  Constructor.
*/
Settings::Settings(QObject *parent)
    : QObject(parent)
{
}


/*!
  Copy constructor.
  Not used.
*/
Settings::Settings(const Settings &settings)
    : QObject(0)
{
    Q_UNUSED(settings)
}


/*!
  Stores the setting as a key value pair.
*/
void Settings::setSetting(const QString &setting, const QVariant &value)
{
    QSettings settings(QSettings::UserScope, Organisation, Application);
    settings.setValue(setting, value);
    emit settingChanged(setting, value);
}


/*!
  Loads the setting by key. Returns value.
*/
QVariant Settings::setting(const QString &setting)
{
    QSettings settings(QSettings::UserScope, Organisation, Application);
    return settings.value(setting);
}


/*!
  Removes the setting by key. Returns true, if setting removed
  successfully. Otherwise false.
*/
bool Settings::removeSetting(const QString &setting)
{
    QSettings settings(QSettings::UserScope, Organisation, Application);
    if (!settings.contains(setting)) {
        return false;
    }

    settings.remove(setting);
    return true;
}


/*!
  Removes all settings.
*/
void Settings::clear()
{
    QSettings settings(QSettings::UserScope, Organisation, Application);
    settings.clear();
}
