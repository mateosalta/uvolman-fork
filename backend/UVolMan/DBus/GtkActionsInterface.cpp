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

#include "GtkActionsInterface.h"
#include "DBusGtkAction.h"

#include <QMetaType>
#include <QDBusMetaType>
#include <QDBusReply>
#include <QDebug>

Q_DECLARE_METATYPE(DBusGtkAction)

GtkActionsInterface::GtkActionsInterface(QObject *parent,
                                         const QString &dbusService,
                                         const QString &dbusPath)
    : QObject(parent),
      conn(QDBusConnection::sessionBus()),
      interface(dbusService,
                dbusPath,
                "org.gtk.Actions",
                conn)
{
    qDBusRegisterMetaType<DBusGtkAction>();

    if (conn.isConnected())
    {
        if (interface.isValid()) {
            bool connected = conn.connect(interface.service(),
                                     interface.path(),
                                     "org.gtk.Actions",
                                     "Changed",
                                     this,
                                     SLOT(Changed(QDBusMessage)));
            if (!connected)
                qWarning() << "[FAILED] GtkActionsInterface[message=signalConnFailed; signal=Changed; interface=" << interface.service() << "]: " << conn.lastError();
        }
        else
            qWarning() << "[FAILED] GtkActionsInterface[message=invalidInterface; interface=" << dbusService << "; path=" << dbusPath << "]: " << conn.lastError();
    }
    else
        qWarning() << "[FAILED] GtkActionsInterface[message=notConnected; interface=" << dbusService << "; path=" << dbusPath << "]: " << conn.lastError();
}

void GtkActionsInterface::Changed(const QDBusMessage &message)
{
    QVariant tmpQVariant;
    QString tmpQString;
    bool tmpBool;

    QList<QVariant> outArgs = message.arguments();

    // extract removals
    tmpQVariant = outArgs.at(0);
    QStringList removals = tmpQVariant.value<QStringList>();
    if (!removals.isEmpty())
        Q_EMIT actionsRemoved(removals);

    // extract enabled flag changes
    QMap<QString, bool> enabledFlagChanges;
    tmpQVariant = outArgs.at(1);
    const QDBusArgument &enabledFlagChangesArg = tmpQVariant.value<QDBusArgument>();
    enabledFlagChangesArg.beginMap();
    while (!enabledFlagChangesArg.atEnd()) {
        enabledFlagChangesArg.beginMapEntry();
        enabledFlagChangesArg >> tmpQString;
        enabledFlagChangesArg >> tmpBool;
        enabledFlagChangesArg.endMapEntry();

        enabledFlagChanges[tmpQString] = tmpBool;
    }
    enabledFlagChangesArg.endMap();
    if (!enabledFlagChanges.isEmpty())
    {
        Q_EMIT actionsEnabledFlagChanged(enabledFlagChanges);
        enabledFlagChanges.clear(); // free mem
    }

    // extract state changes
    QMap<QString, QVariant> stateChanges;
    tmpQVariant = outArgs.at(2);
    const QDBusArgument &stateChangesArg = tmpQVariant.value<QDBusArgument>();
    stateChangesArg.beginMap();
    while (!stateChangesArg.atEnd()) {
        stateChangesArg.beginMapEntry();
        stateChangesArg >> tmpQString;
        stateChangesArg >> tmpQVariant;
        stateChangesArg.endMapEntry();

        stateChanges[tmpQString] = tmpQVariant;
    }
    stateChangesArg.endMap();
    if (!stateChanges.isEmpty())
    {
        Q_EMIT actionsStateChanged(stateChanges);
        stateChanges.clear(); // free mem
    }

    // extract additions
    QStringList additions;
    tmpQVariant = outArgs.at(3);
    const QDBusArgument &additionsArg = tmpQVariant.value<QDBusArgument>();
    //qWarning() << "QDBusArgument current type is" << additions.currentType();
    additionsArg.beginMap();
    while (!additionsArg.atEnd()) {
        DBusGtkAction tmpGtkAction;

        additionsArg.beginMapEntry();
        additionsArg >> tmpQString;
        additionsArg >> tmpGtkAction;
        additionsArg.endMapEntry();

        additions.append(tmpQString);
    }
    additionsArg.endMap();
    if (!additions.isEmpty())
    {
        Q_EMIT actionsAdded(additions);
        additions.clear(); // free mem
    }
}

QVariant GtkActionsInterface::getActionStateSimple(const QString &action)
{
    if (interface.isValid())
    {
        QDBusReply<DBusGtkAction> reply = interface.call("Describe",
                                                         action);
        if (reply.isValid())
            return reply.value().getValues().first();
        else
            qWarning() << "[FAILED] GtkActionsInterface[message=getActionStateSimpleFailed; interface=" << interface.service() << "; action=" << action << "]: " << reply.error();
    }

    return QVariant();
}

bool GtkActionsInterface::setActionStateSimple(const QString &action,
                                               const QVariant &newState)
{
    if (interface.isValid())
    {
        QDBusReply<DBusGtkAction> reply = interface.call(
                    "Describe",
                    action);
        if (reply.isValid()) {
            QMap<QString, QVariant> emptyPlatformData;

            QDBusMessage message = interface.call("SetState",
                                                  action,
                                                  QVariant::fromValue(QDBusVariant(newState)),
                                                  emptyPlatformData);

            if (message.type() == QDBusMessage::ErrorMessage)
                qWarning() << "[FAILED] GtkActionsInterface[message=getActionStateSimpleFailed; interface=" << interface.service() << "; action=" << action << "; newState=" << newState << "]: " << message.errorMessage();

            return message.type() == QDBusMessage::ReplyMessage;
        }
        else
            return false;
    }
    else
        return false;
}
