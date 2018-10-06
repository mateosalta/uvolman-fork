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

#ifndef GTKACTIONSINTERFACE_H
#define GTKACTIONSINTERFACE_H

#include <QObject>
#include <QDBusConnection>
#include <QDBusInterface>

class GtkActionsInterface : public QObject
{
    Q_OBJECT

public:
    explicit GtkActionsInterface(QObject *parent = 0,
                                 const QString &dbusService = "",
                                 const QString &dbusPath = "/");

    Q_INVOKABLE QVariant getActionStateSimple(const QString &action);
    Q_INVOKABLE bool setActionStateSimple(const QString &action,
                                          const QVariant &newState);

public Q_SLOTS:
    void Changed(const QDBusMessage &message);

Q_SIGNALS:
    void actionsRemoved(QStringList removals);
    void actionsEnabledFlagChanged(QMap<QString, bool>);
    void actionsStateChanged(QMap<QString, QVariant>);
    void actionsAdded(QStringList actions);

private:
    QDBusConnection conn;
    QDBusInterface interface;
};

#endif // GTKACTIONSINTERFACE_H

