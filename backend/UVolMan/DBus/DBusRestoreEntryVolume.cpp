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

#include "DBusRestoreEntryVolume.h"

DBusRestoreEntryVolume::DBusRestoreEntryVolume() {}

DBusRestoreEntryVolume::DBusRestoreEntryVolume(uint first, uint second)
    : first(first),
      second(second)
{
}

uint DBusRestoreEntryVolume::getFirst() const
{
    return first;
}

uint DBusRestoreEntryVolume::getSecond() const
{
    return second;
}

QDBusArgument &operator<<(QDBusArgument &argument, const DBusRestoreEntryVolume &result)
{
    argument.beginStructure();
    argument << result.first;
    argument << result.second;
    argument.endStructure();

    return argument;
}

const QDBusArgument &operator>>(const QDBusArgument &argument, DBusRestoreEntryVolume &result)
{
    argument.beginStructure();
    argument >> result.first;
    argument >> result.second;
    argument.endStructure();

    return argument;
}
