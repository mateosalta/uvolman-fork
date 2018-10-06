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

#ifndef PULSERESTOREENTRY_H
#define PULSERESTOREENTRY_H

#include <QObject>
#include <QDBusConnection>
#include <QDBusMessage>

class PulseRestoreEntry : public QObject
{
    Q_OBJECT

public:
    explicit PulseRestoreEntry(QObject *parent = 0, const QString &peerConnName = "", const QString &entryPath = "");

    Q_INVOKABLE QString getPath();
    Q_INVOKABLE QString getName();
    Q_INVOKABLE double getVolume();
    Q_INVOKABLE bool setVolume(const double &newVolume);

public Q_SLOTS:
    void VolumeUpdated(const QDBusMessage &message);

Q_SIGNALS:
    void volumeChanged(QVariant newValue);

private:
    QDBusConnection conn;
    QString path;
    QString name;
    QString device;
    double volume;
    bool isMute;

    QVariant getProperty(const QString &property);
    bool setProperty(const QString &property, const QVariant &value);
};

#endif // PULSERESTOREENTRY_H

