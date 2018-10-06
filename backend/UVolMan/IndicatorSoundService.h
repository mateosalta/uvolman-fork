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

#ifndef INDICATORSOUNDSERVICE_H
#define INDICATORSOUNDSERVICE_H

#include <QObject>
#include "DBus/GtkActionsInterface.h"

class IndicatorSoundService : public QObject
{
    Q_OBJECT

public:
    explicit IndicatorSoundService (QObject *parent = 0);

    Q_INVOKABLE QVariant getVolume();
    Q_INVOKABLE bool setVolume(const QVariant &value);

    Q_INVOKABLE QVariant getMicVolume();
    Q_INVOKABLE bool setMicVolume(const QVariant &value);

public Q_SLOTS:
    void gtkActionsStateChanged(const QMap<QString, QVariant> &stateChanges);

Q_SIGNALS:
    void volumeChanged(QVariant newValue);
    void micVolumeChanged(QVariant newValue);

private:
    QVariant cachedVolume;
    QVariant cachedMicVolume;
    GtkActionsInterface interface;
};

#endif // INDICATORSOUNDSERVICE_H

