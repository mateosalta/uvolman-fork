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
import Lomiri.Components 1.3
/*!
    \brief MainView with a Label and Button elements.
*/

Page {
    id: aboutPage
    visible: false

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("About uVolMan")
        StyleHints {
            foregroundColor: "white"
                    backgroundColor: "#aa0044"
        }
    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: pageHeader.bottom

        ListItem {
            Text {
                anchors {
                    fill: parent
                    leftMargin: units.gu(2)
                    topMargin: units.gu(3);
                    rightMargin: units.gu(2)
                    bottomMargin: units.gu(2);
                }
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: units.gu(2);
                text: i18n.tr("Application")
                color: Theme.palette.normal.foregroundText
            }
            divider.visible: false
        }

        ListItem {
            id: applicationDescription

            Text {
                id: applicationDescriptionText
                wrapMode: Text.WordWrap
                anchors {
                    fill: parent
                    topMargin: units.gu(1)
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                }
                horizontalAlignment: Text.AlignLeft
                text: i18n.tr("uVolMan is a simple Volume Controller for Ubuntu Phone")
                color: Theme.palette.normal.foregroundText
                onPaintedHeightChanged: applicationDescription.height = applicationDescriptionText.paintedHeight+units.gu(2);
            }
        }

        ListItem {
            height: units.gu(4)
            Text {
                anchors {
                    fill: parent
                    topMargin: units.gu(1)
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                }
                horizontalAlignment: Text.AlignLeft
                text: "<a href=\"https://github.com/mateosalta/uvolman-fork\">https://github.com/mateosalta/uvolman-fork</a>"
                onLinkActivated: Qt.openUrlExternally("https://github.com/mateosalta/uvolman-fork")
                
            }
        }

        ListItem {
            Text {
                anchors {
                    fill: parent
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                    topMargin: units.gu(3);
                    bottomMargin: units.gu(2);
                }
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: units.gu(2);
                text: i18n.tr("Author")
                color: Theme.palette.normal.foregroundText
            }
            divider.visible: false
        }

        ListItem {
            height: units.gu(4)
            Text {
                anchors {
                    fill: parent
                    topMargin: units.gu(1)
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                }
                horizontalAlignment: Text.AlignLeft
                text: "Devid Antonio Filoni"
                color: Theme.palette.normal.foregroundText
            }
        }

        ListItem {
            height: units.gu(4)
            Text {
                anchors {
                    fill: parent
                    topMargin: units.gu(1)
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                }
                horizontalAlignment: Text.AlignLeft
                text: "<a href=\"https://launchpad.net/~d.filoni\">https://launchpad.net/~d.filoni</a>"
                onLinkActivated: Qt.openUrlExternally("https://launchpad.net/~d.filoni")
            }
            //onClicked: Qt.openUrlExternally("https://launchpad.net/~d.filoni")
        }
        
        ListItem {
            Text {
                anchors {
                    fill: parent
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                    topMargin: units.gu(3);
                    bottomMargin: units.gu(2);
                }
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: units.gu(2);
                text: i18n.tr("Maintainer")
                color: Theme.palette.normal.foregroundText
            }
            divider.visible: false
        }

        ListItem {
            height: units.gu(4)
            Text {
                anchors {
                    fill: parent
                    topMargin: units.gu(1)
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                }
                horizontalAlignment: Text.AlignLeft
                text: "Mateo Salta"
                color: Theme.palette.normal.foregroundText
            }
        }

        ListItem {
            height: units.gu(4)
            Text {
                anchors {
                    fill: parent
                    topMargin: units.gu(1)
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                }
                horizontalAlignment: Text.AlignLeft
                text: "<a href=\"https://github.com/mateosalta\">https://github.com/mateosalta</a>"
                onLinkActivated: Qt.openUrlExternally("https://github.com/mateosalta")
            }
            //onClicked: Qt.openUrlExternally("https://github.com/mateosalta")
        }
    }

    ListItem {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(1)
        Text {
            anchors {
                fill: parent
                topMargin: units.gu(1)
                leftMargin: units.gu(2)
                rightMargin: units.gu(2)
            }
            horizontalAlignment: Text.AlignLeft
            text: "© Devid Antonio Filoni 2016-2017<br />"+i18n.tr("Version %1<br />Under License %2").arg(uVolMan.applicationVersion).arg("<a href=\"http://www.gnu.org/licenses/gpl-3.0.en.html\">GPL3</a>")
            color: Theme.palette.normal.foregroundText
            onLinkActivated: Qt.openUrlExternally(link)
            font.pixelSize: units.gu(1.6);
        }
        divider.visible: false
    }
}



