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

import QtQuick 2.4
import Ubuntu.Components 1.3

Column {
    property alias slider: sliderId
        property alias icon1: iconId1
        property alias icon: iconId
    property alias labelText: label.text
    property alias divider: listItem.divider

    anchors.left: parent.left
    anchors.right: parent.right

    ListItem {
        id: listItem
        height: units.gu(8.5)

        Label {
            id: label
            anchors {
                top: parent.top
                left: parent.left
                topMargin: units.gu(1)
                leftMargin: units.gu(2)
            }
            horizontalAlignment: Text.AlignLeft
            text: i18n.tr("Volume")
        }

        Icon {
        id: iconId
            anchors {
                top: label.bottom
                left: parent.left
                topMargin: units.gu(1)
                leftMargin: units.gu(2)
            }
            width: height
            height: units.gu(3)
            source: "image://theme/audio-volume-low-zero"
        }

        Slider {
            id: sliderId
            function formatValue(v) { return v.toFixed(2)*100 }
            anchors {
                top: label.bottom
                left: parent.left
                right: parent.right
                leftMargin: units.gu(6)
                rightMargin: units.gu(6)
            }
            minimumValue: 0.0
            maximumValue: 1.0
            live: false
        }

        Icon {
        id: iconId1
            anchors {
                top: label.bottom
                right: parent.right
                topMargin: units.gu(1)
                rightMargin: units.gu(2)
            }
            width: height
            height: units.gu(3)
            source: "image://theme/audio-volume-high"
        }
    }
}
