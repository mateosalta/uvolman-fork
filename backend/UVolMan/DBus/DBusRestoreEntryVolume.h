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

#ifndef DBUSRESTOREENTRYVOLUME_H
#define DBUSRESTOREENTRYVOLUME_H

#include <QDBusSignature>
#include <QDBusArgument>

class DBusRestoreEntryVolume
{
public:
    DBusRestoreEntryVolume();
    DBusRestoreEntryVolume(uint first, uint second);

    friend QDBusArgument &operator<<(QDBusArgument &argument, const DBusRestoreEntryVolume &result);
    friend const QDBusArgument &operator>>(const QDBusArgument &argument, DBusRestoreEntryVolume &result);

    uint getFirst() const;
    uint getSecond() const;

private:
    uint first;
    uint second;
};

#endif // DBUSRESTOREENTRYVOLUME_H
