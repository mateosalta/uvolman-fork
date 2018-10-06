/*
 * This file is part of uvolman.dfiloni
 *
 * Copyright (C) 2016-2017 Devid Antonio Filoni https://launchpad.net/~d.filoni
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "IndicatorSoundService.h"

#define DBUS_SERVICE "com.canonical.indicator.sound"
#define DBUS_PATH "/com/canonical/indicator/sound"

IndicatorSoundService::IndicatorSoundService(QObject *parent)
    : QObject(parent),
      interface(this,
                DBUS_SERVICE,
                DBUS_PATH)
{
    cachedVolume = QVariant::fromValue(-1);
    cachedMicVolume = QVariant::fromValue(-1);

    connect(&interface, SIGNAL(actionsStateChanged(QMap<QString, QVariant>)),
            this, SLOT(gtkActionsStateChanged(QMap<QString, QVariant>)));
}

void IndicatorSoundService::gtkActionsStateChanged(const QMap<QString, QVariant> &stateChanges)
{
    QMap<QString, QVariant>::const_iterator i;
    for (i = stateChanges.begin(); i != stateChanges.end(); ++i)
    {
        if (i.key() == "volume")
        {
            if (i.value().type() == QVariant::Double &&
                (i.value().type() != cachedVolume.type() ||
                 i.value().value<double>() != cachedVolume.value<double>()))
            {
                cachedVolume = i.value();
                Q_EMIT volumeChanged(cachedVolume);
            }
        }
        else if (i.key() == "mic-volume")
        {
            if (i.value().type() == QVariant::Double &&
                (i.value().type() != cachedMicVolume.type() ||
                 i.value().value<double>() != cachedMicVolume.value<double>()))
            {
                cachedMicVolume = i.value();
                Q_EMIT micVolumeChanged(cachedMicVolume);
            }
        }
    }
}

QVariant IndicatorSoundService::getVolume()
{
    QVariant volume = interface.getActionStateSimple("volume");
    if (!volume.isNull() && volume.isValid())
        cachedVolume = volume;
    return cachedVolume;
}


bool IndicatorSoundService::setVolume(const QVariant &value)
{
    if (value.type() == QVariant::Double &&
        value.type() == cachedVolume.type() &&
        value.value<double>() == cachedVolume.value<double>())
        return true;

    bool success = interface.setActionStateSimple("volume", value);
    if (success)
        cachedVolume = value;

    return success;
}

QVariant IndicatorSoundService::getMicVolume()
{
    QVariant volume = interface.getActionStateSimple("mic-volume");
    if (!volume.isNull() && volume.isValid())
        cachedMicVolume = volume;
    return cachedMicVolume;
}


bool IndicatorSoundService::setMicVolume(const QVariant &value)
{
    if (value.type() == QVariant::Double &&
        value.type() == cachedMicVolume.type() &&
        value.value<double>() == cachedMicVolume.value<double>())
        return true;

    bool success = interface.setActionStateSimple("mic-volume", value);
    if (success)
        cachedMicVolume = value;

    return success;
}
