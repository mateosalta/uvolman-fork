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

#include "PulseStreamRestore.h"

#include <QDBusInterface>
#include <QDBusReply>
#include <QDebug>
#include <QMetaType>

typedef PulseRestoreEntry* PulseRestoreEntryStar;
Q_DECLARE_METATYPE(PulseRestoreEntryStar)

#define PEER_CONNECTION_NAME "pulseStreamRestore1"

PulseStreamRestore::PulseStreamRestore(QObject *parent)
    : QObject(parent),
      conn(PEER_CONNECTION_NAME)
{
    QDBusConnection sessionConn(QDBusConnection::sessionBus());
    if (sessionConn.isConnected())
    {
        QDBusInterface lookupInterface("org.PulseAudio1",
                                 "/org/pulseaudio/server_lookup1",
                                 "org.freedesktop.DBus.Properties",
                                 sessionConn,
                                 this);
        if (lookupInterface.isValid()) {
            QList<QVariant> args;
            args.append("org.PulseAudio.ServerLookup1");
            args.append("Address");
            QDBusReply<QDBusVariant> reply = lookupInterface.callWithArgumentList(
                        QDBus::BlockWithGui,
                        "Get",
                        args);
            if (reply.isValid()) {
                bool connected = setupConnection(reply.value().variant().toString());

                if (!connected)
                    qWarning() << "[FAILED] PulseStreamRestore[message=failedConnectionSetup]: " << conn.lastError();
            }
            else
                qWarning() << "[FAILED] PulseStreamRestore[message=invalidServerLookupReply]: " << reply.error();
        }
        else
            qWarning() << "[FAILED] PulseStreamRestore[message=invalidServerLookupInterface]: " << sessionConn.lastError();
    }
    else
        qWarning() << "[FAILED] PulseStreamRestore[message=notConnectedToServerLookup]: " << sessionConn.lastError();
}

bool PulseStreamRestore::setupConnection(const QString &serverAddress)
{
    conn = QDBusConnection::connectToPeer(serverAddress, PEER_CONNECTION_NAME);
    if (conn.isConnected())
    {
        QDBusInterface streamRestoreInterface("org.PulseAudio1",
                                              "/org/pulseaudio/stream_restore1",
                                              "org.freedesktop.DBus.Properties",
                                              conn,
                                              this);
        if (streamRestoreInterface.isValid()) {
            QDBusReply<QDBusVariant> reply = streamRestoreInterface.call(
                        "Get",
                        "org.PulseAudio.Ext.StreamRestore1",
                        "Entries");
            if (reply.isValid()) {
                QString tmpStr;
                const QDBusArgument &entriesArg = reply.value().variant().value<QDBusArgument>();
                entriesArg.beginArray();
                while (!entriesArg.atEnd()) {
                    entriesArg >> tmpStr;
                    PulseRestoreEntryStar tmpEntry = new PulseRestoreEntry(this, PEER_CONNECTION_NAME, tmpStr);
                    entries.insert(tmpStr, QVariant::fromValue(tmpEntry));
                }
                entriesArg.endArray();

                startSignalListening();

                return true;
            }
            else
                qWarning() << "[FAILED] PulseStreamRestore[message=invalidStreamResore1EntriesReply]: " << reply.error();
        }
        else
            qWarning() << "[FAILED] PulseStreamRestore[message=invalidStreamResore1Interface]: " << conn.lastError();
    }
    else
        qWarning() << "[FAILED] PulseStreamRestore[message=notConnected]: " << conn.lastError();

    return false;
}

bool PulseStreamRestore::startSignalListening()
{
    if (conn.isConnected())
    {
        QDBusInterface coreInterface("org.PulseAudio.Core1",
                                     "/org/pulseaudio/core1",
                                     "org.PulseAudio.Core1",
                                     conn,
                                     this);
        if (coreInterface.isValid()) {
            QList<QDBusObjectPath> paths;
            for (QVariantMap::const_iterator i = entries.begin(); i != entries.end(); ++i)
                 paths << QDBusObjectPath(i.key());
            QDBusReply<void> reply = coreInterface.call("ListenForSignal",
                                                                "org.PulseAudio.Ext.StreamRestore1.RestoreEntry.VolumeUpdated",
                                                                QVariant::fromValue(paths));
            if (reply.isValid())
                return true;
            else
                qWarning() << "[FAILED] PulseStreamRestore[message=invalidListenForSignalReply]: " << reply.error();
        }
        else
            qWarning() << "[FAILED] PulseStreamRestore[message=invalidCore1Interface]: " << conn.lastError();
    }
    else
        qWarning() << "[FAILED] PulseStreamRestore[message=notConnected]: " << conn.lastError();

    return false;
}

QVariantMap PulseStreamRestore::getEntries()
{
    return entries;
}

bool PulseStreamRestore::isConnected()
{
    return conn.isConnected();
}
