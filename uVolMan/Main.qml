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
import UVolMan 1.0
/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    id: uVolMan
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "uvolman.mateosalta"
    property string applicationVersion: "0.2"

    width: units.gu(100)
    height: units.gu(75)

    PageStack {
        id: mainStack
        Component.onCompleted: push(mainPage)

        Page {
            id: mainPage
            visible: false

            header: PageHeader {
                anchors.top: mainPage.top
                id: pageHeader
                title: i18n.tr("uVolMan")
                StyleHints {
                    foregroundColor: "black"
                    backgroundColor: UbuntuColors.porcelain
                    dividerColor: UbuntuColors.silk
                }
                trailingActionBar {
                    actions: [
                        Action {
                            iconName: "info"
                            text: i18n.tr("About")
                            onTriggered: mainStack.push(Qt.resolvedUrl("AboutPage.qml"))
                        }
                   ]
                   numberOfSlots: 1
                }
            }

            IndicatorSoundService {
                id: indicatorSoundService
                property real cachedVolume: indicatorSoundService.getVolume();
                property real cachedMicVolume: indicatorSoundService.getMicVolume();
                onVolumeChanged: {
                    if (cachedVolume !== newValue)
                    {
                        cachedVolume = newValue;
                        if (volumeSlider.slider.value !== cachedVolume)
                            volumeSlider.slider.value = cachedVolume;
                    }
                }
                onMicVolumeChanged: {
                    if (cachedMicVolume !== newValue)
                    {
                        cachedMicVolume = newValue;
                        if (micVolumeSlider.slider.value !== cachedMicVolume)
                            micVolumeSlider.slider.value = cachedMicVolume;
                    }
                }
            }

            PulseStreamRestore {
                id: pulseStreamRestore
            }

            Flickable {
                anchors.top: pageHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height-pageHeader.height
                contentHeight: mainColumn.height
                flickableDirection: Flickable.VerticalFlick

                Column {
                    id: mainColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top

                    ListItem {
                        id: indicatorSoundLabel
                        Label {
                            anchors {
                                fill: parent
                                leftMargin: units.gu(2)
                                topMargin: units.gu(3);
                                bottomMargin: units.gu(2);
                            }
                            horizontalAlignment: Text.AlignLeft
                            text: i18n.tr("Indicator.Sound")
                            font.pixelSize: units.gu(2);
                        }
                        divider.visible: false
                    }

                    VolSlider {
                        id: volumeSlider
                        property bool firstValueChange: false
                        labelText: i18n.tr("Speakers")
                        slider.value: indicatorSoundService.cachedVolume
                        slider.onValueChanged: {
                            if (indicatorSoundService.cachedVolume !== slider.value)
                                indicatorSoundService.setVolume(slider.value);
                        }
                        enabled: (indicatorSoundService.cachedVolume != -1)
                        divider.visible: (indicatorSoundService.cachedVolume != -1)
                    }
                    ListItem {
                        id: volumeSliderError
                        visible: (indicatorSoundService.cachedVolume == -1)
                        height: visible ? units.gu(3) : 0
                        Text {
                            anchors {
                                top: parent.top
                                left: parent.left
                                leftMargin: units.gu(2)
                            }
                            horizontalAlignment: Text.AlignLeft
                            text: i18n.tr("Speakers configuration not available!")
                        }
                    }

                    VolSlider {
                        id: micVolumeSlider
                        property bool firstValueChange: false
                        labelText: i18n.tr("Microphone")
                        slider.value: indicatorSoundService.cachedMicVolume
                        slider.onValueChanged: {
                            if (indicatorSoundService.cachedMicVolume !== slider.value)
                                indicatorSoundService.setMicVolume(slider.value);
                        }
                        enabled: (indicatorSoundService.cachedMicVolume != -1)
                        divider.visible: (indicatorSoundService.cachedMicVolume != -1)
                    }
                    ListItem {
                        id: micVolumeSliderError
                        visible: (indicatorSoundService.cachedMicVolume == -1)
                        height: visible ? units.gu(3) : 0
                        Text {
                            anchors {
                                top: parent.top
                                left: parent.left
                                leftMargin: units.gu(2)
                            }
                            horizontalAlignment: Text.AlignLeft
                            text: i18n.tr("Microphone configuration not available!")
                        }
                    }



                    ListItem {
                        id: streamRestoreEntriesLabel
                        anchors.left: parent.left
                        anchors.right: parent.right

                        Label {
                            anchors {
                                fill: parent
                                leftMargin: units.gu(2)
                                topMargin: units.gu(3);
                                bottomMargin: units.gu(2);
                            }
                            horizontalAlignment: Text.AlignLeft
                            text: i18n.tr("PulseAudio.Ext.StreamRestore1")
                            font.pixelSize: units.gu(2);
                        }

                        Button {
                            id: streamRestoreEntriesCheckbox
                            property bool checked: false
                            onClicked: checked = !checked;

                            Icon {
                                anchors.fill: parent
                                anchors.margins: units.gu(0.1);
                                name: "compose"
                                color:  streamRestoreEntriesCheckbox.checked ? "white" : "#808080"
                            }

                            anchors {
                                right: parent.right
                                top: parent.top
                                rightMargin: units.gu(2);
                                topMargin: units.gu(2.75);
                            }
                            width: height
                            height: units.gu(3)
                            StyleHints {
                                defaultColor: streamRestoreEntriesCheckbox.checked ? "#808080" : "white"
                            }
                            visible: (pulseStreamRestore.isConnected())
                        }
                        /* Switch {
                            id: streamRestoreEntriesCheckbox
                            checked: false
                            anchors {
                                right: parent.right
                                top: parent.top
                                rightMargin: units.gu(2);
                                topMargin: units.gu(3);
                            }
                            visible: (pulseStreamRestore.isConnected())
                        } */

                        divider.visible: false
                    }

                    Column {
                        id: streamRestoreEntriesList
                        anchors.left: parent.left
                        anchors.right: parent.right

                        function extractEntriesKeys()
                        {
                            var keys = [];
                            for (var entry in pulseStreamRestore.getEntries())
                                keys.push(entry);
                            return keys;
                        }

                        Repeater {
                            model: streamRestoreEntriesList.extractEntriesKeys()
                            VolSlider {
                                property variant entryObj: false
                                slider.onValueChanged: {
                                    entryObj.setVolume(slider.value);
                                }
                                visible: {
                                   if (labelText == 'sink-input-by-media-role:phone' ||
                                       labelText == 'sink-input-by-media-role:alert' ||
                                       labelText == 'sink-input-by-media-role:multimedia' ||
                                       labelText == 'sink-input-by-media-role:alarm')
                                       return true;
                                   else
                                       return false;
                                }

                                Connections {
                                    target: entryObj
                                    ignoreUnknownSignals: true
                                    onVolumeChanged: {
                                        slider.value = newValue;
                                    }
                                }
                            }
                            onItemAdded: {
                                var entries = pulseStreamRestore.getEntries();
                                var entries_keys = streamRestoreEntriesList.extractEntriesKeys();
                                item.entryObj = entries[entries_keys[index]];
                                item.labelText = item.entryObj.getName();
                                item.slider.value = item.entryObj.getVolume();
                            }
                        }
                        enabled: (pulseStreamRestore.isConnected() && streamRestoreEntriesCheckbox.checked)
                        visible: pulseStreamRestore.isConnected()
                    }
                    ListItem {
                        id: streamRestoreEntriesListError
                        height: units.gu(4)
                        Text {
                            anchors {
                                top: parent.top
                                left: parent.left
                                topMargin: units.gu(1)
                                leftMargin: units.gu(2)
                            }
                            horizontalAlignment: Text.AlignLeft
                            text: i18n.tr("StreamRestore1 configuration not available!")
                            visible: (!pulseStreamRestore.isConnected())
                        }
                        divider.visible: (!pulseStreamRestore.isConnected())
                    }
                }
            }
        }
    }
}



