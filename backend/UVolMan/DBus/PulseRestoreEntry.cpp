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

#include "PulseRestoreEntry.h"
#include "DBusRestoreEntryVolume.h"

#include <QDBusInterface>
#include <QDBusReply>
#include <QMetaType>
#include <QDBusMetaType>
#include <QDebug>

#define PA_VOLUME_NORM (double) 65536
Q_DECLARE_METATYPE(DBusRestoreEntryVolume)

PulseRestoreEntry::PulseRestoreEntry(QObject *parent, const QString &peerConnName, const QString &entryPath)
    : QObject(parent),
      conn(peerConnName)
{
    qDBusRegisterMetaType<DBusRestoreEntryVolume>();

    path = entryPath;

    name = getProperty("Name").toString();
    device = getProperty("Device").toString();

    QList<uint> tmpList;
    double tmp;
    const QDBusArgument &volumeArg = getProperty("Volume").value<QDBusArgument>();
    volumeArg.beginArray();
    while (!volumeArg.atEnd())
        volumeArg >> tmpList;
    volumeArg.endArray();
    tmp = tmpList.last();
    volume = tmp/PA_VOLUME_NORM;

    isMute = getProperty("Mute").toBool();

    bool connected;
    connected = conn.connect("org.PulseAudio1.Ext.StreamRestore1",
                            path,
                            "org.PulseAudio.Ext.StreamRestore1.RestoreEntry",
                            "VolumeUpdated",
                            this,
                            SLOT(VolumeUpdated(QDBusMessage)));
   if (!connected)
       qWarning() << "[FAILED] PulseStreamRestore[message=signalConnFailed; signal=VolumeUpdated; entry=" << path << "]: " << conn.lastError();
}


QString PulseRestoreEntry::getName()
{
    return name;
}

double PulseRestoreEntry::getVolume()
{
    return volume;
}

bool PulseRestoreEntry::setVolume(const double &newVolume)
{
    if (newVolume != volume)
    {
        if (setProperty("Volume", QVariant::fromValue(newVolume)))
        {
            volume = newVolume;
            Q_EMIT volumeChanged(QVariant::fromValue(volume));
        }
    }
    return volume == newVolume;
}

QVariant PulseRestoreEntry::getProperty(const QString &property)
{

    QDBusInterface interface (
                "org.PulseAudio1",
                path,
                "org.freedesktop.DBus.Properties",
                conn,
                this);

    if (interface.isValid()) {
        QDBusReply<QDBusVariant> reply = interface.call(
                    "Get",
                    "org.PulseAudio.Ext.StreamRestore1.RestoreEntry",
                    property);
        if (reply.isValid()) {
            return reply.value().variant();
        }
        else
            qWarning() << "[FAILED] PulseRestoreEntry[path=" << path << "; property=" << property << "; action=GET]: " << reply.error();
    }
    return QVariant();
}

bool PulseRestoreEntry::setProperty(const QString &property, const QVariant &value)
{
    QDBusInterface interface (
                "org.PulseAudio1",
                path,
                "org.freedesktop.DBus.Properties",
                conn,
                this);

    if (interface.isValid())
    {
        QVariant newValue;
        if (property == "Volume")
        {
            uint tmp = (value.toDouble()*PA_VOLUME_NORM);
            DBusRestoreEntryVolume volume = DBusRestoreEntryVolume(((uint) 0), tmp);
            QDBusArgument argument;
            argument.beginArray(qMetaTypeId<DBusRestoreEntryVolume>() );
            argument << volume;
            argument.endStructure();

            newValue = QVariant::fromValue(QDBusVariant(QVariant::fromValue(argument)));
        }
        else
            newValue = QVariant::fromValue(QDBusVariant(value));

        QDBusMessage message = interface.call("Set",
                                      "org.PulseAudio.Ext.StreamRestore1.RestoreEntry",
                                      property,
                                      QVariant::fromValue(newValue));
        if (message.type() == QDBusMessage::ErrorMessage)
            qWarning() << "[FAILED] PulseRestoreEntry[path=" << path << "; property=" << property << "; value=" << value << "; action=SET]: " << message.errorMessage();

        return message.type() == QDBusMessage::ReplyMessage;
    }
    else
        return false;
}

void PulseRestoreEntry::VolumeUpdated(const QDBusMessage &message)
{
    QList<QVariant> outArgs = message.arguments();
    QVariant tmpQVariant = outArgs.at(0);
    const QDBusArgument &arg = tmpQVariant.value<QDBusArgument>();
    double tmpVolume = -1;
    while (!arg.atEnd()) {
        DBusRestoreEntryVolume tmpDBusVolume;
        arg.beginMapEntry();
        arg >> tmpDBusVolume;
        arg.endMapEntry();
        tmpVolume = tmpDBusVolume.getSecond()/PA_VOLUME_NORM;
    }
    arg.endMap();

    if ((tmpVolume != -1) &&
        ((int) (tmpVolume*100) != (int) (volume*100)))
    {
        volume = tmpVolume;
        Q_EMIT volumeChanged(QVariant::fromValue(volume));
    }
}
